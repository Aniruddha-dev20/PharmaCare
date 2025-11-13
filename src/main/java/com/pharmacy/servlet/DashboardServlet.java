package com.pharmacy.servlet;

import com.pharmacy.dao.DashboardDAO;
import com.pharmacy.dao.MedicineDAO;
import com.pharmacy.model.DashboardStats;
import com.pharmacy.model.Medicine;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * DashboardServlet - Displays dashboard with statistics
 * URL: /dashboard
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DashboardDAO dashboardDAO;
    private MedicineDAO medicineDAO;

    @Override
    public void init() throws ServletException {
        dashboardDAO = new DashboardDAO();
        medicineDAO = new MedicineDAO();
        System.out.println("✓ DashboardServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // Get dashboard statistics
            DashboardStats stats = dashboardDAO.getDashboardStats();
            request.setAttribute("stats", stats);

            // Get low stock medicines
            List<Medicine> lowStockMedicines = medicineDAO.getLowStockMedicines();
            request.setAttribute("lowStockMedicines", lowStockMedicines);

            // Get expiring medicines
            List<Medicine> expiringMedicines = medicineDAO.getExpiringMedicines();
            request.setAttribute("expiringMedicines", expiringMedicines);

            // Forward to dashboard page
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error loading dashboard: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading dashboard data");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}