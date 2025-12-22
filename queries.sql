-- create database
CREATE DATABASE vehicles_system

-- users table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE CHECK (email = LOWER(email)),
    phone_number VARCHAR(50),
    password VARCHAR(25) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('Admin', 'Customer'))
);

-- Insert Users 
INSERT INTO users (name, email, phone_number, role, password) 
VALUES 
    ('Alice', 'alice@example.com', '1234567890', 'Customer', '12345678'),
    ('Bob', 'bob@example.com', '0987654321', 'Admin', '12345678'),
    ('Charlie', 'charlie@example.com', '1122334455', 'Customer', '12345678');

-- Retrive Users Data
SELECT user_id, name, email, phone_number as phone, role FROM users


-- Vehicles Table
CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('car', 'bike', 'truck')),
    model VARCHAR(100) NOT NULL,
    registration_number VARCHAR(100) NOT NULL UNIQUE,
    rental_price_per_day DECIMAL(10, 2) NOT NULL CHECK (rental_price_per_day > 0),
    availability_status VARCHAR(50) NOT NULL DEFAULT 'available'
        CHECK (availability_status IN ('available', 'rented', 'maintenance'))
);


-- Insert vehicles
INSERT INTO vehicles (name, type, model, registration_number, rental_price_per_day, availability_status)
VALUES
    ('Toyota Corolla', 'car', '2022', 'ABC-123', 50.00, 'available'),
    ('Honda Civic', 'car', '2021', 'DEF-456', 60.00, 'rented'),
    ('Yamaha R15', 'bike', '2023', 'GHI-789', 30.00, 'available'),
    ('Ford F-150', 'truck', '2020', 'JKL-012', 100.00, 'maintenance')

-- Retrive vehicles Data
SELECT * FROM vehicles


-- Bookings Table
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    vehicle_id INT NOT NULL REFERENCES vehicles(vehicle_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    booking_status VARCHAR(50) NOT NULL DEFAULT 'pending'
        CHECK (booking_status IN ('pending', 'confirmed', 'completed', 'cancelled')),
    total_cost DECIMAL(10, 2) NOT NULL,
    CONSTRAINT valid_date_range CHECK (start_date <= end_date)
);

-- Total cost calculate function
CREATE OR REPLACE FUNCTION calculate_total_cost()
RETURNS TRIGGER AS $$
DECLARE
    price_per_day DECIMAL(10,2);
    rental_days INT;
BEGIN
    SELECT rental_price_per_day
    INTO price_per_day
    FROM vehicles
    WHERE vehicle_id = NEW.vehicle_id;

    IF price_per_day IS NULL THEN
        RAISE EXCEPTION 'Vehicle not found';
    END IF;
    rental_days := (NEW.end_date - NEW.start_date) + 1;

    IF rental_days <= 0 THEN
        RAISE EXCEPTION 'Invalid rental period';
    END IF;

    NEW.total_cost := price_per_day * rental_days;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger functions before insert booking
CREATE TRIGGER trg_calculate_total_cost
BEFORE INSERT ON bookings
FOR EACH ROW
EXECUTE FUNCTION calculate_total_cost();

-- Insert bookings
INSERT INTO bookings (user_id, vehicle_id, start_date, end_date, booking_status)
VALUES
   (1, 1, '2025-12-21', '2025-12-22', 'confirmed'),   
    (1, 1, '2025-12-21', '2025-12-23', 'completed'),   
    (2, 1, '2025-12-21', '2025-12-25', 'confirmed'),  
    (1, 2, '2025-12-21', '2025-12-22', 'pending');

-- Retrive bookings Data
SELECT * FROM bookings

-- Query No-1
SELECT 
    b.booking_id,
    u.name AS customer_name,
    v.name AS vehicle_name,
    b.start_date,
    b.end_date,
    b.booking_status
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
);

-- Query No-3
SELECT 
    *
FROM vehicles v
WHERE v.type = 'car'
  AND availability_status = 'available';

-- Query No-4 
SELECT 
    v.name AS vehicle_name,
    COUNT(b.booking_id) AS total_bookings
FROM vehicles v
LEFT JOIN bookings b ON v.vehicle_id = b.vehicle_id
GROUP BY v.vehicle_id, v.name
HAVING COUNT(b.booking_id) > 2;
	