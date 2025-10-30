# AirBnB Database Schema (DDL)

## Overview
This directory contains the Data Definition Language (DDL) scripts for the AirBnB database. The schema is normalized to Third Normal Form (3NF) and designed for optimal performance and data integrity.

---

## Contents

- `schema.sql` - Complete DDL script with CREATE TABLE statements, indexes, triggers, views, and sample data

---

## Database Specifications

### Database Engine Support
- **Primary**: MySQL 8.0+ / MariaDB 10.5+
- **Alternative**: PostgreSQL 12+ (with minor syntax adjustments)

### Character Set
- **Default**: `utf8mb4`
- **Collation**: `utf8mb4_unicode_ci`

---

## Tables

### 1. User
Stores all user information (guests, hosts, and admins).

**Columns:**
- `user_id` - CHAR(36) - Primary Key (UUID)
- `first_name` - VARCHAR(100) - User's first name
- `last_name` - VARCHAR(100) - User's last name
- `email` - VARCHAR(255) - Unique email address
- `password_hash` - VARCHAR(255) - Hashed password
- `phone_number` - VARCHAR(20) - Contact number (optional)
- `role` - ENUM - User role (guest, host, admin)
- `created_at` - TIMESTAMP - Account creation date

**Indexes:**
- Primary: `user_id`
- Unique: `email`
- Index: `role`

---

### 2. Property
Stores rental property listings.

**Columns:**
- `property_id` - CHAR(36) - Primary Key (UUID)
- `host_id` - CHAR(36) - Foreign Key → User
- `name` - VARCHAR(255) - Property name
- `description` - TEXT - Detailed description
- `street_address` - VARCHAR(255) - Street address
- `city` - VARCHAR(100) - City name
- `state` - VARCHAR(100) - State/Province
- `country` - VARCHAR(100) - Country
- `postal_code` - VARCHAR(20) - ZIP/Postal code
- `latitude` - DECIMAL(10,8) - Geographic coordinate
- `longitude` - DECIMAL(11,8) - Geographic coordinate
- `pricepernight` - DECIMAL(10,2) - Nightly rate
- `created_at` - TIMESTAMP - Listing creation date
- `updated_at` - TIMESTAMP - Last update date

**Indexes:**
- Primary: `property_id`
- Foreign Key: `host_id` → User(user_id)
- Index: `city`, `country`, `(city, state, country)`, `pricepernight`

**Constraints:**
- `pricepernight` must be positive
- Coordinates must be valid ranges (lat: -90 to 90, lon: -180 to 180)

---

### 3. Booking
Stores reservation information.

**Columns:**
- `booking_id` - CHAR(36) - Primary Key (UUID)
- `property_id` - CHAR(36) - Foreign Key → Property
- `user_id` - CHAR(36) - Foreign Key → User
- `start_date` - DATE - Check-in date
- `end_date` - DATE - Check-out date
- `pricepernight` - DECIMAL(10,2) - Historical price snapshot
- `total_price` - DECIMAL(10,2) - Total booking cost
- `status` - ENUM - Booking status (pending, confirmed, canceled)
- `created_at` - TIMESTAMP - Booking creation date

**Indexes:**
- Primary: `booking_id`
- Foreign Keys: `property_id` → Property, `user_id` → User
- Composite: `(property_id, start_date, end_date)`, `(start_date, end_date)`
- Index: `status`

**Constraints:**
- `end_date` must be after `start_date`
- Prices must be positive

**Business Rule:**
The `pricepernight` field stores a snapshot of the property's price at booking time to preserve historical accuracy, even if the property price changes later.

---

### 4. Payment
Stores payment transaction records.

**Columns:**
- `payment_id` - CHAR(36) - Primary Key (UUID)
- `booking_id` - CHAR(36) - Foreign Key → Booking (UNIQUE)
- `amount` - DECIMAL(10,2) - Payment amount
- `payment_date` - TIMESTAMP - Transaction timestamp
- `payment_method` - ENUM - Payment method (credit_card, paypal, stripe)

**Indexes:**
- Primary: `payment_id`
- Unique: `booking_id` (one payment per booking)
- Index: `payment_date`, `payment_method`

**Constraints:**
- `amount` must be positive
- One-to-one relationship with Booking

---

### 5. Review
Stores property reviews and ratings.

**Columns:**
- `review_id` - CHAR(36) - Primary Key (UUID)
- `property_id` - CHAR(36) - Foreign Key → Property
- `user_id` - CHAR(36) - Foreign Key → User
- `rating` - INTEGER - Star rating (1-5)
- `comment` - TEXT - Review text
- `created_at` - TIMESTAMP - Review date

**Indexes:**
- Primary: `review_id`
- Foreign Keys: `property_id` → Property, `user_id` → User
- Unique: `(user_id, property_id)` - One review per user per property
- Index: `rating`, `created_at`

**Constraints:**
- `rating` must be between 1 and 5
- Users can only review each property once

---

### 6. Message
Stores messages between users.

**Columns:**
- `message_id` - CHAR(36) - Primary Key (UUID)
- `sender_id` - CHAR(36) - Foreign Key → User
- `recipient_id` - CHAR(36) - Foreign Key → User
- `message_body` - TEXT - Message content
- `sent_at` - TIMESTAMP - Message timestamp

**Indexes:**
- Primary: `message_id`
- Foreign Keys: `sender_id` → User, `recipient_id` → User
- Composite: `(sender_id, recipient_id, sent_at)` for conversation queries
- Index: `sent_at`

**Constraints:**
- Users cannot send messages to themselves

---

## Entity Relationships

```
User (1) ──────< (M) Property     [User hosts multiple properties]
User (1) ──────< (M) Booking      [User makes multiple bookings]
User (1) ──────< (M) Review       [User writes multiple reviews]
User (1) ──────< (M) Message      [User sends/receives messages]

Property (1) ──< (M) Booking      [Property has multiple bookings]
Property (1) ──< (M) Review       [Property has multiple reviews]

Booking (1) ──── (1) Payment      [One payment per booking]
```

---

## Installation Instructions

### Prerequisites
- MySQL 8.0+ or MariaDB 10.5+
- MySQL client or workbench
- Appropriate database privileges

### Step 1: Create Database
```sql
CREATE DATABASE airbnb_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE airbnb_db;
```

### Step 2: Execute Schema Script
```bash
# Using MySQL command line
mysql -u username -p airbnb_db < schema.sql

# Or using MySQL Workbench
# File → Open SQL Script → Select schema.sql → Execute
```

### Step 3: Verify Installation
```sql
-- Check tables
SHOW TABLES;

-- Verify table structure
DESCRIBE User;
DESCRIBE Property;
DESCRIBE Booking;
DESCRIBE Payment;
DESCRIBE Review;
DESCRIBE Message;

-- Check indexes
SHOW INDEX FROM Property;
SHOW INDEX FROM Booking;
```

---

## PostgreSQL Conversion (Optional)

To use with PostgreSQL, make these adjustments:

### 1. Change ENUM to CHECK constraints
```sql
-- Instead of:
role ENUM('guest', 'host', 'admin')

-- Use:
role VARCHAR(20) CHECK (role IN ('guest', 'host', 'admin'))
```

### 2. Change AUTO_INCREMENT behavior
```sql
-- UUID generation in PostgreSQL
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Use uuid_generate_v4() for default values
user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4()
```

### 3. Adjust timestamp defaults
```sql
-- PostgreSQL syntax
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

---

## Features

### ✅ Data Integrity
- Foreign key constraints with CASCADE deletes
- Check constraints on critical fields
- Unique constraints preventing duplicates
- NOT NULL constraints on required fields

### ✅ Performance Optimization
- Strategic indexes on foreign keys
- Composite indexes for complex queries
- Spatial indexes for geographic searches (if supported)
- Optimized for common query patterns

### ✅ 3NF Compliance
- No partial dependencies
- No transitive dependencies
- Atomic values in all fields
- Documented controlled denormalization where necessary

### ✅ Scalability Features
- UUID primary keys (distributed system friendly)
- Partitioning-ready design
- View definitions for common queries
- Stored procedures for complex operations

### ✅ Business Logic
- Triggers for automatic calculations
- Views for reporting
- Stored procedures for availability checks
- Data validation at database level

---

## Views Included

### vw_property_ratings
Aggregates property information with average ratings and review counts.

```sql
SELECT * FROM vw_property_ratings WHERE average_rating >= 4.0;
```

### vw_user_bookings
Shows user booking history with property details.

```sql
SELECT * FROM vw_user_bookings WHERE user_id = '550e8400-e29b-41d4-a716-446655440001';
```

### vw_property_availability
Displays property booking statistics.

```sql
SELECT * FROM vw_property_availability WHERE confirmed_bookings < 10;
```

---

## Stored Procedures

### sp_check_property_availability
Check if a property is available for specific dates.

```sql
CALL sp_check_property_availability(
    '650e8400-e29b-41d4-a716-446655440001',
    '2025-12-01',
    '2025-12-05',
    @is_available
);
SELECT @is_available;
```

---

## Triggers

### trg_booking_calculate_total
Automatically calculates `total_price` on booking insert if not provided.

### trg_property_update_timestamp
Updates `updated_at` timestamp on property modifications.

---

## Sample Data

The schema includes sample data for testing:
- 3 Users (1 host, 1 guest, 1 admin)
- 2 Properties

To load additional test data, see the sample INSERT statements at the end of `schema.sql`.

---

## Performance Considerations

### Recommended Optimizations
1. **Connection Pooling**: Use connection pools in application layer
2. **Query Caching**: Enable query cache for read-heavy operations
3. **Partitioning**: Consider partitioning large tables by date
4. **Replication**: Set up read replicas for scalability
5. **Monitoring**: Enable slow query log to identify bottlenecks

### Index Strategy
- Primary keys: Automatic indexing
- Foreign keys: Explicit indexes for JOIN performance
- Search fields: Indexes on city, country, dates
- Composite indexes: For multi-column WHERE clauses

---

## Security Recommendations

1. **Password Storage**: Always use bcrypt or argon2 for password hashing
2. **SQL Injection**: Use prepared statements in application code
3. **Access Control**: Create separate database users with minimal privileges
4. **Encryption**: Enable encryption at rest and in transit
5. **Audit Logging**: Track sensitive operations (payments, bookings)

```sql
-- Example: Create limited privilege user
CREATE USER 'airbnb_app'@'localhost' IDENTIFIED BY 'secure_password';
GRANT SELECT, INSERT, UPDATE ON airbnb_db.* TO 'airbnb_app'@'localhost';
FLUSH PRIVILEGES;
```

---

## Maintenance Tasks

### Regular Maintenance
```sql
-- Analyze tables for query optimization
ANALYZE TABLE User, Property, Booking, Payment, Review, Message;

-- Optimize tables to reclaim space
OPTIMIZE TABLE Booking, Message;

-- Check table integrity
CHECK TABLE Property, Booking;

-- Repair tables if needed
REPAIR TABLE tablename;
```

### Backup Strategy
```bash
# Full backup
mysqldump -u root -p airbnb_db > backup_$(date +%Y%m%d).sql

# Backup with compression
mysqldump -u root -p airbnb_db | gzip > backup_$(date +%Y%m%d).sql.gz

# Restore from backup
mysql -u root -p airbnb_db < backup_20251030.sql
```

---

## Common Queries

### Find available properties in a city
```sql
SELECT p.*
FROM Property p
WHERE p.city = 'San Francisco'
AND NOT EXISTS (
    SELECT 1 FROM Booking b
    WHERE b.property_id = p.property_id
    AND b.status = 'confirmed'
    AND b.start_date <= '2025-12-05'
    AND b.end_date >= '2025-12-01'
);
```

### Get property with highest rating
```sql
SELECT * FROM vw_property_ratings
ORDER BY average_rating DESC, review_count DESC
LIMIT 10;
```

### User booking history
```sql
SELECT * FROM vw_user_bookings
WHERE user_id = '550e8400-e29b-41d4-a716-446655440002'
ORDER BY start_date DESC;
```

---

## Troubleshooting

### Issue: Foreign key constraint fails
**Solution**: Ensure parent records exist before inserting child records.

### Issue: Duplicate entry for key 'email'
**Solution**: Email must be unique. Check for existing user before insert.

### Issue: Check constraint violation on rating
**Solution**: Rating must be between 1 and 5.

### Issue: Date validation fails on booking
**Solution**: Ensure `end_date` is after `start_date`.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-10-30 | Initial schema with 3NF normalization |

---

## Contributing

When modifying the schema:
1. Update this README with any changes
2. Document new indexes, constraints, or tables
3. Test migrations thoroughly
4. Update the normalization documentation if structure changes

---

## License

This database schema is part of the ALX AirBnB project.

---

## Support

For issues or questions:
- Review the normalization documentation in `/normalization.md`
- Check the ER diagram in `/ERD/requirements.md`
- Consult MySQL documentation: https://dev.mysql.com/doc/

---

**Last Updated**: October 30, 2025  
**Schema Version**: 1.0  
**Normalization Level**: 3NF ✅