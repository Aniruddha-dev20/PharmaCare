package com.pharmacy.servlet;

import com.pharmacy.dao.SaleDAO;
import com.pharmacy.dao.MedicineDAO;
import com.pharmacy.model.Sale;
import com.pharmacy.model.SaleItem;
import com.pharmacy.model.User;
import com.pharmacy.model.Medicine;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/sales")
public class SaleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SaleDAO saleDAO;
    private MedicineDAO medicineDAO;

    @Override
    public void init() throws ServletException {
        saleDAO = new SaleDAO();
        medicineDAO = new MedicineDAO();
        System.out.println("✓ SaleServlet initialized");
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
                listSales(request, response);
            } else if (action.equals("view")) {
                viewSale(request, response);
            } else if (action.equals("print")) {
                printInvoice(request, response);
            } else {
                listSales(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("sales.jsp").forward(request, response);
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
            if (action.equals("create")) {
                createSale(request, response);
            } else {
                listSales(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("sales.jsp").forward(request, response);
        }
    }

    private void listSales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Sale> sales = saleDAO.getAllSales();
        request.setAttribute("sales", sales);
        request.getRequestDispatcher("sales.jsp").forward(request, response);
    }

    private void createSale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            // Get form parameters
            String customerName = request.getParameter("customerName");
            String customerPhone = request.getParameter("customerPhone");
            String paymentMethod = request.getParameter("paymentMethod");
            String notes = request.getParameter("notes");

            String discountParam = request.getParameter("discount");
            double discount = 0;
            if (discountParam != null && !discountParam.isEmpty()) {
                try {
                    discount = Double.parseDouble(discountParam);
                } catch (NumberFormatException e) {
                    discount = 0;
                }
            }

            // Get medicine IDs, quantities, and prices
            String[] medicineIds = request.getParameterValues("medicineId[]");
            String[] quantities = request.getParameterValues("quantity[]");
            String[] unitPrices = request.getParameterValues("unitPrice[]");

            if (medicineIds == null || medicineIds.length == 0) {
                request.setAttribute("error", "Please add at least one item");
                listSales(request, response);
                return;
            }

            // Create sale object
            Sale sale = new Sale();
            sale.setInvoiceNumber(saleDAO.generateInvoiceNumber());
            sale.setUserId(user.getUserId());
            sale.setCustomerName(customerName);
            sale.setCustomerPhone(customerPhone);
            sale.setDiscount(discount);
            sale.setPaymentMethod(paymentMethod);
            sale.setNotes(notes);

            // Create sale items
            List<SaleItem> saleItems = new ArrayList<>();
            double totalAmount = 0;

            for (int i = 0; i < medicineIds.length; i++) {
                if (medicineIds[i] != null && !medicineIds[i].isEmpty()) {
                    int medicineId = Integer.parseInt(medicineIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);
                    double unitPrice = Double.parseDouble(unitPrices[i]);
                    double subtotal = quantity * unitPrice;

                    // **CRITICAL FIX: Add null check**
                    Medicine medicine = medicineDAO.getMedicineById(medicineId);
                    if (medicine == null) {
                        throw new Exception("Medicine not found with ID: " + medicineId);
                    }

                    // Check stock availability
                    if (medicine.getStockQuantity() < quantity) {
                        throw new Exception("Insufficient stock for " + medicine.getMedicineName() +
                                ". Available: " + medicine.getStockQuantity() +
                                ", Requested: " + quantity);
                    }

                    String medicineName = medicine.getMedicineName();

                    SaleItem item = new SaleItem();
                    item.setMedicineId(medicineId);
                    item.setMedicineName(medicineName);
                    item.setQuantity(quantity);
                    item.setUnitPrice(unitPrice);
                    item.setSubtotal(subtotal);

                    saleItems.add(item);
                    totalAmount += subtotal;
                }
            }

            sale.setSaleItems(saleItems);
            sale.setTotalAmount(totalAmount);
            sale.setFinalAmount(totalAmount - discount);

            // Save to database
            boolean success = saleDAO.addSale(sale);

            if (success) {
                System.out.println("✓ Sale created successfully: " + sale.getInvoiceNumber());
                response.sendRedirect("sales?success=true");
            } else {
                request.setAttribute("error", "Failed to create sale");
                listSales(request, response);
            }

        } catch (Exception e) {
            System.err.println("✗ Error creating sale: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error creating sale: " + e.getMessage());
            listSales(request, response);
        }
    }

    private void viewSale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int saleId = Integer.parseInt(request.getParameter("id"));
        Sale sale = saleDAO.getSaleById(saleId);

        request.setAttribute("sale", sale);
        request.getRequestDispatcher("view-sale.jsp").forward(request, response);
    }

    private void printInvoice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int saleId = Integer.parseInt(request.getParameter("id"));
        Sale sale = saleDAO.getSaleById(saleId);

        request.setAttribute("sale", sale);
        request.getRequestDispatcher("print-invoice.jsp").forward(request, response);
    }
}