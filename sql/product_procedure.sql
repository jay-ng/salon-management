DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `add_product`(IN `code` INT(11), IN `name` VARCHAR(50), IN `type` VARCHAR(50), IN `amount` DECIMAL(6,0), IN `price` DECIMAL(6,0))
    MODIFIES SQL DATA
BEGIN
INSERT INTO product VALUES (code, name, type, amount, price);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `view_products`()
    READS SQL DATA
BEGIN
SELECT * FROM product;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `delete_product`(IN `product_code` INT(11))
    MODIFIES SQL DATA
BEGIN
DELETE FROM product WHERE product.product_code = product_code;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `edit_product`(IN `product_code` INT(11), IN `name` VARCHAR(50), IN `type` VARCHAR(50), IN `amount` DECIMAL(6,0), IN `price` DECIMAL(6,0))
    MODIFIES SQL DATA
BEGIN
UPDATE product set product.name = name, product.type = type, product.amount = amount, product.price = price where product.product_code =product_code;
END$$
DELIMITER ;
