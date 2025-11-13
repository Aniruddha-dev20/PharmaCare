<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login - PharmaCare</title>

  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <style>
    body {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .login-container {
      background: white;
      border-radius: 20px;
      box-shadow: 0 10px 40px rgba(0,0,0,0.2);
      overflow: hidden;
      max-width: 450px;
      width: 100%;
    }

    .login-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 40px;
      text-align: center;
    }

    .login-header i {
      font-size: 50px;
      margin-bottom: 15px;
    }

    .login-header h2 {
      margin: 0;
      font-weight: 600;
    }

    .login-header p {
      margin: 5px 0 0 0;
      opacity: 0.9;
      font-size: 14px;
    }

    .login-body {
      padding: 40px;
    }

    .form-control {
      padding: 12px 15px;
      border-radius: 10px;
      border: 1px solid #ddd;
    }

    .form-control:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
    }

    .input-group-text {
      background: #f8f9fa;
      border: 1px solid #ddd;
      border-radius: 10px 0 0 10px;
    }

    .btn-login {
      width: 100%;
      padding: 12px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border: none;
      border-radius: 10px;
      color: white;
      font-weight: 600;
      font-size: 16px;
      transition: transform 0.2s;
    }

    .btn-login:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    }

    .alert {
      border-radius: 10px;
      border: none;
    }

    .credentials-info {
      background: #f8f9fa;
      padding: 15px;
      border-radius: 10px;
      margin-top: 20px;
      font-size: 13px;
    }

    .credentials-info strong {
      color: #667eea;
    }
  </style>
</head>
<body>
<div class="login-container">
  <!-- Header -->
  <div class="login-header">
    <i class="fas fa-pills"></i>
    <h2>PharmaCare</h2>
  </div>

  <!-- Body -->
  <div class="login-body">
    <h4 class="text-center mb-4">Welcome Back!</h4>

    <!-- Error Message -->
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
      <i class="fas fa-exclamation-circle me-2"></i>
      <%= request.getAttribute("error") %>
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Logout Message -->
    <% if ("logout".equals(request.getParameter("message"))) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
      <i class="fas fa-check-circle me-2"></i>
      You have been successfully logged out.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Login Form -->
    <form action="login" method="post" id="loginForm">
      <div class="mb-3">
        <label for="username" class="form-label">
          <i class="fas fa-user me-1"></i> Username
        </label>
        <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-user"></i>
                        </span>
          <input type="text"
                 class="form-control"
                 id="username"
                 name="username"
                 placeholder="Enter username"
                 value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
                 required
                 autofocus>
        </div>
      </div>

      <div class="mb-4">
        <label for="password" class="form-label">
          <i class="fas fa-lock me-1"></i> Password
        </label>
        <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-lock"></i>
                        </span>
          <input type="password"
                 class="form-control"
                 id="password"
                 name="password"
                 placeholder="Enter password"
                 required>
          <button class="btn btn-outline-secondary" type="button" id="togglePassword">
            <i class="fas fa-eye"></i>
          </button>
        </div>
      </div>

      <button type="submit" class="btn btn-login">
        <i class="fas fa-sign-in-alt me-2"></i> Login
      </button>
    </form>

    <!-- Demo Credentials -->
    <div class="credentials-info">
      <strong><i class="fas fa-info-circle me-1"></i> Demo Credentials:</strong><br>
      <small>
        <strong>Admin:</strong> admin / admin123<br>
        <strong>Pharmacist:</strong> pharmacist1 / pharmacist123<br>
        <strong>Cashier:</strong> cashier1 / cashier123
      </small>
    </div>
  </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Toggle Password Visibility -->
<script>
  document.getElementById('togglePassword').addEventListener('click', function() {
    const passwordInput = document.getElementById('password');
    const icon = this.querySelector('i');

    if (passwordInput.type === 'password') {
      passwordInput.type = 'text';
      icon.classList.remove('fa-eye');
      icon.classList.add('fa-eye-slash');
    } else {
      passwordInput.type = 'password';
      icon.classList.remove('fa-eye-slash');
      icon.classList.add('fa-eye');
    }
  });

  // Form validation
  document.getElementById('loginForm').addEventListener('submit', function(e) {
    const username = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value.trim();

    if (!username || !password) {
      e.preventDefault();
      alert('Please enter both username and password');
    }
  });
</script>
</body>
</html>