-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- Schema maersk
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema maersk
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS maersk DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;



-- -----------------------------------------------------
-- Table maersk.customers
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS maersk.customers (
  customer_id INT NOT NULL,
  name VARCHAR(120) NULL DEFAULT NULL,
  contact VARCHAR(80) NULL DEFAULT NULL,
  country VARCHAR(80) NULL DEFAULT NULL,
  PRIMARY KEY (customer_id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table maersk.ports
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS maersk.ports (
  port_id INT NOT NULL,
  code VARCHAR(12) NULL DEFAULT NULL,
  name VARCHAR(120) NULL DEFAULT NULL,
  city VARCHAR(80) NULL DEFAULT NULL,
  country VARCHAR(80) NULL DEFAULT NULL,
  PRIMARY KEY (port_id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table maersk.bookings
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS maersk.bookings (
  booking_id INT NOT NULL,
  booking_no VARCHAR(40) NULL DEFAULT NULL,
  shipper_id INT NULL DEFAULT NULL,
  customer_id INT NULL DEFAULT NULL,
  origin_port_id INT NULL DEFAULT NULL,
  dest_port_id INT NULL DEFAULT NULL,
  booking_date DATE NULL DEFAULT NULL,
  status VARCHAR(30) NULL DEFAULT NULL,
  PRIMARY KEY (booking_id),
  INDEX shipper_id (shipper_id ASC) VISIBLE,
  INDEX customer_id (customer_id ASC) VISIBLE,
  INDEX origin_port_id (origin_port_id ASC) VISIBLE,
  INDEX dest_port_id (dest_port_id ASC) VISIBLE,
  CONSTRAINT bookings_ibfk_1
    FOREIGN KEY (shipper_id)
    REFERENCES maersk.shippers (shipper_id),
  CONSTRAINT bookings_ibfk_2
    FOREIGN KEY (customer_id)
    REFERENCES maersk.customers (customer_id),
  CONSTRAINT bookings_ibfk_3
    FOREIGN KEY (origin_port_id)
    REFERENCES maersk.ports (port_id),
  CONSTRAINT bookings_ibfk_4
    FOREIGN KEY (dest_port_id)
    REFERENCES maersk.ports (port_id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table maersk.containers
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS maersk.containers (
  container_id INT NOT NULL,
  container_no VARCHAR(20) NULL DEFAULT NULL,
  size_type VARCHAR(8) NULL DEFAULT NULL,
  status VARCHAR(40) NULL DEFAULT NULL,
  PRIMARY KEY (container_id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table maersk.booking_containers
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS maersk.booking_containers (
  id INT NOT NULL,
  booking_id INT NULL DEFAULT NULL,
  container_id INT NULL DEFAULT NULL,
  commodity VARCHAR(120) NULL DEFAULT NULL,
  weight_kg INT NULL DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX booking_id (booking_id ASC) VISIBLE,
  INDEX container_id (container_id ASC) VISIBLE,
  CONSTRAINT booking_containers_ibfk_1
    FOREIGN KEY (booking_id)
    REFERENCES maersk.bookings (booking_id),
  CONSTRAINT booking_containers_ibfk_2
    FOREIGN KEY (container_id)
    REFERENCES maersk.containers (container_id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table maersk.carriers
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS maersk.carriers (
  carrier_id INT NOT NULL,
  name VARCHAR(120) NULL DEFAULT NULL,
  scac VARCHAR(8) NULL DEFAULT NULL,
  PRIMARY KEY (carrier_id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table maersk.shipments
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS maersk.shipments (
  shipment_id INT NOT NULL,
  shipment_no VARCHAR(40) NULL DEFAULT NULL,
  booking_id INT NULL DEFAULT NULL,
  pickup_date DATE NULL DEFAULT NULL,
  delivery_date DATE NULL DEFAULT NULL,
  status VARCHAR(30) NULL DEFAULT NULL,
  PRIMARY KEY (shipment_id),
  INDEX booking_id (booking_id ASC) VISIBLE,
  CONSTRAINT shipments_ibfk_1
    FOREIGN KEY (booking_id)
    REFERENCES maersk.bookings (booking_id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table maersk.customs_declarations
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS maersk.customs_declarations (
  decl_id INT NOT NULL,
  shipment_id INT NULL DEFAULT NULL,
  container_id INT NULL DEFAULT NULL,
  declaration_date DATE NULL DEFAULT NULL,
  status VARCHAR(40) NULL DEFAULT NULL,
  assessed_duty DECIMAL(10,2) NULL DEFAULT NULL,
  remarks VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (decl_id),
  INDEX shipment_id (shipment_id ASC) VISIBLE,
  INDEX container_id (container_id ASC) VISIBLE,
  CONSTRAINT customs_declarations_ibfk_1
    FOREIGN KEY (shipment_id)
    REFERENCES maersk.shipments (shipment_id),
  CONSTRAINT customs_declarations_ibfk_2
    FOREIGN KEY (container_id)
    REFERENCES maersk.containers (container_id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table maersk.insurances
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS maersk.insurances (
  policy_id INT NOT NULL,
  shipment_id INT NULL DEFAULT NULL,
  customer_id INT NULL DEFAULT NULL,
  provider VARCHAR(120) NULL DEFAULT NULL,
  premium DECIMAL(10,2) NULL DEFAULT NULL,
  coverage_amount DECIMAL(12,2) NULL DEFAULT NULL,
  start_date DATE NULL DEFAULT NULL,
  end_date DATE NULL DEFAULT NULL,
  status VARCHAR(30) NULL DEFAULT NULL,
  PRIMARY KEY (policy_id),
  INDEX shipment_id (shipment_id ASC) VISIBLE,
  INDEX customer_id (customer_id ASC) VISIBLE,
  CONSTRAINT insurances_ibfk_1
    FOREIGN KEY (shipment_id)
    REFERENCES maersk.shipments (shipment_id),
  CONSTRAINT insurances_ibfk_2
    FOREIGN KEY (customer_id)
    REFERENCES maersk.customers (customer_id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table maersk.invoices
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS maersk.invoices (
  invoice_id INT NOT NULL,
  shipment_id INT NULL DEFAULT NULL,
  amount DECIMAL(12,2) NULL DEFAULT NULL,
  currency VARCHAR(6) NULL DEFAULT NULL,
  invoice_date DATE NULL DEFAULT NULL,
  status VARCHAR(30) NULL DEFAULT NULL,
  PRIMARY KEY (invoice_id),
  INDEX shipment_id (shipment_id ASC) VISIBLE,
  CONSTRAINT invoices_ibfk_1
    FOREIGN KEY (shipment_id)
    REFERENCES maersk.shipments (shipment_id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table maersk.payments
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS maersk.payments (
  payment_id INT NOT NULL,
  invoice_id INT NULL DEFAULT NULL,
  customer_id INT NULL DEFAULT NULL,
  payment_date DATE NULL DEFAULT NULL,
  amount DECIMAL(12,2) NULL DEFAULT NULL,
  method VARCHAR(30) NULL DEFAULT NULL,
  status VARCHAR(30) NULL DEFAULT NULL,
  PRIMARY KEY (payment_id),
  INDEX invoice_id (invoice_id ASC) VISIBLE,
  INDEX customer_id (customer_id ASC) VISIBLE,
  CONSTRAINT payments_ibfk_1
    FOREIGN KEY (invoice_id)
    REFERENCES maersk.invoices (invoice_id),
  CONSTRAINT payments_ibfk_2
    FOREIGN KEY (customer_id)
    REFERENCES maersk.customers (customer_id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table maersk.routes
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS maersk.routes (
  route_id INT NOT NULL,
  origin_port_id INT NULL DEFAULT NULL,
  dest_port_id INT NULL DEFAULT NULL,
  typical_duration_days INT NULL DEFAULT NULL,
  distance_nm INT NULL DEFAULT NULL,
  PRIMARY KEY (route_id),
  INDEX origin_port_id (origin_port_id ASC) VISIBLE,
  INDEX dest_port_id (dest_port_id ASC) VISIBLE,
  CONSTRAINT routes_ibfk_1
    FOREIGN KEY (origin_port_id)
    REFERENCES maersk.ports (port_id),
  CONSTRAINT routes_ibfk_2
    FOREIGN KEY (dest_port_id)
    REFERENCES maersk.ports (port_id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table maersk.ships
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS maersk.ships (
  ship_id INT NOT NULL,
  imo_number INT NULL DEFAULT NULL,
  name VARCHAR(120) NULL DEFAULT NULL,
  capacity_teu INT NULL DEFAULT NULL,
  carrier_id INT NULL DEFAULT NULL,
  PRIMARY KEY (ship_id),
  INDEX carrier_id (carrier_id ASC) VISIBLE,
  CONSTRAINT ships_ibfk_1
    FOREIGN KEY (carrier_id)
    REFERENCES maersk.carriers (carrier_id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table maersk.tracking_events
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS maersk.tracking_events (
  event_id INT NOT NULL,
  container_id INT NULL DEFAULT NULL,
  event_time DATETIME NULL DEFAULT NULL,
  location VARCHAR(120) NULL DEFAULT NULL,
  event_type VARCHAR(60) NULL DEFAULT NULL,
  remark VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (event_id),
  INDEX container_id (container_id ASC) VISIBLE,
  CONSTRAINT tracking_events_ibfk_1
    FOREIGN KEY (container_id)
    REFERENCES maersk.containers (container_id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table maersk.voyages
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS maersk.voyages (
  voyage_id INT NOT NULL,
  ship_id INT NULL DEFAULT NULL,
  voyage_no VARCHAR(40) NULL DEFAULT NULL,
  departure_date DATE NULL DEFAULT NULL,
  arrival_date DATE NULL DEFAULT NULL,
  origin_port_id INT NULL DEFAULT NULL,
  dest_port_id INT NULL DEFAULT NULL,
  PRIMARY KEY (voyage_id),
  INDEX ship_id (ship_id ASC) VISIBLE,
  INDEX origin_port_id (origin_port_id ASC) VISIBLE,
  INDEX dest_port_id (dest_port_id ASC) VISIBLE,
  CONSTRAINT voyages_ibfk_1
    FOREIGN KEY (ship_id)
    REFERENCES maersk.ships (ship_id),
  CONSTRAINT voyages_ibfk_2
    FOREIGN KEY (origin_port_id)
    REFERENCES maersk.ports (port_id),
  CONSTRAINT voyages_ibfk_3
    FOREIGN KEY (dest_port_id)
    REFERENCES maersk.ports (port_id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table maersk.warehouses
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS maersk.warehouses (
  warehouse_id INT NOT NULL,
  name VARCHAR(120) NULL DEFAULT NULL,
  port_id INT NULL DEFAULT NULL,
  address VARCHAR(200) NULL DEFAULT NULL,
  capacity_teu INT NULL DEFAULT NULL,
  PRIMARY KEY (warehouse_id),
  INDEX port_id (port_id ASC) VISIBLE,
  CONSTRAINT warehouses_ibfk_1
    FOREIGN KEY (port_id)
    REFERENCES maersk.ports (port_id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
