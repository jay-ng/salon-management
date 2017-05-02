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
				viewSingleEmployee(eid); // function to view one employee comes in handy here 
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
					int innerOption = scanner.nextInt();
					// To do: add sql statements to view, add, delete
					switch (innerOption) {
						case 1:
						//View all employees
						System.out.println("All employees:");
						viewAllEmployees();
						break;
						
						case 2:
						//Add an employee
						addAnEmployee();
						break;
						
						case 3:
						//Delete an employee
						System.out.println("Enter the id of the employee you want to delete: ");
						int dID = scanner.nextInt();
						deleteAnEmployee(dID);
						break;
						
						default:
						System.out.println("Invalid option.");
						break;
					}
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
					System.out.println("All customers: ");
					viewAllCustomers();
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
					//View employee info if not manager
					viewSingleEmployee(eid);
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
					System.out.println("My customers: ");
					viewYourCustomers(eid);
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

	//Manager's view
	public static void viewAllEmployees() {
		String viewEmployees = "CALL view_all_emp();";
		try {
			ResultSet rsView = dbi.executeStatement(viewEmployees);
			while(rsView.next()){
				int id = rsView.getInt(1);
				String name = rsView.getString(2);
				String dob = rsView.getDate(3).toString();
				String ssn = rsView.getString(4);
				double period = rsView.getDouble(5);
				double ytd = rsView.getDouble(6);
				String address = rsView.getString(7);
				String phone = rsView.getString(8);
				System.out.printf("%d %5s %5s %5s %5f %5f %5s %5s \n", id, name, dob, ssn, period, ytd, address, phone);
			}
		} catch (SQLException e) {
			System.out.println("SQLException: " + e.getMessage());
		}
	}

	//Employee's view
	public static void viewSingleEmployee(int id){
		String viewOneEmployee = "CALL view_an_employee(" + id + ");";
		try {
			ResultSet rsView = dbi.executeStatement(viewOneEmployee);
			while(rsView.next()){
				int id = rsView.getInt(1);
				String name = rsView.getString(2);
				String dob = rsView.getDate(3).toString();
				String ssn = rsView.getString(4);
				double period = rsView.getDouble(5);
				double ytd = rsView.getDouble(6);
				String address = rsView.getString(7);
				String phone = rsView.getString(8);
				System.out.printf("%d %5s %5s %5s %5f %5f %5s %5s \n", id, name, dob, ssn, period, ytd, address, phone);
			}
		} catch (SQLException e) {
			System.out.println("SQLException: " + e.getMessage());
		}
	}
	
	//Insert an employee
	public static void addAnEmployee() {
		System.out.println("Employee's ID: ");
		int id = scanner.nextInt();
		
		System.out.println("Employee's name: ");
		String name = scanner.next();
		
		System.out.println("Employee's date of birth (format YYYYMMDD): ");
		String dob = scanner.next();
		
		System.out.println("Employee's SSN: ");
		String ssn = scanner.next();
		
		System.out.println("Employee's address: ");
		String address = scanner.next();
		
		System.out.println("Employee's phone number: ");
		String phone = scanner.next();
		
		System.out.println("Employee's username: ");
		String user = scanner.next();
		
		System.out.println("Employee's password: ");
		String pw = scanner.next();
		String digest = utils.sha256(pw);
		
		System.out.println("Is this employee a manager? (y for yes, otherwise no) ");
		String man = scanner.next();
		int manager = 0;
		if(man.equalsIgnoreCase("y")){
			manager = 1;
		}
		
		// sql statement
		String insert = "CALL insert_emp(" + id + ", '" + name + "', '" + dob + "', '" + ssn + "', '" 
		+ address + "', '" + phone + "', '" + user + "', '" + digest + "', " + manager + ");";
		
		try {
			dbi.executeStatement(insert);
			System.out.println("Inserted an employee");
		}
		catch (SQLException e) {
			System.out.println("SQLException: " + e.getMessage());
		}
	}

	//Delete an employee
	public static void deleteAnEmployee(int dID) {
		String deleteEmp = "CALL delete_an_emp(" + dID + ");";
		try{
			dbi.executeStatement(deleteEmp);
			System.out.println("Deleted employee "+ dID);
		} catch (SQLException e) {
			System.out.println("SQLException: " + e.getMessage());
		}
	}
	
	// View all customers
	public static void viewAllCustomers(){
		String allCustomers = "CALL view_all_customers();";
		try {
			ResultSet rsView = dbi.executeStatement(allCustomers);
			while(rsView.next()){
				String cust = rsView.getString(1);
				String phone = rsView.getString(2);
				int sid = rsView.getInt(3);
				System.out.printf("%s %5s %5d \n", cust, phone, sid);
			}
		} catch (SQLException e) {
			System.out.println("SQLException: " + e.getMessage());
		}	
	}
	
	// View your customers
	public static void viewYourCustomers(int id){
		String customers = "CALL view_customers(" + id + ");";
		try {
			ResultSet rsView = dbi.executeStatement(customers);
			while(rsView.next()){
				String cust = rsView.getString(1);
				String phone = rsView.getString(2);
				System.out.printf("%s %5s \n", cust, phone);
			}
		} catch (SQLException e) {
			System.out.println("SQLException: " + e.getMessage());
		}
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
