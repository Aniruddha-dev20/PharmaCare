package com.pharmacy.servlet;

import com.pharmacy.dao.MedicineDAO;
import com.pharmacy.model.Medicine;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * StockListServlet - Displays stock status
 * URL: /stock-list
 *
 * ALL ROLES can access this:
 * - Admin & Pharmacist: Full access (can click to edit)
 * - Cashier: VIEW ONLY (no edit buttons, redirects on modify attempts)
 */
@WebServlet("/stock-list")
public class StockListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MedicineDAO medicineDAO;

    @Override
    public void init() throws ServletException {
        medicineDAO = new MedicineDAO();
        System.out.println("✓ StockListServlet initialized");
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

        // Get user role
        String role = (String) session.getAttribute("role");
        boolean isCashier = "cashier".equalsIgnoreCase(role);

        String filter = request.getParameter("filter");

        try {
            List<Medicine> medicines = medicineDAO.getAllMedicines();

            // Apply filter if specified
            if (filter != null && !filter.isEmpty()) {
                switch (filter) {
                    case "available":
                        medicines = medicines.stream()
                                .filter(m -> "available".equals(m.getStatus()) && m.getStockQuantity() > m.getReorderLevel())
                                .collect(Collectors.toList());
                        break;
                    case "low":
                        medicines = medicines.stream()
                                .filter(m -> m.getStockQuantity() <= m.getReorderLevel() && m.getStockQuantity() > 0)
                                .collect(Collectors.toList());
                        break;
                    case "out":
                        medicines = medicines.stream()
                                .filter(m -> m.getStockQuantity() == 0)
                                .collect(Collectors.toList());
                        break;
                    default:
                        // Show all
                        break;
                }
            }

            // Calculate statistics
            long totalItems = medicines.size();
            long inStock = medicines.stream()
                    .filter(m -> "available".equals(m.getStatus()) && m.getStockQuantity() > m.getReorderLevel())
                    .count();
            long lowStock = medicines.stream()
                    .filter(m -> m.getStockQuantity() <= m.getReorderLevel() && m.getStockQuantity() > 0)
                    .count();
            long outOfStock = medicines.stream()
                    .filter(m -> m.getStockQuantity() == 0)
                    .count();

            request.setAttribute("medicines", medicines);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("inStock", inStock);
            request.setAttribute("lowStock", lowStock);
            request.setAttribute("outOfStock", outOfStock);
            request.setAttribute("currentFilter", filter);
            request.setAttribute("isCashier", isCashier); // Pass to JSP

            request.getRequestDispatcher("stock-list.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error loading stock list: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading stock data");
            request.getRequestDispatcher("stock-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}