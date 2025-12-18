USE shipping_simple;

-- ===========================
-- 1. DROP TABLES (clean reset)
-- 0. DROP TABLES (clean reset)
-- include new tables for safe re-run
-- ===========================
DROP TABLE IF EXISTS customs_declarations;
DROP TABLE IF EXISTS insurances;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS routes;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS warehouses;
DROP TABLE IF EXISTS tracking_events;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS shipments;
@@ -19,7 +26,8 @@ DROP TABLE IF EXISTS shippers;
DROP TABLE IF EXISTS customers;

-- ===========================
-- 2. CREATE TABLES
-- 1. CREATE TABLES
-- order chosen so referenced tables exist when creating FKs
-- ===========================

CREATE TABLE customers (
@@ -50,6 +58,17 @@ CREATE TABLE ports (
country VARCHAR(80)
);

-- warehouses references ports
CREATE TABLE warehouses (
  warehouse_id INT PRIMARY KEY,
  name VARCHAR(120),
  port_id INT,
  address VARCHAR(200),
  capacity_teu INT,
  FOREIGN KEY (port_id) REFERENCES ports(port_id)
);

-- ships references carriers
CREATE TABLE ships (
ship_id INT PRIMARY KEY,
imo_number INT,
@@ -59,6 +78,17 @@ CREATE TABLE ships (
FOREIGN KEY (carrier_id) REFERENCES carriers(carrier_id)
);

-- routes reference ports (origin & dest)
CREATE TABLE routes (
  route_id INT PRIMARY KEY,
  origin_port_id INT,
  dest_port_id INT,
  typical_duration_days INT,
  distance_nm INT,
  FOREIGN KEY (origin_port_id) REFERENCES ports(port_id),
  FOREIGN KEY (dest_port_id) REFERENCES ports(port_id)
);

CREATE TABLE voyages (
voyage_id INT PRIMARY KEY,
ship_id INT,
@@ -124,6 +154,48 @@ CREATE TABLE invoices (
FOREIGN KEY (shipment_id) REFERENCES shipments(shipment_id)
);

-- payments references invoices and customers
CREATE TABLE payments (
  payment_id INT PRIMARY KEY,
  invoice_id INT,
  customer_id INT,
  payment_date DATE,
  amount DECIMAL(12,2),
  method VARCHAR(30),
  status VARCHAR(30),
  FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- insurances references shipments and customers
CREATE TABLE insurances (
  policy_id INT PRIMARY KEY,
  shipment_id INT,
  customer_id INT,
  provider VARCHAR(120),
  premium DECIMAL(10,2),
  coverage_amount DECIMAL(12,2),
  start_date DATE,
  end_date DATE,
  status VARCHAR(30),
  FOREIGN KEY (shipment_id) REFERENCES shipments(shipment_id),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- customs_declarations references shipments & containers
CREATE TABLE customs_declarations (
  decl_id INT PRIMARY KEY,
  shipment_id INT,
  container_id INT,
  declaration_date DATE,
  status VARCHAR(40),
  assessed_duty DECIMAL(10,2),
  remarks VARCHAR(200),
  FOREIGN KEY (shipment_id) REFERENCES shipments(shipment_id),
  FOREIGN KEY (container_id) REFERENCES containers(container_id)
);


CREATE TABLE tracking_events (
event_id INT PRIMARY KEY,
container_id INT,
@@ -135,7 +207,7 @@ CREATE TABLE tracking_events (
);

-- ===========================
-- 3. INSERT DATA (correct order)
-- 2. INSERT DATA (correct order)
-- ===========================

-- CUSTOMERS
@@ -207,7 +279,7 @@ INSERT INTO carriers VALUES
(19,'Ever 2','E2LU'),
(20,'Harbor Carrier','HBRC');

-- PORTS  (IMPORTANT: must be BEFORE voyages)
-- PORTS  (must exist before warehouses, routes, voyages, bookings)
INSERT INTO ports VALUES
(1,'INDEL','JNPT (JN Port)','Navi Mumbai','India'),
(2,'INCCU','Kolkata Port','Kolkata','India'),
@@ -230,7 +302,20 @@ INSERT INTO ports VALUES
(19,'CADIS','Vancouver','Vancouver','Canada'),
(20,'MXVER','Veracruz','Veracruz','Mexico');

-- SHIPS
-- WAREHOUSES (references ports)
INSERT INTO warehouses VALUES
(1,'JNPT ICD',1,'Terminal Road, Navi Mumbai',2000),
(2,'Kolkata ICD',2,'Dock Street, Kolkata',1500),
(3,'Rotterdam Hub',3,'Harbor Rd, Rotterdam',3000),
(4,'Shanghai Yard',4,'East Pier, Shanghai',2500),
(5,'LA Storage',5,'Pier 10, Los Angeles',1800),
(6,'Singapore Depot',6,'Marina View, Singapore',2200),
(7,'Melbourne Bonded',7,'Docklands, Melbourne',1200),
(8,'Dubai Warehouse',9,'JAFZA Area, Dubai',2000),
(9,'Busan Depot',11,'Portside Rd, Busan',1600),
(10,'Genoa Storage',15,'Port Street, Genoa',1400);

-- SHIPS (references carriers)
INSERT INTO ships VALUES
(1,9812345,'Maersk Horizon',8000,1),
(2,9787654,'MSC Aurora',9500,2),
@@ -253,6 +338,19 @@ INSERT INTO ships VALUES
(19,9560133,'Evergreen Beacon',9200,19),
(20,9550144,'Harbor Classic',2500,20);

-- ROUTES (references ports)
INSERT INTO routes VALUES
(1,4,3,19,5400),
(2,4,1,26,7200),
(3,3,5,30,8200),
(4,5,1,22,6000),
(5,6,3,21,5600),
(6,3,6,18,5200),
(7,4,2,20,5000),
(8,3,4,17,4800),
(9,6,5,15,4500),
(10,3,11,12,2400);

-- VOYAGES (after ports + ships)
INSERT INTO voyages VALUES
(1,1,'MH20251101','2025-11-01','2025-11-20',4,3),
@@ -391,7 +489,46 @@ INSERT INTO invoices VALUES
(19,19,9000.00,'USD','2025-11-21','paid'),
(20,20,21000.00,'USD','2025-11-22','unpaid');

-- TRACKING EVENTS
-- PAYMENTS (references invoices + customers)
INSERT INTO payments VALUES
(1,1,1,'2025-11-06',45000.00,'Bank Transfer','pending'),
(2,2,2,'2025-11-04',22000.00,'SWIFT','completed'),
(3,4,4,'2025-11-10',30000.00,'Cheque','pending'),
(4,5,5,'2025-11-11',18000.00,'RTGS','pending'),
(5,6,6,'2025-11-12',12000.00,'Card','completed'),
(6,7,7,'2025-11-13',25000.00,'Bank Transfer','pending'),
(7,8,8,'2025-11-14',9000.00,'Card','completed'),
(8,9,9,'2025-11-15',6000.00,'Bank Transfer','completed'),
(9,10,10,'2025-11-16',20000.00,'Wire','pending'),
(10,11,11,'2025-11-17',14000.00,'SWIFT','completed');

-- INSURANCES (references shipments + customers)
INSERT INTO insurances VALUES
(1,1,1,'Global Ins Co',500.00,50000.00,'2025-10-27','2025-12-27','active'),
(2,2,2,'SafeCargo Ltd',300.00,25000.00,'2025-10-30','2025-12-30','active'),
(3,3,3,'Shield Ins',200.00,15000.00,'2025-10-12','2025-12-12','expired'),
(4,4,4,'Global Ins Co',400.00,30000.00,'2025-11-01','2025-12-31','active'),
(5,5,5,'SafeCargo Ltd',350.00,20000.00,'2025-11-02','2025-12-31','active'),
(6,6,6,'Shield Ins',250.00,18000.00,'2025-11-03','2025-12-31','active'),
(7,7,7,'Global Ins Co',600.00,60000.00,'2025-11-04','2025-12-31','active'),
(8,8,8,'SafeCargo Ltd',150.00,10000.00,'2025-11-05','2025-12-31','active'),
(9,9,9,'Shield Ins',120.00,8000.00,'2025-11-06','2025-12-31','active'),
(10,10,10,'Global Ins Co',450.00,45000.00,'2025-11-07','2025-12-31','active');

-- CUSTOMS DECLARATIONS (references shipments + containers)
INSERT INTO customs_declarations VALUES
(1,1,1,'2025-11-02','clear',0.00,'All docs ok'),
(2,2,2,'2025-11-05','clear',100.00,'Minor duty'),
(3,3,3,'2025-10-20','released',0.00,'No issues'),
(4,4,4,'2025-11-08','pending',500.00,'Under review'),
(5,5,5,'2025-11-09','clear',0.00,'Perishable cleared'),
(6,6,6,'2025-11-10','clear',0.00,'OK'),
(7,7,7,'2025-11-11','held',1200.00,'Additional docs needed'),
(8,8,8,'2025-11-12','clear',0.00,'OK'),
(9,9,9,'2025-11-13','released',0.00,'OK'),
(10,10,10,'2025-11-14','clear',0.00,'OK');

-- TRACKING EVENTS (after containers exist)
INSERT INTO tracking_events VALUES
(1,1,'2025-10-27 06:30','Mumbai Terminal 2','Gate In','Arrived at terminal'),
(2,1,'2025-11-01 16:00','Shanghai - Berth 4','Loaded','Loaded on vessel Maersk Horizon'),
@@ -412,4 +549,4 @@ INSERT INTO tracking_events VALUES
(17,16,'2025-11-14 09:00','Rotterdam - Berth 5','Loaded','Loaded for transshipment'),
(18,17,'2025-11-15 13:45','Los Angeles - Yard','Gate Out','Left for final mile'),
(19,18,'2025-11-16 10:05','Vancouver','Customs Clearance','Cleared'),
(20,19,'2025-11-17 16:30','Veracruz','Received','Received at port');
(20,19,'2025-11-17 16:30','Veracruz','Received','Received at port');
