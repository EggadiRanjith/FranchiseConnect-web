<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FranchiseConnect Dashboard</title>
    <!-- Include Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Include Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Include Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- Custom styles -->
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }
        .navbar {
            background-color: #343a40;
            color: white;
        }
        .navbar-brand {
            color: white;
        }
        .content {
            padding: 20px;
        }
        /* Chart styles */
        canvas {
            max-width: 100%;
            height: auto;
        }
        /* Custom styles for radio buttons */
        .custom-control-input {
            position: absolute;
            left: -9999px;
        }
        .custom-control-input:checked ~ .custom-control-label::before {
            color: #fff;
            border-color: #007bff;
            background-color: #007bff;
        }
        .custom-control-label::before {
            position: absolute;
            top: 0.25rem;
            left: -1.25rem;
            display: block;
            width: 1rem;
            height: 1rem;
            pointer-events: none;
            content: "";
            background-color: #fff;
            border: #adb5bd solid 0.1rem;
        }
        .custom-control-label {
            padding-left: 2.5rem;
        }
        .custom-control-label.monthly::before {
            padding-left: 1rem;
        }
        .custom-control-input:checked ~ .custom-control-label::after {
            color: #fff;
            background-color: #007bff;
        }
        /* Cards */
        .card {
            margin-bottom: 20px;
            border: none;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        .card-body {
            padding: 20px;
            background-color: #fff;
            border-radius: 0.25rem;
        }
        .card-title {
            font-size: 1.25rem;
            margin-bottom: 20px;
            color: #333;
        }
        .card-subtitle {
            font-size: 1rem;
            margin-bottom: 10px;
            color: #6c757d;
        }
    </style>
</head>
<body>

<header>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="home.jsp">FranchiseConnect<span>.</span></a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ml-auto">
<ul class="menu-links">
    <li><a href="#" id="logoutLink">Log Out</a></li>
</ul>

                </ul>
            </div>
        </div>
    </nav>
</header>

<main role="main">
    <section class="dashboard-section">
        <div class="container">
     <h2 style="text-align: center; margin-top: 30px; font-size: 36px; font-weight: bold; color: #007bff;">Dashboard</h2>


            <div>
<div class="text-center" style="text-align: center; margin-top: 20px; margin-bottom:30px;">
    <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="dataPeriod" id="yearlyOption" value="yearly" checked>
        <label class="form-check-label" for="yearlyOption">Yearly</label>
    </div>
    <div class="form-check form-check-inline monthly">
        <input class="form-check-input" type="radio" name="dataPeriod" id="monthlyOption" value="monthly">
        <label class="form-check-label" for="monthlyOption">Monthly</label>
    </div>
</div>
            <div class="row">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Investment</h5>
                            <canvas id="investmentChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Income</h5>
                            <canvas id="incomeChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Transactions Chart -->
            <div class="row">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Total Transactions Income vs Investment</h5>
                            <canvas id="transactionsChart"></canvas>
                        </div>
                    </div>
                </div>
                <!-- New Chart for Transaction Counts with Income vs Investment -->
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Transaction Counts</h5>
                            <canvas id="transactionCountChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Profit/Loss, Total Invested Amount, and Total Income Cards -->
            <div class="row">
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Profit/Loss</h5>
                            <h6 class="card-subtitle mb-2 text-muted" id="profitLossSubtitle">This Year</h6>
                            <p id="profitLossCardValue" class="card-text">$XX,XXX</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Total Invested Amount</h5>
                            <h6 class="card-subtitle mb-2 text-muted" id="investmentSubtitle">Amount</h6>
                            <p id="totalInvestmentCardValue" class="card-text">$XX,XXX</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Total Income</h5>
                            <h6 class="card-subtitle mb-2 text-muted" id="incomeSubtitle">Amount</h6>
                            <p id="totalIncomeCardValue" class="card-text">$XX,XXX</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<!-- Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    $(document).ready(function() {
        var businessId = sessionStorage.getItem('selectedBusinessId');
        var investmentChart, incomeChart, transactionsChart, transactionCountChart; // Variables to hold chart instances

        // Function to fetch chart data from servlet
        function fetchChartData(period) {
            var url = "fetchChartData?businessId=" + businessId;
            if (period === 'monthly') {
                url += "&monthly=true"; // Send monthly parameter if period is monthly
                $('#profitLossSubtitle').text("This Month");
            } else {
                $('#profitLossSubtitle').text("This Year");
            }

            $.ajax({
                url: url,
                type: "GET",
                dataType: "json",
                success: function(data) {
                    // Update chart data
                    updateChartData(data);
                    // Update transactions chart data
                    updateTransactionsChart(data);
                    // Update transaction count chart data
                    updateTransactionCountChart(data);
                },
                error: function(xhr, status, error) {
                    console.error("Error fetching chart data: " + error);
                }
            });
        }

        // Function to update chart data
        function updateChartData(data) {
            // Update investment chart data
            investmentChart.data.labels = data.labels;
            investmentChart.data.datasets[0].data = data.investmentData;
            investmentChart.update();

            // Update income chart data
            incomeChart.data.labels = data.labels;
            incomeChart.data.datasets[0].data = data.incomeData;
            incomeChart.update();

            // Calculate and display total income and total investment
            var totalIncome = data.incomeData.reduce((total, income) => total + income, 0);
            var totalInvestment = data.investmentData.reduce((total, investment) => total + investment, 0);

            // Update card values
            $('#totalIncomeCardValue').text("$" + totalIncome.toFixed(2));
            $('#totalInvestmentCardValue').text("$" + totalInvestment.toFixed(2));

            if ($('#monthlyOption').is(':checked')) {
                calculateMonthlyProfitLoss(data.incomeData, data.investmentData);
            } else {
                calculateTotalProfitLoss(totalIncome, totalInvestment);
            }
        }

        // Function to update transactions chart data
        function updateTransactionsChart(transactionsData) {
            // Clear previous data
            transactionsChart.data.labels = transactionsData.labels;
            transactionsChart.data.datasets[0].data = transactionsData.investmentData;
            transactionsChart.data.datasets[1].data = transactionsData.incomeData;

            // Update the chart
            transactionsChart.update();
        }

        // Function to update transaction count chart data
        function updateTransactionCountChart(data) {
            transactionCountChart.data.labels = data.labels;
            transactionCountChart.data.datasets[0].data = data.transactionCounts;
            transactionCountChart.update();
        }

        // Function to calculate monthly profit/loss
        function calculateMonthlyProfitLoss(incomeData, investmentData) {
            var profitLossData = incomeData.map((income, index) => income - investmentData[index]);
            var currentMonth = new Date().getMonth();
            $('#profitLossCardValue').text("$" + profitLossData[currentMonth].toFixed(2));
        }

        // Function to calculate total profit/loss
        function calculateTotalProfitLoss(totalIncome, totalInvestment) {
            var profitLoss = totalIncome - totalInvestment;
            $('#profitLossCardValue').text("$" + profitLoss.toFixed(2));
        }

        // Initialize charts
        var investmentChartCtx = document.getElementById('investmentChart').getContext('2d');
        investmentChart = new Chart(investmentChartCtx, {
            type: 'line',
            data: {
                labels: [],
                datasets: [{
                    label: 'Investment',
                    data: [],
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                    }]
                }
            }
        });

        var incomeChartCtx = document.getElementById('incomeChart').getContext('2d');
        incomeChart = new Chart(incomeChartCtx, {
            type: 'bar',
            data: {
                labels: [],
                datasets: [{
                    label: 'Income',
                    data: [],
                    backgroundColor: 'rgba(255, 99, 132, 0.2)',
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                    }]
                }
            }
        });

        var transactionsChartCtx = document.getElementById('transactionsChart').getContext('2d');
        transactionsChart = new Chart(transactionsChartCtx, {
            type: 'radar', // Change chart type to radar
            data: {
                labels: [],
                datasets: [{
                    label: 'Investment',
                    data: [],
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1,
                    fill: true // Fill area under the radar shape
                }, {
                    label: 'Income',
                    data: [],
                    backgroundColor: 'rgba(255, 99, 132, 0.2)',
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 1,
                    fill: true // Fill area under the radar shape
                }]
            },
            options: {
                scale: {
                    ticks: {
                        beginAtZero: true
                    }
                }
            }
        });

        // New chart for transaction counts
        var transactionCountChartCtx = document.getElementById('transactionCountChart').getContext('2d');
        transactionCountChart = new Chart(transactionCountChartCtx, {
            type: 'pie', // Change chart type to pie
            data: {
                labels: [],
                datasets: [{
                    label: 'Transaction Counts',
                    data: [],
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(54, 162, 235, 0.2)',
                        'rgba(255, 206, 86, 0.2)',
                        'rgba(75, 192, 192, 0.2)',
                        'rgba(153, 102, 255, 0.2)',
                        'rgba(255, 159, 64, 0.2)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                    }]
                }
            }
        });

        // Fetch initial chart data (default to yearly)
        fetchChartData('yearly');

        // Event listener for data period selection
        $('input[name="dataPeriod"]').change(function() {
            fetchChartData($(this).val());
        });
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
