<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 - Access Forbidden | Pharmacy System</title>
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
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 20px;
            animation: shake 2s infinite;
        }

        @keyframes shake {
            0%, 100% {
                transform: rotate(0deg);
            }
            10%, 30%, 50%, 70%, 90% {
                transform: rotate(-3deg);
            }
            20%, 40%, 60%, 80% {
                transform: rotate(3deg);
            }
        }

        .error-code {
            font-size: 80px;
            font-weight: 900;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
            background: #fff5f5;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border-left: 4px solid #f5576c;
        }

        .error-details h4 {
            color: #f5576c;
            font-size: 16px;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .error-details p {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
            text-align: left;
        }

        .error-details strong {
            color: #333;
        }

        .role-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
        }

        .role-info p {
            margin: 0;
            font-size: 13px;
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
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            border: none;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(245, 87, 108, 0.4);
            color: white;
        }

        .btn-secondary-custom {
            background: white;
            color: #f5576c;
            border: 2px solid #f5576c;
        }

        .btn-secondary-custom:hover {
            background: #f5576c;
            color: white;
            transform: translateY(-2px);
        }

        .contact-section {
            margin-top: 30px;
            padding-top: 30px;
            border-top: 2px solid #f0f0f0;
        }

        .contact-section h4 {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
        }

        .contact-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .contact-item {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            text-align: center;
        }

        .contact-item i {
            font-size: 24px;
            color: #f5576c;
            margin-bottom: 8px;
        }

        .contact-item h5 {
            font-size: 14px;
            color: #333;
            margin-bottom: 5px;
        }

        .contact-item p {
            font-size: 13px;
            color: #666;
            margin: 0;
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
        <i class="fas fa-lock"></i>
    </div>

    <div class="error-code">403</div>
    <h1 class="error-title">Access Forbidden</h1>
    <p class="error-message">
        You don't have permission to access this resource. This page is restricted based on your role.
    </p>

    <div class="error-details">
        <h4><i class="fas fa-info-circle"></i> Why am I seeing this?</h4>
        <p>
            <strong>Your Role:</strong>
            <%= session.getAttribute("role") != null ?
                    ((String) session.getAttribute("role")).toUpperCase() : "Not logged in" %>
        </p>
        <p>
            The page you're trying to access requires different permissions than your current role allows.
        </p>

        <div class="role-info">
            <p><strong>👑 Admin:</strong> Full access to all modules</p>
            <p><strong>💊 Pharmacist:</strong> Medicine, Stock, Supplier, Purchase</p>
            <p><strong>🛒 Cashier:</strong> Sales, Stock (view only), Customers</p>
        </div>
    </div>

    <div class="btn-group">
        <a href="<%= request.getContextPath() %>/dashboard" class="btn-custom btn-primary-custom">
            <i class="fas fa-home"></i> Go to Dashboard
        </a>
        <a href="javascript:history.back()" class="btn-custom btn-secondary-custom">
            <i class="fas fa-arrow-left"></i> Go Back
        </a>
    </div>

    <div class="contact-section">
        <h4>Need Help?</h4>
        <div class="contact-grid">
            <div class="contact-item">
                <i class="fas fa-user-shield"></i>
                <h5>Contact Admin</h5>
                <p>Request access permissions</p>
            </div>
            <div class="contact-item">
                <i class="fas fa-question-circle"></i>
                <h5>Help Center</h5>
                <p>View documentation</p>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>