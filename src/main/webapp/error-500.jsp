<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Server Error | Pharmacy System</title>
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
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
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
            max-width: 700px;
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
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 20px;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
        }

        .error-code {
            font-size: 80px;
            font-weight: 900;
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
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
            background: #fff9e6;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border-left: 4px solid #fee140;
            text-align: left;
        }

        .error-details h4 {
            color: #fa709a;
            font-size: 16px;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .error-details p {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .error-details strong {
            color: #333;
        }

        .error-stack {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
            max-height: 200px;
            overflow-y: auto;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            text-align: left;
            color: #d63031;
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
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            color: white;
            border: none;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(250, 112, 154, 0.4);
            color: white;
        }

        .btn-secondary-custom {
            background: white;
            color: #fa709a;
            border: 2px solid #fa709a;
        }

        .btn-secondary-custom:hover {
            background: #fa709a;
            color: white;
            transform: translateY(-2px);
        }

        .help-section {
            margin-top: 30px;
            padding-top: 30px;
            border-top: 2px solid #f0f0f0;
        }

        .help-section h4 {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
        }

        .help-steps {
            text-align: left;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
        }

        .help-steps ol {
            padding-left: 20px;
            margin: 0;
        }

        .help-steps li {
            margin-bottom: 10px;
            color: #666;
            font-size: 14px;
        }

        .help-steps li strong {
            color: #333;
        }

        .timestamp {
            font-size: 12px;
            color: #999;
            margin-top: 20px;
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
        <i class="fas fa-exclamation-triangle"></i>
    </div>

    <div class="error-code">500</div>
    <h1 class="error-title">Internal Server Error</h1>
    <p class="error-message">
        Oops! Something went wrong on our end. We're working to fix the issue.
    </p>

    <div class="error-details">
        <h4><i class="fas fa-bug"></i> Error Information</h4>
        <p>
            <strong>Error Type:</strong>
            <%= exception != null ? exception.getClass().getSimpleName() : "Server Error" %>
        </p>
        <p>
            <strong>Message:</strong>
            <%= exception != null && exception.getMessage() != null ? exception.getMessage() : "An unexpected error occurred" %>
        </p>

        <% if (exception != null && request.getParameter("debug") != null) { %>
        <div class="error-stack">
            <strong>Stack Trace:</strong><br>
            <%
                java.io.StringWriter sw = new java.io.StringWriter();
                java.io.PrintWriter pw = new java.io.PrintWriter(sw);
                exception.printStackTrace(pw);
                out.println(sw.toString().replace("<", "&lt;").replace(">", "&gt;"));
            %>
        </div>
        <% } %>
    </div>

    <div class="btn-group">
        <a href="<%= request.getContextPath() %>/dashboard" class="btn-custom btn-primary-custom">
            <i class="fas fa-home"></i> Go to Dashboard
        </a>
        <a href="javascript:location.reload()" class="btn-custom btn-secondary-custom">
            <i class="fas fa-redo"></i> Reload Page
        </a>
    </div>

    <div class="help-section">
        <h4>What can you do?</h4>
        <div class="help-steps">
            <ol>
                <li><strong>Refresh the page</strong> - Sometimes this resolves temporary issues</li>
                <li><strong>Check your internet connection</strong> - Ensure you're connected</li>
                <li><strong>Clear browser cache</strong> - Old cached data might cause issues</li>
                <li><strong>Try again later</strong> - Our team might be performing maintenance</li>
                <li><strong>Contact support</strong> - If the problem persists, reach out to the system administrator</li>
            </ol>
        </div>
    </div>

    <div class="timestamp">
        <i class="fas fa-clock"></i>
        Error occurred at: <%= new java.text.SimpleDateFormat("dd-MMM-yyyy HH:mm:ss").format(new java.util.Date()) %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>