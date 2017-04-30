package me.jayng;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Scanner;

public class Main {

    public static Utils utils;
    public static DBI dbi = DBI.getInstance();
    public static Connection conn;
    public static Scanner scanner = new Scanner(System.in);
	static int eid;
	static boolean isManager = false;

    public static void main(String[] args) {
	// write your code here
        printHeading();
        login();
        presentOption();
    }

    public static void printHeading() {
        System.out.println("--------------------------------------------------");
        System.out.println("------ Salon Software by Huy Nguyen, Man Vu ------");
        System.out.println("--------------------------------------------------");
    }

    public static void login() {
        Boolean success = false;
        String username = "";
        while (!success) {

            System.out.println("\nPlease Login");
            System.out.print("Username: ");
            username = scanner.nextLine();
            System.out.print("Password: ");
            String password = scanner.nextLine();
            System.out.println();

            // Get String Digest with SHA256
            String digest = utils.sha256(password);

            // Construct Query for login process
            // Function return 1|0 (true|false)
            String loginCheckSQL = "SELECT f_loginCheck('" + username + "','" + digest + "');";
            Boolean matched = false;
            try {
                ResultSet rsLogin = dbi.executeStatement(loginCheckSQL);
                rsLogin.next();
                matched = rsLogin.getBoolean(1);
            } catch (SQLException e) {
                System.out.println("SQLException: " + e);
            }

            if (matched) {
                success = true;
				// get eid from username and password
				String getEID = "SELECT f_getEID('" + username + "','" + digest + "');";
				try {
					ResultSet rsEID = dbi.executeStatement(getEID);
					rsEID.next();
					eid = rsEID.getInt(1);
				} catch (SQLException e) {
					System.out.println("SQLException: " + e.getMessage());
				}
				// get isManager from username and password
				String checkManager = "SELECT f_getEmployeeType('" + username + "','" + digest + "');";
				try {
					ResultSet rsType = dbi.executeStatement(checkManager);
					rsType.next();
					isManager = rsType.getBoolean(1);
				} catch (SQLException e) {
					System.out.println("SQLException: " + e.getMessage());
				}
				// show employee information
				String showEmployee = "SELECT *  from employees where employee_id = " + eid + ";"; // TODO: function to hide SQL struct
				try{
					ResultSet rsShow = dbi.executeStatement(showEmployee);
					rsShow.next();
				} catch (SQLException e){
					System.out.println("SQLException: " + e.getMessage());
				}
            } else {
                System.out.println("-> Login failed for " + username + ". Please check your username and password.\n-> If problem persists, please contact administrator.");
            }
        }

        System.out.println("Welcome " + username + "!!!");
    }

    public static void presentOption() {
    	System.out.println(isManager);
		if(isManager){
			System.out.println("1. Manage Employees");
			System.out.println("2. Manage Appointments");
			System.out.println("3. Manage Products and Orders");
			System.out.println("4. View Customers");
			System.out.println("5. Services");
			System.out.println();
			System.out.print("- Choice: ");
			int option = -1;
			boolean inputMismatch = true;
			while (inputMismatch) {
				if (!scanner.hasNextInt()) {
					System.out.println("-> Acceptable Choices Are 1, 2, 3, 4, and 5\n");
					System.out.print("Choice: ");
					scanner.next();
					continue;
				} else {
					option = scanner.nextInt();
				}
				inputMismatch = false;
			}
			switch (option) {
				case 1:
					System.out.println("1. View all employees");
					System.out.println("2. Add an employee");
					System.out.println("3. Delete an employee");
					//int innerOption = scanner.nextInt();
					// To do: add sql statements to view, add, delete
					break;
				case 2:
					System.out.println("1. View all appointments");
					System.out.println("2. Add an appointment");
					System.out.println("3. Edit an appointment");
					System.out.println("4. Delete an appointment");
					//int innerOption = scanner.nextInt();
					// sql statements for appointments
					break;
				case 3:
					System.out.println("1. View all products");
					System.out.println("2. Add a products");
					System.out.println("3. Edit a product");
					System.out.println("4. Delete a product");
					//int innerOption = scanner.nextInt();
					// sql statements
					break;
				case 4:
					// sql view customers
					break;
				case 5:
					System.out.println("1. View services");
					System.out.println("2. Add a service");
					System.out.println("3. Edit a service");
					System.out.println("4. Delete a service");
					System.out.println("5. View employees' service counts");
					System.out.println("6. Update employees' service counts");
					//int innerOption = scanner.nextInt();
					// sql statements
					break;
				default:
					System.out.println("Invalid option.");
					break;
			}
		} else {
			System.out.println("1. View your information");
			System.out.println("2. Manage Appointments");
			System.out.println("3. View your customers");
			System.out.println("4. Services");
			int option = scanner.nextInt();

			switch (option) {
				case 1:
					// sql view
					break;
				case 2:
					System.out.println("1. View all appointments");
					System.out.println("2. Add an appointment");
					System.out.println("3. Delete an appointment");
					System.out.println("4. Edit an appointment");
					//int innerOption = scanner.nextInt();
					// sql statements for appointments
					break;
				case 3:
					// sql view
					break;
				case 4:
					System.out.println("1. View all offered services");
					System.out.println("2. View your service counts");
					System.out.println("3. Update your service counts");
					//int innerOption = scanner.nextInt();
					// sql statements
					break;
				default:
					System.out.println("Invalid option.");
					break;
			}
		}
	}

	public static void viewAllEmployees() {
		// TODO: Implementation
	}

	public static void addAnEmployee() {
		// TODO: Implementation
	}

	public static void deleteAnEmployee() {
		// TODO: Implementation
	}

	public static void viewAllAppointment() {
		// TODO: Implementation
	}

	public static void addAnAppointment() {
		// TODO: Implementation
	}

	public static void deleteAnAppointment() {
		// TODO: Implementation
	}

	public static void editAnAppointment() {
		// TODO: Implementation
	}

	public static void viewAllProduct() {
		// TODO: Implementation
	}

	public static void addAProduct() {
		// TODO: Implementation
	}

	public static void editAProduct() {
		// TODO: Implementation
	}

	public static void deleteAProduct() {
		// TODO: Implementation
	}

	public static void viewAllServices() {
		// TODO: Implementation
	}

	public static void addAService() {
		// TODO: Implementation
	}

	public static void editAService() {
		// TODO: Implementation
	}

	public static void deleteAService() {
		// TODO: Implementation
	}

	public static void viewServicesCount() {
		// TODO: Implementation
	}

	public static void addServicesCount() {
		// TODO: Implementation
	}

	public static void updateServicesCount() {
		// TODO: Implementation
	}
}
