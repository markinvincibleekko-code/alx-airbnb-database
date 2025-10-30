-- =====================================================
-- AirBnB Database Schema (DDL)
-- Database: PostgreSQL/MySQL Compatible
-- Version: 1.0
-- Date: October 30, 2025
-- Normalized to 3NF
-- =====================================================

-- Drop existing tables if they exist (for clean setup)
-- Note: Order matters due to foreign key constraints
DROP TABLE IF EXISTS Message;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS Property;
DROP TABLE IF EXISTS User;

-- =====================================================
-- 1. USER TABLE
-- =====================================================
CREATE TABLE User (
    user_id CHAR(36) PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) NULL,
    role ENUM('guest', 'host', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_email_format CHECK (email LIKE '%_@__%.__%'),
    CONSTRAINT chk_role_valid CHECK (role IN ('guest', 'host', 'admin'))
);

-- Indexes for User table
CREATE INDEX idx_user_email ON User(email);
CREATE INDEX idx_user_role ON User(role);

-- =====================================================
-- 2. PROPERTY TABLE
-- =====================================================
CREATE TABLE Property (
    property_id CHAR(36) PRIMARY KEY,
    host_id CHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    
    -- Normalized location fields (3NF compliant)
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    latitude DECIMAL(10, 8) NULL,
    longitude DECIMAL(11, 8) NULL,
    
    pricepernight DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT fk_property_host FOREIGN KEY (host_id) REFERENCES User(user_id) ON DELETE CASCADE,
    CONSTRAINT chk_price_positive CHECK (pricepernight > 0),
    CONSTRAINT chk_coordinates CHECK (
        (latitude IS NULL AND longitude IS NULL) OR 
        (latitude BETWEEN -90 AND 90 AND longitude BETWEEN -180 AND 180)
    )
);

-- Indexes for Property table
CREATE INDEX idx_property_host ON Property(host_id);
CREATE INDEX idx_property_city ON Property(city);
CREATE INDEX idx_property_country ON Property(country);
CREATE INDEX idx_property_location ON Property(city, state, country);
CREATE INDEX idx_property_price ON Property(pricepernight);

-- Spatial index for geographic searches (if database supports it)
-- CREATE SPATIAL INDEX idx_property_coordinates ON Property(latitude, longitude);

-- =====================================================
-- 3. BOOKING TABLE
-- =====================================================
CREATE TABLE Booking (
    booking_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    
    -- Historical price preservation (3NF exception with business justification)
    pricepernight DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT fk_booking_property FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    CONSTRAINT chk_booking_dates CHECK (end_date > start_date),
    CONSTRAINT chk_booking_status CHECK (status IN ('pending', 'confirmed', 'canceled')),
    CONSTRAINT chk_booking_prices CHECK (pricepernight > 0 AND total_price > 0)
);

-- Indexes for Booking table
CREATE INDEX idx_booking_property ON Booking(property_id);
CREATE INDEX idx_booking_user ON Booking(user_id);
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);
CREATE INDEX idx_booking_status ON Booking(status);
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);

-- =====================================================
-- 4. PAYMENT TABLE
-- =====================================================
CREATE TABLE Payment (
    payment_id CHAR(36) PRIMARY KEY,
    booking_id CHAR(36) NOT NULL UNIQUE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
    
    -- Constraints
    CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE,
    CONSTRAINT chk_payment_amount CHECK (amount > 0),
    CONSTRAINT chk_payment_method CHECK (payment_method IN ('credit_card', 'paypal', 'stripe'))
);

-- Indexes for Payment table
CREATE INDEX idx_payment_booking ON Payment(booking_id);
CREATE INDEX idx_payment_date ON Payment(payment_date);
CREATE INDEX idx_payment_method ON Payment(payment_method);

-- =====================================================
-- 5. REVIEW TABLE
-- =====================================================
CREATE TABLE Review (
    review_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    rating INTEGER NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT fk_review_property FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    CONSTRAINT chk_review_rating CHECK (rating >= 1 AND rating <= 5),
    
    -- Prevent duplicate reviews (one review per user per property)
    CONSTRAINT uk_review_user_property UNIQUE (user_id, property_id)
);

-- Indexes for Review table
CREATE INDEX idx_review_property ON Review(property_id);
CREATE INDEX idx_review_user ON Review(user_id);
CREATE INDEX idx_review_rating ON Review(rating);
CREATE INDEX idx_review_created ON Review(created_at);

-- =====================================================
-- 6. MESSAGE TABLE
-- =====================================================
CREATE TABLE Message (
    message_id CHAR(36) PRIMARY KEY,
    sender_id CHAR(36) NOT NULL,
    recipient_id CHAR(36) NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT fk_message_sender FOREIGN KEY (sender_id) REFERENCES User(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_message_recipient FOREIGN KEY (recipient_id) REFERENCES User(user_id) ON DELETE CASCADE,
    CONSTRAINT chk_message_not_self CHECK (sender_id != recipient_id)
);

-- Indexes for Message table
CREATE INDEX idx_message_sender ON Message(sender_id);
CREATE INDEX idx_message_recipient ON Message(recipient_id);
CREATE INDEX idx_message_sent_at ON Message(sent_at);
CREATE INDEX idx_message_conversation ON Message(sender_id, recipient_id, sent_at);

-- =====================================================
-- TRIGGERS (Optional - for data integrity)
-- =====================================================

-- Trigger to automatically calculate total_price on Booking insert
DELIMITER //

CREATE TRIGGER trg_booking_calculate_total
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
    -- Calculate total price if not provided
    IF NEW.total_price IS NULL OR NEW.total_price = 0 THEN
        SET NEW.total_price = NEW.pricepernight * DATEDIFF(NEW.end_date, NEW.start_date);
    END IF;
END//

-- Trigger to update Property.updated_at timestamp
CREATE TRIGGER trg_property_update_timestamp
BEFORE UPDATE ON Property
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END//

DELIMITER ;

-- =====================================================
-- VIEWS (Optional - for common queries)
-- =====================================================

-- View: Property with average rating
CREATE VIEW vw_property_ratings AS
SELECT 
    p.property_id,
    p.name,
    p.city,
    p.country,
    p.pricepernight,
    COUNT(r.review_id) as review_count,
    COALESCE(AVG(r.rating), 0) as average_rating
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
GROUP BY p.property_id, p.name, p.city, p.country, p.pricepernight;

-- View: User booking history
CREATE VIEW vw_user_bookings AS
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    b.booking_id,
    p.name as property_name,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM User u
JOIN Booking b ON u.user_id = b.user_id
JOIN Property p ON b.property_id = p.property_id
ORDER BY b.created_at DESC;

-- View: Property availability (properties without overlapping bookings)
CREATE VIEW vw_property_availability AS
SELECT 
    p.property_id,
    p.name,
    p.city,
    p.pricepernight,
    COUNT(b.booking_id) as total_bookings,
    SUM(CASE WHEN b.status = 'confirmed' THEN 1 ELSE 0 END) as confirmed_bookings
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name, p.city, p.pricepernight;

-- =====================================================
-- STORED PROCEDURES (Optional - for common operations)
-- =====================================================

-- Procedure to check property availability for dates
DELIMITER //

CREATE PROCEDURE sp_check_property_availability(
    IN p_property_id CHAR(36),
    IN p_start_date DATE,
    IN p_end_date DATE,
    OUT p_is_available BOOLEAN
)
BEGIN
    DECLARE booking_count INT;
    
    SELECT COUNT(*) INTO booking_count
    FROM Booking
    WHERE property_id = p_property_id
    AND status IN ('pending', 'confirmed')
    AND (
        (start_date <= p_start_date AND end_date > p_start_date)
        OR (start_date < p_end_date AND end_date >= p_end_date)
        OR (start_date >= p_start_date AND end_date <= p_end_date)
    );
    
    SET p_is_available = (booking_count = 0);
END//

DELIMITER ;

-- =====================================================
-- SAMPLE DATA (Optional - for testing)
-- =====================================================

-- Insert sample users
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'John', 'Doe', 'john.doe@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+1234567890', 'host'),
('550e8400-e29b-41d4-a716-446655440002', 'Jane', 'Smith', 'jane.smith@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+1234567891', 'guest'),
('550e8400-e29b-41d4-a716-446655440003', 'Admin', 'User', 'admin@airbnb.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+1234567892', 'admin');

-- Insert sample properties
INSERT INTO Property (property_id, host_id, name, description, street_address, city, state, country, postal_code, latitude, longitude, pricepernight) VALUES
('650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Cozy Downtown Apartment', 'Beautiful 2-bedroom apartment in the heart of the city', '123 Main Street', 'San Francisco', 'California', 'USA', '94102', 37.7749, -122.4194, 150.00),
('650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'Beach House Paradise', 'Stunning ocean view beach house with 3 bedrooms', '456 Beach Road', 'Miami', 'Florida', 'USA', '33139', 25.7617, -80.1918, 300.00);

-- =====================================================
-- PERFORMANCE OPTIMIZATION NOTES
-- =====================================================

-- 1. Partitioning Strategy (for large datasets):
--    - Consider partitioning Booking table by date range
--    - Partition Message table by sent_at date
--    - Partition Review table by created_at date

-- 2. Additional Indexes (add if needed):
--    - Full-text search on Property.description
--    - Composite index on Booking (user_id, status, start_date)

-- 3. Caching Recommendations:
--    - Cache frequently accessed property data
--    - Cache user session data
--    - Cache aggregated review ratings

-- 4. Query Optimization:
--    - Use prepared statements
--    - Implement connection pooling
--    - Monitor slow query logs

-- =====================================================
-- END OF SCHEMA DEFINITION
-- =====================================================

-- Verify table creation
SHOW TABLES;

-- Display table structures
DESCRIBE User;
DESCRIBE Property;
DESCRIBE Booking;
DESCRIBE Payment;
DESCRIBE Review;
DESCRIBE Message;