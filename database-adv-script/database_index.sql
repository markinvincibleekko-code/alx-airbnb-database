-- =====================================================
-- Task 3: Implement Indexes for Optimization
-- File: database_index.sql
-- Description: Create indexes to improve query performance
-- =====================================================

-- =====================================================
-- ANALYSIS: High-Usage Columns Identification
-- =====================================================

/*
IDENTIFIED HIGH-USAGE COLUMNS:

User Table:
- email: Used in WHERE clauses for login/authentication (UNIQUE constraint exists)
- role: Used in WHERE clauses for filtering users by type
- user_id: Primary key, already indexed

Booking Table:
- user_id: Foreign key, used in JOINs and WHERE clauses
- property_id: Foreign key, used in JOINs and WHERE clauses
- start_date, end_date: Used in WHERE clauses for availability checks
- status: Used in WHERE clauses for filtering bookings
- created_at: Used in ORDER BY for chronological queries

Property Table:
- host_id: Foreign key, used in JOINs to find host's properties
- city: Used in WHERE clauses for location-based searches
- country: Used in WHERE clauses for location filtering
- pricepernight: Used in WHERE and ORDER BY for price filtering
- property_id: Primary key, already indexed

Review Table:
- property_id: Foreign key, used in JOINs for property reviews
- user_id: Foreign key, used in JOINs for user reviews
- rating: Used in WHERE and ORDER BY for rating filters
- created_at: Used in ORDER BY for recent reviews

Payment Table:
- booking_id: Foreign key, used in JOINs (UNIQUE constraint exists)
- payment_date: Used in WHERE and ORDER BY for date filtering
- payment_method: Used in WHERE for payment analysis

Message Table:
- sender_id: Foreign key, used in JOINs and WHERE clauses
- recipient_id: Foreign key, used in JOINs and WHERE clauses
- sent_at: Used in ORDER BY for message chronology
*/

-- =====================================================
-- DROP EXISTING INDEXES (if re-running script)
-- =====================================================

-- Note: Only drop if indexes exist, otherwise skip errors
DROP INDEX IF EXISTS idx_user_email ON User;
DROP INDEX IF EXISTS idx_user_role ON User;

DROP INDEX IF EXISTS idx_booking_user ON Booking;
DROP INDEX IF EXISTS idx_booking_property ON Booking;
DROP INDEX IF EXISTS idx_booking_dates ON Booking;
DROP INDEX IF EXISTS idx_booking_status ON Booking;
DROP INDEX IF EXISTS idx_booking_created ON Booking;
DROP INDEX IF EXISTS idx_booking_property_dates ON Booking;

DROP INDEX IF EXISTS idx_property_host ON Property;
DROP INDEX IF EXISTS idx_property_city ON Property;
DROP INDEX IF EXISTS idx_property_country ON Property;
DROP INDEX IF EXISTS idx_property_price ON Property;
DROP INDEX IF EXISTS idx_property_location ON Property;

DROP INDEX IF EXISTS idx_review_property ON Review;
DROP INDEX IF EXISTS idx_review_user ON Review;
DROP INDEX IF EXISTS idx_review_rating ON Review;
DROP INDEX IF EXISTS idx_review_created ON Review;

DROP INDEX IF EXISTS idx_payment_booking ON Payment;
DROP INDEX IF EXISTS idx_payment_date ON Payment;
DROP INDEX IF EXISTS idx_payment_method ON Payment;

DROP INDEX IF EXISTS idx_message_sender ON Message;
DROP INDEX IF EXISTS idx_message_recipient ON Message;
DROP INDEX IF EXISTS idx_message_sent ON Message;
DROP INDEX IF EXISTS idx_message_conversation ON Message;

-- =====================================================
-- USER TABLE INDEXES
-- =====================================================

-- Index on email for login queries (if not already unique index)
CREATE INDEX idx_user_email ON User(email);

-- Index on role for filtering by user type
CREATE INDEX idx_user_role ON User(role);

-- Composite index for role and created_at (for admin queries)
CREATE INDEX idx_user_role_created ON User(role, created_at);

-- =====================================================
-- BOOKING TABLE INDEXES
-- =====================================================

-- Index on user_id for user booking history queries
CREATE INDEX idx_booking_user ON Booking(user_id);

-- Index on property_id for property booking queries
CREATE INDEX idx_booking_property ON Booking(property_id);

-- Composite index on start_date and end_date for availability checks
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);

-- Index on status for filtering by booking status
CREATE INDEX idx_booking_status ON Booking(status);

-- Index on created_at for chronological queries
CREATE INDEX idx_booking_created ON Booking(created_at);

-- Composite index for property availability queries
-- (Most specific columns first: property_id, then dates, then status)
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);

-- Composite index for user bookings with status
CREATE INDEX idx_booking_user_status ON Booking(user_id, status, created_at);

-- Composite index for date range queries with status
CREATE INDEX idx_booking_status_dates ON Booking(status, start_date, end_date);

-- =====================================================
-- PROPERTY TABLE INDEXES
-- =====================================================

-- Index on host_id for finding host's properties
CREATE INDEX idx_property_host ON Property(host_id);

-- Index on city for location-based searches
CREATE INDEX idx_property_city ON Property(city);

-- Index on country for country filtering
CREATE INDEX idx_property_country ON Property(country);

-- Index on pricepernight for price filtering and sorting
CREATE INDEX idx_property_price ON Property(pricepernight);

-- Composite index for location hierarchy (country, state, city)
CREATE INDEX idx_property_location ON Property(country, state, city);

-- Composite index for city and price (common search pattern)
CREATE INDEX idx_property_city_price ON Property(city, pricepernight);

-- Composite index for available properties in a city
CREATE INDEX idx_property_city_created ON Property(city, created_at);

-- =====================================================
-- REVIEW TABLE INDEXES
-- =====================================================

-- Index on property_id for property reviews
CREATE INDEX idx_review_property ON Review(property_id);

-- Index on user_id for user review history
CREATE INDEX idx_review_user ON Review(user_id);

-- Index on rating for filtering by rating
CREATE INDEX idx_review_rating ON Review(rating);

-- Index on created_at for recent reviews
CREATE INDEX idx_review_created ON Review(created_at);

-- Composite index for property reviews with ratings
CREATE INDEX idx_review_property_rating ON Review(property_id, rating, created_at);

-- Composite index for user reviews chronologically
CREATE INDEX idx_review_user_created ON Review(user_id, created_at);

-- =====================================================
-- PAYMENT TABLE INDEXES
-- =====================================================

-- Index on booking_id for payment lookup (if not unique)
CREATE INDEX idx_payment_booking ON Payment(booking_id);

-- Index on payment_date for date-based queries
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- Index on payment_method for payment analysis
CREATE INDEX idx_payment_method ON Payment(payment_method);

-- Composite index for payment reporting
CREATE INDEX idx_payment_method_date ON Payment(payment_method, payment_date);

-- =====================================================
-- MESSAGE TABLE INDEXES
-- =====================================================

-- Index on sender_id for sent messages
CREATE INDEX idx_message_sender ON Message(sender_id);

-- Index on recipient_id for received messages
CREATE INDEX idx_message_recipient ON Message(recipient_id);

-- Index on sent_at for chronological ordering
CREATE INDEX idx_message_sent ON Message(sent_at);

-- Composite index for conversation queries
CREATE INDEX idx_message_conversation ON Message(sender_id, recipient_id, sent_at);

-- Composite index for recipient inbox
CREATE INDEX idx_message_recipient_sent ON Message(recipient_id, sent_at);

-- =====================================================
-- FULL-TEXT SEARCH INDEXES (Optional - MySQL specific)
-- =====================================================

-- Full-text index on property description for search
-- Note: Only if using MyISAM or InnoDB with MySQL 5.6+
-- CREATE FULLTEXT INDEX idx_property_description_fulltext ON Property(description);

-- Full-text index on property name
-- CREATE FULLTEXT INDEX idx_property_name_fulltext ON Property(name);

-- Full-text index on review comments
-- CREATE FULLTEXT INDEX idx_review_comment_fulltext ON Review(comment);

-- =====================================================
-- COVERING INDEXES (Advanced Optimization)
-- =====================================================

-- Covering index for user booking summary
-- Includes all columns needed for a common query
CREATE INDEX idx_booking_user_summary ON Booking(user_id, status, total_price, created_at);

-- Covering index for property listing
CREATE INDEX idx_property_listing ON Property(city, pricepernight, name, property_id);

-- Covering index for property reviews summary
CREATE INDEX idx_review_summary ON Review(property_id, rating, created_at, user_id);

-- =====================================================
-- VERIFY INDEXES CREATED
-- =====================================================

-- Show all indexes on User table
SHOW INDEX FROM User;

-- Show all indexes on Booking table
SHOW INDEX FROM Booking;

-- Show all indexes on Property table
SHOW INDEX FROM Property;

-- Show all indexes on Review table
SHOW INDEX FROM Review;

-- Show all indexes on Payment table
SHOW INDEX FROM Payment;

-- Show all indexes on Message table
SHOW INDEX FROM Message;

-- =====================================================
-- INDEX STATISTICS AND INFORMATION
-- =====================================================

-- Get index sizes
SELECT 
    table_name,
    index_name,
    ROUND(stat_value * @@innodb_page_size / 1024 / 1024, 2) AS size_mb
FROM mysql.innodb_index_stats
WHERE database_name = DATABASE()
    AND stat_name = 'size'
ORDER BY stat_value DESC;

-- Get index cardinality (uniqueness)
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    CARDINALITY,
    SEQ_IN_INDEX
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = DATABASE()
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;

-- =====================================================
-- MAINTENANCE QUERIES
-- =====================================================

-- Analyze tables to update index statistics
ANALYZE TABLE User;
ANALYZE TABLE Property;
ANALYZE TABLE Booking;
ANALYZE TABLE Review;
ANALYZE TABLE Payment;
ANALYZE TABLE Message;

-- Optimize tables (rebuilds indexes)
-- Warning: Can be slow on large tables
-- OPTIMIZE TABLE User;
-- OPTIMIZE TABLE Property;
-- OPTIMIZE TABLE Booking;

-- =====================================================
-- NOTES ON INDEX STRATEGY
-- =====================================================

/*
INDEX SELECTION CRITERIA:
1. Columns used in WHERE clauses
2. Columns used in JOIN conditions (foreign keys)
3. Columns used in ORDER BY clauses
4. Columns with high selectivity (many unique values)

COMPOSITE INDEX GUIDELINES:
1. Most selective column first (highest cardinality)
2. Equality conditions before range conditions
3. Consider query patterns and column order
4. Left-prefix rule: (a, b, c) supports (a), (a, b), (a, b, c)

INDEXES TO AVOID:
1. Low cardinality columns alone (e.g., boolean, status with few values)
2. Columns that are rarely queried
3. Small tables (< 1000 rows) - full table scan may be faster
4. Columns with frequent updates (index maintenance overhead)

TRADE-OFFS:
✓ Pros: Faster SELECT queries, faster JOINs, faster sorting
✗ Cons: Slower INSERT/UPDATE/DELETE, increased storage, maintenance overhead

MONITORING:
- Use EXPLAIN to verify index usage
- Monitor slow query log
- Review index usage statistics
- Remove unused indexes periodically
*/

-- =====================================================
-- END OF INDEX CREATION SCRIPT
-- =====================================================