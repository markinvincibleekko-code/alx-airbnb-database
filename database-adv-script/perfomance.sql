-- =====================================================
-- Query Optimization: Bookings with User, Property, and Payment Details
-- =====================================================

-- -----------------------------------------------------
-- INITIAL QUERY (Unoptimized)
-- -----------------------------------------------------
-- This query retrieves all bookings with complete details
-- but may have performance issues

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    
    -- User details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at AS user_created_at,
    
    -- Property details
    p.property_id,
    p.host_id,
    p.name AS property_name,
    p.description AS property_description,
    p.location,
    p.pricepernight,
    p.created_at AS property_created_at,
    p.updated_at AS property_updated_at,
    
    -- Payment details
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_date,
    pay.payment_method
    
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id
ORDER BY 
    b.created_at DESC;


-- -----------------------------------------------------
-- EXPLAIN ANALYSIS - Run this to analyze the initial query
-- -----------------------------------------------------

EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at AS user_created_at,
    p.property_id,
    p.host_id,
    p.name AS property_name,
    p.description AS property_description,
    p.location,
    p.pricepernight,
    p.created_at AS property_created_at,
    p.updated_at AS property_updated_at,
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_date,
    pay.payment_method
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id
ORDER BY 
    b.created_at DESC;


-- -----------------------------------------------------
-- OPTIMIZED QUERY VERSION 1: Reduced Columns
-- -----------------------------------------------------
-- Only select necessary columns to reduce data transfer

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    
    -- Essential user details only
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    
    -- Essential property details only
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    -- Payment details
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method
    
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id
ORDER BY 
    b.booking_id DESC;  -- Index-friendly ordering


-- -----------------------------------------------------
-- OPTIMIZED QUERY VERSION 2: With Filtering
-- -----------------------------------------------------
-- Add WHERE clause to limit result set

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id
WHERE 
    b.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    AND b.status IN ('confirmed', 'pending')
ORDER BY 
    b.booking_id DESC
LIMIT 1000;


-- -----------------------------------------------------
-- OPTIMIZED QUERY VERSION 3: Indexed Columns Only
-- -----------------------------------------------------
-- Use indexed columns for joining and filtering

SELECT 
    b.booking_id,
    b.user_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    u.email,
    p.name AS property_name,
    p.location,
    pay.payment_id,
    pay.amount
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id
WHERE 
    b.booking_id > 0  -- Forces index usage
ORDER BY 
    b.booking_id DESC
LIMIT 100;


-- -----------------------------------------------------
-- CREATE INDEXES FOR OPTIMIZATION
-- -----------------------------------------------------

-- Index on Booking table
CREATE INDEX idx_booking_user_id ON Booking(user_id);
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_created_at ON Booking(created_at);
CREATE INDEX idx_booking_status ON Booking(status);

-- Composite index for common queries
CREATE INDEX idx_booking_status_created ON Booking(status, created_at);

-- Index on Payment table
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- Index on User table (if not already exists)
CREATE INDEX idx_user_email ON User(email);

-- Index on Property table
CREATE INDEX idx_property_host_id ON Property(host_id);
CREATE INDEX idx_property_location ON Property(location);


-- -----------------------------------------------------
-- ANALYZE OPTIMIZED QUERY
-- -----------------------------------------------------

EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id
WHERE 
    b.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
ORDER BY 
    b.booking_id DESC
LIMIT 1000;


-- -----------------------------------------------------
-- PARTITIONED QUERY FOR VERY LARGE DATASETS
-- -----------------------------------------------------
-- Break query into smaller chunks if dataset is huge

-- Get recent bookings only (most common use case)
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    u.email,
    p.name AS property_name,
    p.location,
    pay.amount AS payment_amount
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id
WHERE 
    b.start_date >= CURDATE()
    AND b.status = 'confirmed'
ORDER BY 
    b.start_date ASC
LIMIT 500;


-- -----------------------------------------------------
-- MATERIALIZED VIEW APPROACH (For frequently run queries)
-- -----------------------------------------------------
-- Create a view for commonly accessed booking details

CREATE VIEW vw_booking_details AS
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id;

-- Use the view
SELECT * FROM vw_booking_details 
WHERE booking_status = 'confirmed' 
ORDER BY booking_created_at DESC 
LIMIT 100;


-- -----------------------------------------------------
-- PERFORMANCE COMPARISON QUERIES
-- -----------------------------------------------------

-- Check index usage
SHOW INDEX FROM Booking;
SHOW INDEX FROM User;
SHOW INDEX FROM Property;
SHOW INDEX FROM Payment;

-- Analyze table statistics
ANALYZE TABLE Booking;
ANALYZE TABLE User;
ANALYZE TABLE Property;
ANALYZE TABLE Payment;