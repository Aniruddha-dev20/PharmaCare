<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap 5.3.2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">

    <!-- Font Awesome 6.4.0 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- Custom CSS -->
    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --sidebar-width: 260px;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }

        /* Top Navbar */
        .top-navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 15px 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
        }

        .top-navbar .navbar-brand {
            color: white;
            font-weight: 600;
            font-size: 22px;
        }

        .top-navbar .navbar-brand i {
            margin-right: 10px;
        }

        .user-info {
            color: white;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .btn-logout {
            background: rgba(255,255,255,0.2);
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 20px;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-logout:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
            color: white;
        }

        /* Main Layout */
        .main-wrapper {
            display: flex;
            margin-top: 70px;
        }

        /* Content Area */
        .content-area {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 30px;
            min-height: calc(100vh - 70px);
        }

        .page-header {
            margin-bottom: 30px;
        }

        .page-title {
            font-size: 28px;
            font-weight: 600;
            color: #333;
            margin: 0;
        }

        .page-subtitle {
            color: #666;
            margin: 5px 0 0 0;
        }

        /* Card Styles */
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }

        .card-header {
            background: white;
            border-bottom: 1px solid #dee2e6;
            padding: 20px;
            border-radius: 15px 15px 0 0;
        }

        .card-body {
            padding: 20px;
        }

        /* Button Styles */
        .btn {
            border-radius: 8px;
            padding: 8px 20px;
            font-weight: 500;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #5568d3 0%, #6a3f8f 100%);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
<!-- Top Navbar -->
<nav class="top-navbar">
    <div class="d-flex justify-content-between align-items-center">
            <a href="logout" class="btn btn-logout">
                <i class="fas fa-sign-out-alt me-1"></i> Logout
            </a>
        </div>
</nav>

<div class="main-wrapper">
</div>