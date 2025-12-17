# ETB

<div style="text-align: center;">
  <h3></h3>
  <p><strong>Database Management Systems (DBMS) Project</strong></p>
  <p><strong>End-Term Submission</strong></p>

  <p><strong>Submitted to:</strong> Prof. Ashok Harnal</p>

  <p><strong>Submitted By: Group 08</strong></p>
  <ul>
    <li>Abhinav Bhatnagar 341156</li>
    <li>Ritika Gupta 341165</li>
    <li>Kavya Nair 341147</li>
  </ul>
</div>

---

# End-to-End Shipping & Logistics Management System  
## (Maersk-Inspired Global Supply Chain Database)

This project designs and implements a **relational database system inspired by A.P. Moller – Maersk**, a global leader in integrated container logistics.  
The system models **end-to-end maritime shipping operations**, covering customer bookings, vessel operations, port handling, container tracking, warehousing, invoicing, payments, insurance, and customs compliance.

The database reflects Maersk’s **integrated logistics model**, where ocean transport, inland logistics, and supply chain visibility are managed through a unified digital platform.

---

## 📊 EER Diagram

The **Enhanced Entity Relationship (EER) Diagram** represents the logical architecture of the Maersk-style logistics system, highlighting entities, attributes, constraints, and interdependencies.

<img width="1224" height="634" alt="image" src=https://github.com/DilipBaduwal/Udaan-B2B-Supply-Chain-Management/raw/main/image.png >

---

## 📌 Project Objectives

- Design a scalable database for **global container shipping operations**
- Model Maersk’s **end-to-end logistics workflow**
- Track shipments across vessels, ports, warehouses, and customers
- Manage financial processes including billing, payments, and insurance
- Ensure regulatory compliance via customs declarations
- Enable real-time visibility using container tracking events

---

## 🧱 Database Entities (17 Core Tables)

The system consists of **17 core entities**, each representing a critical component of Maersk’s logistics ecosystem:

1. **Customers** – Importers/exporters using Maersk logistics services  
2. **Shippers** – Logistics coordinators managing customer bookings  
3. **Carriers** – Shipping lines (Maersk and partner carriers)  
4. **Ports** – Global ports operated or serviced by Maersk  
5. **Warehouses** – Inland and port-adjacent storage facilities  
6. **Ships** – Container vessels operated by carriers  
7. **Routes** – Shipping lanes between international ports  
8. **Voyages** – Scheduled vessel journeys  
9. **Containers** – Standardized containers used in transport  
10. **Bookings** – Customer shipment reservations  
11. **Shipments** – Physical execution of cargo movement  
12. **Invoices** – Freight and logistics billing records  
13. **Payments** – Settlement of customer invoices  
14. **Insurances** – Cargo insurance coverage  
15. **Customs_Declarations** – Trade and regulatory documentation  
16. **Employees** – Operational staff at ports, ships, and warehouses  
17. **Tracking_Events** – Time-stamped container movement updates  

All entities are connected through **Primary Key–Foreign Key relationships**, ensuring data accuracy and traceability.

---

## 🔗 Key Relationships Overview

- Customers place **Bookings**, which generate **Shipments**
- Shipments are billed through **Invoices**, settled via **Payments**
- Containers are assigned to bookings and tracked using **Tracking_Events**
- Ships operate **Voyages** on predefined **Routes**
- Ports support voyages and connect to **Warehouses**
- **Employees** are assigned to ships or warehouses
- **Customs_Declarations** and **Insurances** ensure compliance and risk coverage

Many-to-many relationships (e.g., bookings and containers) are resolved using junction tables such as **booking_containers**.

---

## ⚙️ Engineering Approach

- **Forward Engineering** was used to convert the EER diagram into SQL tables  
- **Reverse Engineering** can recreate the EER diagram from the database  

---

## 🔒 Data Integrity & Reliability

- **Primary Keys** ensure unique identification of records  
- **Foreign Keys** maintain relational consistency  
- Domain constraints ensure valid and reliable data entry  

---

## 🛠️ Tools & Technologies

- **Database:** MySQL  
- **Design Tool:** MySQL Workbench  
- **Query Language:** SQL  

---

## 📈 Business Use-Cases (Maersk Context)

- End-to-end container shipment tracking  
- Multi-port and multi-vessel logistics coordination  
- Integrated billing and payment processing  
- Customs clearance and compliance monitoring  
- Performance analysis of routes, voyages, and delivery timelines  

---

## ✅ Conclusion

This project demonstrates a **Maersk-inspired integrated logistics database**, capable of supporting complex global shipping operations.  
The design emphasizes **scalability, traceability, regulatory compliance, and operational efficiency**, reflecting real-world maritime logistics systems used by industry leaders like Maersk.

---

## 🎤 Viva-Ready Summary

> “Our project models a Maersk-style end-to-end shipping and logistics system using 17 interconnected entities, enabling complete visibility from booking to delivery while ensuring financial and regulatory compliance.”
