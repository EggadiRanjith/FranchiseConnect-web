<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction Management</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        /* Background Image with Blur */
        body::before {
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background-image: url("resources/images/franchise.jpeg");
            background-size: cover;
            filter: blur(8px);
        }

        /* Navbar Styling */
        .navbar-brand {
            color: #fff;
            font-weight: bold;
        }

        .navbar-brand span {
            color: #c06b3e;
        }

        .nav-link {
            color: #fff !important;
        }

        /* Transaction Form Styling */
        .transaction-form {
            background-color: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            box-shadow: 0px 0px 15px 0px rgba(0,0,0,0.1);
            padding: 30px;
            margin-top: 100px;
        }

        .transaction-form h2 {
            color: #333;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-control {
            border-radius: 5px;
        }

        .btn-primary {
            background-color: #c06b3e;
            border: none;
            color: #fff;
            padding: 10px 20px;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #a4512a;
        }
    </style>
</head>
<body>

<header>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="#">FranchiseConnect<span>.</span></a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="home.jsp">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" id="logoutLink">Log Out</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</header>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="transaction-form">
                <h2>Add Invest Transaction</h2>
                <form id="transactionForm">
                    <div class="form-group">
                        <label for="predefinedPurposes">Select Predefined Purposes:</label>
                        <div id="predefinedPurposes"></div>
                    </div>
                    <div class="form-group">
                        <label for="totalAmount">Total Amount:</label>
                        <input type="number" class="form-control" id="totalAmount" name="totalAmount" readonly>
                    </div>
                    <div class="custom-transaction" style="display: none;">
                        <div class="form-group">
                            <label for="additionalPurpose">Additional Purpose:</label>
                            <input type="text" class="form-control" id="additionalPurpose">
                        </div>
                        <div class="form-group">
                            <label for="additionalAmount">Additional Amount:</label>
                            <input type="number" class="form-control" id="additionalAmount">
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary" id="submitBtn">Submit</button>
                    <button type="button" class="btn btn-success" id="toggleCustomBtn">Add Custom Transaction</button>
                </form>
            </div>
        </div>
    </div>
</div>
<div class="row justify-content-center">
    <div class="col-lg-8">
        <h2 class="mt-5 mb-3 text-center">Transaction List</h2>
        <table id="transactionTable" class="table table-striped table-bordered">
            <thead>
                <tr>
                    <th>Purpose</th>
                    <th>Total Amount</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <!-- Table rows will be added dynamically from client-side -->
            </tbody>
        </table>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    $(document).ready(function() {
        // Function to fetch predefined transaction types
        function fetchPredefinedTypes() {
            var businessId = sessionStorage.getItem('selectedBusinessId');
            $.ajax({
                type: "GET",
                url: "transactionType", // Replace 'your_servlet_url' with the actual servlet URL
                data: { businessId: businessId },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        // Filter response to get only records where category is 'Invest'
                        var investTypes = response.transactionTypes.filter(function(item) {
                            return item.category === 'Invest';
                        });
                        populatePredefinedPurposes(investTypes);
                    } else {
                        console.error('Error fetching predefined transaction types:', response.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error fetching predefined transaction types:', error);
                }
            });
        }

        // Call function to fetch predefined types when the document is ready
        // You need to replace 'your_business_id' with the actual business ID
        fetchPredefinedTypes();

        // Function to populate predefined purposes and handle checkbox change event
        function populatePredefinedPurposes(predefinedData) {
            var predefinedPurposesDiv = $('#predefinedPurposes');
            predefinedData.forEach(function(item) {
                predefinedPurposesDiv.append(
                    '<div class="form-check">' +
                    '<input class="form-check-input predefinedPurpose" type="checkbox" id="purpose' + item.id + '" value="' + item.cost + '">' +
                    '<label class="form-check-label" for="purpose' + item.id + '">' + item.type + ' - $' + item.cost + '</label>' +
                    '</div>'
                );
            });

            // Add change event listener to checkboxes
            $('.predefinedPurpose').change(function() {
                calculateTotalAmount();
            });
        }

        // Function to calculate total amount based on selected predefined purposes
        function calculateTotalAmount() {
            var totalAmount = 0;
            $('.predefinedPurpose:checked').each(function() {
                totalAmount += parseInt($(this).val());
            });
            $('#totalAmount').val(totalAmount);
        }

        // Toggle visibility of additional input fields
        $('#toggleCustomBtn').click(function() {
            $('.custom-transaction').toggle();
        });

        // Function to handle form submission
        $('#transactionForm').submit(function(event) {
            event.preventDefault(); // Prevent default form submission
            handleFormSubmission();
        });

        // Function to handle form submission
        function handleFormSubmission() {
            // Get selected predefined purposes
            var selectedPurposes = [];
            $('.predefinedPurpose:checked').each(function() {
                selectedPurposes.push($(this).next('label').text().split(' - ')[0]); // Get the purpose text
            });

            // Get total amount
            var totalAmount = $('#totalAmount').val();

            // Get additional purpose and amount
            var additionalPurpose = $('#additionalPurpose').val();
            var additionalAmount = $('#additionalAmount').val();

            // Check if additional purpose and amount are not empty
            if (additionalPurpose && additionalPurpose.trim() !== '' && !isNaN(additionalAmount)) {
                // Append additional purpose and amount to the selected purposes and total amount
                selectedPurposes.push(additionalPurpose);
                totalAmount = parseInt(totalAmount) + parseInt(additionalAmount);
            }

            // Append new row to the table with selected purposes and total amount
            $('#transactionTable tbody').prepend(
                '<tr>' +
                '<td>' + selectedPurposes.join(', ') + '</td>' + // Display selected purposes
                '<td>' + totalAmount + '</td>' +
                '<td>' + new Date().toLocaleString() + '</td>' +
                '<td class="status">Pending</td>' +
                '<td>' +
                '<button class="acceptBtn btn btn-success">Accept</button> ' +
                '<button class="addBtn btn btn-info">Add</button>' +
                '</td>' +
                '</tr>'
            );

            // Clear selected checkboxes
            $('.predefinedPurpose:checked').prop('checked', false);

            // Clear total amount field
            $('#totalAmount').val('');

            // Clear additional input fields
            $('#additionalPurpose').val('');
            $('#additionalAmount').val('');

            // Hide custom transaction inputs
            $('.custom-transaction').hide();
        }

        // Function to hide action buttons for rows with "Accepted" status
        function hideActionButtonsForAcceptedTransactions() {
            $('.status').each(function() {
                if ($(this).text().trim() === 'Accepted') {
                    $(this).closest('tr').find('.acceptBtn, .addBtn').hide();
                }
            });
        }

        // Call the function initially to hide action buttons for existing "Accepted" transactions
        hideActionButtonsForAcceptedTransactions();

        $(document).on('click', '.acceptBtn', function() {
            var row = $(this).closest('tr');
            var purpose = row.find('td:eq(0)').text();
            var amount = parseInt(row.find('td:eq(1)').text());
            var statusCell = row.find('.status');

            // Fetch business ID from session storage
            var businessId = sessionStorage.getItem('selectedBusinessId');

            // Send AJAX request to the servlet to update the database
            $.ajax({
                type: "POST",
                url: "transaction",
                data: {
                    purpose: purpose,
                    amount: amount,
                    businessId: businessId
                },
                success: function(response) {
                    // Update status cell and add accepted class
                    statusCell.text('Accepted');
                    statusCell.addClass('accepted');

                    // Hide action buttons for accepted transactions
                    row.find('.acceptBtn, .addBtn').hide();

                    // Move accepted transaction to the end
                    row.appendTo('#transactionTable tbody');

                    // Handle success response (optional)
                    alert(response); // Display a success message
                },
                error: function(xhr, status, error) {
                    // Handle error response (optional)
                    console.error(xhr.responseText); // Log the error message
                    alert("Error occurred while accepting the transaction.");
                }
            });
        });
        $(document).on('click', '.addBtn', function() {
            var row = $(this).closest('tr');
            var purposeCell = row.find('td:eq(0)');
            var amountCell = row.find('td:eq(1)');
            var additionalPurposeField = $('#additionalPurpose');
            var additionalAmountField = $('#additionalAmount');

            // Change the text of the submit button to reflect adding additional data
            $('.btn-primary').text('Add Additional');

            // Handle form submission
            $('#transactionForm').off('submit').submit(function(event) {
                event.preventDefault(); // Prevent default form submission

                // Get additional purpose and amount from the existing form fields
                var additionalPurpose = additionalPurposeField.val();
                var additionalAmount = additionalAmountField.val();

                // Check if additionalPurpose and additionalAmount are not empty and defined
                if (additionalPurpose && additionalPurpose.trim() !== '' && !isNaN(additionalAmount)) {
                    // Append additional purpose and add additional amount to the existing amount
                    purposeCell.text(purposeCell.text() + ' / ' + additionalPurpose.trim());
                    amountCell.text(parseInt(amountCell.text()) + parseInt(additionalAmount));
                }

                // Append selected predefined purposes and their amounts
                $('.predefinedPurpose:checked').each(function() {
                    purposeCell.append(' / ' + $(this).next('label').text().split(' - ')[0]);
                    amountCell.text(parseInt(amountCell.text()) + parseInt($(this).val()));
                });

                // Revert the text of the submit button and clear the input fields
                $('.btn-primary').text('Submit');
                additionalPurposeField.val('');
                additionalAmountField.val('');

                // Remove the event handler for form submission
                $('#transactionForm').off('submit');
            });
        });

        // Function to update total amount dynamically
        $('#additionalAmount').on('input', function() {
            calculateTotalAmount(); // Call the function to recalculate total amount
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

    });
</script>

</body>
</html>
