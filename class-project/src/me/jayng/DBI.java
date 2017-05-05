package me.jayng;

import java.sql.*;
import java.util.Properties;

/**
 * Created by Jay Ng on 4/25/2017.
 */

public class DBI {

    // Singleton DBI
    private static DBI dbi = new DBI();

    // Database constants
    private static final String DATABASE_DRIVER = "com.mysql.jdbc.Driver";
    private static final String DATABASE_URL = "jdbc:mysql://173.53.111.15/cmsc508";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "JJ123456JJ";

    // Connection object
    private Connection connection;
    // Properties object
    private Properties properties;

    // Instance
    private DBI() {
        connect();
    }

    // Get DBI Instance
    public static DBI getInstance( ) {
        return dbi;
    }

    // Create properties
    private Properties getProperties() {
        if (properties == null) {
            properties = new Properties();
            properties.setProperty("user", USERNAME);
            properties.setProperty("password", PASSWORD);
            properties.setProperty("useSSL", "false");
            properties.setProperty("autoReconnect", "true");
        }
        return properties;
    }

    // Connect Database
    public void connect() {
        if (connection == null) {
            try {
                Class.forName(DATABASE_DRIVER);
                connection = DriverManager.getConnection(DATABASE_URL, getProperties());
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Disconnect database
    public void disconnect() {
        if (connection != null) {
            try {
                connection.close();
                connection = null;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public ResultSet executeStatement(String sql) {
        ResultSet rs = null;
        try {
            Statement stmt = connection.createStatement();
            rs = stmt.executeQuery(sql);
        } catch (SQLException e) {
            System.out.println(e.getStackTrace());
        }
        return rs;
    }
}