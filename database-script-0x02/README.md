# AirBnB Database - Seed Data

## Overview
This directory contains SQL scripts to populate the AirBnB database with realistic sample data for development and testing purposes.

## Files
- **`seed.sql`**: Complete seed data script with sample records for all tables

## What's Included

### Sample Data Summary
| Table | Record Count | Description |
|-------|--------------|-------------|
| User | 15 | 5 hosts, 8 guests, 2 admins |
| Property | 10 | Properties across 5 cities (SF, Miami, NYC, London, Barcelona) |
| Booking | 15 | 10 confirmed, 3 pending, 2 canceled |
| Payment | 10 | Payments for confirmed bookings only |
| Review | 12 | Property reviews with ratings 4-5 stars |
| Message | 20 | Communication between guests and hosts |

### User Types
1. **Hosts (5 users)**
   - John Doe (San Francisco properties)
   - Sarah Johnson (Miami properties)
   - Michael Chen (New York properties)
   - Emma Williams (London properties)
   - Carlos Rodriguez (Barcelona properties)

2. **Guests (8 users)**
   - Jane Smith, David Brown, Lisa Anderson, Robert Taylor
   - Maria Garcia, James Wilson, Patricia Martinez, Daniel Lee

3. **Admins (2 users)**
   - admin@airbnb.com
   - support@airbnb.com

### Properties by Location
- **San Francisco, CA**: 2 properties ($120-$150/night)
- **Miami Beach, FL**: 2 properties ($180-$300/night)
- **New York, NY**: 2 properties ($220-$250/night)
- **London, UK**: 2 properties ($160-$175/night)
- **Barcelona, Spain**: 2 properties ($140-$190/night)

### Booking Status Distribution
- **Confirmed**: 10 bookings (with payments)
- **Pending**: 3 bookings (awaiting payment)
- **Canceled**: 2 bookings (no payment processed)

### Payment Methods
- **Credit Card**: 4 payments
- **Stripe**: 4 payments
- **PayPal**: 2 payments

## How to Use

### Prerequisites
- MySQL/MariaDB server running
- Database `airbnb_db` created and schema loaded (from `database-script-0x01/schema.sql`)

### Method 1: Using phpMyAdmin (Recommended for XAMPP users)
1. Open phpMyAdmin: `http://localhost/phpmyadmin`
2. Select the `airbnb_db` database
3. Click the **Import** tab
4. Click **Choose File** and select `seed.sql`
5. Click **Go** to execute
6. Wait for success message

### Method 2: Using MySQL Command Line
```bash
# Navigate to MySQL bin directory (XAMPP)
cd C:\xampp\mysql\bin   # Windows
cd /Applications/XAMPP/xamppfiles/bin   # Mac

# Import the seed data
mysql -u root -p airbnb_db < /path/to/seed.sql

# Or if no password:
mysql -u root airbnb_db < /path/to/seed.sql
```

### Method 3: Using MySQL Client
```bash
# Login to MySQL
mysql -u root -p

# Select database
USE airbnb_db;

# Run the seed script
SOURCE /path/to/database-script-0x02/seed.sql;

# Exit
EXIT;
```

## Verification

After importing, verify the data was loaded correctly:

```sql
-- Check record counts
SELECT 'Users' as TableName, COUNT(*) as RecordCount FROM User
UNION ALL
SELECT 'Properties', COUNT(*) FROM Property
UNION ALL
SELECT 'Bookings', COUNT(*) FROM Booking
UNION ALL
SELECT 'Payments', COUNT(*) FROM Payment
UNION ALL
SELECT 'Reviews', COUNT(*) FROM Review
UNION ALL
SELECT 'Messages', COUNT(*) FROM Message;
```

**Expected Output:**
```
+-----------+-------------+
| TableName | RecordCount |
+-----------+-------------+
| Users     |          15 |
| Properties|          10 |
| Bookings  |          15 |
| Payments  |          10 |
| Reviews   |          12 |
| Messages  |          20 |
+-----------+-------------+
```

### Sample Queries to Test Data

```sql
-- View all properties with host information
SELECT 
    p.name AS property_name,
    p.city,
    p.pricepernight,
    CONCAT(u.first_name, ' ', u.last_name) AS host_name
FROM Property p
JOIN User u ON p.host_id = u.user_id
ORDER BY p.city, p.name;

-- View confirmed bookings with guest details
SELECT 
    b.booking_id,
    p.name AS property_name,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM Booking b
JOIN Property p ON b.property_id = p.property_id
JOIN User u ON b.user_id = u.user_id
WHERE b.status = 'confirmed'
ORDER BY b.start_date;

-- View property ratings
SELECT 
    p.name AS property_name,
    p.city,
    AVG(r.rating) AS avg_rating,
    COUNT(r.review_id) AS review_count
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
GROUP BY p.property_id, p.name, p.city
ORDER BY avg_rating DESC;

-- View recent messages
SELECT 
    CONCAT(sender.first_name, ' ', sender.last_name) AS sender,
    CONCAT(recipient.first_name, ' ', recipient.last_name) AS recipient,
    m.message_body,
    m.sent_at
FROM Message m
JOIN User sender ON m.sender_id = sender.user_id
JOIN User recipient ON m.recipient_id = recipient.user_id
ORDER BY m.sent_at DESC
LIMIT 10;
```

## Data Relationships

### Key Relationships Demonstrated
- ✅ Users can be hosts, guests, or admins
- ✅ Hosts own multiple properties
- ✅ Guests make multiple bookings
- ✅ Properties have multiple bookings from different guests
- ✅ Each confirmed booking has one payment
- ✅ Properties receive multiple reviews from different guests
- ✅ Users send and receive messages

### Foreign Key Integrity
All foreign key relationships are properly maintained:
- `Property.host_id` → `User.user_id`
- `Booking.property_id` → `Property.property_id`
- `Booking.user_id` → `User.user_id`
- `Payment.booking_id` → `Booking.booking_id`
- `Review.property_id` → `Property.property_id`
- `Review.user_id` → `User.user_id`
- `Message.sender_id` → `User.user_id`
- `Message.recipient_id` → `User.user_id`

## Notes

### Password Hashes
- All users have the same password hash for testing: `$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS`
- This is a bcrypt hash of the password: `password123`
- **⚠️ DO NOT use this in production!**

### UUIDs
- All IDs use UUID format (v4)
- UUIDs are pre-generated and consistent across tables
- Pattern: `550e8400-e29b-41d4-a716-44665544XXXX` (User)
- Pattern: `650e8400-e29b-41d4-a716-44665544XXXX` (Property)
- Pattern: `750e8400-e29b-41d4-a716-44665544XXXX` (Booking)
- Pattern: `850e8400-e29b-41d4-a716-44665544XXXX` (Payment)
- Pattern: `950e8400-e29b-41d4-a716-44665544XXXX` (Review)
- Pattern: `A50e8400-e29b-41d4-a716-44665544XXXX` (Message)

### Dates
- User accounts created: January - June 2024
- Properties listed: January - May 2024
- Past bookings: June - October 2024
- Future bookings: November 2025 - March 2026
- Pending bookings: February - March 2026

### Data Realism
- Property prices range from $120-$300 per night
- Booking durations range from 3-7 nights
- Reviews are 4-5 stars with detailed comments
- Payment amounts match booking total prices
- Messages show realistic guest-host communication

## Troubleshooting

### Error: Table doesn't exist
**Solution**: Run the schema script first:
```bash
mysql -u root -p airbnb_db < database-script-0x01/schema.sql
```

### Error: Duplicate entry for key 'PRIMARY'
**Solution**: The database already has data. Clear it first:
```sql
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM Message;
DELETE FROM Review;
DELETE FROM Payment;
DELETE FROM Booking;
DELETE FROM Property;
DELETE FROM User;
SET FOREIGN_KEY_CHECKS = 1;
```

### Error: Cannot add or update a child row: a foreign key constraint fails
**Solution**: This should not occur with this script as it uses `SET FOREIGN_KEY_CHECKS = 0`. If it does:
1. Ensure schema is loaded correctly
2. Check that foreign key relationships exist in schema
3. Run seed script again

## Testing Scenarios

This seed data supports testing:
- ✅ User authentication (all roles)
- ✅ Property search and filtering
- ✅ Booking creation and management
- ✅ Payment processing
- ✅ Review submission and display
- ✅ Messaging between users
- ✅ Host property management
- ✅ Guest booking history
- ✅ Admin user management

## Next Steps

After loading seed data:
1. Test database queries and joins
2. Build API endpoints
3. Create front-end interfaces
4. Implement authentication
5. Add more test scenarios as needed

## Resources

- **Schema Documentation**: `../database-script-0x01/README.md`
- **ER Diagram**: `../ERD/requirements.md`
- **Normalization Analysis**: `../normalization.md`

---

**Created for**: ALX AirBnB Database Project  
**Version**: 1.0  
**Last Updated**: October 2024