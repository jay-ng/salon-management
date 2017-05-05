DROP PROCEDURE IF EXISTS add_product;
DELIMITER $$
CREATE PROCEDURE add_product(IN code INT, IN name VARCHAR(50), IN type VARCHAR(50), IN amount DECIMAL(6,0), IN price DECIMAL(6,0))
    MODIFIES SQL DATA
BEGIN
INSERT INTO product VALUES (code, name, type, amount, price);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS view_products;
DELIMITER $$
CREATE PROCEDURE view_products()
    READS SQL DATA
BEGIN
SELECT * FROM product;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS delete_product;
DELIMITER $$
CREATE PROCEDURE delete_product(IN product_code INT)
    MODIFIES SQL DATA
BEGIN
DELETE FROM product WHERE product.product_code = product_code;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS edit_product;
DELIMITER $$
CREATE PROCEDURE edit_product(IN product_code INT, IN name VARCHAR(50), IN type VARCHAR(50), IN amount DECIMAL(6,0), IN price DECIMAL(6,0))
    MODIFIES SQL DATA
BEGIN
UPDATE product set product.name = name, product.type = type, product.amount = amount, product.price = price where product.product_code =product_code;
END$$
DELIMITER ;
