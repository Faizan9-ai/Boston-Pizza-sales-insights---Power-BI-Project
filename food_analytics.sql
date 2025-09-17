create database food_analytics;
use food_analytics; 


SET SESSION sql_mode='STRICT_TRANS_TABLES';

CREATE TABLE customers (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  customer_uuid CHAR(36) NOT NULL UNIQUE,
  first_name VARCHAR(80),
  last_name VARCHAR(80),
  signup_date DATE,
  city VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE  restaurants (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(200),
  cuisine VARCHAR(100),
  city VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE  drivers (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(200),
  vehicle_no VARCHAR(32),
  city VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE  menu_items (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  restaurant_id BIGINT NOT NULL,
  item_name VARCHAR(200),
  price DECIMAL(10,2),
  category VARCHAR(100),
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE  orders (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  order_uuid CHAR(36) NOT NULL UNIQUE,
  customer_id BIGINT NOT NULL,
  restaurant_id BIGINT NOT NULL,
  order_placed_at DATETIME NOT NULL,
  order_accepted_at DATETIME NULL,
  picked_up_at DATETIME NULL,
  delivered_at DATETIME NULL,
  status ENUM('placed','accepted','picked_up','delivered','cancelled','failed') DEFAULT 'placed',
  total_amount DECIMAL(10,2) NOT NULL,
  tip_amount DECIMAL(10,2) DEFAULT 0,
  payment_method VARCHAR(50),
  city VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_order_time (order_placed_at),
  INDEX idx_restaurant_time (restaurant_id, order_placed_at),
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
) ENGINE=InnoDB;

CREATE TABLE  order_items (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  order_id BIGINT NOT NULL,
  menu_item_id BIGINT NOT NULL,
  qty INT DEFAULT 1,
  price DECIMAL(10,2),
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
) ENGINE=InnoDB;

CREATE TABLE  deliveries (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  order_id BIGINT NOT NULL,
  driver_id BIGINT,
  assigned_at DATETIME,
  picked_at DATETIME,
  delivered_at DATETIME,
  status ENUM('assigned','in_transit','delivered','failed') DEFAULT 'assigned',
  actual_travel_minutes INT,
  distance_km DECIMAL(6,2),
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (driver_id) REFERENCES drivers(id)
) ENGINE=InnoDB;

CREATE TABLE  payments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  order_id BIGINT NOT NULL,
  paid_amount DECIMAL(10,2),
  payment_gateway_fee DECIMAL(10,2),
  refunded BOOLEAN DEFAULT FALSE,
  refunded_at DATETIME NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id)
) ENGINE=InnoDB;

CREATE TABLE  dim_date (
  date_id DATE PRIMARY KEY,
  year INT,
  month INT,
  day INT,
  quarter INT,
  weekday INT,
  is_weekend BOOLEAN
) ENGINE=InnoDB; 


