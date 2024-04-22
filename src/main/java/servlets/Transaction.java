package servlets;

public class Transaction {
    private int id;
    private String description;
    private int investAmount;
    private String date;
    private Integer incomeAmount; // Use Integer to handle null values

    // Constructor
    public Transaction(int id, String description, int investAmount, String date, Integer incomeAmount) {
        this.id = id;
        this.description = description;
        this.investAmount = investAmount;
        this.date = date;
        this.incomeAmount = incomeAmount;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getAmount() {
        return investAmount;
    }

    public void setAmount(int investAmount) {
        this.investAmount = investAmount;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public Integer getIncomeAmount() {
        return incomeAmount;
    }

    public void setIncomeAmount(Integer incomeAmount) {
        this.incomeAmount = incomeAmount;
    }
}

