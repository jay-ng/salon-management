package me.jayng;

import javax.xml.transform.Result;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Scanner;

public class Main {

    public static Utils utils;
    public static DBI dbi = DBI.getInstance();
    public static Connection conn;
    public static Scanner scanner = new Scanner(System.in).useDelimiter("\\n");
	static int eid;
	static boolean isManager = false;
	static String today = "";

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
            } else {
                System.out.println("-> Login failed for " + username + ". Please check your username and password.\n-> If problem persists, please contact administrator.");
            }
        }

        if (isManager) {
            System.out.println("-> Welcome " + username + ", you have manager permission.");
        } else {
            System.out.println("-> Welcome " + username + ", you have employee permission.");
        }
    }

    public static void presentOption() {
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
					addAnAppointment();
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
			System.out.println();
			System.out.print("- Choice: ");
			int option = scanner.nextInt();

			switch (option) {
				case 1:
					//View employee info if not manager
					viewSingleEmployee(eid);
					break;
				case 2:
					System.out.println("1. View today appointments");
					System.out.println("2. Add an appointment");
					System.out.println("3. Delete an appointment");
					System.out.println("4. Edit an appointment");
                    System.out.println("5. View all appointments up to date");
					int innerOption = scanner.nextInt();
					switch (innerOption) {
                        case 1:
                            viewTodayAppointment();
                            break;
                        case 2:
                            addAnAppointment();
                            break;
                        default:
                            System.out.println("-> Invalid Option.");
                    }
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
        ResultSet rsView = dbi.executeStatement(viewEmployees);
        Utils.printResultSet(rsView);
	}

	//Employee's view
	public static void viewSingleEmployee(int id){
		String viewOneEmployee = "CALL view_an_employee(" + id + ");";
        ResultSet rsView = dbi.executeStatement(viewOneEmployee);
        Utils.printResultSet(rsView);
	}
	
	//Insert an employee
	public static void addAnEmployee() {
		System.out.println("Employee's name: ");
		String name = scanner.next();
		
		System.out.println("Employee's date of birth (format YYYY-MM-DD): ");
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
		String insert = "CALL insert_emp('" + name + "', '" + dob + "', '" + ssn + "', '"
		+ address + "', '" + phone + "', '" + user + "', '" + digest + "', " + manager + ");";

        dbi.executeStatement(insert);
        System.out.println("-> Inserted an employee");
	}

	//Delete an employee
	public static void deleteAnEmployee(int dID) {
		String deleteEmp = "CALL delete_an_emp(" + dID + ");";
        dbi.executeStatement(deleteEmp);
        System.out.println("-> Deleted employee "+ dID);
	}
	
	// View all customers
	public static void viewAllCustomers(){
		String allCustomers = "CALL view_all_customers();";
        ResultSet rsView = dbi.executeStatement(allCustomers);
        Utils.printResultSet(rsView);
	}
	
	// View your customers
	public static void viewYourCustomers(int id){
		String customers = "CALL view_customers(" + id + ");";
        ResultSet rsView = dbi.executeStatement(customers);
        Utils.printResultSet(rsView);
	}

	// View All Appointments
	public static void viewAllAppointment() {
		String getAptSQL = "CALL view_all_appointments;";
		ResultSet rsView = dbi.executeStatement(getAptSQL);
		Utils.printResultSet(rsView);
	}

	// View Today Appointments (Should be used the most for normal operations)
	public static void viewTodayAppointment() {
        String getAptSQL = "CALL view_today_appointments;";
        ResultSet rsView = dbi.executeStatement(getAptSQL);
        Utils.printResultSet(rsView);
    }

    // View your appointment
    public static void viewYourAppointment() {
	    System.out.print("Please enter inquiry date (Format: YYYY-MM-DD): ");
	    String date = scanner.next();
	    String getYourAptSQL = "CALL view_emp_appointments(" + eid + ", '" + date + "');";
        ResultSet yourApt = dbi.executeStatement(getYourAptSQL);
	    Utils.printResultSet(yourApt);
    }

    // Add an appointment for an employee
	public static void addAnAppointment() {
		viewAllEmployees();
		System.out.println("Please enter Employee ID. You can refer to the table above for correct ID: ");
		int id = scanner.nextInt();
		System.out.println("Please enter the date of the appointment (Format YYYY-MM-DD): ");
		String date = scanner.next();
		String getEmpAptSQL = "CALL view_emp_appointments(" + id + ", '" + date +"');";
        ResultSet empApt = dbi.executeStatement(getEmpAptSQL);
		Utils.printResultSet(empApt);
		System.out.println("Please enter start time (Format: HH:MM): ");
		String startTime = scanner.next();
		boolean conflict = true;
		while (conflict) {
            String aptCheckSQL = "SELECT f_appointmentCheck(" + id + ", '" + date + "', '" + startTime + "');";
            try {
		        ResultSet aptCheck = dbi.executeStatement(aptCheckSQL);
		        if (aptCheck.next()) {
                    conflict = aptCheck.getBoolean(1);
                } else {
		            conflict = false;
                }
		        if (conflict) {
		            System.out.println("-> Employee already have an appointment running at " + startTime + ".");
                    System.out.println("Please reschedule with a new start time (Format: HH:MM): ");
                    startTime = scanner.next();
                }
            } catch (SQLException e) {
		        System.out.println("SQLException: " + e.getMessage());
            }
        }
        System.out.println("Please enter service name: ");
		String serviceName = scanner.next();
		System.out.println("Please enter customer name: ");
		String customerName = scanner.next();
		String getEndTimeSQL = "SELECT f_getEndTime('" + startTime + "', '" + serviceName + "');";
		String endTime = "";
		try {
		    ResultSet getEndTime = dbi.executeStatement(getEndTimeSQL);
		    getEndTime.next();
		    endTime = getEndTime.getString(1);
        } catch (SQLException e) {
            System.out.println("SQLException: " + e.getMessage());
        }
        String addEmpAptSQL = "CALL add_emp_appointment(" + id + ", '" + startTime + "', '" + endTime + "', '" + date + "', '" + serviceName + "', '" + customerName + "');";
		dbi.executeStatement(addEmpAptSQL);
		System.out.println("-> Appointment for " + customerName + " at " + startTime + " on " + date + " Added");
	}

	public static void deleteAnAppointment() {
		// TODO: Implementation
	}

	public static void editAnAppointment() {
		// TODO: Implementation
	}

	public static void viewAllProduct() {
		String products = "CALL view_products();";
		ResultSet rsView = dbi.executeStatement(products);
		utils.printResultSet(rsView);
	}

	public static void addAProduct() {
		System.out.println("Enter product code: ");
		int code = scanner.nextInt();
		
		System.out.println("Enter product name: ");
		String name = scanner.next();
		
		System.out.println("Enter product type: ");
		String type = scanner.next();
		
		System.out.println("Enter product amount: ");
		int amount = scanner.nextInt();
		
		System.out.println("Enter product price: ");
		int price = scanner.nextInt();
		
		String addProduct = "CALL add_product(" + code +", '" + name + "', '" + type + "', " + amount + ", " +  price + ");";
        dbi.executeStatement(addProduct);
        System.out.println("Product added.");
		
	}

	public static void editAProduct() {
		System.out.println("Edit a product.");
		System.out.println("Enter product code: ");
		int code = scanner.nextInt();
		
		System.out.println("Enter product new name: ");
		String name = scanner.next();
		
		System.out.println("Enter product new type: ");
		String type = scanner.next();
		
		System.out.println("Enter product new amount: ");
		int amount = scanner.nextInt();
		
		System.out.println("Enter product new price: ");
		int price = scanner.nextInt();
		
		String editProduct = "CALL add_product(" + code +", '" + name + "', '" + type + "', " + amount + ", " +  price + ");";
        dbi.executeStatement(editProduct);
        System.out.println("Edited the product.");
	}

	public static void deleteAProduct() {
		System.out.println("Enter product code to delete: ");
		int code = scanner.nextInt();
		String deleteProduct = "CALL delete_product(" + code + ");";
        dbi.executeStatement(deleteProduct);
        System.out.println("Deleted the product.");
	}

	public static void viewAllServices() {
		String allServices = "CALL view_all_services();";
		ResultSet rsView = dbi.executeStatement(allServices);
		utils.printResultSet(rsView);
	}

	public static void addAService() {
		System.out.println("Enter service name: ");
		String name = scanner.next();
		
		System.out.println("Enter service price: ");
		int price = scanner.nextInt();
		
		System.out.println("Enter service duration (format HH:MM:SS): ");
		String time = scanner.next();
		
		String addService = "CALL add_service('" + name + "', " + price + ", '" + time + "');";
		dbi.executeStatement(addService);
		System.out.println("Service added.");
	}

	public static void editAService() {
		System.out.println("Enter service name: ");
		String name = scanner.next();
		
		System.out.println("Enter new service price: ");
		int price = scanner.nextInt();
		
		System.out.println("Enter new service duration (format HH:MM:SS): ");
		String time = scanner.next();
		
		String editService = "CALL edit_a_service('" + name + "', " + price + ", '" + time + "');";
		dbi.executeStatement(editService);
		System.out.println("Service edited.");
	}

	public static void deleteAService() {
		System.out.println("Enter service name you want to remove:");
		String rm = scanner.next();
		String deleteService = "CALL delete_a_service('" + rm + "');";
		dbi.executeStatement(deleteService);
		System.out.println("Service deleted");
	}
	
	public static void viewOrders() {
		//TO DO: implement method
	}
	
	public static void placeOrder() {
		//TO DO: implement method
	}
	
	public static void editOrder() {
		//TO DO: implement method
	}
	
	public static void cancelOrder() {
		//TO DO: implement method
	}
	
	//For manager
	public static void viewAllEmployeesServiceCounts() {
		String empSevCount = "CALL view_all_employees_service_counts();";
		ResultSet rsView = dbi.executeStatement(empSevCount);
		utils.printResultSet(rsView);
	}

	//For employee
	public static void viewPersonalServiceCounts(int id) {
		String pSevCount = "CALL view_personal_counts(" + id + ");";
		ResultSet rsView = dbi.executeStatement(pSevCount);
		utils.printResultSet(rsView);
	}
	
	//For manager
	public static void addServicesCount() {
		System.out.println("Enter employee id: ");
		int id = scanner.nextInt();
		System.out.println("Enter service name: ");
		String service = scanner.next();
		System.out.println("Enter service count: ");
		int count = scanner.nextInt();
		
		String addNewCount = "CALL add_new_count(" + id + ", '" + service + "', " + count + ");";
		dbi.executeStatement(addNewCount);
		System.out.println("Added new count for employee " + id);
	}

	public static void updateServicesCount() {
		System.out.println("Enter employee id: ");
		int id = scanner.nextInt();
		System.out.println("Enter service name: ");
		String service = scanner.next();
		System.out.println("Enter new service count: ");
		int count = scanner.nextInt();
		
		String updateCount = "CALL update_count(" + id + ", '" + service + "', " + count + ");";
		dbi.executeStatement(updateCount);
		System.out.println("Updated count for employee " + id + ", service " + service);
	}
	
	//For employee
	//Employees can only add new service with a count of 1 when it is the their first time
	public static void empAddServiceCount() {
		System.out.println("Enter service name: ");
		String service = scanner.next();
		String addNewCount = "CALL add_new_count(" + eid + ", '" + service + "', " + 1 + ");";
		dbi.executeStatement(addNewCount);
		System.out.println("Added new count for employee " + eid);
	}
	//This is called when an employee finishes his/her service, thus count increases by 1
	public static void empUpdateCount() {
		System.out.println("Enter service name: ");
		String service = scanner.next();
		
		String empUpdateCount = "CALL update_count_emp_ver(" + eid + ", '" + service + "');";
		dbi.executeStatement(empUpdateCount);
		System.out.println("Updated count for employee " + eid + ", service " + service);
	}
}
