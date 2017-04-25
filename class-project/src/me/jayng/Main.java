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

    public static void main(String[] args) {
	// write your code here
        printHeading();
        login();
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

            String digest = utils.sha256(password);

            String loginSql = "SELECT username FROM users WHERE username ='" + username + "';";
            String passwordSql = "SELECT password FROM users WHERE username ='" + username + "';";
            String returnLogin = "";
            String returnPassword = "";
            try {
                ResultSet rsLogin = dbi.executeStatement(loginSql);
                rsLogin.next();
                ResultSet rsPassword = dbi.executeStatement(passwordSql);
                rsPassword.next();
                ResultSetMetaData metaLogin = rsLogin.getMetaData();
                ResultSetMetaData metaPassword = rsPassword.getMetaData();
                returnLogin = rsLogin.getString(1);
                returnPassword = rsPassword.getString(1);
            } catch (SQLException e) {
                System.out.println("SQLException: " + e);
            }

            if (returnLogin.equals(username) && returnPassword.equals(digest)) {
                success = true;
            } else {
                System.out.println("Login failed for " + username);
            }

        }

        System.out.println("Welcome " + username + "!!!");
    }
}
