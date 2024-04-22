<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FranchiseConnect</title>
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="resources/css/main.css">
</head>
<body>

<header>
    <nav class="navbar">
        <a class="logo" href="#">FranchiseConnect<span>.</span></a>
    </nav>
</header>

<section class="hero-section">
    <div class="container">
        <div class="col-md-6">
            <div class="content">
                <h2 class="text-center">Login to FranchiseConnect</h2>
                <!-- Login Form -->
                <form id="loginForm" action="login" method="post" onsubmit="return validateForm()">
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" class="form-control" id="email" name="email">
                    </div>
                    <div class="form-group">
                        <label for="password">Password:</label>
                        <input type="password" class="form-control" id="password" name="password">
                    </div>
                    <button type="submit">Login</button>
                    <p id="errorMessage" class="text-danger" style="display: none;">Please fill in all fields and ensure email format is correct.</p>
                </form>
                
                <%-- Display login status message --%>
                <% String message = (String) request.getAttribute("message");
                   if (message != null) { %>
                    <p class="message text-center <%= message.startsWith("Error") ? "text-danger" : "text-success" %>"><%= message %></p>
                <% } %>
            </div>
        </div>
    </div>
</section>

<!-- Bootstrap JavaScript -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    function validateForm() {
        var email = document.getElementById("email").value;
        var password = document.getElementById("password").value;
        // Email format validation
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            document.getElementById("errorMessage").innerText = "Please enter a valid email address.";
            document.getElementById("errorMessage").style.display = "block";
            return false; // Prevent form submission
        }
        // Non-empty fields validation
        if (email.trim() === "" || password.trim() === "") {
            document.getElementById("errorMessage").innerText = "Please fill in all fields.";
            document.getElementById("errorMessage").style.display = "block";
            return false; // Prevent form submission
        }
        return true; // Allow form submission
    }

    // Check if the current page is the login page
    if (window.history.replaceState) {
        // If the browser supports the replaceState method, replace the current URL with the URL of the dashboard/home page
        window.history.replaceState(null, null, window.location.href);
    }

    // Clear browser history
    window.history.replaceState({}, document.title, window.location.href);

</script>

</body>
</html>
