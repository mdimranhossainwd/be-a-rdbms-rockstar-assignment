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