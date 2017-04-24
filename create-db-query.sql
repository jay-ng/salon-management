use cmsc508;

CREATE TABLE employees (
	employee_id NUMERIC(6) PRIMARY KEY,
    name VARCHAR(50) not null,
    dob DATE not null,
    ssn CHAR(11) not null,
    periodPay NUMERIC(5),
    yearToDatePay NUMERIC(6));
    
CREATE TABLE customers (
	name VARCHAR(50),
    phoneNumber NUMERIC(10),
    stylistID NUMERIC(6) references employees(employee_id),
    primary key (name, phoneNumber));
    
CREATE TABLE users (
	username VARCHAR(24) primary key,
    password VARCHAR(30),
    isManager bool,
    employee_id NUMERIC(6) references employees(employee_id));

CREATE TABLE employeePhones (
	employee_id NUMERIC(6) references employees(employee_id),
    phoneNumber NUMERIC(10),
    primary key (employee_id, phoneNumber));

CREATE TABLE employeeAddress (
	employee_id NUMERIC(6) references employees(employee_id),
    address VARCHAR(50),
    primary key (employee_id, address));
    
CREATE TABLE services (
	name VARCHAR(50) primary key,
    price NUMERIC(5) not null,
    time NUMERIC(3) not null);
    
CREATE TABLE serviceDone (
	employee_id NUMERIC(6) references employees(employee_id),
    service VARCHAR(50) references services(name),
    count numeric(6),
    primary key (employee_id, service));

CREATE TABLE product (
	product_code VARCHAR(6) primary key,
    name VARCHAR(50) not null,
    type VARCHAR(30) not null,
    amount NUMERIC(5),
    price NUMERIC(6) not null);
    
CREATE TABLE appointment (
	employee_id NUMERIC(6) references employees(employee_id),
    startTime NUMERIC(2),
    endTime NUMERIC(2),
    service VARCHAR(50) references services(name),
    customer_name VARCHAR(50) references customers(name),
    primary key (employee_id, startTime));
    
CREATE TABLE orders (
	orderNumber NUMERIC(7) primary key,
    orderDate DATE not null,
    customer_name VARCHAR(50) references customers(name),
    customer_phone NUMERIC(10) references customers(phoneNumber),
    employee_id NUMERIC(6) references employees(employee_id),
    product_code VARCHAR(6) references product(product_code),
    amount NUMERIC(1));

DROP TABLE employees;
DROP TABLE appointment;
DROP TABLE users;
DROP TABLE employeePhones;
DROP TABLE employeeAddress;
DROP TABLE customers;
DROP TABLE serviceDone;
DROP TABLE product;
DROP TABLE orders;