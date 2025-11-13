package com.pharmacy.servlet;

import com.pharmacy.dao.SupplierDAO;
import com.pharmacy.model.Supplier;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * SupplierServlet - Handles all supplier operations
 * URL: /suppliers
 */
@WebServlet("/suppliers")
public class SupplierServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SupplierDAO supplierDAO;

    @Override
    public void init() throws ServletException {
        supplierDAO = new SupplierDAO();
        System.out.println("✓ SupplierServlet initialized");
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
                listSuppliers(request, response);
            } else if (action.equals("add")) {
                showAddForm(request, response);
            } else if (action.equals("edit")) {
                showEditForm(request, response);
            } else if (action.equals("delete")) {
                deleteSupplier(request, response);
            } else {
                listSuppliers(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("suppliers.jsp").forward(request, response);
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
            if (action.equals("add")) {
                addSupplier(request, response);
            } else if (action.equals("update")) {
                updateSupplier(request, response);
            } else {
                listSuppliers(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("suppliers.jsp").forward(request, response);
        }
    }

    private void listSuppliers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();
        request.setAttribute("suppliers", suppliers);
        request.getRequestDispatcher("suppliers.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("add-supplier.jsp").forward(request, response);
    }

    private void addSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String supplierName = request.getParameter("supplierName");
        String contactPerson = request.getParameter("contactPerson");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");

        Supplier supplier = new Supplier();
        supplier.setSupplierName(supplierName);
        supplier.setContactPerson(contactPerson);
        supplier.setPhone(phone);
        supplier.setEmail(email);
        supplier.setAddress(address);
        supplier.setCity(city);
        supplier.setState(state);
        supplier.setPincode(pincode);

        boolean success = supplierDAO.addSupplier(supplier);

        if (success) {
            response.sendRedirect("suppliers?success=added");
        } else {
            request.setAttribute("error", "Failed to add supplier");
            showAddForm(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int supplierId = Integer.parseInt(request.getParameter("id"));
        Supplier supplier = supplierDAO.getSupplierById(supplierId);
        request.setAttribute("supplier", supplier);
        request.getRequestDispatcher("edit-supplier.jsp").forward(request, response);
    }

    private void updateSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int supplierId = Integer.parseInt(request.getParameter("supplierId"));
        String supplierName = request.getParameter("supplierName");
        String contactPerson = request.getParameter("contactPerson");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");

        Supplier supplier = new Supplier();
        supplier.setSupplierId(supplierId);
        supplier.setSupplierName(supplierName);
        supplier.setContactPerson(contactPerson);
        supplier.setPhone(phone);
        supplier.setEmail(email);
        supplier.setAddress(address);
        supplier.setCity(city);
        supplier.setState(state);
        supplier.setPincode(pincode);

        boolean success = supplierDAO.updateSupplier(supplier);

        if (success) {
            response.sendRedirect("suppliers?success=updated");
        } else {
            request.setAttribute("error", "Failed to update supplier");
            showEditForm(request, response);
        }
    }

    private void deleteSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int supplierId = Integer.parseInt(request.getParameter("id"));
        boolean success = supplierDAO.deleteSupplier(supplierId);

        if (success) {
            response.sendRedirect("suppliers?success=deleted");
        } else {
            response.sendRedirect("suppliers?error=delete_failed");
        }
    }
}