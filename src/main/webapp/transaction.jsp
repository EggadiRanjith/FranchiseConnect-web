<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction Details</title>
    <!-- Add external CSS libraries for styling -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Add Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        /* Custom CSS for styling */
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
        .transaction-section {
            padding: 50px 0;
        }
        .card {
            background-color: rgba(255, 255, 255, 0.9);
            border: none;
            border-radius: 10px;
            box-shadow: 0px 10px 30px rgba(0, 0, 0, 0.1);
        }
        .card-header {
            background-color: #007bff !important;
            color: #ffffff !important;
            font-weight: bold;
            border-radius: 10px 10px 0 0;
        }
        .table {
            background-color: #ffffff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0px 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 0; /* Remove default margin */
        }
        .table th, .table td {
            border-top: none !important;
            padding: 15px; /* Increase padding for better spacing */
        }
        .table th {
            font-weight: bold;
            vertical-align: middle; /* Align content vertically centered */
        }
        .table td {
            vertical-align: middle; /* Align content vertically centered */
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
                    <a class="nav-link" href="#" id="logoutLink">Log out</a>
                </li>
            </ul>
        </div>
    </nav>
</header>

<section class="transaction-section">
    <div class="container">
        <h2 class="text-center mb-5 text-white">Transaction Details</h2>
        <div class="row mb-3">
            <div class="col-md-6">
                <label for="transactionType" class="text-white">Select Transaction Type:</label>
                <select id="transactionType" class="form-control">
                    <option value="all">All Transactions</option>
                    <option value="singleDay">Single Day Transaction</option>
                    <option value="interval">Transaction Interval</option>
                </select>
            </div>
        </div>
        <div class="row mb-3" id="singleDateSelection" style="display: none;">
            <div class="col-md-6">
                <label for="transactionDate" class="text-white">Select Date:</label>
                <input type="date" id="transactionDate" class="form-control">
            </div>
        </div>
        <div class="row mb-3" id="intervalSelection" style="display: none;">
            <div class="col-md-6">
                <label for="transactionStartDate" class="text-white">From:</label>
                <input type="date" id="transactionStartDate" class="form-control">
            </div>
            <div class="col-md-6">
                <label for="transactionEndDate" class="text-white">To:</label>
                <input type="date" id="transactionEndDate" class="form-control">
            </div>
        </div>
        <div class="row mb-3">
            <div class="col-md-6">
                <button id="proceedBtn" class="btn btn-primary">Proceed</button>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h3 class="mb-0"><i class="fas fa-hand-holding-usd"></i> Income Transactions</h3>
                    </div>
                    <div>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Transaction ID</th>
                                        <th>Description</th>
                                        <th>Amount</th>
                                        <th>Date</th>
                                    </tr>
                                </thead>
                                <tbody id="incomeTableBody">
                                    <!-- Income transaction details will be populated here -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h3 class="mb-0"><i class="fas fa-chart-line"></i> Investment Transactions</h3>
                    </div>
                    <div>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Transaction ID</th>
                                        <th>Description</th>
                                        <th>Amount</th>
                                        <th>Date</th>
                                    </tr>
                                </thead>
                                <tbody id="investmentTableBody">
                                    <!-- Investment transaction details will be populated here -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Include jQuery library -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<!-- Include Bootstrap JS library -->
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
$(document).ready(function() {
    var businessId = sessionStorage.getItem('selectedBusinessId');
    var allTransactions; // Variable to store all transactions fetched from the server

    // Function to fetch all transactions from the server
    function fetchAllTransactions() {
        $.ajax({
            url: 'fetchAllTransactions', // URL mapping for fetching all transactions
            type: 'GET',
            dataType: 'json',
            data: {
                businessId: businessId // Include business ID in the data
            },
            success: function(data) {
                allTransactions = data; // Store all transactions in the variable
                // Initially display all transactions
                displayTransactions(allTransactions);
            },
            error: function(xhr, status, error) {
                console.error('Error fetching transactions:', error);
            }
        });
    }

    // Function to display transactions based on the selected date or date range
    function displayTransactions(transactions) {
        var incomeTableBody = $('#incomeTableBody');
        var investmentTableBody = $('#investmentTableBody');

        // Clear existing rows
        incomeTableBody.empty();
        investmentTableBody.empty();

        // Iterate over each transaction in the received data
        $.each(transactions, function(index, transaction) {
            // Create a new row for the transaction
            var row = $('<tr>');
            // Populate the row with transaction details
            row.append($('<td>').text(transaction.id));
            row.append($('<td>').text(transaction.description));
            // Determine transaction type based on the presence of incomeAmount
            if (transaction.incomeAmount != null && transaction.incomeAmount !== 0) {
                // If it's an income transaction, display the income amount in the row
                row.append($('<td>').text(transaction.incomeAmount));
                // Add the row to the income table
                incomeTableBody.append(row);
            } else {
                // Otherwise, it's an investment transaction, display the investAmount in the row
                row.append($('<td>').text(transaction.investAmount));
                // Add the row to the investment table
                investmentTableBody.append(row);
            }
            // Add the date to the row
            row.append($('<td>').text(transaction.date));
        });
    }

    // Initial fetch of all transactions
    fetchAllTransactions();

    $('#proceedBtn').click(function() {
        var transactionType = $('#transactionType').val();
        if (transactionType === 'singleDay') {
            var selectedDate = $('#transactionDate').val();
            console.log(selectedDate);

            // Trim time component from selected date
            var trimmedSelectedDate = new Date(selectedDate);
            trimmedSelectedDate.setHours(0, 0, 0, 0);

            // Filter transactions for the selected date
            var filteredTransactions = allTransactions.filter(function(transaction) {
                // Trim time component from transaction date
                var transactionDate = new Date(transaction.date);
                transactionDate.setHours(0, 0, 0, 0);

                // Compare dates without time
                return transactionDate.getTime() === trimmedSelectedDate.getTime();
            });

            // Display filtered transactions
            displayTransactions(filteredTransactions);
        } else if (transactionType === 'interval') {
            var startDate = $('#transactionStartDate').val();
            var endDate = $('#transactionEndDate').val();
            // Filter transactions for the selected date range
            var filteredTransactions = allTransactions.filter(function(transaction) {
                // Trim time component from transaction date
                var transactionDate = new Date(transaction.date);
                transactionDate.setHours(0, 0, 0, 0);

                // Trim time component from start and end dates
                var trimmedStartDate = new Date(startDate);
                trimmedStartDate.setHours(0, 0, 0, 0);
                var trimmedEndDate = new Date(endDate);
                trimmedEndDate.setHours(0, 0, 0, 0);

                // Check if transaction date falls within the date range
                return transactionDate >= trimmedStartDate && transactionDate <= trimmedEndDate;
            });
            // Display filtered transactions
            displayTransactions(filteredTransactions);
        } else {
            // Display all transactions
            displayTransactions(allTransactions);
        }
    });


    // Change event for transaction type selection
    $('#transactionType').change(function() {
        var selectedType = $(this).val();
        if (selectedType === 'singleDay') {
            $('#singleDateSelection').show();
            $('#intervalSelection').hide();
        } else if (selectedType === 'interval') {
            $('#singleDateSelection').hide();
            $('#intervalSelection').show();
        } else {
            $('#singleDateSelection').hide();
            $('#intervalSelection').hide();
        }
    });

    // Log out functionality
    $('#logoutLink').click(function(event) {
        event.preventDefault(); // Prevent default link behavior
        $.ajax({
            url: 'logoutServlet', // URL mapping for logout
            type: 'POST',
            contentType: 'application/json',
            success: function() {
                // Clear session storage
                sessionStorage.clear();
                // Redirect to login page
                window.location.href = 'Login.jsp';
            },
            error: function(xhr, status, error) {
                console.error('Error during logout:', error);
            }
        });
    });
});
</script>
</body>
</html>
