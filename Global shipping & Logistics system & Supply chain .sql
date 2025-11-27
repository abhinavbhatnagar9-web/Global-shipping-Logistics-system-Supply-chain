DROP DATABASE IF EXISTS shipping_simple;
CREATE DATABASE shipping_simple;
USE shipping_simple;

-- ===========================
-- 1. DROP TABLES (clean reset)
-- ===========================
DROP TABLE IF EXISTS tracking_events;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS booking_containers;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS containers;
DROP TABLE IF EXISTS voyages;
DROP TABLE IF EXISTS ships;
DROP TABLE IF EXISTS ports;
DROP TABLE IF EXISTS carriers;
DROP TABLE IF EXISTS shippers;
DROP TABLE IF EXISTS customers;

-- ===========================
-- 2. CREATE TABLES
-- ===========================

CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  name VARCHAR(120),
  contact VARCHAR(80),
  country VARCHAR(80)
);

CREATE TABLE shippers (
  shipper_id INT PRIMARY KEY,
  name VARCHAR(120),
  contact VARCHAR(80),
  country VARCHAR(80)
);

CREATE TABLE carriers (
  carrier_id INT PRIMARY KEY,
  name VARCHAR(120),
  scac VARCHAR(8)
);

CREATE TABLE ports (
  port_id INT PRIMARY KEY,
  code VARCHAR(12),
  name VARCHAR(120),
  city VARCHAR(80),
  country VARCHAR(80)
);

CREATE TABLE ships (
  ship_id INT PRIMARY KEY,
  imo_number INT,
  name VARCHAR(120),
  capacity_teu INT,
  carrier_id INT,
  FOREIGN KEY (carrier_id) REFERENCES carriers(carrier_id)
);

CREATE TABLE voyages (
  voyage_id INT PRIMARY KEY,
  ship_id INT,
  voyage_no VARCHAR(40),
  departure_date DATE,
  arrival_date DATE,
  origin_port_id INT,
  dest_port_id INT,
  FOREIGN KEY (ship_id) REFERENCES ships(ship_id),
  FOREIGN KEY (origin_port_id) REFERENCES ports(port_id),
  FOREIGN KEY (dest_port_id) REFERENCES ports(port_id)
);

CREATE TABLE containers (
  container_id INT PRIMARY KEY,
  container_no VARCHAR(20),
  size_type VARCHAR(8),
  status VARCHAR(40)
);

CREATE TABLE bookings (
  booking_id INT PRIMARY KEY,
  booking_no VARCHAR(40),
  shipper_id INT,
  customer_id INT,
  origin_port_id INT,
  dest_port_id INT,
  booking_date DATE,
  status VARCHAR(30),
  FOREIGN KEY (shipper_id) REFERENCES shippers(shipper_id),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (origin_port_id) REFERENCES ports(port_id),
  FOREIGN KEY (dest_port_id) REFERENCES ports(port_id)
);

CREATE TABLE booking_containers (
  id INT PRIMARY KEY,
  booking_id INT,
  container_id INT,
  commodity VARCHAR(120),
  weight_kg INT,
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
  FOREIGN KEY (container_id) REFERENCES containers(container_id)
);

CREATE TABLE shipments (
  shipment_id INT PRIMARY KEY,
  shipment_no VARCHAR(40),
  booking_id INT,
  pickup_date DATE,
  delivery_date DATE,
  status VARCHAR(30),
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

CREATE TABLE invoices (
  invoice_id INT PRIMARY KEY,
  shipment_id INT,
  amount DECIMAL(12,2),
  currency VARCHAR(6),
  invoice_date DATE,
  status VARCHAR(30),
  FOREIGN KEY (shipment_id) REFERENCES shipments(shipment_id)
);

CREATE TABLE tracking_events (
  event_id INT PRIMARY KEY,
  container_id INT,
  event_time DATETIME,
  location VARCHAR(120),
  event_type VARCHAR(60),
  remark VARCHAR(200),
  FOREIGN KEY (container_id) REFERENCES containers(container_id)
);

-- ===========================
-- 3. INSERT DATA (correct order)
-- ===========================

-- CUSTOMERS
INSERT INTO customers VALUES
(1,'Aqua Imports Pvt Ltd','Rahul Mehra','India'),
(2,'Nord Exports LLC','Anna Svensson','Sweden'),
(3,'Sunrise Traders','Karan Bhat','India'),
(4,'Pacific Electronics','Lisa Wong','Hong Kong'),
(5,'Global Foods Ltd','Samuel Osei','Ghana'),
(6,'Oceanic Supplies','M. Das','India'),
(7,'Baltic Traders','Lars Jensen','Denmark'),
(8,'Atlas Retailers','Priya Nair','India'),
(9,'Continental Goods','Marco Rossi','Italy'),
(10,'Polar Exports','Sven Erik','Norway'),
(11,'Eastern Foods','Li Wei','China'),
(12,'Western Imports','John Carter','USA'),
(13,'Tropic Produce','Ama Boateng','Ghana'),
(14,'Desert Traders','Omar Ahmed','UAE'),
(15,'Highland Merchants','Faisal Khan','Pakistan'),
(16,'Nile Commerce','Amina Yousuf','Egypt'),
(17,'Andes Supplies','Diego Perez','Peru'),
(18,'Caspian Traders','Ruslan Ibragim','Azerbaijan'),
(19,'Summit Goods','Ella Brown','UK'),
(20,'Harbor Solutions','Rohit Singh','India');

-- SHIPPERS
INSERT INTO shippers VALUES
(1,'Aqua Logistics','R. Mehra','India'),
(2,'Nord Freight','A. Svensson','Sweden'),
(3,'Sunrise Cargo','K. Bhat','India'),
(4,'Pacific Shippers','L. Wong','Hong Kong'),
(5,'Global ColdChain','S. Osei','Ghana'),
(6,'Ocean Movers','N. Rao','India'),
(7,'Baltic Lines','J. Petersen','Denmark'),
(8,'Atlas Transport','P. Nair','India'),
(9,'Continental Carriers','M. Rossi','Italy'),
(10,'Polar Shipping','S. Erik','Norway'),
(11,'EastGate Logistics','L. Zhang','China'),
(12,'WestBridge','J. Carter','USA'),
(13,'Tropic Movers','A. Boateng','Ghana'),
(14,'Desert Express','O. Ahmed','UAE'),
(15,'Highland Transit','F. Khan','Pakistan'),
(16,'Nile Freight','A. Yousuf','Egypt'),
(17,'Andes Cargo','D. Perez','Peru'),
(18,'Caspian Lines','R. Ibragim','Azerbaijan'),
(19,'Summit Logistics','E. Brown','UK'),
(20,'Harbor Carriers','R. Singh','India');

-- CARRIERS
INSERT INTO carriers VALUES
(1,'A.P. Moller - Maersk','MAEU'),
(2,'MSC Mediterranean','MSCU'),
(3,'CMA CGM','CMDU'),
(4,'Hapag-Lloyd','HLCU'),
(5,'Evergreen','OOLU'),
(6,'ONE','ONYU'),
(7,'Yang Ming','YMLU'),
(8,'ZIM','ZIMU'),
(9,'HMM','HMMU'),
(10,'COSCO','CCLU'),
(11,'K Line','KLIN'),
(12,'NYK Line','NYKU'),
(13,'Wan Hai','WNHU'),
(14,'PIL','PILU'),
(15,'Maersk 2','M2EU'),
(16,'MSC 2','M2CU'),
(17,'CMA 2','C2DU'),
(18,'Hapag 2','H2CU'),
(19,'Ever 2','E2LU'),
(20,'Harbor Carrier','HBRC');

-- PORTS  (IMPORTANT: must be BEFORE voyages)
INSERT INTO ports VALUES
(1,'INDEL','JNPT (JN Port)','Navi Mumbai','India'),
(2,'INCCU','Kolkata Port','Kolkata','India'),
(3,'NLRTM','Rotterdam','Rotterdam','Netherlands'),
(4,'CNSHA','Shanghai Port','Shanghai','China'),
(5,'USLAX','Los Angeles','Los Angeles','USA'),
(6,'SGSIN','Singapore','Singapore City','Singapore'),
(7,'AUMEL','Melbourne','Melbourne','Australia'),
(8,'BRREC','Recife','Recife','Brazil'),
(9,'ZAZEZ','Jebel Ali','Dubai','UAE'),
(10,'JPTYO','Tokyo Port','Tokyo','Japan'),
(11,'KRPUS','Busan','Busan','South Korea'),
(12,'GBLON','London Gateway','London','UK'),
(13,'FRLEH','Le Havre','Le Havre','France'),
(14,'DEHAM','Hamburg','Hamburg','Germany'),
(15,'ITGNS','Genoa','Genoa','Italy'),
(16,'EGALX','Alexandria','Alexandria','Egypt'),
(17,'INMUN','Mundra','Mundra','India'),
(18,'USNYC','New York','New York','USA'),
(19,'CADIS','Vancouver','Vancouver','Canada'),
(20,'MXVER','Veracruz','Veracruz','Mexico');

-- SHIPS
INSERT INTO ships VALUES
(1,9812345,'Maersk Horizon',8000,1),
(2,9787654,'MSC Aurora',9500,2),
(3,9723456,'CMA Polaris',7000,3),
(4,9712340,'Hapag Titan',6500,4),
(5,9704321,'Evergreen Star',9000,5),
(6,9698760,'ONE Voyager',8500,6),
(7,9680011,'Yang Ming Voyager',6200,7),
(8,9670022,'ZIM Adventurer',4800,8),
(9,9660033,'HMM Galaxy',11000,9),
(10,9650044,'COSCO Fortune',10000,10),
(11,9640055,'KLine Spirit',4000,11),
(12,9630066,'NYK Explorer',4200,12),
(13,9620077,'Wan Hai Trader',3500,13),
(14,9610088,'PIL Mariner',3000,14),
(15,9600099,'Maersk Origin',7800,15),
(16,9590100,'MSC Meridian',8100,16),
(17,9580111,'CMA Northern',7200,17),
(18,9570122,'Hapag Voyager',6400,18),
(19,9560133,'Evergreen Beacon',9200,19),
(20,9550144,'Harbor Classic',2500,20);

-- VOYAGES (after ports + ships)
INSERT INTO voyages VALUES
(1,1,'MH20251101','2025-11-01','2025-11-20',4,3),
(2,2,'MA20251020','2025-10-20','2025-11-15',4,1),
(3,3,'CP20251105','2025-11-05','2025-11-25',3,5),
(4,4,'HL20251110','2025-11-10','2025-11-30',5,1),
(5,5,'EG20251102','2025-11-02','2025-11-22',6,3),
(6,6,'ONE20251025','2025-10-25','2025-11-12',6,5),
(7,7,'YM20251028','2025-10-28','2025-11-18',4,2),
(8,8,'ZIM20251107','2025-11-07','2025-11-27',3,6),
(9,9,'HMM20251111','2025-11-11','2025-11-29',5,3),
(10,10,'COS20251115','2025-11-15','2025-12-05',3,4),
(11,11,'KLINE20251103','2025-11-03','2025-11-23',4,11),
(12,12,'NYK20251106','2025-11-06','2025-11-26',6,10),
(13,13,'WAN20251030','2025-10-30','2025-11-19',6,3),
(14,14,'PIL20251108','2025-11-08','2025-11-28',3,15),
(15,15,'M2EU20251109','2025-11-09','2025-11-29',4,14),
(16,16,'M2CU20251022','2025-10-22','2025-11-12',3,1),
(17,17,'C2DU20251112','2025-11-12','2025-11-30',5,2),
(18,18,'H2CU20251113','2025-11-13','2025-12-03',4,9),
(19,19,'E2LU20251018','2025-10-18','2025-11-07',6,3),
(20,20,'HB20251114','2025-11-14','2025-12-04',3,5);

-- CONTAINERS
INSERT INTO containers VALUES
(1,'MSKU1234567','40HC','at_port'),
(2,'TGBU7654321','20GP','in_transit'),
(3,'CMAU1112223','40GP','delivered'),
(4,'YMLU0001234','40HC','at_warehouse'),
(5,'HLCU9998887','20GP','available'),
(6,'ZIMU1110001','40GP','at_port'),
(7,'HMMU2220002','20GP','in_transit'),
(8,'COSCU3330003','40HC','delivered'),
(9,'NYKU4440004','20GP','available'),
(10,'KLIN5550005','40GP','at_port'),
(11,'WNHU6660006','20GP','in_transit'),
(12,'PILU7770007','40HC','delivered'),
(13,'M2EU8880008','40GP','at_warehouse'),
(14,'MSCU9990009','20GP','available'),
(15,'CMDU0001110','40HC','at_port'),
(16,'YMLU0002111','20GP','in_transit'),
(17,'CCLU0003112','40GP','delivered'),
(18,'HBRC0004113','40HC','available'),
(19,'OOLU0005114','20GP','at_port'),
(20,'ONYU0006115','40GP','in_transit');

-- BOOKINGS
INSERT INTO bookings VALUES
(1,'BK-20251101-001',1,1,4,3,'2025-10-25','confirmed'),
(2,'BK-20251102-002',2,2,3,1,'2025-10-28','confirmed'),
(3,'BK-20251030-003',3,3,4,1,'2025-10-10','shipped'),
(4,'BK-20251105-004',4,4,4,5,'2025-10-30','booked'),
(5,'BK-20251107-005',5,5,6,3,'2025-11-01','confirmed'),
(6,'BK-20251108-006',6,6,6,5,'2025-11-02','confirmed'),
(7,'BK-20251109-007',7,7,3,6,'2025-11-03','booked'),
(8,'BK-20251110-008',8,8,1,5,'2025-11-04','shipped'),
(9,'BK-20251111-009',9,9,2,4,'2025-11-05','confirmed'),
(10,'BK-20251112-010',10,10,5,3,'2025-11-06','confirmed'),
(11,'BK-20251113-011',11,11,6,10,'2025-11-07','booked'),
(12,'BK-20251114-012',12,12,6,1,'2025-11-08','confirmed'),
(13,'BK-20251115-013',13,13,3,6,'2025-11-09','confirmed'),
(14,'BK-20251116-014',14,14,4,15,'2025-11-10','booked'),
(15,'BK-20251117-015',15,15,4,14,'2025-11-11','confirmed'),
(16,'BK-20251118-016',16,16,3,1,'2025-11-12','confirmed'),
(17,'BK-20251119-017',17,17,5,2,'2025-11-13','booked'),
(18,'BK-20251120-018',18,18,4,9,'2025-11-14','confirmed'),
(19,'BK-20251121-019',19,19,6,3,'2025-11-15','confirmed'),
(20,'BK-20251122-020',20,20,3,5,'2025-11-16','booked');

-- BOOKING CONTAINERS
INSERT INTO booking_containers VALUES
(1,1,1,'Mobile Phones',12000),
(2,2,2,'Furniture Parts',5000),
(3,3,3,'Home Appliances',10000),
(4,4,4,'Accessories',8000),
(5,5,5,'Frozen Fish',6000),
(6,6,6,'Textiles',7000),
(7,7,7,'Auto Parts',9000),
(8,8,8,'Household Items',4000),
(9,9,9,'Electronics',11000),
(10,10,10,'Pharma',2000),
(11,11,11,'Chemicals',5000),
(12,12,12,'Agriculture Goods',8000),
(13,13,13,'Toys',3000),
(14,14,14,'Footwear',4500),
(15,15,15,'Mobile Phones',10000),
(16,16,16,'Paper Goods',2500),
(17,17,17,'Machinery',15000),
(18,18,18,'Seeds',3500),
(19,19,19,'Beverages',6000),
(20,20,20,'Cosmetics',2200);

-- SHIPMENTS
INSERT INTO shipments VALUES
(1,'SHP-20251101-01',1,'2025-10-27','2025-11-22','in_transit'),
(2,'SHP-20251102-02',2,'2025-10-30','2025-11-15','delivered'),
(3,'SHP-20251030-03',3,'2025-10-12','2025-10-28','delivered'),
(4,'SHP-20251105-04',4,'2025-11-01','2025-11-25','in_transit'),
(5,'SHP-20251107-05',5,'2025-11-02','2025-11-24','in_transit'),
(6,'SHP-20251108-06',6,'2025-11-03','2025-11-20','in_transit'),
(7,'SHP-20251109-07',7,'2025-11-04','2025-11-21','booked'),
(8,'SHP-20251110-08',8,'2025-11-05','2025-11-23','in_transit'),
(9,'SHP-20251111-09',9,'2025-11-06','2025-11-26','in_transit'),
(10,'SHP-20251112-10',10,'2025-11-07','2025-11-27','booked'),
(11,'SHP-20251113-11',11,'2025-11-08','2025-11-28','in_transit'),
(12,'SHP-20251114-12',12,'2025-11-09','2025-11-29','in_transit'),
(13,'SHP-20251115-13',13,'2025-11-10','2025-11-30','in_transit'),
(14,'SHP-20251116-14',14,'2025-11-11','2025-12-01','in_transit'),
(15,'SHP-20251117-15',15,'2025-11-12','2025-12-02','in_transit'),
(16,'SHP-20251118-16',16,'2025-11-13','2025-12-03','in_transit'),
(17,'SHP-20251119-17',17,'2025-11-14','2025-12-04','in_transit'),
(18,'SHP-20251120-18',18,'2025-11-15','2025-12-05','in_transit'),
(19,'SHP-20251121-19',19,'2025-11-16','2025-12-06','in_transit'),
(20,'SHP-20251122-20',20,'2025-11-17','2025-12-07','in_transit');

-- INVOICES
INSERT INTO invoices VALUES
(1,1,45000.00,'USD','2025-11-05','unpaid'),
(2,2,22000.00,'EUR','2025-11-03','paid'),
(3,3,15000.00,'USD','2025-10-30','paid'),
(4,4,30000.00,'USD','2025-11-06','unpaid'),
(5,5,18000.00,'USD','2025-11-07','unpaid'),
(6,6,12000.00,'USD','2025-11-08','paid'),
(7,7,25000.00,'EUR','2025-11-09','unpaid'),
(8,8,9000.00,'USD','2025-11-10','paid'),
(9,9,6000.00,'USD','2025-11-11','paid'),
(10,10,20000.00,'EUR','2025-11-12','unpaid'),
(11,11,14000.00,'USD','2025-11-13','paid'),
(12,12,17500.00,'USD','2025-11-14','unpaid'),
(13,13,8000.00,'USD','2025-11-15','paid'),
(14,14,22000.00,'EUR','2025-11-16','unpaid'),
(15,15,16000.00,'USD','2025-11-17','paid'),
(16,16,13000.00,'USD','2025-11-18','unpaid'),
(17,17,27000.00,'EUR','2025-11-19','paid'),
(18,18,11000.00,'USD','2025-11-20','unpaid'),
(19,19,9000.00,'USD','2025-11-21','paid'),
(20,20,21000.00,'USD','2025-11-22','unpaid');

-- TRACKING EVENTS
INSERT INTO tracking_events VALUES
(1,1,'2025-10-27 06:30','Mumbai Terminal 2','Gate In','Arrived at terminal'),
(2,1,'2025-11-01 16:00','Shanghai - Berth 4','Loaded','Loaded on vessel Maersk Horizon'),
(3,2,'2025-10-29 09:00','Rotterdam - Yard 3','Gate Out','Departed for hinterland truck'),
(4,3,'2025-10-25 18:00','Los Angeles - Warehouse','Customs Clearance','Cleared by customs'),
(5,4,'2025-11-02 08:00','Mumbai Warehouse','Received','Received at warehouse'),
(6,5,'2025-11-03 10:30','Kolkata Port','Loaded','Loaded onto feeder'),
(7,6,'2025-11-04 14:20','Singapore Terminal','Gate In','Arrived at Singapore'),
(8,7,'2025-11-05 09:10','Dubai Port','Loaded','Loaded for Europe route'),
(9,8,'2025-11-06 11:25','Rotterdam Yard','Gate In','Arrived at yard'),
(10,9,'2025-11-07 07:45','Los Angeles Pier','Loaded','Loaded onto vessel'),
(11,10,'2025-11-08 12:00','Busan Terminal','Gate In','Arrived at Busan'),
(12,11,'2025-11-09 15:30','Genoa Port','Customs Clearance','Cleared by customs'),
(13,12,'2025-11-10 17:00','Alexandria','Gate Out','Departed on truck'),
(14,13,'2025-11-11 08:40','Mundra','Received','Received at ICD'),
(15,14,'2025-11-12 19:20','New York Terminal','Gate In','Arrived at NY'),
(16,15,'2025-11-13 06:10','Shanghai - Berth 2','Loaded','Loaded on feeder'),
(17,16,'2025-11-14 09:00','Rotterdam - Berth 5','Loaded','Loaded for transshipment'),
(18,17,'2025-11-15 13:45','Los Angeles - Yard','Gate Out','Left for final mile'),
(19,18,'2025-11-16 10:05','Vancouver','Customs Clearance','Cleared'),
(20,19,'2025-11-17 16:30','Veracruz','Received','Received at port');