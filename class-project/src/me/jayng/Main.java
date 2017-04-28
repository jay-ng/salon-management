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
	int eid;
	boolean isManager = false;

    public static void main(String[] args) {
	// write your code here
        printHeading();
        login();
		System.out.println("Options: ");
		if(isManager){
			System.out.println("1. Manage employees");
			System.out.println("2. Manage Appointments");
			System.out.println("3. Manage products and orders");
			System.out.println("4. View customers");
			System.out.println("5. Services");
			int option = scanner.nextInt();
			switch (option) {
			case 1:
				System.out.println("1. View all employees");
				System.out.println("2. Add an employee");
				System.out.println("3. Delete an employee");
				int innerOption = scan.nextInt();
				// To do: add sql statements to view, add, delete
				break;
			case 2:
				System.out.println("1. View all appointments");
				System.out.println("2. Add an appointment");
				System.out.println("3. Delete an appointment");
				System.out.println("4. Edit an appointment");
				int innerOption = scan.nextInt();
				// sql statements for appointments
				break;
			case 3:
				System.out.println("1. View all products");
				System.out.println("2. Edit a product");
				int innerOption = scan.nextInt();
				// sql statements
				break;
			case 4:
				// sql view customers
				break;
			case 5:
				System.out.println("1. View services");
				System.out.println("2. Edit a service");
				System.out.println("2. View employees' service counts");
				System.out.println("3. Update employees' service counts");
				int innerOption = scan.nextInt();
				// sql statements
				break;
			default: 
				System.out.println("Invalid option.");
				break;
			}
		}
		
		else {
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
					int innerOption = scan.nextInt();
					// sql statements for appointments
					break;
				case 3:
					// sql view
					break;
				case 4:
					System.out.println("1. View all offered services");
					System.out.println("2. View your service counts");
					System.out.println("3. Update your service counts");
					int innerOption = scan.nextInt();
					// sql statements
					break;
				default: 
					System.out.println("Invalid option.");
					break;
			}
		}
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
				String getEID = "SELECT f_getEID(':" + username + "','" + digest + "');";
				try {
					ResultSet rsEID = dbi.executeStatement(getEID);
					rsEID.next();
					eid = rsEID.getInt(1);
				} catch (SQLException e) {
					System.out.println("SQLException: " + e.getMessage());
				}
				// get isManager from username and password
				String checkManager = "SELECT f_getEmployeeType(':" + username + "','" + digest + "');";
				try {
					ResultSet rsType = dbi.executeStatement(checkManager);
					rsType.next();
					isManager = rsType.getBoolean(1);
				} catch (SQLException e) {
					System.out.println("SQLException: " + e.getMessage());
				}
				// show employee information
				String showEmployee = "SELECT *  from employees where employee_id = " + eid + ";";
				try{
					ResultSet rsShow = dbi.executeStatement(showEmployee);
				} catch (SQLException e){
					System.out.println("SQLException: " + e.getMessage());
				}
            } else {
                System.out.println("-> Login failed for " + username + ". Please check your username and password.\n-> If problem persists, please contact administrator.");
            }
        }

        System.out.println("Welcome " + username + "!!!");
    }
}
