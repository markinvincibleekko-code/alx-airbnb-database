-- =====================================================
-- Task 5: Partitioning Large Tables
-- File: partitioning.sql
-- Description: Implement table partitioning on Booking table
-- =====================================================

-- =====================================================
-- STEP 1: BACKUP EXISTING BOOKING TABLE
-- =====================================================

-- Create backup of existing Booking table
CREATE TABLE Booking_backup AS
SELECT * FROM Booking;

-- Verify backup
SELECT COUNT(*) AS total_bookings FROM Booking_backup;

-- =====================================================
-- STEP 2: CHECK CURRENT TABLE STATUS
-- =====================================================

-- Check current table structure
DESCRIBE Booking;

-- Check row count and size
SELECT 
    table_name,
    table_rows,
    ROUND(data_length / 1024 / 1024, 2) AS data_size_mb,
    ROUND(index_length / 1024 / 1024, 2) AS index_size_mb,
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS total_size_mb
FROM 
    information_schema.TABLES
WHERE 
    table_schema = DATABASE()
    AND table_name = 'Booking';

-- =====================================================
-- STEP 3: DROP EXISTING BOOKING TABLE
-- (Required for partitioning in MySQL)
-- =====================================================

-- Note: This will drop all foreign key constraints
-- You may need to drop dependent foreign keys first

-- Drop the existing table
DROP TABLE IF EXISTS Booking;

-- =====================================================
-- STEP 4: CREATE PARTITIONED BOOKING TABLE
-- Partitioning by RANGE on start_date
-- =====================================================

-- Create partitioned Booking table
-- Using RANGE partitioning by YEAR for start_date
CREATE TABLE Booking (
    booking_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_booking_property (property_id),
    INDEX idx_booking_user (user_id),
    INDEX idx_booking_status (status),
    INDEX idx_booking_dates (start_date, end_date)
)
PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p_before_2020 VALUES LESS THAN (2020),
    PARTITION p_2020 VALUES LESS THAN (2021),
    PARTITION p_2021 VALUES LESS THAN (2022),
    PARTITION p_2022 VALUES LESS THAN (2023),
    PARTITION p_2023 VALUES LESS THAN (2024),
    PARTITION p_2024 VALUES LESS THAN (2025),
    PARTITION p_2025 VALUES LESS THAN (2026),
    PARTITION p_2026 VALUES LESS THAN (2027),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- =====================================================
-- ALTERNATIVE: Partitioning by QUARTER
-- =====================================================

/*
-- More granular partitioning by quarter
DROP TABLE IF EXISTS Booking;

CREATE TABLE Booking (
    booking_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_booking_property (property_id),
    INDEX idx_booking_user (user_id),
    INDEX idx_booking_status (status)
)
PARTITION BY RANGE (TO_DAYS(start_date)) (
    PARTITION p_2023_q1 VALUES LESS THAN (TO_DAYS('2023-04-01')),
    PARTITION p_2023_q2 VALUES LESS THAN (TO_DAYS('2023-07-01')),
    PARTITION p_2023_q3 VALUES LESS THAN (TO_DAYS('2023-10-01')),
    PARTITION p_2023_q4 VALUES LESS THAN (TO_DAYS('2024-01-01')),
    PARTITION p_2024_q1 VALUES LESS THAN (TO_DAYS('2024-04-01')),
    PARTITION p_2024_q2 VALUES LESS THAN (TO_DAYS('2024-07-01')),
    PARTITION p_2024_q3 VALUES LESS THAN (TO_DAYS('2024-10-01')),
    PARTITION p_2024_q4 VALUES LESS THAN (TO_DAYS('2025-01-01')),
    PARTITION p_2025_q1 VALUES LESS THAN (TO_DAYS('2025-04-01')),
    PARTITION p_2025_q2 VALUES LESS THAN (TO_DAYS('2025-07-01')),
    PARTITION p_2025_q3 VALUES LESS THAN (TO_DAYS('2025-10-01')),
    PARTITION p_2025_q4 VALUES LESS THAN (TO_DAYS('2026-01-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);
*/

-- =====================================================
-- STEP 5: RESTORE DATA FROM BACKUP
-- =====================================================

-- Insert data back from backup
INSERT INTO Booking
SELECT * FROM Booking_backup;

-- Verify data restoration
SELECT COUNT(*) AS total_bookings FROM Booking;

-- =====================================================
-- STEP 6: VERIFY PARTITIONING
-- =====================================================

-- Check partition information
SELECT 
    PARTITION_NAME,
    PARTITION_METHOD,
    PARTITION_EXPRESSION,
    PARTITION_DESCRIPTION,
    TABLE_ROWS,
    AVG_ROW_LENGTH,
    DATA_LENGTH,
    INDEX_LENGTH,
    CREATE_TIME
FROM 
    information_schema.PARTITIONS
WHERE 
    TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'Booking'
ORDER BY 
    PARTITION_ORDINAL_POSITION;

-- Count rows in each partition
SELECT 
    PARTITION_NAME,
    TABLE_ROWS
FROM 
    information_schema.PARTITIONS
WHERE 
    TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'Booking'
ORDER BY 
    PARTITION_ORDINAL_POSITION;

-- =====================================================
-- STEP 7: PERFORMANCE TEST QUERIES
-- =====================================================

-- Test Query 1: Fetch bookings for a specific year (2024)
-- This query should only scan the p_2024 partition
EXPLAIN PARTITIONS
SELECT 
    booking_id,
    property_id,
    user_id,
    start_date,
    end_date,
    total_price,
    status
FROM 
    Booking
WHERE 
    start_date >= '2024-01-01' 
    AND start_date < '2025-01-01';

-- Execute the query
SELECT 
    booking_id,
    property_id,
    user_id,
    start_date,
    end_date,
    total_price,
    status
FROM 
    Booking
WHERE 
    start_date >= '2024-01-01' 
    AND start_date < '2025-01-01'
ORDER BY 
    start_date;

-- Test Query 2: Fetch bookings for a date range (Q1 2024)
EXPLAIN PARTITIONS
SELECT 
    booking_id,
    start_date,
    end_date,
    total_price,
    status
FROM 
    Booking
WHERE 
    start_date >= '2024-01-01' 
    AND start_date <= '2024-03-31';

-- Test Query 3: Count bookings by year
SELECT 
    YEAR(start_date) AS booking_year,
    COUNT(*) AS total_bookings,
    SUM(total_price) AS total_revenue,
    AVG(total_price) AS avg_booking_price
FROM 
    Booking
GROUP BY 
    YEAR(start_date)
ORDER BY 
    booking_year DESC;

-- Test Query 4: Recent bookings (last 6 months)
-- Should scan only recent partitions
EXPLAIN PARTITIONS
SELECT 
    booking_id,
    property_id,
    start_date,
    end_date,
    total_price,
    status
FROM 
    Booking
WHERE 
    start_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
ORDER BY 
    start_date DESC
LIMIT 100;

-- =====================================================
-- STEP 8: PARTITION MAINTENANCE
-- =====================================================

-- Add new partition for future year (2028)
ALTER TABLE Booking
ADD PARTITION (PARTITION p_2027 VALUES LESS THAN (2028));

-- Drop old partition (if needed)
-- WARNING: This will delete all data in that partition
-- ALTER TABLE Booking DROP PARTITION p_before_2020;

-- Reorganize partition (split a partition)
-- This is useful if a partition becomes too large
/*
ALTER TABLE Booking
REORGANIZE PARTITION p_future INTO (
    PARTITION p_2027 VALUES LESS THAN (2028),
    PARTITION p_2028 VALUES LESS THAN (2029),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);
*/

-- Analyze partitions to update statistics
ANALYZE TABLE Booking;

-- =====================================================
-- STEP 9: PERFORMANCE COMPARISON QUERIES
-- =====================================================

-- Benchmark Query 1: With partition pruning
SET @start_time = NOW(6);

SELECT COUNT(*), SUM(total_price)
FROM Booking
WHERE start_date >= '2024-01-01' AND start_date < '2025-01-01';

SET @end_time = NOW(6);
SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) AS execution_time_microseconds;

-- Benchmark Query 2: Full table scan
SET @start_time = NOW(6);

SELECT COUNT(*), SUM(total_price)
FROM Booking;

SET @end_time = NOW(6);
SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) AS execution_time_microseconds;

-- Benchmark Query 3: Date range query
SET @start_time = NOW(6);

SELECT booking_id, start_date, total_price
FROM Booking
WHERE start_date BETWEEN '2024-06-01' AND '2024-08-31'
ORDER BY start_date;

SET @end_time = NOW(6);
SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) AS execution_time_microseconds;

-- =====================================================
-- STEP 10: MONITORING AND STATISTICS
-- =====================================================

-- Check partition sizes
SELECT 
    PARTITION_NAME,
    TABLE_ROWS,
    ROUND(DATA_LENGTH / 1024 / 1024, 2) AS data_size_mb,
    ROUND(INDEX_LENGTH / 1024 / 1024, 2) AS index_size_mb,
    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS total_size_mb,
    CREATE_TIME,
    UPDATE_TIME
FROM 
    information_schema.PARTITIONS
WHERE 
    TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'Booking'
ORDER BY 
    PARTITION_ORDINAL_POSITION;

-- Check partition distribution
SELECT 
    PARTITION_NAME,
    PARTITION_DESCRIPTION AS year_boundary,
    TABLE_ROWS AS row_count,
    ROUND(TABLE_ROWS * 100.0 / (SELECT SUM(TABLE_ROWS) 
                                  FROM information_schema.PARTITIONS 
                                  WHERE TABLE_NAME = 'Booking' 
                                  AND TABLE_SCHEMA = DATABASE()), 2) AS percentage
FROM 
    information_schema.PARTITIONS
WHERE 
    TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'Booking'
ORDER BY 
    PARTITION_ORDINAL_POSITION;

-- =====================================================
-- STEP 11: RE-ADD FOREIGN KEY CONSTRAINTS
-- =====================================================

-- Add foreign key constraints back (if they were dropped)
ALTER TABLE Booking
ADD CONSTRAINT fk_booking_user 
    FOREIGN KEY (user_id) REFERENCES User(user_id)
    ON DELETE CASCADE;

ALTER TABLE Booking
ADD CONSTRAINT fk_booking_property 
    FOREIGN KEY (property_id) REFERENCES Property(property_id)
    ON DELETE CASCADE;

-- =====================================================
-- POSTGRESQL ALTERNATIVE (Declarative Partitioning)
-- =====================================================

/*
-- PostgreSQL 10+ supports native partitioning
-- Drop existing table
DROP TABLE IF EXISTS Booking CASCADE;

-- Create partitioned table
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY RANGE (start_date);

-- Create partitions
CREATE TABLE booking_2020 PARTITION OF Booking
    FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');

CREATE TABLE booking_2021 PARTITION OF Booking
    FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');

CREATE TABLE booking_2022 PARTITION OF Booking
    FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE booking_2023 PARTITION OF Booking
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE booking_2024 PARTITION OF Booking
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE booking_2025 PARTITION OF Booking
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

CREATE TABLE booking_future PARTITION OF Booking
    FOR VALUES FROM ('2026-01-01') TO (MAXVALUE);

-- Create indexes on partitions
CREATE INDEX idx_booking_property ON Booking(property_id);
CREATE INDEX idx_booking_user ON Booking(user_id);
CREATE INDEX idx_booking_status ON Booking(status);
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);

-- Add foreign keys
ALTER TABLE Booking
    ADD CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES "User"(user_id),
    ADD CONSTRAINT fk_booking_property FOREIGN KEY (property_id) REFERENCES Property(property_id);
*/

-- =====================================================
-- CLEANUP (Optional)
-- =====================================================

-- Drop backup table after verification
-- DROP TABLE IF EXISTS Booking_backup;

-- =====================================================
-- NOTES AND BEST PRACTICES
-- =====================================================

/*
PARTITIONING BENEFITS:
1. Query Performance: Partition pruning reduces data scanned
2. Maintenance: Easier to archive/delete old data
3. Parallel Processing: Better query parallelization
4. Index Size: Smaller indexes per partition

PARTITIONING CONSIDERATIONS:
1. Partition Key: Choose column used in WHERE clauses (start_date)
2. Partition Size: Balance between too many/few partitions
3. Foreign Keys: MySQL has limitations with partitioned tables
4. Primary Key: Must include partition key in MySQL

MAINTENANCE TASKS:
1. Add new partitions before needed (annually)
2. Archive/drop old partitions as needed
3. Monitor partition sizes and distribution
4. Regularly run ANALYZE TABLE

QUERY OPTIMIZATION:
1. Always include partition key in WHERE clause
2. Use EXPLAIN PARTITIONS to verify partition pruning
3. Avoid queries that scan all partitions
4. Consider partition-wise joins for large joins
*/

-- =====================================================
-- END OF PARTITIONING SCRIPT
-- =====================================================