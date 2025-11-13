package com.pharmacy.servlet;

import com.pharmacy.dao.SaleDAO;
import com.pharmacy.dao.MedicineDAO;
import com.pharmacy.model.Sale;
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
 * ReportServlet - Handles reports generation
 * URL: /reports
 */
@WebServlet("/reports")
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SaleDAO saleDAO;
    private MedicineDAO medicineDAO;

    @Override
    public void init() throws ServletException {
        saleDAO = new SaleDAO();
        medicineDAO = new MedicineDAO();
        System.out.println("✓ ReportServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String reportType = request.getParameter("type");

        try {
            if (reportType == null || reportType.equals("dashboard")) {
                showReportsDashboard(request, response);
            } else if (reportType.equals("sales")) {
                generateSalesReport(request, response);
            } else if (reportType.equals("stock")) {
                generateStockReport(request, response);
            } else if (reportType.equals("expiry")) {
                generateExpiryReport(request, response);
            } else {
                showReportsDashboard(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("reports.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void showReportsDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("reports.jsp").forward(request, response);
    }

    private void generateSalesReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Sale> sales = saleDAO.getAllSales();
        request.setAttribute("sales", sales);
        request.setAttribute("reportType", "sales");
        request.getRequestDispatcher("reports.jsp").forward(request, response);
    }

    private void generateStockReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Medicine> medicines = medicineDAO.getAllMedicines();
        request.setAttribute("medicines", medicines);
        request.setAttribute("reportType", "stock");
        request.getRequestDispatcher("reports.jsp").forward(request, response);
    }

    private void generateExpiryReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Medicine> expiringMedicines = medicineDAO.getExpiringMedicines();
        request.setAttribute("expiringMedicines", expiringMedicines);
        request.setAttribute("reportType", "expiry");
        request.getRequestDispatcher("reports.jsp").forward(request, response);
    }
}