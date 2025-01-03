DROP SCHEMA IF EXISTS `ONLINE-SHOP`;

CREATE SCHEMA `ONLINE-SHOP`;

USE `ONLINE-SHOP`;

-- User Table
CREATE TABLE User (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(68) NOT NULL,
    address TEXT,
    role VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Product Table
CREATE TABLE Product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    category VARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Basket (Cart) Table
CREATE TABLE Basket (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    status VARCHAR(30) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY FK_USER_idx (user_id),
    CONSTRAINT FK_USER FOREIGN KEY (user_id) REFERENCES User(id)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- BasketItem Table
CREATE TABLE Basket_Item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    basket_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY FK_BASKET_idx (basket_id),
    KEY FK_PRODUCT_idx (product_id),
    CONSTRAINT FK_BASKET FOREIGN KEY (basket_id) REFERENCES Basket(id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_PRODUCT FOREIGN KEY (product_id) REFERENCES Product(id)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Order Table
CREATE TABLE The_Order (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    basket_id INT NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(30) NOT NULL,
    order_status VARCHAR(30) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY FK_ORDER_USER_idx (user_id),
    KEY FK_ORDER_BASKET_idx (basket_id),
    CONSTRAINT FK_ORDER_USER FOREIGN KEY (user_id) REFERENCES User(id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_ORDER_BASKET FOREIGN KEY (basket_id) REFERENCES Basket(id)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Payment Table
CREATE TABLE Payment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method VARCHAR(255) NOT NULL,
    status VARCHAR(20) NOT NULL,
    transaction_id VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    KEY FK_PAYMENT_ORDER_idx (order_id),
    CONSTRAINT FK_PAYMENT_ORDER FOREIGN KEY (order_id) REFERENCES The_Order(id)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
