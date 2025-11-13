package com.pharmacy.servlet;

import com.pharmacy.dao.MedicineDAO;
import com.pharmacy.dao.SupplierDAO;
import com.pharmacy.model.Medicine;
import com.pharmacy.model.Supplier;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

/**
 * MedicineServlet - Handles all medicine operations (CRUD)
 * URL: /medicines
 */
@WebServlet("/medicines")
public class MedicineServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MedicineDAO medicineDAO;
    private SupplierDAO supplierDAO;

    @Override
    public void init() throws ServletException {
        medicineDAO = new MedicineDAO();
        supplierDAO = new SupplierDAO();
        System.out.println("✓ MedicineServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        try {
            if (action == null || action.equals("list")) {
                listMedicines(request, response);
            } else if (action.equals("add")) {
                showAddForm(request, response);
            } else if (action.equals("edit")) {
                showEditForm(request, response);
            } else if (action.equals("delete")) {
                deleteMedicine(request, response);
            } else if (action.equals("search")) {
                searchMedicines(request, response);
            } else {
                listMedicines(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("medicines.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        try {
            if (action.equals("add")) {
                addMedicine(request, response);
            } else if (action.equals("update")) {
                updateMedicine(request, response);
            } else {
                listMedicines(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("medicines.jsp").forward(request, response);
        }
    }

    /**
     * List all medicines
     */
    private void listMedicines(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Medicine> medicines = medicineDAO.getAllMedicines();
        request.setAttribute("medicines", medicines);
        request.getRequestDispatcher("medicines.jsp").forward(request, response);
    }

    /**
     * Search medicines
     */
    private void searchMedicines(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchTerm = request.getParameter("search");
        List<Medicine> medicines;

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            medicines = medicineDAO.searchMedicines(searchTerm);
            request.setAttribute("searchTerm", searchTerm);
        } else {
            medicines = medicineDAO.getAllMedicines();
        }

        request.setAttribute("medicines", medicines);
        request.getRequestDispatcher("medicines.jsp").forward(request, response);
    }

    /**
     * Show add medicine form
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Supplier> suppliers = supplierDAO.getAllSuppliers();
        request.setAttribute("suppliers", suppliers);
        request.getRequestDispatcher("add-medicine.jsp").forward(request, response);
    }

    /**
     * Add new medicine
     */
    private void addMedicine(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get form parameters
            String medicineName = request.getParameter("medicineName");
            String genericName = request.getParameter("genericName");
            String category = request.getParameter("category");
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            double unitPrice = Double.parseDouble(request.getParameter("unitPrice"));
            double sellingPrice = Double.parseDouble(request.getParameter("sellingPrice"));
            int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            int reorderLevel = Integer.parseInt(request.getParameter("reorderLevel"));
            Date expiryDate = Date.valueOf(request.getParameter("expiryDate"));
            Date manufactureDate = request.getParameter("manufactureDate") != null &&
                    !request.getParameter("manufactureDate").isEmpty()
                    ? Date.valueOf(request.getParameter("manufactureDate"))
                    : null;
            String batchNumber = request.getParameter("batchNumber");
            String description = request.getParameter("description");
            String rackNumber = request.getParameter("rackNumber");

            // Create medicine object
            Medicine medicine = new Medicine();
            medicine.setMedicineName(medicineName);
            medicine.setGenericName(genericName);
            medicine.setCategory(category);
            medicine.setSupplierId(supplierId);
            medicine.setUnitPrice(unitPrice);
            medicine.setSellingPrice(sellingPrice);
            medicine.setStockQuantity(stockQuantity);
            medicine.setReorderLevel(reorderLevel);
            medicine.setExpiryDate(expiryDate);
            medicine.setManufactureDate(manufactureDate);
            medicine.setBatchNumber(batchNumber);
            medicine.setDescription(description);
            medicine.setRackNumber(rackNumber);

            // Add to database
            boolean success = medicineDAO.addMedicine(medicine);

            if (success) {
                response.sendRedirect("medicines?success=added");
            } else {
                request.setAttribute("error", "Failed to add medicine");
                showAddForm(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            showAddForm(request, response);
        }
    }

    /**
     * Show edit medicine form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int medicineId = Integer.parseInt(request.getParameter("id"));
        Medicine medicine = medicineDAO.getMedicineById(medicineId);
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();

        request.setAttribute("medicine", medicine);
        request.setAttribute("suppliers", suppliers);
        request.getRequestDispatcher("edit-medicine.jsp").forward(request, response);
    }

    /**
     * Update medicine
     */
    private void updateMedicine(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get form parameters
            int medicineId = Integer.parseInt(request.getParameter("medicineId"));
            String medicineName = request.getParameter("medicineName");
            String genericName = request.getParameter("genericName");
            String category = request.getParameter("category");
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            double unitPrice = Double.parseDouble(request.getParameter("unitPrice"));
            double sellingPrice = Double.parseDouble(request.getParameter("sellingPrice"));
            int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            int reorderLevel = Integer.parseInt(request.getParameter("reorderLevel"));
            Date expiryDate = Date.valueOf(request.getParameter("expiryDate"));
            Date manufactureDate = request.getParameter("manufactureDate") != null &&
                    !request.getParameter("manufactureDate").isEmpty()
                    ? Date.valueOf(request.getParameter("manufactureDate"))
                    : null;
            String batchNumber = request.getParameter("batchNumber");
            String description = request.getParameter("description");
            String rackNumber = request.getParameter("rackNumber");
            String status = request.getParameter("status");

            // Create medicine object
            Medicine medicine = new Medicine();
            medicine.setMedicineId(medicineId);
            medicine.setMedicineName(medicineName);
            medicine.setGenericName(genericName);
            medicine.setCategory(category);
            medicine.setSupplierId(supplierId);
            medicine.setUnitPrice(unitPrice);
            medicine.setSellingPrice(sellingPrice);
            medicine.setStockQuantity(stockQuantity);
            medicine.setReorderLevel(reorderLevel);
            medicine.setExpiryDate(expiryDate);
            medicine.setManufactureDate(manufactureDate);
            medicine.setBatchNumber(batchNumber);
            medicine.setDescription(description);
            medicine.setRackNumber(rackNumber);
            medicine.setStatus(status);

            // Update in database
            boolean success = medicineDAO.updateMedicine(medicine);

            if (success) {
                response.sendRedirect("medicines?success=updated");
            } else {
                request.setAttribute("error", "Failed to update medicine");
                showEditForm(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            showEditForm(request, response);
        }
    }

    /**
     * Delete medicine
     */
    private void deleteMedicine(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int medicineId = Integer.parseInt(request.getParameter("id"));
            boolean success = medicineDAO.deleteMedicine(medicineId);

            if (success) {
                response.sendRedirect("medicines?success=deleted");
            } else {
                response.sendRedirect("medicines?error=delete_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("medicines?error=" + e.getMessage());
        }
    }
}