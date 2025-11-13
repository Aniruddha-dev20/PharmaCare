<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pharmacy.model.User" %>
<%
  if (session.getAttribute("user") == null || !"admin".equalsIgnoreCase((String)session.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
  }

  User editUser = (User) request.getAttribute("user");
  boolean isEdit = editUser != null;
%>
<%
  String pageTitle = isEdit ? "Edit User" : "Add User";
%>
<jsp:include page="includes/header.jsp">
  <jsp:param name="title" value="<%= pageTitle %>" />
</jsp:include>


<jsp:include page="includes/sidebar.jsp">
  <jsp:param name="active" value="users" />
</jsp:include>

<div class="content-area">
  <div class="page-header">
    <h1 class="page-title">
      <i class="fas fa-<%= isEdit ? "edit" : "plus" %>"></i>
      <%= isEdit ? "Edit User" : "Add New User" %>
    </h1>
  </div>

  <div class="card border-0 shadow-sm">
    <div class="card-body">
      <form action="user" method="post">
        <input type="hidden" name="action" value="<%= isEdit ? "update" : "add" %>">
        <% if (isEdit) { %>
        <input type="hidden" name="userId" value="<%= editUser.getUserId() %>">
        <% } %>

        <div class="row">
          <div class="col-md-6 mb-3">
            <label class="form-label">Username *</label>
            <input type="text" class="form-control" name="username"
                   value="<%= isEdit ? editUser.getUsername() : "" %>"
              <%= isEdit ? "readonly" : "required" %>>
          </div>

          <% if (!isEdit) { %>
          <div class="col-md-6 mb-3">
            <label class="form-label">Password *</label>
            <input type="password" class="form-control" name="password" required>
          </div>
          <% } %>

          <div class="col-md-6 mb-3">
            <label class="form-label">Full Name *</label>
            <input type="text" class="form-control" name="fullName"
                   value="<%= isEdit ? editUser.getFullName() : "" %>" required>
          </div>

          <div class="col-md-6 mb-3">
            <label class="form-label">Email</label>
            <input type="email" class="form-control" name="email"
                   value="<%= isEdit ? (editUser.getEmail() != null ? editUser.getEmail() : "") : "" %>">
          </div>

          <div class="col-md-6 mb-3">
            <label class="form-label">Phone</label>
            <input type="tel" class="form-control" name="phone"
                   value="<%= isEdit ? (editUser.getPhone() != null ? editUser.getPhone() : "") : "" %>">
          </div>

          <div class="col-md-6 mb-3">
            <label class="form-label">Role *</label>
            <select class="form-select" name="role" required>
              <option value="">Select Role</option>
              <option value="admin" <%= isEdit && "admin".equals(editUser.getRole()) ? "selected" : "" %>>Admin</option>
              <option value="pharmacist" <%= isEdit && "pharmacist".equals(editUser.getRole()) ? "selected" : "" %>>Pharmacist</option>
              <option value="cashier" <%= isEdit && "cashier".equals(editUser.getRole()) ? "selected" : "" %>>Cashier</option>
            </select>
          </div>

          <% if (isEdit) { %>
          <div class="col-md-6 mb-3">
            <label class="form-label">Status *</label>
            <select class="form-select" name="status" required>
              <option value="active" <%= "active".equals(editUser.getStatus()) ? "selected" : "" %>>Active</option>
              <option value="inactive" <%= "inactive".equals(editUser.getStatus()) ? "selected" : "" %>>Inactive</option>
            </select>
          </div>
          <% } %>
        </div>

        <div class="mt-4">
          <button type="submit" class="btn btn-primary">
            <i class="fas fa-save me-2"></i>
            <%= isEdit ? "Update User" : "Add User" %>
          </button>
          <a href="user?action=list" class="btn btn-secondary">
            <i class="fas fa-times me-2"></i>Cancel
          </a>
        </div>
      </form>
    </div>
  </div>
</div>

<jsp:include page="includes/footer.jsp" />
