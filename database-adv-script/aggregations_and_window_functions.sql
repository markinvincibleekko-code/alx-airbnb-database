-- =====================================================
-- Task 2: Apply Aggregations and Window Functions
-- File: aggregations_and_window_functions.sql
-- Description: Master SQL aggregation and window functions for data analysis
-- =====================================================

-- =====================================================
-- PART 1: AGGREGATION FUNCTIONS
-- Query 1: Total number of bookings made by each user
-- =====================================================

-- Basic aggregation with COUNT and GROUP BY
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    COUNT(b.booking_id) AS total_bookings
FROM 
    User u
LEFT JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, 
    u.first_name, 
    u.last_name, 
    u.email, 
    u.role
ORDER BY 
    total_bookings DESC, 
    u.last_name ASC;

-- Enhanced version with additional aggregations
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    COUNT(b.booking_id) AS total_bookings,
    COUNT(CASE WHEN b.status = 'confirmed' THEN 1 END) AS confirmed_bookings,
    COUNT(CASE WHEN b.status = 'pending' THEN 1 END) AS pending_bookings,
    COUNT(CASE WHEN b.status = 'canceled' THEN 1 END) AS canceled_bookings,
    COALESCE(SUM(b.total_price), 0) AS total_amount_spent,
    COALESCE(AVG(b.total_price), 0) AS average_booking_amount,
    COALESCE(MIN(b.total_price), 0) AS min_booking_amount,
    COALESCE(MAX(b.total_price), 0) AS max_booking_amount
FROM 
    User u
LEFT JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, 
    u.first_name, 
    u.last_name, 
    u.email, 
    u.role
ORDER BY 
    total_bookings DESC;

-- Filter to show only users with bookings
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM 
    User u
INNER JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, 
    u.first_name, 
    u.last_name, 
    u.email
HAVING 
    COUNT(b.booking_id) > 0
ORDER BY 
    total_bookings DESC;

-- =====================================================
-- PART 2: WINDOW FUNCTIONS
-- Query 2: Rank properties based on total bookings
-- =====================================================

-- Using ROW_NUMBER() - Assigns unique sequential numbers
SELECT 
    p.property_id,
    p.name AS property_name,
    p.city,
    p.state,
    p.country,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_number_rank
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id,
    p.name,
    p.city,
    p.state,
    p.country,
    p.pricepernight
ORDER BY 
    row_number_rank;

-- Using RANK() - Assigns same rank to ties, skips next rank
SELECT 
    p.property_id,
    p.name AS property_name,
    p.city,
    p.country,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id,
    p.name,
    p.city,
    p.country,
    p.pricepernight
ORDER BY 
    booking_rank;

-- Using DENSE_RANK() - Assigns same rank to ties, no gaps in ranking
SELECT 
    p.property_id,
    p.name AS property_name,
    p.city,
    p.country,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS dense_rank
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id,
    p.name,
    p.city,
    p.country,
    p.pricepernight
ORDER BY 
    dense_rank;

-- Comparison of all three ranking functions
SELECT 
    p.property_id,
    p.name AS property_name,
    p.city,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_num,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS dense_rank
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id,
    p.name,
    p.city
ORDER BY 
    total_bookings DESC;

-- =====================================================
-- ADVANCED WINDOW FUNCTIONS
-- =====================================================

-- Partition ranking by city
SELECT 
    p.property_id,
    p.name AS property_name,
    p.city,
    p.country,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (PARTITION BY p.city ORDER BY COUNT(b.booking_id) DESC) AS city_rank,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS overall_rank
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id,
    p.name,
    p.city,
    p.country
ORDER BY 
    p.city, city_rank;

-- Running total of bookings over time
SELECT 
    b.booking_id,
    b.created_at,
    u.first_name || ' ' || u.last_name AS guest_name,
    p.name AS property_name,
    b.total_price,
    ROW_NUMBER() OVER (ORDER BY b.created_at) AS booking_sequence,
    SUM(b.total_price) OVER (ORDER BY b.created_at) AS running_total_revenue,
    AVG(b.total_price) OVER (ORDER BY b.created_at ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_avg_price
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
ORDER BY 
    b.created_at;

-- =====================================================
-- BONUS AGGREGATION QUERIES
-- =====================================================

-- Bonus 1: Property booking statistics by status
SELECT 
    p.property_id,
    p.name AS property_name,
    p.city,
    COUNT(CASE WHEN b.status = 'confirmed' THEN 1 END) AS confirmed_bookings,
    COUNT(CASE WHEN b.status = 'pending' THEN 1 END) AS pending_bookings,
    COUNT(CASE WHEN b.status = 'canceled' THEN 1 END) AS canceled_bookings,
    COUNT(b.booking_id) AS total_bookings,
    ROUND(COUNT(CASE WHEN b.status = 'confirmed' THEN 1 END) * 100.0 / 
          NULLIF(COUNT(b.booking_id), 0), 2) AS confirmation_rate
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id,
    p.name,
    p.city
ORDER BY 
    total_bookings DESC;

-- Bonus 2: Monthly booking trends
SELECT 
    DATE_FORMAT(b.created_at, '%Y-%m') AS booking_month,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_revenue,
    AVG(b.total_price) AS average_booking_value,
    COUNT(DISTINCT b.user_id) AS unique_customers,
    COUNT(DISTINCT b.property_id) AS unique_properties_booked
FROM 
    Booking b
GROUP BY 
    DATE_FORMAT(b.created_at, '%Y-%m')
ORDER BY 
    booking_month DESC;

-- Bonus 3: Host performance metrics
SELECT 
    u.user_id AS host_id,
    u.first_name || ' ' || u.last_name AS host_name,
    COUNT(DISTINCT p.property_id) AS total_properties,
    COUNT(b.booking_id) AS total_bookings,
    COALESCE(SUM(b.total_price), 0) AS total_earnings,
    COALESCE(AVG(b.total_price), 0) AS avg_booking_value,
    COUNT(DISTINCT b.user_id) AS unique_guests,
    COALESCE(AVG(r.rating), 0) AS average_rating,
    COUNT(r.review_id) AS total_reviews
FROM 
    User u
INNER JOIN 
    Property p ON u.user_id = p.host_id
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
LEFT JOIN 
    Review r ON p.property_id = r.property_id
WHERE 
    u.role = 'host'
GROUP BY 
    u.user_id,
    u.first_name,
    u.last_name
ORDER BY 
    total_earnings DESC;

-- Bonus 4: Property performance with window functions
SELECT 
    p.property_id,
    p.name AS property_name,
    p.city,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    COALESCE(AVG(r.rating), 0) AS avg_rating,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank,
    RANK() OVER (ORDER BY COALESCE(AVG(r.rating), 0) DESC) AS rating_rank,
    RANK() OVER (ORDER BY p.pricepernight DESC) AS price_rank,
    NTILE(4) OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_quartile
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
LEFT JOIN 
    Review r ON p.property_id = r.property_id
GROUP BY 
    p.property_id,
    p.name,
    p.city,
    p.pricepernight
ORDER BY 
    booking_rank;

-- Bonus 5: User booking patterns with LAG and LEAD
SELECT 
    b.booking_id,
    b.user_id,
    u.first_name || ' ' || u.last_name AS guest_name,
    b.created_at AS booking_date,
    b.total_price,
    LAG(b.created_at) OVER (PARTITION BY b.user_id ORDER BY b.created_at) AS previous_booking_date,
    LEAD(b.created_at) OVER (PARTITION BY b.user_id ORDER BY b.created_at) AS next_booking_date,
    DATEDIFF(b.created_at, LAG(b.created_at) OVER (PARTITION BY b.user_id ORDER BY b.created_at)) AS days_since_last_booking
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
ORDER BY 
    b.user_id, b.created_at;

-- Bonus 6: Cumulative booking statistics by property
SELECT 
    p.property_id,
    p.name AS property_name,
    b.created_at AS booking_date,
    b.total_price,
    ROW_NUMBER() OVER (PARTITION BY p.property_id ORDER BY b.created_at) AS booking_number,
    COUNT(*) OVER (PARTITION BY p.property_id ORDER BY b.created_at) AS cumulative_bookings,
    SUM(b.total_price) OVER (PARTITION BY p.property_id ORDER BY b.created_at) AS cumulative_revenue,
    AVG(b.total_price) OVER (PARTITION BY p.property_id ORDER BY b.created_at 
                             ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_avg_price
FROM 
    Property p
INNER JOIN 
    Booking b ON p.property_id = b.property_id
ORDER BY 
    p.property_id, b.created_at;

-- =====================================================
-- STATISTICAL AGGREGATIONS
-- =====================================================

-- Overall platform statistics
SELECT 
    COUNT(DISTINCT u.user_id) AS total_users,
    COUNT(DISTINCT CASE WHEN u.role = 'guest' THEN u.user_id END) AS total_guests,
    COUNT(DISTINCT CASE WHEN u.role = 'host' THEN u.user_id END) AS total_hosts,
    COUNT(DISTINCT p.property_id) AS total_properties,
    COUNT(b.booking_id) AS total_bookings,
    COUNT(DISTINCT b.user_id) AS users_with_bookings,
    SUM(b.total_price) AS total_platform_revenue,
    AVG(b.total_price) AS avg_booking_value,
    MIN(b.total_price) AS min_booking_value,
    MAX(b.total_price) AS max_booking_value,
    STDDEV(b.total_price) AS std_dev_booking_value,
    COUNT(r.review_id) AS total_reviews,
    AVG(r.rating) AS avg_platform_rating
FROM 
    User u
LEFT JOIN 
    Property p ON u.user_id = p.host_id
LEFT JOIN 
    Booking b ON p.property_id = b.property_id OR b.user_id = u.user_id
LEFT JOIN 
    Review r ON p.property_id = r.property_id;

-- =====================================================
-- PERCENTILE ANALYSIS WITH WINDOW FUNCTIONS
-- =====================================================

-- Property pricing percentiles
SELECT 
    p.property_id,
    p.name AS property_name,
    p.pricepernight,
    NTILE(10) OVER (ORDER BY p.pricepernight) AS price_decile,
    PERCENT_RANK() OVER (ORDER BY p.pricepernight) AS price_percentile,
    CUME_DIST() OVER (ORDER BY p.pricepernight) AS cumulative_distribution
FROM 
    Property p
ORDER BY 
    p.pricepernight;

-- =====================================================
-- ADVANCED GROUPING OPERATIONS
-- =====================================================

-- Using ROLLUP for subtotals
SELECT 
    p.country,
    p.city,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_revenue
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.country, p.city WITH ROLLUP
ORDER BY 
    p.country, p.city;

-- Using GROUPING SETS for multiple grouping combinations
SELECT 
    p.country,
    p.city,
    b.status,
    COUNT(b.booking_id) AS booking_count,
    SUM(b.total_price) AS total_revenue
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY GROUPING SETS (
    (p.country),
    (p.city),
    (b.status),
    (p.country, p.city),
    (p.country, b.status),
    ()
)
ORDER BY 
    p.country, p.city, b.status;

-- =====================================================
-- END OF AGGREGATIONS AND WINDOW FUNCTIONS
-- =====================================================