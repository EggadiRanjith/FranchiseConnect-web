<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FranchiseConnect</title>
    <link rel="stylesheet" href="resources/css/main.css">
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
    <div class="content">
        <h2>Start Your Journey with FranchiseConnect</h2>
        <p>
            FranchiseConnect offers you a wide range of franchise opportunities.
            Begin your entrepreneurial journey today!
        </p>
        <form action="businesslist" method="GET">
            <button type="submit">Get Started</button>
        </form>
    </div>
</section>

<script>
document.addEventListener("DOMContentLoaded", function() {
    // Get user type from session attribute
    var userType = "<%= session.getAttribute("userType") %>";
    // Save user type in session storage
    sessionStorage.setItem("userType", userType);

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
