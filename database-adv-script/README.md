# Task 0: Complex Queries with Joins

## Objective
Master SQL joins by writing complex queries using different types of joins to retrieve data from multiple related tables in the AirBnB database.

## Files
- `joins_queries.sql` - Contains all SQL join queries

## Database Schema Overview
The queries interact with the following tables:
- **User** - Stores user information (guests, hosts, admins)
- **Property** - Stores property listings
- **Booking** - Stores booking information
- **Review** - Stores property reviews
- **Payment** - Stores payment transactions

## Queries Implemented

### 1. INNER JOIN Query
**Purpose**: Retrieve all bookings and the respective users who made those bookings.

**SQL Join Type**: `INNER JOIN`

**Description**: 
- Combines the `Booking` table with the `User` table
- Returns only records where there is a match in both tables
- Shows booking details along with user information who made the booking

**Key Fields Returned**:
- Booking ID, dates, total price, status
- User ID, name, email, phone number

**Use Case**: When you need to see all confirmed bookings with complete guest information.

---

### 2. LEFT JOIN Query
**Purpose**: Retrieve all properties and their reviews, including properties that have no reviews.

**SQL Join Type**: `LEFT JOIN`

**Description**:
- Returns all properties from the `Property` table
- Includes matching reviews from the `Review` table
- Properties without reviews will show NULL values for review fields
- Additional LEFT JOIN with `User` table to get reviewer information

**Key Fields Returned**:
- Property ID, name, city, country, price per night
- Review ID, rating, comment, review date
- Reviewer's first and last name

**Use Case**: When you want to analyze all properties, including those that haven't received any reviews yet. Useful for identifying properties that need attention.

---

### 3. FULL OUTER JOIN Query
**Purpose**: Retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user.

**SQL Join Type**: `FULL OUTER JOIN` (simulated in MySQL)

**Description**:
- Returns all users, whether they have bookings or not
- Returns all bookings, even if somehow not linked to a user
- **Important Note**: MySQL doesn't support FULL OUTER JOIN natively
- We simulate it using `UNION` of `LEFT JOIN` and `RIGHT JOIN`

**MySQL Implementation**:
```sql
LEFT JOIN ... UNION ... RIGHT JOIN
```

**PostgreSQL Implementation** (if available):
```sql
FULL OUTER JOIN
```

**Key Fields Returned**:
- User ID, name, email, role
- Booking ID, dates, total price, status
- Property name

**Use Case**: When you need to see all users (including those who haven't made bookings) and all bookings (including any orphaned records). Useful for data auditing and finding data integrity issues.

---

## Bonus Queries

### Bonus 1: Complete Booking Information
Retrieves comprehensive booking details including:
- Guest information
- Property details
- Host information
- Payment information

Uses multiple INNER JOINs and one LEFT JOIN to create a complete booking record view.

### Bonus 2: Property Ratings Summary
Aggregates review data to show:
- Total number of reviews per property
- Average rating per property
- Host information

Uses GROUP BY with aggregate functions (COUNT, AVG) combined with joins.

---

## How to Run the Queries

### Prerequisites
- MySQL or PostgreSQL database installed
- AirBnB database schema created (from `schema.sql`)
- Sample data loaded (from `seed.sql`)

### Execution Steps

1. **Connect to your database**:
   ```bash
   mysql -u your_username -p airbnb_database
   ```

2. **Run the queries file**:
   ```bash
   source /path/to/joins_queries.sql
   ```

3. **Or execute individual queries**:
   - Copy a specific query from the file
   - Paste it into your MySQL/PostgreSQL client
   - Execute and review results

---

## Expected Results

### Query 1 (INNER JOIN)
- Should return **15 rows** (all bookings with user information)
- No NULL values as INNER JOIN only returns matching records

### Query 2 (LEFT JOIN)
- Should return **10+ rows** (one row per property-review combination)
- Properties without reviews will appear with NULL review fields
- Some properties may appear multiple times if they have multiple reviews

### Query 3 (FULL OUTER JOIN)
- Should return **15+ rows** (all users and all bookings)
- Users without bookings will show NULL booking fields
- All bookings should be linked to users in this dataset

---

## Key Learning Points

### INNER JOIN
- Returns only matching records from both tables
- Most restrictive join type
- Use when you only want records that exist in both tables

### LEFT JOIN (LEFT OUTER JOIN)
- Returns all records from the left table
- Includes matching records from the right table
- NULL values for non-matching right table records
- Use when you want all records from the primary table

### FULL OUTER JOIN
- Returns all records from both tables
- NULL values where no match exists
- Most inclusive join type
- Use for comprehensive data auditing

### MySQL vs PostgreSQL
- MySQL doesn't support FULL OUTER JOIN directly
- Use UNION of LEFT and RIGHT JOINs as workaround
- PostgreSQL supports FULL OUTER JOIN natively

---

## Performance Considerations

1. **Indexes**: Ensure foreign key columns are indexed:
   - `Booking.user_id`
   - `Booking.property_id`
   - `Review.property_id`
   - `Review.user_id`

2. **Query Optimization**:
   - Use EXPLAIN to analyze query execution plans
   - Avoid SELECT * in production; specify needed columns
   - Consider adding composite indexes for frequently joined columns

3. **Large Datasets**:
   - Add LIMIT clauses for testing
   - Use pagination for user-facing queries
   - Consider materialized views for complex aggregations

---

## Common Issues and Solutions

### Issue 1: "Unknown column in field list"
**Solution**: Verify column names match the schema exactly (case-sensitive in some databases)

### Issue 2: Cartesian product (too many rows)
**Solution**: Ensure JOIN conditions are properly specified with ON clause

### Issue 3: FULL OUTER JOIN not supported
**Solution**: Use the UNION approach provided for MySQL compatibility

---

## Testing Queries

### Verify INNER JOIN Results
```sql
-- Should match the count of bookings
SELECT COUNT(*) FROM Booking;
```

### Verify LEFT JOIN Results
```sql
-- Should equal total properties
SELECT COUNT(DISTINCT property_id) FROM Property;
```

### Verify FULL OUTER JOIN Results
```sql
-- Should include all users
SELECT COUNT(*) FROM User;
```

---

## Additional Resources

- [MySQL JOIN Documentation](https://dev.mysql.com/doc/refman/8.0/en/join.html)
- [PostgreSQL JOIN Documentation](https://www.postgresql.org/docs/current/queries-table-expressions.html)
- [SQL Join Visualizer](https://sql-joins.leopard.in.ua/)

---

## Author Notes

These queries demonstrate fundamental SQL join operations essential for:
- Data retrieval across related tables
- Building comprehensive reports
- Understanding database relationships
- Preparing for advanced analytics

Master these joins before moving to subqueries and complex aggregations in subsequent tasks.

---

## Next Steps

After completing this task:
1. Review the query results to understand the data relationships
2. Experiment with different JOIN types to see how results change
3. Move to Task 1: Power of Subqueries
4. Apply these join concepts to more complex scenarios

---

**Project**: ALX AirBnB Database - Advanced SQL Querying  
**Task**: 0 - Write Complex Queries with Joins  
**Status**: ✅ Complete
# Task 1: Practice Subqueries

## Objective
Master both correlated and non-correlated subqueries to perform advanced data retrieval and filtering operations in SQL.

## Files
- `subqueries.sql` - Contains all subquery implementations

---

## Understanding Subqueries

### What is a Subquery?
A subquery (also called an inner query or nested query) is a SQL query nested inside a larger query. It can be used in SELECT, INSERT, UPDATE, or DELETE statements.

### Types of Subqueries

#### 1. **Non-Correlated Subquery**
- Executes **independently** of the outer query
- Runs **once** and returns result to outer query
- Can be executed standalone
- Generally **faster** for large datasets

#### 2. **Correlated Subquery**
- References columns from the **outer query**
- Executes **repeatedly** (once per row of outer query)
- Cannot be executed independently
- Generally **slower** but more flexible

---

## Required Queries Implementation

### Query 1: Non-Correlated Subquery
**Objective**: Find all properties where the average rating is greater than 4.0

#### Understanding the Query:
```sql
SELECT p.property_id, p.name, p.city, p.country
FROM Property p
WHERE p.property_id IN (
    SELECT r.property_id
    FROM Review r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
);
```

#### How It Works:
1. **Inner Query (Subquery)** runs first:
   - Groups reviews by property
   - Calculates average rating for each property
   - Filters properties with average > 4.0
   - Returns list of property_ids

2. **Outer Query** runs second:
   - Selects properties from Property table
   - Filters only those property_ids returned by subquery

#### Why Non-Correlated?
- The subquery doesn't reference any columns from the outer query
- It can run independently: `SELECT property_id FROM Review GROUP BY property_id HAVING AVG(rating) > 4.0`
- It executes **once** and returns a result set

#### Expected Results:
Based on the seed data, this should return properties like:
- Cozy Downtown Apartment (multiple 5-star reviews)
- Beach House Paradise (5-star reviews)
- Manhattan Luxury Loft (4-star reviews)

---

### Query 2: Correlated Subquery
**Objective**: Find users who have made more than 3 bookings

#### Understanding the Query:
```sql
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    (SELECT COUNT(*) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) AS total_bookings
FROM User u
WHERE (
    SELECT COUNT(*) 
    FROM Booking b 
    WHERE b.user_id = u.user_id
) > 3;
```

#### How It Works:
1. **Outer Query** starts processing User table row by row

2. **Inner Query (Correlated Subquery)** executes for each user:
   - References `u.user_id` from outer query (correlation)
   - Counts bookings for that specific user
   - Returns the count

3. **Filter** applies: Only users with count > 3 are returned

#### Why Correlated?
- The subquery references `u.user_id` from the outer query
- It **cannot** run independently (no `u.user_id` context)
- It executes **multiple times** (once per user in User table)

#### Execution Flow:
```
For each user in User table:
  1. Get user_id from current row
  2. Count bookings WHERE booking.user_id = this user_id
  3. If count > 3, include this user in results
```

#### Performance Note:
Correlated subqueries can be slower on large datasets because they execute repeatedly. Consider using JOINs with GROUP BY for better performance.

#### Expected Results:
Based on the seed data (15 bookings, 8 guests):
- Most users have 1-2 bookings
- Some users might have no results if none exceed 3 bookings
- Adjust threshold to test: change `> 3` to `> 0` to see all users with bookings

---

## Query Comparison: Subquery vs JOIN

### Same Result, Different Approach:

#### Using Subquery (Non-Correlated):
```sql
SELECT p.name
FROM Property p
WHERE p.property_id IN (
    SELECT property_id 
    FROM Review 
    GROUP BY property_id 
    HAVING AVG(rating) > 4.0
);
```

#### Using JOIN (Often Faster):
```sql
SELECT p.name
FROM Property p
INNER JOIN (
    SELECT property_id, AVG(rating) as avg_rating
    FROM Review
    GROUP BY property_id
    HAVING AVG(rating) > 4.0
) r ON p.property_id = r.property_id;
```

**When to Use Subqueries vs JOINs?**
- **Subqueries**: Better for existence checks (EXISTS), better readability for complex conditions
- **JOINs**: Generally faster, better for retrieving data from multiple tables

---

## Subquery Locations

Subqueries can appear in different parts of SQL statements:

### 1. In SELECT Clause (Scalar Subquery)
```sql
SELECT 
    p.name,
    (SELECT AVG(rating) FROM Review r WHERE r.property_id = p.property_id) AS avg_rating
FROM Property p;
```

### 2. In WHERE Clause
```sql
SELECT * FROM Property
WHERE property_id IN (SELECT property_id FROM Review WHERE rating = 5);
```

### 3. In FROM Clause (Derived Table)
```sql
SELECT * FROM (
    SELECT property_id, AVG(rating) as avg_rating
    FROM Review
    GROUP BY property_id
) AS property_ratings
WHERE avg_rating > 4.0;
```

### 4. In HAVING Clause
```sql
SELECT property_id, COUNT(*) as review_count
FROM Review
GROUP BY property_id
HAVING COUNT(*) > (SELECT AVG(review_count) FROM (
    SELECT COUNT(*) as review_count 
    FROM Review 
    GROUP BY property_id
) AS counts);
```

---

## Subquery Operators

### IN Operator
```sql
WHERE property_id IN (SELECT property_id FROM Review WHERE rating > 4)
```
Checks if value exists in subquery result set.

### EXISTS Operator
```sql
WHERE EXISTS (SELECT 1 FROM Booking b WHERE b.user_id = u.user_id)
```
Returns TRUE if subquery returns any rows. More efficient than IN for large datasets.

### NOT EXISTS Operator
```sql
WHERE NOT EXISTS (SELECT 1 FROM Booking b WHERE b.user_id = u.user_id)
```
Finds records that don't have matching records in subquery.

### Comparison Operators (=, >, <, >=, <=, !=)
```sql
WHERE total_price > (SELECT AVG(total_price) FROM Booking)
```

### ALL Operator
```sql
WHERE rating > ALL (SELECT rating FROM Review WHERE property_id = '123')
```
Compares to all values returned by subquery.

### ANY/SOME Operator
```sql
WHERE rating > ANY (SELECT rating FROM Review WHERE property_id = '123')
```
Compares to any value returned by subquery.

---

## Bonus Queries Explained

### Find Users Who Have Never Made a Booking
```sql
SELECT u.* FROM User u
WHERE NOT EXISTS (
    SELECT 1 FROM Booking b WHERE b.user_id = u.user_id
);
```
**Use Case**: Identify inactive users, target for marketing campaigns

### Find Properties That Have Never Been Booked
```sql
SELECT p.* FROM Property p
WHERE NOT EXISTS (
    SELECT 1 FROM Booking b WHERE b.property_id = p.property_id
);
```
**Use Case**: Identify underperforming properties, adjust pricing or marketing

### Find Properties with Ratings Above Overall Average
```sql
SELECT p.name, AVG(r.rating) as avg_rating
FROM Property p
JOIN Review r ON p.property_id = r.property_id
GROUP BY p.property_id
HAVING AVG(r.rating) > (SELECT AVG(rating) FROM Review);
```
**Use Case**: Highlight top-performing properties, "Featured" listings

---

## Performance Considerations

### 1. Correlated Subqueries Can Be Slow
**Problem**: Executes once per row of outer query
```sql
-- Slow for large tables
SELECT u.*, 
    (SELECT COUNT(*) FROM Booking b WHERE b.user_id = u.user_id)
FROM User u;
```

**Solution**: Use JOIN instead
```sql
-- Faster alternative
SELECT u.*, COUNT(b.booking_id) as booking_count
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
GROUP BY u.user_id;
```

### 2. Use EXISTS Instead of IN for Large Datasets
**Why?**: EXISTS stops searching once it finds a match

```sql
-- Better performance
WHERE EXISTS (SELECT 1 FROM Booking b WHERE b.user_id = u.user_id)

-- vs
WHERE user_id IN (SELECT user_id FROM Booking)
```

### 3. Index Foreign Key Columns
Ensure indexes exist on:
- `Booking.user_id`
- `Booking.property_id`
- `Review.property_id`

### 4. Use EXPLAIN to Analyze Performance
```sql
EXPLAIN SELECT * FROM Property p
WHERE p.property_id IN (
    SELECT property_id FROM Review GROUP BY property_id HAVING AVG(rating) > 4.0
);
```

---

## Testing the Queries

### Test Query 1 (Non-Correlated)
```sql
-- First, check which properties have reviews
SELECT property_id, AVG(rating) as avg_rating, COUNT(*) as review_count
FROM Review
GROUP BY property_id
ORDER BY avg_rating DESC;

-- Then run the subquery
SELECT p.property_id, p.name, p.city
FROM Property p
WHERE p.property_id IN (
    SELECT property_id FROM Review GROUP BY property_id HAVING AVG(rating) > 4.0
);
```

**Expected**: Properties with 4+ star average ratings

### Test Query 2 (Correlated)
```sql
-- First, check booking counts per user
SELECT user_id, COUNT(*) as booking_count
FROM Booking
GROUP BY user_id
ORDER BY booking_count DESC;

-- Adjust threshold based on data
SELECT u.user_id, u.first_name, u.last_name,
    (SELECT COUNT(*) FROM Booking b WHERE b.user_id = u.user_id) as bookings
FROM User u
WHERE (SELECT COUNT(*) FROM Booking b WHERE b.user_id = u.user_id) > 1;
```

**Expected**: Users with more than specified number of bookings

---

## Common Mistakes to Avoid

### 1. Using Column Alias in WHERE
```sql
-- WRONG ❌
SELECT u.*, (SELECT COUNT(*) FROM Booking b WHERE b.user_id = u.user_id) as cnt
FROM User u
WHERE cnt > 3;

-- CORRECT ✓
SELECT * FROM (
    SELECT u.*, (SELECT COUNT(*) FROM Booking b WHERE b.user_id = u.user_id) as cnt
    FROM User u
) tmp
WHERE tmp.cnt > 3;
```

### 2. Forgetting GROUP BY with Aggregate Functions
```sql
-- WRONG ❌
SELECT property_id FROM Review HAVING AVG(rating) > 4.0;

-- CORRECT ✓
SELECT property_id FROM Review GROUP BY property_id HAVING AVG(rating) > 4.0;
```

### 3. Using SELECT * in Subqueries When Not Needed
```sql
-- INEFFICIENT ❌
WHERE EXISTS (SELECT * FROM Booking b WHERE b.user_id = u.user_id)

-- EFFICIENT ✓
WHERE EXISTS (SELECT 1 FROM Booking b WHERE b.user_id = u.user_id)
```

---

## Advanced Techniques

### Nested Subqueries (Subquery within Subquery)
```sql
SELECT p.name
FROM Property p
WHERE p.pricepernight > (
    SELECT AVG(pricepernight)
    FROM Property
    WHERE city IN (
        SELECT city FROM Property GROUP BY city HAVING COUNT(*) > 2
    )
);
```

### Correlated Subquery with Multiple Conditions
```sql
SELECT u.*
FROM User u
WHERE (SELECT COUNT(*) FROM Booking b WHERE b.user_id = u.user_id) > 3
  AND (SELECT SUM(total_price) FROM Booking b WHERE b.user_id = u.user_id) > 1000;
```

---

## Summary

| Feature | Non-Correlated | Correlated |
|---------|----------------|------------|
| **Independence** | Runs independently | Depends on outer query |
| **Execution** | Once | Once per outer row |
| **Performance** | Generally faster | Can be slower |
| **Use Case** | Fixed filtering conditions | Row-by-row comparisons |
| **Readability** | Often clearer | More complex |

---

## Next Steps

1. Test all queries with your database
2. Use EXPLAIN to analyze performance
3. Try converting correlated subqueries to JOINs
4. Move to Task 2: Aggregations and Window Functions

---

**Project**: ALX AirBnB Database - Advanced SQL Querying  
**Task**: 1 - Practice Subqueries  
**Status**: ✅ Complete