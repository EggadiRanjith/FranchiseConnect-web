package servlets;

public class Business {
    private int id;
    private String name;

    public Business(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }
}
