# Vehicle Rental System - Database Design & SQL Queries

## Overview & Objectives

This project focuses on designing and implementing a simple Vehicle Rental System database using SQL. The primary objective of this project is to demonstrate how multiple database tables are connected through Primary Keys and Foreign Keys to maintain data integrity and represent real-world relationships.The project clearly explains ERD relationships such as One-to-One (1:1), One-to-Many (1:N), and Many-to-One (M:1) using practical examples from a vehicle rental scenario.

#### 🌐 [ERD Design Link](https://drawsql.app/teams/hydra-15/diagrams/vehicles-rental)

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

## Database Schema Design Table

### ENUM Types

```sql
CREATE TYPE user_role AS ENUM ('Admin', 'Customer');
CREATE TYPE vehicle_type AS ENUM ('car', 'bike', 'truck');
CREATE TYPE vehicle_status AS ENUM ('available', 'rented', 'maintenance');
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'completed','cancelled');
```

### Users Tables

```sql
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE CHECK (email = LOWER(email)),
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role user_role NOT NULL DEFAULT 'Customer'
);

<!-- Insert User Tables Data -->
INSERT INTO users (name, email, phone_number, role, password)
VALUES
  ('Alice', 'alice@example.com', '1234567890', 'Customer', '12345678');


```

### Vehicles Tables

```sql
CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type vehicle_type NOT NULL,
    model VARCHAR(100) NOT NULL,
    registration_number VARCHAR(100) NOT NULL UNIQUE,
    rental_price DECIMAL(10) NOT NULL CHECK (rental_price > 0),
    status vehicle_status NOT NULL DEFAULT 'available'
);

<!-- Insert Vehicles Tables Data -->
INSERT INTO vehicles (
  name,
  type,
  model,
  registration_number,
  rental_price,
  status
)
VALUES
  ('Toyota Corolla', 'car', '2022', 'ABC-123', 50.00, 'available');

```

### Bookings Tables

```sql
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL
      REFERENCES users(user_id) ON DELETE CASCADE,
    vehicle_id INT NOT NULL
      REFERENCES vehicles(vehicle_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL CHECK (start_date <= end_date),
    status booking_status NOT NULL DEFAULT 'pending',
    total_cost DECIMAL(10) NOT NULL
);

<!-- Insert Vehicles Tables Data -->
INSERT INTO bookings (
  user_id,
  vehicle_id,
  start_date,
  end_date,
  status,
  total_cost
)
VALUES
  (1, 1, '2025-12-21', '2025-12-22', 'confirmed', 100);
```
