package com.pharmacy.servlet;

import com.pharmacy.dao.CustomerDAO;
import com.pharmacy.model.Customer;

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
 * CustomerServlet - Handles all customer operations
 * URL: /customers
 */
@WebServlet("/customers")
public class CustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
        System.out.println("✓ CustomerServlet initialized");
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
                listCustomers(request, response);
            } else if (action.equals("add")) {
                showAddForm(request, response);
            } else if (action.equals("edit")) {
                showEditForm(request, response);
            } else if (action.equals("delete")) {
                deleteCustomer(request, response);
            } else {
                listCustomers(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("customers.jsp").forward(request, response);
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
                addCustomer(request, response);
            } else if (action.equals("update")) {
                updateCustomer(request, response);
            } else {
                listCustomers(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("customers.jsp").forward(request, response);
        }
    }

    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Customer> customers = customerDAO.getAllCustomers();
        request.setAttribute("customers", customers);
        request.getRequestDispatcher("customers.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("add-customer.jsp").forward(request, response);
    }

    private void addCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String customerName = request.getParameter("customerName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String dobStr = request.getParameter("dateOfBirth");

        Customer customer = new Customer();
        customer.setCustomerName(customerName);
        customer.setPhone(phone);
        customer.setEmail(email);
        customer.setAddress(address);
        customer.setCity(city);

        if (dobStr != null && !dobStr.isEmpty()) {
            customer.setDateOfBirth(Date.valueOf(dobStr));
        }

        boolean success = customerDAO.addCustomer(customer);

        if (success) {
            response.sendRedirect("customers?success=added");
        } else {
            request.setAttribute("error", "Failed to add customer");
            showAddForm(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("id"));
        Customer customer = customerDAO.getCustomerById(customerId);
        request.setAttribute("customer", customer);
        request.getRequestDispatcher("edit-customer.jsp").forward(request, response);
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String customerName = request.getParameter("customerName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String dobStr = request.getParameter("dateOfBirth");

        Customer customer = new Customer();
        customer.setCustomerId(customerId);
        customer.setCustomerName(customerName);
        customer.setPhone(phone);
        customer.setEmail(email);
        customer.setAddress(address);
        customer.setCity(city);

        if (dobStr != null && !dobStr.isEmpty()) {
            customer.setDateOfBirth(Date.valueOf(dobStr));
        }

        boolean success = customerDAO.updateCustomer(customer);

        if (success) {
            response.sendRedirect("customers?success=updated");
        } else {
            request.setAttribute("error", "Failed to update customer");
            showEditForm(request, response);
        }
    }

    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int customerId = Integer.parseInt(request.getParameter("id"));
        boolean success = customerDAO.deleteCustomer(customerId);

        if (success) {
            response.sendRedirect("customers?success=deleted");
        } else {
            response.sendRedirect("customers?error=delete_failed");
        }
    }
}