-- =====================================================
-- Task 1: Practice Subqueries
-- File: subqueries.sql
-- Description: Master correlated and non-correlated subqueries
-- =====================================================

-- =====================================================
-- Query 1: NON-CORRELATED SUBQUERY
-- Find all properties where the average rating is greater than 4.0
-- =====================================================

-- Method 1: Using subquery in WHERE clause
SELECT 
    p.property_id,
    p.name AS property_name,
    p.description,
    p.city,
    p.state,
    p.country,
    p.pricepernight,
    (SELECT AVG(r.rating) 
     FROM Review r 
     WHERE r.property_id = p.property_id) AS average_rating
FROM 
    Property p
WHERE 
    p.property_id IN (
        SELECT r.property_id
        FROM Review r
        GROUP BY r.property_id
        HAVING AVG(r.rating) > 4.0
    )
ORDER BY 
    average_rating DESC;

-- Method 2: Using subquery in FROM clause (Derived Table)
SELECT 
    p.property_id,
    p.name AS property_name,
    p.city,
    p.country,
    p.pricepernight,
    avg_ratings.average_rating
FROM 
    Property p
INNER JOIN (
    SELECT 
        property_id,
        AVG(rating) AS average_rating
    FROM 
        Review
    GROUP BY 
        property_id
    HAVING 
        AVG(rating) > 4.0
) AS avg_ratings ON p.property_id = avg_ratings.property_id
ORDER BY 
    avg_ratings.average_rating DESC;

-- Method 3: Using subquery with EXISTS
SELECT 
    p.property_id,
    p.name AS property_name,
    p.city,
    p.country,
    p.pricepernight
FROM 
    Property p
WHERE EXISTS (
    SELECT 1
    FROM Review r
    WHERE r.property_id = p.property_id
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
);

-- =====================================================
-- Query 2: CORRELATED SUBQUERY
-- Find users who have made more than 3 bookings
-- =====================================================

-- Method 1: Using correlated subquery in WHERE clause
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    (SELECT COUNT(*) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) AS total_bookings
FROM 
    User u
WHERE 
    (SELECT COUNT(*) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) > 3
ORDER BY 
    total_bookings DESC;

-- Method 2: Using correlated subquery with EXISTS
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    (SELECT COUNT(*) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) AS total_bookings
FROM 
    User u
WHERE EXISTS (
    SELECT 1
    FROM Booking b
    WHERE b.user_id = u.user_id
    GROUP BY b.user_id
    HAVING COUNT(*) > 3
);

-- Method 3: Correlated subquery showing booking details
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    (SELECT COUNT(*) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) AS total_bookings,
    (SELECT SUM(b.total_price) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) AS total_spent,
    (SELECT AVG(b.total_price) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) AS average_booking_price
FROM 
    User u
WHERE 
    (SELECT COUNT(*) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) > 3
ORDER BY 
    total_bookings DESC, total_spent DESC;

-- =====================================================
-- BONUS QUERIES: Additional Subquery Examples
-- =====================================================

-- Bonus 1: Find properties with ratings above the overall average
SELECT 
    p.property_id,
    p.name AS property_name,
    p.city,
    AVG(r.rating) AS property_avg_rating,
    (SELECT AVG(rating) FROM Review) AS overall_avg_rating
FROM 
    Property p
INNER JOIN 
    Review r ON p.property_id = r.property_id
GROUP BY 
    p.property_id, p.name, p.city
HAVING 
    AVG(r.rating) > (SELECT AVG(rating) FROM Review);

-- Bonus 2: Find users who have never made a booking (NOT EXISTS)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    u.created_at
FROM 
    User u
WHERE NOT EXISTS (
    SELECT 1 
    FROM Booking b 
    WHERE b.user_id = u.user_id
)
ORDER BY 
    u.created_at DESC;

-- Bonus 3: Find properties that have never been booked
SELECT 
    p.property_id,
    p.name AS property_name,
    p.city,
    p.country,
    p.pricepernight,
    p.created_at
FROM 
    Property p
WHERE NOT EXISTS (
    SELECT 1 
    FROM Booking b 
    WHERE b.property_id = p.property_id
)
ORDER BY 
    p.created_at DESC;

-- Bonus 4: Find the most expensive booking for each user (correlated)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    (SELECT MAX(b.total_price) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) AS highest_booking_amount,
    (SELECT MIN(b.total_price) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) AS lowest_booking_amount
FROM 
    User u
WHERE EXISTS (
    SELECT 1 
    FROM Booking b 
    WHERE b.user_id = u.user_id
)
ORDER BY 
    highest_booking_amount DESC;

-- Bonus 5: Find properties in cities with more than 2 properties
SELECT 
    p.property_id,
    p.name AS property_name,
    p.city,
    p.country,
    p.pricepernight
FROM 
    Property p
WHERE 
    p.city IN (
        SELECT city
        FROM Property
        GROUP BY city
        HAVING COUNT(*) > 2
    )
ORDER BY 
    p.city, p.name;

-- Bonus 6: Find users who have spent more than the average user (nested subquery)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    (SELECT SUM(b.total_price) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) AS total_spent
FROM 
    User u
WHERE 
    (SELECT SUM(b.total_price) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) > (
        SELECT AVG(user_total)
        FROM (
            SELECT SUM(total_price) AS user_total
            FROM Booking
            GROUP BY user_id
        ) AS user_spending
    )
ORDER BY 
    total_spent DESC;

-- Bonus 7: Find properties with the highest rated review in their city
SELECT 
    p.property_id,
    p.name AS property_name,
    p.city,
    (SELECT MAX(r.rating) 
     FROM Review r 
     WHERE r.property_id = p.property_id) AS highest_rating
FROM 
    Property p
WHERE 
    (SELECT MAX(r.rating) 
     FROM Review r 
     WHERE r.property_id = p.property_id) = (
        SELECT MAX(r2.rating)
        FROM Review r2
        INNER JOIN Property p2 ON r2.property_id = p2.property_id
        WHERE p2.city = p.city
    )
ORDER BY 
    p.city, highest_rating DESC;

-- Bonus 8: Find bookings with prices above property average
SELECT 
    b.booking_id,
    p.name AS property_name,
    b.total_price,
    (SELECT AVG(b2.total_price) 
     FROM Booking b2 
     WHERE b2.property_id = b.property_id) AS property_avg_price
FROM 
    Booking b
INNER JOIN 
    Property p ON b.property_id = p.property_id
WHERE 
    b.total_price > (
        SELECT AVG(b2.total_price) 
        FROM Booking b2 
        WHERE b2.property_id = b.property_id
    )
ORDER BY 
    b.total_price DESC;

-- =====================================================
-- PERFORMANCE COMPARISON QUERIES
-- Compare subquery vs JOIN performance
-- =====================================================

-- Using EXPLAIN to analyze query performance
EXPLAIN SELECT 
    p.property_id,
    p.name AS property_name,
    (SELECT AVG(r.rating) 
     FROM Review r 
     WHERE r.property_id = p.property_id) AS average_rating
FROM 
    Property p
WHERE 
    p.property_id IN (
        SELECT r.property_id
        FROM Review r
        GROUP BY r.property_id
        HAVING AVG(r.rating) > 4.0
    );

-- =====================================================
-- SUBQUERY TYPES DEMONSTRATION
-- =====================================================

-- 1. Scalar Subquery (returns single value)
SELECT 
    p.property_id,
    p.name,
    p.pricepernight,
    (SELECT AVG(pricepernight) FROM Property) AS market_average,
    p.pricepernight - (SELECT AVG(pricepernight) FROM Property) AS price_difference
FROM 
    Property p
ORDER BY 
    price_difference DESC;

-- 2. Row Subquery (returns single row with multiple columns)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name
FROM 
    User u
WHERE 
    (u.first_name, u.last_name) IN (
        SELECT first_name, last_name
        FROM User
        WHERE role = 'host'
    );

-- 3. Table Subquery (returns multiple rows and columns)
SELECT *
FROM (
    SELECT 
        p.property_id,
        p.name,
        p.city,
        AVG(r.rating) AS avg_rating,
        COUNT(r.review_id) AS review_count
    FROM 
        Property p
    LEFT JOIN 
        Review r ON p.property_id = r.property_id
    GROUP BY 
        p.property_id, p.name, p.city
) AS property_stats
WHERE 
    review_count > 0
ORDER BY 
    avg_rating DESC;

-- =====================================================
-- END OF SUBQUERIES
-- =====================================================