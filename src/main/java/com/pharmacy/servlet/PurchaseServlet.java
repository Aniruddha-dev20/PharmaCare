package com.pharmacy.servlet;

import com.pharmacy.dao.PurchaseDAO;
import com.pharmacy.dao.SupplierDAO;
import com.pharmacy.dao.MedicineDAO;
import com.pharmacy.model.PurchaseOrder;
import com.pharmacy.model.PurchaseItem;
import com.pharmacy.model.Supplier;
import com.pharmacy.model.User;
import com.pharmacy.model.Medicine;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * PurchaseServlet - Handles all purchase order operations
 * URL: /purchases
 */
@WebServlet("/purchases")
public class PurchaseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PurchaseDAO purchaseDAO;
    private SupplierDAO supplierDAO;
    private MedicineDAO medicineDAO;

    @Override
    public void init() throws ServletException {
        purchaseDAO = new PurchaseDAO();
        supplierDAO = new SupplierDAO();
        medicineDAO = new MedicineDAO();
        System.out.println("✓ PurchaseServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        try {
            if (action == null || action.equals("list")) {
                listPurchaseOrders(request, response);
            } else if (action.equals("view")) {
                viewPurchaseOrder(request, response);
            } else if (action.equals("receive")) {
                receivePurchaseOrder(request, response);
            } else if (action.equals("cancel")) {
                cancelPurchaseOrder(request, response);
            } else {
                listPurchaseOrders(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                request.setAttribute("error", "Error: " + e.getMessage());
                request.getRequestDispatcher("purchases.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        try {
            if (action != null && action.equals("create")) {
                createPurchaseOrder(request, response);
            } else {
                listPurchaseOrders(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                request.setAttribute("error", "Error: " + e.getMessage());
                request.getRequestDispatcher("purchases.jsp").forward(request, response);
            }
        }
    }

    /**
     * List all purchase orders
     */
    private void listPurchaseOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<PurchaseOrder> purchaseOrders = purchaseDAO.getAllPurchaseOrders();
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();
        List<Medicine> medicines = medicineDAO.getAllMedicines();

        // Use "purchases" to match JSP expectation
        request.setAttribute("purchases", purchaseOrders);
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("medicines", medicines);
        request.getRequestDispatcher("purchases.jsp").forward(request, response);
    }

    /**
     * Create new purchase order
     */
    private void createPurchaseOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            // Get form parameters
            String supplierIdStr = request.getParameter("supplierId");
            if (supplierIdStr == null || supplierIdStr.trim().isEmpty()) {
                response.sendRedirect("purchases?error=Please select a supplier");
                return;
            }

            int supplierId = Integer.parseInt(supplierIdStr);
            String expectedDeliveryStr = request.getParameter("expectedDelivery");
            String notes = request.getParameter("notes");
            String taxPercentStr = request.getParameter("taxPercent");

            // Get medicine IDs, quantities, and unit costs (matching form field names)
            String[] medicineIds = request.getParameterValues("medicineId[]");
            String[] quantities = request.getParameterValues("quantity[]");
            String[] unitCosts = request.getParameterValues("unitCost[]"); // Changed from unitPrice[]

            if (medicineIds == null || medicineIds.length == 0) {
                response.sendRedirect("purchases?error=Please add at least one item");
                return;
            }

            // Create purchase order
            PurchaseOrder po = new PurchaseOrder();
            po.setPoNumber(purchaseDAO.generatePONumber());
            po.setSupplierId(supplierId);
            po.setUserId(user.getUserId());

            // Use current date as order date
            po.setOrderDate(Date.valueOf(LocalDate.now()));

            // Set expected delivery if provided
            if (expectedDeliveryStr != null && !expectedDeliveryStr.isEmpty()) {
                po.setExpectedDelivery(Date.valueOf(expectedDeliveryStr));
            }

            po.setStatus("pending");
            po.setNotes(notes != null ? notes : "");

            // Parse tax percent
            double taxPercent = 0;
            if (taxPercentStr != null && !taxPercentStr.isEmpty()) {
                try {
                    taxPercent = Double.parseDouble(taxPercentStr);
                } catch (NumberFormatException e) {
                    taxPercent = 0;
                }
            }

            // Create purchase items
            List<PurchaseItem> items = new ArrayList<>();
            double subtotal = 0;

            for (int i = 0; i < medicineIds.length; i++) {
                if (medicineIds[i] != null && !medicineIds[i].isEmpty()) {
                    try {
                        int medicineId = Integer.parseInt(medicineIds[i]);
                        int quantity = Integer.parseInt(quantities[i]);
                        double unitCost = Double.parseDouble(unitCosts[i]);
                        double itemTotal = quantity * unitCost;

                        // Get medicine name
                        Medicine medicine = medicineDAO.getMedicineById(medicineId);
                        String medicineName = medicine != null ? medicine.getMedicineName() : "Unknown";

                        PurchaseItem item = new PurchaseItem();
                        item.setMedicineId(medicineId);
                        item.setMedicineName(medicineName);
                        item.setQuantity(quantity);
                        item.setUnitPrice(unitCost);
                        item.setSubtotal(itemTotal);

                        items.add(item);
                        subtotal += itemTotal;
                    } catch (NumberFormatException e) {
                        System.err.println("Error parsing item " + i + ": " + e.getMessage());
                        continue;
                    }
                }
            }

            if (items.isEmpty()) {
                response.sendRedirect("purchases?error=No valid items to add");
                return;
            }

            // Calculate total with tax
            double taxAmount = (subtotal * taxPercent) / 100;
            double totalAmount = subtotal + taxAmount;

            po.setPurchaseItems(items);
            po.setTotalAmount(totalAmount);

            // Save to database
            boolean success = purchaseDAO.addPurchaseOrder(po);

            if (success) {
                response.sendRedirect("purchases?success=true");
            } else {
                response.sendRedirect("purchases?error=Failed to create purchase order");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("purchases?error=Invalid number format: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("purchases?error=" + e.getMessage());
        }
    }

    /**
     * View purchase order details
     */
    private void viewPurchaseOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int poId = Integer.parseInt(request.getParameter("id"));
            PurchaseOrder po = purchaseDAO.getPurchaseOrderById(poId);

            if (po != null) {
                request.setAttribute("purchaseOrder", po);
                request.getRequestDispatcher("view-purchase.jsp").forward(request, response);
            } else {
                response.sendRedirect("purchases?error=Purchase order not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("purchases?error=" + e.getMessage());
        }
    }

    /**
     * Mark purchase order as received (updates stock)
     */
    private void receivePurchaseOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int poId = Integer.parseInt(request.getParameter("id"));
            boolean success = purchaseDAO.updatePurchaseStatus(poId, "received");

            if (success) {
                response.sendRedirect("purchases?success=true");
            } else {
                response.sendRedirect("purchases?error=Failed to receive purchase order");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("purchases?error=" + e.getMessage());
        }
    }

    /**
     * Cancel purchase order
     */
    private void cancelPurchaseOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int poId = Integer.parseInt(request.getParameter("id"));
            boolean success = purchaseDAO.updatePurchaseStatus(poId, "cancelled");

            if (success) {
                response.sendRedirect("purchases?success=true");
            } else {
                response.sendRedirect("purchases?error=Failed to cancel purchase order");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("purchases?error=" + e.getMessage());
        }
    }
}