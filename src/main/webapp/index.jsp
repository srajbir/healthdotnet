<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>HealthDotNet</title>
    <link rel="icon" type="image/svg+xml" href="./images/favicon.svg">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #e0f7fa, #e8f5e9);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: default;
        }

        .container {
            background: white;
            width: 400px;
            padding: 40px;
            text-align: center;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        }

        p {
            color: #555;
            margin-bottom: 30px;
        }

        .btn {
            display: block;
            width: 100%;
            padding: 12px 0;
            margin: 10px 0;
            font-size: 16px;
            font-weight: 600;
            color: #00796b;
            background: white;
            border: 2px solid #00796b;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.2s ease, transform 0.2s ease;
        }

        .btn:hover {
            background: #00796b;
            color: white;
        }

        .btn:active {
            transform: scale(0.98);
        }

        .footer {
            margin-top: 20px;
            font-size: 14px;
            color: #777;
        }

        .title-container {
            display: flex;
            align-items: baseline;
            justify-content: center;
            margin-bottom: 20px;
        }

        .title-container img {
            width: 30px;
            height: 30px;
            margin-right: 10px;
        }

        .title-container:hover img {
            animation: spin 2s linear infinite;
            transform-origin: center;
        }
        .title-container:hover h1 {
            text-shadow: 0 0 10px #00796b1a;
        }

        .title-container h1 {
            margin: 0;
            color: #00796b;
            font-size: 2.5rem;
            font-weight: 700;
        }

        @keyframes spin {
            from {
                transform: rotate(0deg);
            }
            to {
                transform: rotate(360deg);
            }
        }

        @media (max-width: 550px) {
            body {
                padding: 20px;
            }
        
            .container {
                width: 90%;
                padding: 25px 20px;
                border-radius: 10px;
            }
        
            .title-container h1 {
                font-size: 2rem;
            }

            .title-container img {
                width: 24px;
                height: 24px;
                margin-right: 8px;
            }
        
            p {
                font-size: 0.95rem;
                margin-bottom: 20px;
            }
        
            .btn {
                font-size: 15px;
                padding: 10px 0;
                margin: 8px 0;
            }
        
            .footer {
                font-size: 12px;
                margin-top: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="title-container">
            <img src="./images/favicon.svg" alt="HealthDotNet Logo">
            <h1>HealthDotNet</h1>
        </div>

        <p>Hospital Management System</p>

        <form action="login.jsp" method="get">
            <button type="submit" class="btn">Login</button>
        </form>

        <form action="register.jsp" method="get">
            <button type="submit" class="btn">Register</button>
        </form>

        <div class="footer">
            <p>Managed by <strong>Rajbir Singh</strong> & <strong>Rohit Chand</strong></p>
            <p>&copy; <%= java.time.Year.now() %> HealthDotNet</p>
        </div>
    </div>
</body>
</html>
