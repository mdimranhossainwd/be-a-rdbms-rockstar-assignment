# Vehicle Rental System - Database Design & SQL Queries

## Overview & Objectives

This project is about creating a simple Vehicle Rental System database using SQL.
The main purpose is to show how tables are connected using primary keys, foreign keys, and how real-life problems are solved using SQL queries. The goal is to demonstrate a clear understanding of ERD relationships (1:1, 1:N, M:1) and complex SQL queries using JOINs, EXISTS, and data aggregation.

##### 🌐 [ERD Diagram Link](https://drawsql.app/teams/hydra-15/diagrams/vehicles-rental)

## Database Design & Business Logic

- **Users**: Stores information about system users such as Admins and Customers.Each user has a unique email and basic contact details.
- **Vehicles**: Stores vehicle information including registration number, vehicle type (car, bike, truck), and availability status.
- **Bookings**: Tracks rental transactions, linking users to specific vehicles with dates and total costs.

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
