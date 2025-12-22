# Vehicle Rental System - Database Design & SQL Queries

## Overview & Objectives

This project focuses on designing and implementing a simple Vehicle Rental System database using SQL. The primary objective of this project is to demonstrate how multiple database tables are connected through Primary Keys and Foreign Keys to maintain data integrity and represent real-world relationships.The project clearly explains ERD relationships such as One-to-One (1:1), One-to-Many (1:N), and Many-to-One (M:1) using practical examples from a vehicle rental scenario.

#### 🌐 [ERD Diagram Link](https://drawsql.app/teams/hydra-15/diagrams/vehicles-rental)

## Database Design & Business Logic

### Tables

- **Users**: Stores information about system users, including Admins and Customers. Each user has a unique email and basic contact details.
- **Vehicles**: Stores information about vehicles, such as registration number, vehicle type (car, bike, truck), and current availability status.
- **Bookings**: Records rental details, linking users with the vehicles they rent, including rental start and end dates, booking status, and total rental cost.

### Table Relationships

- **User to Bookings (One-to-Many)**: One user can make many bookings.
- **Vehicle to Bookings (One-to-Many)**: One vehicle can be booked many times.
- **Booking to User and Vehicle (Many-to-One)**: Each booking belongs to one user and one vehicle.

## SQL Queries Documentation

The following queries are implemented in `queries.sql`:

1.  **JOIN**: Retrieves booking details combined with customer and vehicle names.
2.  **EXISTS**: Identifies vehicles that have never been booked.
3.  **WHERE**: Filters available vehicles of a specific type (e.g., 'car').
4.  **GROUP BY & HAVING**: Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.
