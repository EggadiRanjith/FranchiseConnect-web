<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FranchiseConnect</title>
    <link rel="stylesheet" href="resources/css/main.css">
    <!-- Add any additional meta tags, stylesheets, or scripts here -->
</head>
<body>

<header>
    <nav class="navbar">
        <a class="logo" href="#">FranchiseConnect<span>.</span></a>
        <ul class="menu-links">
            <li><a href="#">Home</a></li>
            <li><a href="#" id="logoutLink">Log Out</a></li>
        </ul>
    </nav>
</header>

<section class="hero-section">
    <div class="content">
        <h2>Welcome to Your Franchise</h2>
        <div class="action-buttons">
            <button onclick="window.location.href='invest.jsp'">Invest</button>
            <button onclick="window.location.href='income.jsp'">Income</button>
        </div>
        <div class="buttons" id="dynamicButtons">
            <%-- Dashboard Button --%>
            <a href="dashboard.jsp"><button>Dashboard</button></a>
            <%-- Transaction Button --%>
            <button onclick="window.location.href='transaction.jsp'">Transactions</button>
            <%-- Add Static Transaction Types Button --%>
            <a href="settransactiontype.jsp"><button>Add static transaction types</button></a>
        </div>
    </div>
</section>

<!-- Add any additional sections or content here -->
<script>
document.addEventListener("DOMContentLoaded", function() {
    // Get user type from session storage
    var userType = sessionStorage.getItem("userType");

    // Get reference to the dynamic buttons container
    var dynamicButtons = document.getElementById("dynamicButtons");

    // If user type is "business", hide the "Invest" and "Income" buttons
    // and show only the "Dashboard" and "Transactions" buttons
    if (userType === "business") {
        var actionButtons = document.querySelector(".action-buttons");
        actionButtons.style.display = "none"; // Hide action buttons

        // Show only dashboard and transaction buttons
        dynamicButtons.innerHTML = `
            <a href="dashboard.jsp"><button>Dashboard</button></a>
            <button onclick="window.location.href='transaction.jsp'">Transactions</button>
        `;
    }

    // Get reference to the "Log Out" link
    var logoutLink = document.getElementById("logoutLink");

    // Add click event listener to the "Log Out" link
    logoutLink.addEventListener("click", function(event) {
        event.preventDefault(); // Prevent default link behavior (e.g., navigating to "#")

        // Send AJAX request to invalidate servlet session
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "logoutServlet", true); // Adjust URL to match your servlet mapping
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    // Servlet session invalidated successfully
                    // Clear JavaScript sessions (if any)
                    sessionStorage.clear();

                    // Redirect user to login page
                    window.location.href = "Login.jsp";
                } else {
                    // Handle errors, if any
                    console.error("Error occurred during logout:", xhr.responseText);
                    // You can display an error message or handle it based on your requirements
                }
            }
        };
        xhr.send();
    });
});
</script>
</body>
</html>
