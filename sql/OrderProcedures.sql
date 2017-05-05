DROP PROCEDURE IF EXISTS delete_order;
DELIMITER $$
CREATE PROCEDURE delete_order(orderNo INT)
BEGIN
DELETE FROM orders WHERE orderNumber = orderNo;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS place_order;
DELIMITER $$
CREATE PROCEDURE place_order(IN customer_name VARCHAR(50), IN customer_phone VARCHAR(50), IN eid INT, IN pCode INT, IN amount INT)
    MODIFIES SQL DATA
BEGIN
INSERT INTO orders(orderDate, customer_name, customer_phone, employee_id, product_code, amount) VALUES (sysdate(), customer_name, customer_phone, eid, pCode, amount);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS edit_order;
DELIMITER $$
CREATE PROCEDURE edit_order(IN orderNo INT(11), IN product_code INT(11), IN amount DECIMAL(1,0))
    MODIFIES SQL DATA
BEGIN
UPDATE orders
SET orders.product_code = product_code,
	orders.amount = amount
WHERE orders.orderNumber = orderNo;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS view_all_orders;
DELIMITER $$
CREATE PROCEDURE view_all_orders()
    READS SQL DATA
BEGIN
SELECT orderNumber, orderDate, customer_name, customer_phone, orders.employee_id, employees.name "Seller" , orders.product_code, product.name "Product", orders.amount 
FROM orders JOIN employees on orders.employee_id = employees.employee_id
JOIN product on orders.product_code = product.product_code;
END$$
DELIMITER ;
