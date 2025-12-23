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

 1. **JOIN**: Retrieves booking details combined with customer and vehicle names.

```sql
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
```

#### Explaination: This query shows all booking records from the bookings table.It joins the users table to get the customer’s name.It also joins the vehicles table to get the vehicle name.In short, it displays each booking along with who booked it and which vehicle was booked.




2.  **EXISTS**: Identifies vehicles that have never been booked.

```sql
SELECT 
    *
FROM vehicles v
WHERE NOT EXISTS (
    SELECT 1 
    FROM bookings b 
    WHERE b.vehicle_id = v.vehicle_id
) ORDER BY v.vehicle_id;

```

#### Explaination: It checks each vehicle in the vehicles table and looks into the bookings table to see if any booking exists for that vehicle.If no matching booking is found, NOT EXISTS returns true and the vehicle is shown.

3.  **WHERE**: Filters available vehicles of a specific type (e.g., 'car').

```sql
SELECT 
    *
FROM vehicles v
WHERE v.type = 'car'
  AND status = 'available';
```

#### Explaination: It only selects vehicles whose type is car and whose status is available. In simple words, it lists all cars that are currently available for booking.

4.  **GROUP BY & HAVING**: Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.

```sql
SELECT 
    v.name AS vehicle_name,
    COUNT(b.booking_id) AS total_bookings
FROM vehicles v
LEFT JOIN bookings b ON v.vehicle_id = b.vehicle_id
GROUP BY v.vehicle_id, v.name
HAVING COUNT(b.booking_id) > 2;
```

#### Explaination: This query shows each vehicle name along with how many times it has been booked.It uses a LEFT JOIN so all vehicles are considered, even if some have no bookings.The data is grouped by vehicle, and only vehicles with more than 2 bookings are shown.
