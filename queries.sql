-- create database
CREATE DATABASE vehicles_system;

-- create ENUM types
CREATE TYPE user_role AS ENUM ('Admin', 'Customer');
CREATE TYPE vehicle_type AS ENUM ('car', 'bike', 'truck');
CREATE TYPE vehicle_status AS ENUM ('available', 'rented', 'maintenance');
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'completed', 'cancelled');

-- users table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE CHECK (email = LOWER(email)),
    phone VARCHAR(50),
    password VARCHAR(255) NOT NULL,
    role user_role VARCHAR(20) NOT NULL DEFAULT 'Customer'
);

-- Insert Users 
INSERT INTO users (name, email, phone, role, password) 
VALUES 
    ('Alice', 'alice@example.com', '1234567890', 'Customer', '12345678');


-- Vehicles Table
CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type vehicle_type VARCHAR(50) NOT NULL ,
    model VARCHAR(100) NOT NULL,
    registration_number VARCHAR(100) NOT NULL UNIQUE,
    rental_price DECIMAL(10) NOT NULL CHECK (rental_price > 0),
    availability_status vehicle_status VARCHAR(50) NOT NULL DEFAULT 'available'
);

-- Insert vehicles
INSERT INTO vehicles (name, type, model, registration_number, rental_price, availability_status)
VALUES
    ('Toyota Corolla', 'car', '2022', 'ABC-123', 50, 'available');

    -- Bookings Table
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    vehicle_id INT NOT NULL REFERENCES vehicles(vehicle_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status booking_status VARCHAR(50) NOT NULL DEFAULT 'pending',
    total_cost DECIMAL(10) NOT NULL,
    CONSTRAINT valid_date_range CHECK (start_date <= end_date)
);

-- Insert Booking
INSERT INTO bookings (user_id, vehicle_id, start_date, end_date, status, total_cost)
VALUES
   (1, 1, '2025-12-21', '2025-12-22', 'confirmed', 240),   
    (1, 1, '2025-12-21', '2025-12-23', 'completed', 120),   
    (2, 1, '2025-12-21', '2025-12-25', 'confirmed', 60),  
    (1, 2, '2025-12-21', '2025-12-22', 'pending', 100);



-- Query No-1
SELECT 
    b.booking_id,
    u.name AS customer_name,
    v.name AS vehicle_name,
    b.start_date,
    b.end_date,
    b.status
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN vehicles v ON b.vehicle_id = v.vehicle_id;

-- Query No-2
SELECT 
    *
FROM vehicles v
WHERE NOT EXISTS (
    SELECT 1 
    FROM bookings b 
    WHERE b.vehicle_id = v.vehicle_id
) ORDER BY v.vehicle_id;

-- Query No-3
SELECT 
    *
FROM vehicles v
WHERE v.type = 'car'
  AND status = 'available';

-- Query No-4 
SELECT 
    v.name AS vehicle_name,
    COUNT(b.booking_id) AS total_bookings
FROM vehicles v
LEFT JOIN bookings b ON v.vehicle_id = b.vehicle_id
GROUP BY v.vehicle_id, v.name
HAVING COUNT(b.booking_id) > 2;