
// Represents a user with a name and email address
public class User {
    // The user's name
    private String name;
    // The user's email address
    private String email;

    /**
     * Constructs a new User with the specified name and email.
     * @param name The user's name
     * @param email The user's email address
     */
    public User(String name, String email) {
        this.name = name;
        this.email = email;
    }

    /**
     * Returns the user's name.
     * @return name
     */
    public String getName() {
        return name;
    }

    /**
     * Returns the user's email address.
     * @return email
     */
    public String getEmail() {
        return email;
    }
}



// Main class to demonstrate usage of the User class
class Main {
    public static void main(String[] args) {
        // Create two User objects with sample data
        User userOne = new User("John Doe", "john.doe@example.com");
        User userTwo = new User("Jane Smith", "jane.smith@example.com");

        // Print user details to the console
        System.out.println("User One: " + userOne.getName() + ", Email: " + userOne.getEmail());
        System.out.println("User Two: " + userTwo.getName() + ", Email: " + userTwo.getEmail());
    }
}
