<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found | Pharmacy System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .error-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 60px 40px;
            text-align: center;
            max-width: 600px;
            width: 100%;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .error-icon {
            font-size: 120px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 20px;
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-10px);
            }
        }

        .error-code {
            font-size: 80px;
            font-weight: 900;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 10px;
            line-height: 1;
        }

        .error-title {
            font-size: 28px;
            font-weight: 700;
            color: #333;
            margin-bottom: 15px;
        }

        .error-message {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .error-details {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 30px;
            font-size: 14px;
            color: #666;
            text-align: left;
        }

        .error-details strong {
            color: #333;
        }

        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-custom {
            padding: 12px 30px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
            color: white;
        }

        .btn-secondary-custom {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
        }

        .btn-secondary-custom:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }

        .helpful-links {
            margin-top: 30px;
            padding-top: 30px;
            border-top: 2px solid #f0f0f0;
        }

        .helpful-links h4 {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
        }

        .links-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 10px;
        }

        .link-item {
            padding: 10px;
            background: #f8f9fa;
            border-radius: 8px;
            text-decoration: none;
            color: #667eea;
            font-size: 14px;
            transition: all 0.3s;
        }

        .link-item:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }

        .link-item i {
            margin-right: 5px;
        }

        @media (max-width: 768px) {
            .error-container {
                padding: 40px 20px;
            }

            .error-code {
                font-size: 60px;
            }

            .error-title {
                font-size: 22px;
            }

            .btn-group {
                flex-direction: column;
            }

            .btn-custom {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
<div class="error-container">
    <div class="error-icon">
        <i class="fas fa-search"></i>
    </div>

    <div class="error-code">404</div>
    <h1 class="error-title">Page Not Found</h1>
    <p class="error-message">
        Oops! The page you're looking for doesn't exist. It might have been moved or deleted.
    </p>

    <div class="error-details">
        <strong>Requested URL:</strong> <%= request.getAttribute("javax.servlet.error.request_uri") != null ?
            request.getAttribute("javax.servlet.error.request_uri") : "Unknown" %>
    </div>

    <div class="btn-group">
        <a href="<%= request.getContextPath() %>/dashboard" class="btn-custom btn-primary-custom">
            <i class="fas fa-home"></i> Go to Dashboard
        </a>
        <a href="javascript:history.back()" class="btn-custom btn-secondary-custom">
            <i class="fas fa-arrow-left"></i> Go Back
        </a>
    </div>

    <div class="helpful-links">
        <h4>Quick Links</h4>
        <div class="links-grid">
            <a href="<%= request.getContextPath() %>/medicines" class="link-item">
                <i class="fas fa-pills"></i> Medicines
            </a>
            <a href="<%= request.getContextPath() %>/stock-list" class="link-item">
                <i class="fas fa-boxes"></i> Stock List
            </a>
            <a href="<%= request.getContextPath() %>/sales" class="link-item">
                <i class="fas fa-shopping-cart"></i> Sales
            </a>
            <a href="<%= request.getContextPath() %>/customers" class="link-item">
                <i class="fas fa-users"></i> Customers
            </a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>