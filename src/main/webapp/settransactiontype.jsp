<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction Management</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: url('resources/images/franchise.jpeg') no-repeat center center fixed;
            background-size: cover;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
        }
    
                .navbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    max-width: 1200px;
    margin: 0 auto;
    
        }
        .navbar-brand {
    color: white;
    font-weight: 600;
    font-size: 2.1rem;
    text-decoration: none;
        }
        .navbar-nav .nav-link {
    color: white;
    text-decoration: none;
    transition: 0.2s ease;
        }
        .navbar-brand span {
    color: #c06b3e;
}
        
        .navbar-nav .nav-link:hover {
    color: #c06b3e;
        }

        .container {
            margin-top: 50px;
        }

        .card {
            border: none;
            box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.1);
        }

        .card-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .btn-primary {
            background-color: #007bff;
            border: none;
            transition: background-color 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }

        .list-group-item {
            border: none;
            border-top: 1px solid rgba(0, 0, 0, 0.125);
            transition: background-color 0.3s ease;
        }

        .list-group-item:hover {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>

<header>
    <nav class="navbar navbar-expand-lg">
        <a class="navbar-brand" href="home.jsp">FranchiseConnect<span>.</span></a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="#" id="logoutLink"><i class="fas fa-envelope"></i>Log out</a>
                </li>
            </ul>
        </div>
    </nav>
</header>

<div class="container">
    <div class="row">
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h2 class="card-title">Add Transaction Type</h2>
                    <form id="transactionForm">
                        <div class="form-group">
                            <label for="transactionType">Transaction Type:</label>
                            <input type="text" id="transactionType" name="transactionType" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="transactionCost">Cost:</label>
                            <input type="number" id="transactionCost" name="transactionCost" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="transactionCategory">Category:</label>
                            <select id="transactionCategory" name="transactionCategory" class="form-control" required>
                                <option value="Income">Income</option>
                                <option value="Invest">Invest</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block">Add Transaction</button>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h2 class="card-title">Income Transactions</h2>
                    <table id="transactionListIncome" class="table">
                        <thead>
                            <tr>
                                <th>Transaction Type</th>
                                <th>Cost</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Existing income transactions will be listed dynamically here -->
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card mt-4">
                <div class="card-body">
                    <h2 class="card-title">Invest Transactions</h2>
                    <table id="transactionListInvest" class="table">
                        <thead>
                            <tr>
                                <th>Transaction Type</th>
                                <th>Cost</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Existing invest transactions will be listed dynamically here -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const transactionForm = $('#transactionForm');
        const transactionListIncome = $('#transactionListIncome');
        const transactionListInvest = $('#transactionListInvest');
        var businessId = sessionStorage.getItem('selectedBusinessId');

        function fetchTransactionTypes() {
            $.ajax({
                url: 'transactionType',
                type: 'GET',
                dataType: 'json',
                data: { businessId: businessId },
                success: function (response) {
                    if (response.success && Array.isArray(response.transactionTypes)) {
                        const data = response.transactionTypes;
                        console.log(data);
                        transactionListIncome.empty();
                        transactionListInvest.empty();
                        data.forEach(function (item) {
                            const row = $('<tr>');
                            row.append($('<td>').text(item.type));
                            row.append($('<td>').text('$' + item.cost));
                            const actions = $('<td>');
                            const editButton = $('<button>')
                            .text('Edit')
                            .addClass('btn btn-primary btn-sm mr-2') // Added margin-right for spacing
                            .css({
                                'border-radius': '5px', // Custom border-radius
                                'font-weight': 'bold'   // Custom font-weight
                            })
                            .click(function() {
                                editTransaction(item);
                            });

                        const deleteButton = $('<button>')
                            .text('Delete')
                            .addClass('btn btn-danger btn-sm') // Added margin-right for spacing
                            .css({
                                'border-radius': '5px', // Custom border-radius
                                'font-weight': 'bold'   // Custom font-weight
                            })
                            .click(function() {
                                deleteTransaction(item.id);
                            });

                            actions.append(editButton).append(deleteButton);
                            row.append(actions);
                            if (item.category === 'Income') {
                                transactionListIncome.append(row);
                            } else if (item.category === 'Invest') {
                                transactionListInvest.append(row);
                            }
                        });
                    } else {
                        console.error('Invalid data format:', response);
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Error fetching transaction types:', error);
                }
            });
        }

        fetchTransactionTypes();

        transactionForm.submit(function(event) {
            event.preventDefault();
            const transactionType = $('#transactionType').val().trim();
            const transactionCost = $('#transactionCost').val().trim();
            const transactionCategory = $('#transactionCategory').val().trim();
            if (transactionType && transactionCost && transactionCategory) {
                $.ajax({
                    url: 'transactionType',
                    type: 'POST',
                    dataType: 'json',
                    data: { type: transactionType, cost: transactionCost, category: transactionCategory, businessId: businessId },
                    success: function () {
                        transactionForm[0].reset();
                        fetchTransactionTypes();
                    },
                    error: function (xhr, status, error) {
                        console.error('Error adding transaction:', error);
                    }
                });
            } else {
                alert('Please enter transaction type, cost, and category');
            }
        });

        function editTransaction(transaction) {
            const newType = prompt('Enter new type:', transaction.type);
            const newCost = prompt('Enter new cost:', transaction.cost);
            
            if (newType !== null && newCost !== null) {
                $.ajax({
                    url: 'transactionType?id=' + transaction.id + '&type=' + encodeURIComponent(newType) + '&cost=' + newCost, // Append type and cost to the URL
                    type: 'PUT',
                    dataType: 'json',
                    success: function () {
                        fetchTransactionTypes();
                    },
                    error: function (xhr, status, error) {
                        console.error('Error editing transaction:', error);
                    }
                });
            } else {
                console.error('Invalid newType or newCost:', newType, newCost);
            }
        }



        function deleteTransaction(transactionId) {
            console.log(transactionId);
            if (transactionId !== null && !isNaN(transactionId)) { // Check if transactionId is not null and is a valid number
                if (confirm('Are you sure you want to delete this transaction?')) {
                    $.ajax({
                        url: 'transactionType?transactionId=' + transactionId, // Pass transactionId as a query parameter
                        type: 'DELETE', // Use DELETE method for RESTful deletion
                        dataType: 'json',
                        success: function () {
                            fetchTransactionTypes();
                        },
                        error: function (xhr, status, error) {
                            console.error('Error deleting transaction:', error);
                        }
                    });
                }
            } else {
                console.error('Invalid transactionId:', transactionId);
            }
        }


    });
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

</body>
</html>
