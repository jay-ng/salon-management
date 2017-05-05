use cmsc508;

CREATE TABLE employees (
	employee_id INT not null PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) not null,
    dob DATE not null,
    ssn CHAR(11) not null,
    periodPay NUMERIC(5),
    yearToDatePay NUMERIC(6));
    
CREATE TABLE customers (
	name VARCHAR(50) not null,
    phoneNumber VARCHAR(50) not null,
    stylistID INT not null references employees(employee_id),
    primary key (name, phoneNumber));
INSERT INTO customers VALUES ('Walk In', '000-000-0000',1);
    
CREATE TABLE users (
	username VARCHAR(24) not null primary key,
    password CHAR(64) not null,
    isManager bool not null,
    employee_id INT not null references employees(employee_id));

CREATE TABLE employeePhones (
	employee_id INT not null references employees(employee_id),
    phoneNumber VARCHAR(40) not null,
    primary key (employee_id, phoneNumber));

CREATE TABLE employeeAddress (
	employee_id INT not null references employees(employee_id),
    address VARCHAR(50) not null,
    primary key (employee_id, address));
    
CREATE TABLE services (
	name VARCHAR(50) not null primary key,
    price NUMERIC(5) not null,
    time TIME not null);
    
CREATE TABLE serviceDone (
	employee_id INT not null references employees(employee_id),
    service VARCHAR(50) not null references services(name),
    count numeric(6) not null,
    primary key (employee_id, service));

CREATE TABLE product (
	product_code INT not null primary key auto_increment,
    name VARCHAR(50) not null,
    type VARCHAR(30) not null,
    amount NUMERIC(5) not null,
    price NUMERIC(6) not null);
    
CREATE TABLE appointment (
	employee_id INT not null references employees(employee_id),
    startTime TIME not null,
    endTime TIME not null,
    date DATE not null,
    service VARCHAR(50) not null references services(name),
    customer_name VARCHAR(50) not null references customers(name),
    status VARCHAR(12),
    primary key (employee_id, startTime, date));

CREATE TABLE orders (
	orderNumber INT not null auto_increment,
    orderDate DATE not null,
    customer_name VARCHAR(50) not null references customers(name),
    customer_phone VARCHAR(50) not null references customers(phoneNumber),
    employee_id INT not null references employees(employee_id),
    product_code INT not null references product(product_code),
    amount NUMERIC(1) not null,
    primary key (orderNumber));

DROP TABLE employees;
DROP TABLE appointment;
DROP TABLE users;
DROP TABLE employeePhones;
DROP TABLE employeeAddress;
DROP TABLE customers;
DROP TABLE serviceDone;
DROP TABLE services;
DROP TABLE product;
DROP TABLE orders;