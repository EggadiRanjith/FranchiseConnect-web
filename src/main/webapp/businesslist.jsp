<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="servlets.Business" %> <!-- Import the Business class -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FranchiseConnect</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="resources/css/main.css">
    <style>
        /* Additional CSS styles */
        .card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 12px rgba(0, 0, 0, 0.1);
        }

        .card-body {
            padding: 20px;
        }
    </style>
</head>
<body>

<header>
    <nav class="navbar">
        <a class="logo" href="#">FranchiseConnect<span>.</span></a>
<ul class="menu-links">
    <li><a href="#" id="logoutLink">Log Out</a></li>
</ul>
    </nav>
</header>

<section class="hero-section">
    <div class="container">
        <h2 class="mt-5 mb-4">Available Businesses</h2>
        <div class="row">
            <% 
                Object businessListObj = request.getAttribute("businessList");
                if (businessListObj instanceof List) {
                    List<Business> businessList = (List<Business>) businessListObj; // Cast to List<Business>
                    for (Business business : businessList) { // Iterate over List<Business>
            %>
            <div class="col-md-4">
                <div class="card" onclick="handleBusinessClick('<%= business.getId() %>', '<%= business.getName() %>')">
                    <div class="card-body">
                        <%= business.getName() %> <!-- Access business name using getName() method -->
                    </div>
                </div>
            </div>
            <% 
                    }
                } else {
            %>
            <div class="col">
                <div class="card">
                    <div class="card-body">No businesses available</div>
                </div>
            </div>
            <% 
                }
            %>
        </div>
    </div>
</section>

<!-- JavaScript function to handle business click -->
<script>
    function handleBusinessClick(businessId, businessName) {
        // Set selected business name and ID in session attributes
        sessionStorage.setItem('selectedBusinessId', businessId);
        sessionStorage.setItem('selectedBusinessName', businessName);
        
        // Handle click action, e.g., redirect to business details page
        window.location.href = 'home.jsp';
    }
    document.addEventListener("DOMContentLoaded", function() {
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
                        // For example, if you're using sessionStorage:
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

<!-- Bootstrap JavaScript and jQuery -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
