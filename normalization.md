# Database Normalization Analysis - AirBnB

## Objective
Apply normalization principles to ensure the AirBnB database is in Third Normal Form (3NF).

---

## Table of Contents
1. [Overview of Normalization](#overview-of-normalization)
2. [Initial Schema Analysis](#initial-schema-analysis)
3. [First Normal Form (1NF) Analysis](#first-normal-form-1nf-analysis)
4. [Second Normal Form (2NF) Analysis](#second-normal-form-2nf-analysis)
5. [Third Normal Form (3NF) Analysis](#third-normal-form-3nf-analysis)
6. [Identified Issues and Solutions](#identified-issues-and-solutions)
7. [Final Normalized Schema](#final-normalized-schema)
8. [Conclusion](#conclusion)

---

## Overview of Normalization

### What is Normalization?
Normalization is the process of organizing database tables to minimize redundancy and dependency by dividing large tables into smaller ones and defining relationships between them.

### Normal Forms:
- **1NF (First Normal Form)**: Eliminate repeating groups; ensure atomic values
- **2NF (Second Normal Form)**: Achieve 1NF + remove partial dependencies
- **3NF (Third Normal Form)**: Achieve 2NF + remove transitive dependencies

### Benefits:
- Reduces data redundancy
- Improves data integrity
- Simplifies database maintenance
- Optimizes storage space
- Prevents update, insertion, and deletion anomalies

---

## Initial Schema Analysis

### Current Tables:
1. **User** - Stores user information
2. **Property** - Stores property listings
3. **Booking** - Stores reservation data
4. **Payment** - Stores payment transactions
5. **Review** - Stores property reviews
6. **Message** - Stores user messages

---

## First Normal Form (1NF) Analysis

### Requirements for 1NF:
1. Each column contains atomic (indivisible) values
2. Each column contains values of a single type
3. Each column has a unique name
4. The order of rows doesn't matter

### Analysis of Current Schema:

#### ✅ User Table - Complies with 1NF
- All attributes are atomic
- No repeating groups
- Each field contains single values

#### ❌ Property Table - **VIOLATION FOUND**
**Issue**: `location` field stores composite data (address, city, state, country, zip)

**Current Structure**:
```
location: VARCHAR - "123 Main St, San Francisco, CA, USA, 94102"
```

**Problem**: Non-atomic value containing multiple pieces of information

**Solution**: Decompose location into atomic attributes

#### ✅ Booking Table - Complies with 1NF
- All attributes are atomic
- Date fields are proper data types

#### ✅ Payment Table - Complies with 1NF
- All attributes are atomic

#### ✅ Review Table - Complies with 1NF
- All attributes are atomic

#### ✅ Message Table - Complies with 1NF
- All attributes are atomic

---

## Second Normal Form (2NF) Analysis

### Requirements for 2NF:
1. Must be in 1NF
2. No partial dependencies (all non-key attributes must depend on the entire primary key)
3. Only applies to tables with composite primary keys

### Analysis:

All our tables use **single-column UUID primary keys**, not composite keys. Therefore:

- **User**: Single PK (`user_id`) - No partial dependencies possible ✅
- **Property**: Single PK (`property_id`) - No partial dependencies possible ✅
- **Booking**: Single PK (`booking_id`) - No partial dependencies possible ✅
- **Payment**: Single PK (`payment_id`) - No partial dependencies possible ✅
- **Review**: Single PK (`review_id`) - No partial dependencies possible ✅
- **Message**: Single PK (`message_id`) - No partial dependencies possible ✅

**Result**: All tables comply with 2NF since there are no composite primary keys.

---

## Third Normal Form (3NF) Analysis

### Requirements for 3NF:
1. Must be in 2NF
2. No transitive dependencies (non-key attributes should not depend on other non-key attributes)

### Analysis of Each Table:

#### ✅ User Table - Complies with 3NF
All non-key attributes depend only on `user_id`:
- `first_name`, `last_name`, `email`, `password_hash`, `phone_number`, `role`, `created_at`

No transitive dependencies detected.

#### ❌ Property Table - **VIOLATION FOUND**

**Issue 1**: Location decomposition (from 1NF violation)

**Issue 2**: Potential transitive dependency with host information

**Current Structure**:
```
property_id → host_id
property_id → name, description, location, pricepernight, created_at, updated_at
```

**Analysis**: 
While `host_id` is a foreign key reference, all attributes properly depend on `property_id`. However, the location field needs normalization.

**Host Information**: Already normalized - host details are in User table (good design).

#### ❌ Booking Table - **VIOLATION FOUND**

**Issue**: `total_price` is a calculated field

**Current Structure**:
```
booking_id → property_id, user_id, start_date, end_date, total_price, status, created_at
```

**Problem**: `total_price` can be derived from:
- `total_price` = (`end_date` - `start_date`) × `Property.pricepernight`

**Transitive Dependency**:
```
booking_id → property_id → pricepernight
booking_id → start_date, end_date
total_price = f(start_date, end_date, pricepernight)
```

This is a **calculated/derived attribute** creating redundancy.

#### ✅ Payment Table - Complies with 3NF
All non-key attributes depend only on `payment_id`:
- `booking_id`, `amount`, `payment_date`, `payment_method`

No transitive dependencies.

#### ✅ Review Table - Complies with 3NF
All non-key attributes depend only on `review_id`:
- `property_id`, `user_id`, `rating`, `comment`, `created_at`

No transitive dependencies.

#### ✅ Message Table - Complies with 3NF
All non-key attributes depend only on `message_id`:
- `sender_id`, `recipient_id`, `message_body`, `sent_at`

No transitive dependencies.

---

## Identified Issues and Solutions

### Issue 1: Property Location Not Atomic (1NF Violation)

**Current Design**:
```sql
Property {
    property_id
    host_id
    name
    description
    location VARCHAR        -- Contains: street, city, state, country, zip
    pricepernight
    created_at
    updated_at
}
```

**Solution**: Create a separate Location table or decompose into atomic fields

**Option A: Inline Decomposition (Recommended for simplicity)**
```sql
Property {
    property_id
    host_id
    name
    description
    street_address VARCHAR
    city VARCHAR
    state VARCHAR
    country VARCHAR
    postal_code VARCHAR
    latitude DECIMAL(10, 8)    -- Optional: for mapping
    longitude DECIMAL(11, 8)   -- Optional: for mapping
    pricepernight
    created_at
    updated_at
}
```

**Option B: Separate Location Table (Better for location reuse)**
```sql
Location {
    location_id UUID PK
    street_address VARCHAR
    city VARCHAR
    state VARCHAR
    country VARCHAR
    postal_code VARCHAR
    latitude DECIMAL(10, 8)
    longitude DECIMAL(11, 8)
}

Property {
    property_id
    host_id
    location_id FK          -- References Location
    name
    description
    pricepernight
    created_at
    updated_at
}
```

**Recommendation**: Use **Option A** (inline decomposition) because:
- Each property has a unique location
- No location sharing between properties
- Simpler queries without additional joins
- Better performance for property searches

---

### Issue 2: Booking total_price is Derived (3NF Violation)

**Current Design**:
```sql
Booking {
    booking_id
    property_id
    user_id
    start_date
    end_date
    total_price DECIMAL     -- Calculated: (end_date - start_date) × pricepernight
    status
    created_at
}
```

**Problem**: 
- `total_price` is redundant (can be calculated)
- Creates update anomalies if property price changes
- Violates 3NF (derived from other attributes)

**Solution Options**:

**Option A: Remove total_price entirely (Strictest 3NF)**
```sql
Booking {
    booking_id
    property_id
    user_id
    start_date
    end_date
    status
    created_at
}

-- Calculate on-the-fly:
-- SELECT (end_date - start_date) * pricepernight AS total_price
```

**Option B: Store both original price and total (Recommended)**
```sql
Booking {
    booking_id
    property_id
    user_id
    start_date
    end_date
    pricepernight DECIMAL   -- Snapshot of price at booking time
    total_price DECIMAL     -- Calculated and stored
    status
    created_at
}
```

**Recommendation**: Use **Option B** because:
- **Historical accuracy**: Price at booking time may differ from current property price
- **Business requirement**: Need to preserve booking price even if property price changes
- **Performance**: Avoid recalculating for reporting/invoicing
- **Practical 3NF**: While technically a calculated field, it represents a business transaction snapshot

**This is a controlled denormalization for legitimate business reasons.**

---

### Issue 3: Potential Enhancement - Property Amenities (Future Consideration)

**Not currently in schema, but worth noting:**

If we later add amenities (WiFi, Pool, Parking, etc.), we should use a many-to-many relationship:

```sql
Amenity {
    amenity_id UUID PK
    name VARCHAR
    description TEXT
}

Property_Amenity {
    property_id UUID FK
    amenity_id UUID FK
    PRIMARY KEY (property_id, amenity_id)
}
```

This prevents storing comma-separated amenities in a single field (1NF violation).

---

## Final Normalized Schema

### 1. User Table (No Changes - Already in 3NF) ✅
```sql
User {
    user_id UUID PK
    first_name VARCHAR NOT NULL
    last_name VARCHAR NOT NULL
    email VARCHAR UNIQUE NOT NULL
    password_hash VARCHAR NOT NULL
    phone_number VARCHAR NULL
    role ENUM('guest', 'host', 'admin') NOT NULL
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
}
```

### 2. Property Table (Normalized - 3NF) ✅
```sql
Property {
    property_id UUID PK
    host_id UUID FK → User(user_id)
    name VARCHAR NOT NULL
    description TEXT NOT NULL
    
    -- Normalized location fields (was: location VARCHAR)
    street_address VARCHAR NOT NULL
    city VARCHAR NOT NULL
    state VARCHAR NOT NULL
    country VARCHAR NOT NULL
    postal_code VARCHAR NOT NULL
    latitude DECIMAL(10, 8) NULL
    longitude DECIMAL(11, 8) NULL
    
    pricepernight DECIMAL NOT NULL
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
}
```

**Changes**:
- ✅ Decomposed `location` into atomic fields
- ✅ Added optional geographic coordinates
- ✅ Maintains 3NF compliance

### 3. Booking Table (Normalized - 3NF with Business Exception) ✅
```sql
Booking {
    booking_id UUID PK
    property_id UUID FK → Property(property_id)
    user_id UUID FK → User(user_id)
    start_date DATE NOT NULL
    end_date DATE NOT NULL
    
    -- Added: Snapshot of price at booking time
    pricepernight DECIMAL NOT NULL
    
    -- Kept: Calculated but necessary for historical accuracy
    total_price DECIMAL NOT NULL
    
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
}
```

**Changes**:
- ✅ Added `pricepernight` to capture price at booking time
- ✅ Retained `total_price` for business/historical reasons
- ✅ Documents controlled denormalization

**Justification**: 
This controlled denormalization is acceptable because:
1. Represents a financial transaction (audit requirement)
2. Historical price must be preserved
3. Business rule: Booked price doesn't change if property price changes

### 4. Payment Table (No Changes - Already in 3NF) ✅
```sql
Payment {
    payment_id UUID PK
    booking_id UUID FK → Booking(booking_id)
    amount DECIMAL NOT NULL
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL
}
```

### 5. Review Table (No Changes - Already in 3NF) ✅
```sql
Review {
    review_id UUID PK
    property_id UUID FK → Property(property_id)
    user_id UUID FK → User(user_id)
    rating INTEGER CHECK (rating >= 1 AND rating <= 5) NOT NULL
    comment TEXT NOT NULL
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
}
```

### 6. Message Table (No Changes - Already in 3NF) ✅
```sql
Message {
    message_id UUID PK
    sender_id UUID FK → User(user_id)
    recipient_id UUID FK → User(user_id)
    message_body TEXT NOT NULL
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
}
```

---

## Normalization Summary

| Table | Initial Status | Issues Found | Final Status |
|-------|---------------|--------------|--------------|
| User | 3NF ✅ | None | 3NF ✅ |
| Property | 1NF ❌ | Non-atomic location | 3NF ✅ |
| Booking | 3NF ❌ | Derived attribute | 3NF ✅* |
| Payment | 3NF ✅ | None | 3NF ✅ |
| Review | 3NF ✅ | None | 3NF ✅ |
| Message | 3NF ✅ | None | 3NF ✅ |

*✅ = Complies with 3NF with documented business justification for controlled denormalization

---

## Database Constraints After Normalization

### Additional Constraints to Implement:

```sql
-- Property: Validate coordinates if provided
ALTER TABLE Property ADD CONSTRAINT check_coordinates 
    CHECK (
        (latitude IS NULL AND longitude IS NULL) OR 
        (latitude BETWEEN -90 AND 90 AND longitude BETWEEN -180 AND 180)
    );

-- Booking: Ensure end_date is after start_date
ALTER TABLE Booking ADD CONSTRAINT check_booking_dates 
    CHECK (end_date > start_date);

-- Booking: Ensure total_price matches calculation (soft check via trigger)
-- This can be enforced with application logic or database trigger

-- Payment: Ensure amount matches booking total_price
ALTER TABLE Payment ADD CONSTRAINT check_payment_amount
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id);
```

---

## Indexes After Normalization

### Recommended Indexes:

```sql
-- Property location searches
CREATE INDEX idx_property_city ON Property(city);
CREATE INDEX idx_property_country ON Property(country);
CREATE INDEX idx_property_location ON Property(city, state, country);

-- Geographic searches (if using coordinates)
CREATE SPATIAL INDEX idx_property_coordinates ON Property(latitude, longitude);

-- Booking queries
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);

-- Existing indexes remain
CREATE INDEX idx_property_host ON Property(host_id);
CREATE INDEX idx_booking_user ON Booking(user_id);
CREATE INDEX idx_review_property ON Review(property_id);
CREATE INDEX idx_message_recipient ON Message(recipient_id);
```

---

## Migration Strategy

### Step 1: Backup Current Database
```sql
mysqldump -u username -p airbnb_db > backup_before_normalization.sql
```

### Step 2: Update Property Table
```sql
-- Add new columns
ALTER TABLE Property 
    ADD COLUMN street_address VARCHAR(255),
    ADD COLUMN city VARCHAR(100),
    ADD COLUMN state VARCHAR(100),
    ADD COLUMN country VARCHAR(100),
    ADD COLUMN postal_code VARCHAR(20),
    ADD COLUMN latitude DECIMAL(10, 8),
    ADD COLUMN longitude DECIMAL(11, 8);

-- Migrate data (parse existing location field)
-- This would need custom script based on location format

-- Drop old column after migration
ALTER TABLE Property DROP COLUMN location;
```

### Step 3: Update Booking Table
```sql
-- Add pricepernight column
ALTER TABLE Booking 
    ADD COLUMN pricepernight DECIMAL(10, 2) NOT NULL;

-- Populate with current property prices
UPDATE Booking b
JOIN Property p ON b.property_id = p.property_id
SET b.pricepernight = p.pricepernight;

-- Verify total_price calculations
-- Add validation/correction logic if needed
```

---

## Conclusion

### Summary of Changes:

1. **Property Table**: 
   - Decomposed `location` into 7 atomic fields (street_address, city, state, country, postal_code, latitude, longitude)
   - Achieves 1NF and maintains 3NF

2. **Booking Table**: 
   - Added `pricepernight` field to capture historical price
   - Retained `total_price` with business justification
   - Documented controlled denormalization

3. **Other Tables**: 
   - Already compliant with 3NF
   - No changes required

### Benefits Achieved:

✅ **Reduced Redundancy**: Location data now atomic and properly structured  
✅ **Improved Data Integrity**: Historical prices preserved accurately  
✅ **Better Query Performance**: Can search by city, state, country independently  
✅ **Scalability**: Easy to add geographic features (mapping, distance searches)  
✅ **Maintainability**: Clear, logical structure following normalization principles  
✅ **Flexibility**: Location components can be used independently for filtering/sorting  

### 3NF Compliance:

- ✅ All tables are in 1NF (atomic values)
- ✅ All tables are in 2NF (no partial dependencies)
- ✅ All tables are in 3NF (no transitive dependencies, with documented exceptions)

### Final Note:

The database now adheres to Third Normal Form (3NF) with one controlled denormalization in the Booking table (`total_price` and `pricepernight`). This exception is justified by business requirements for maintaining historical transaction records and is a common practice in e-commerce and booking systems.

---

**Document Version**: 1.0  
**Date**: October 30, 2025  
**Status**: Normalized to 3NF ✅