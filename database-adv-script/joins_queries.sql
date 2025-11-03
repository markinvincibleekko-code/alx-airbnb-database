-- =====================================================
-- Task 0: Complex Queries with Joins
-- File: joins_queries.sql
-- Description: Master SQL joins by writing complex queries
-- =====================================================

-- =====================================================
-- Query 1: INNER JOIN
-- Retrieve all bookings and the respective users who made those bookings
-- =====================================================

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
ORDER BY 
    b.created_at DESC;

-- =====================================================
-- Query 2: LEFT JOIN
-- Retrieve all properties and their reviews, including properties that have no reviews
-- =====================================================

SELECT 
    p.property_id,
    p.name AS property_name,
    p.city,
    p.country,
    p.pricepernight,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_date,
    u.first_name AS reviewer_first_name,
    u.last_name AS reviewer_last_name
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id
LEFT JOIN 
    User u ON r.user_id = u.user_id
ORDER BY 
    p.property_id, r.created_at DESC;

-- =====================================================
-- Query 3: FULL OUTER JOIN
-- Retrieve all users and all bookings, even if the user has no booking 
-- or a booking is not linked to a user
-- =====================================================

-- Note: MySQL does not support FULL OUTER JOIN directly.
-- We simulate it using UNION of LEFT JOIN and RIGHT JOIN

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    p.name AS property_name
FROM 
    User u
LEFT JOIN 
    Booking b ON u.user_id = b.user_id
LEFT JOIN 
    Property p ON b.property_id = p.property_id

UNION

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    p.name AS property_name
FROM 
    Booking b
RIGHT JOIN 
    User u ON b.user_id = u.user_id
LEFT JOIN 
    Property p ON b.property_id = p.property_id
ORDER BY 
    user_id, booking_id;

-- =====================================================
-- Alternative FULL OUTER JOIN for PostgreSQL
-- (Uncomment if using PostgreSQL instead of MySQL)
-- =====================================================

/*
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    p.name AS property_name
FROM 
    User u
FULL OUTER JOIN 
    Booking b ON u.user_id = b.user_id
LEFT JOIN 
    Property p ON b.property_id = p.property_id
ORDER BY 
    u.user_id, b.booking_id;
*/

-- =====================================================
-- BONUS: Additional Complex Join Queries
-- =====================================================

-- Bonus Query 1: Get all bookings with user, property, and payment information
SELECT 
    b.booking_id,
    u.first_name || ' ' || u.last_name AS guest_name,
    u.email AS guest_email,
    p.name AS property_name,
    p.city AS property_city,
    h.first_name || ' ' || h.last_name AS host_name,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    pay.payment_method,
    pay.payment_date,
    pay.amount AS payment_amount
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
INNER JOIN 
    User h ON p.host_id = h.user_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id
ORDER BY 
    b.created_at DESC;

-- Bonus Query 2: Properties with average rating and total reviews
SELECT 
    p.property_id,
    p.name AS property_name,
    p.city,
    p.country,
    p.pricepernight,
    COUNT(r.review_id) AS total_reviews,
    ROUND(AVG(r.rating), 2) AS average_rating,
    u.first_name || ' ' || u.last_name AS host_name
FROM 
    Property p
INNER JOIN 
    User u ON p.host_id = u.user_id
LEFT JOIN 
    Review r ON p.property_id = r.property_id
GROUP BY 
    p.property_id, p.name, p.city, p.country, p.pricepernight, u.first_name, u.last_name
ORDER BY 
    average_rating DESC, total_reviews DESC;

-- =====================================================
-- END OF JOINS QUERIES
-- =====================================================