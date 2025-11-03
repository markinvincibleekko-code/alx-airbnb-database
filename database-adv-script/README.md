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

# Task 2: Apply Aggregations and Window Functions

## Objective
Master SQL aggregation functions and window functions to perform advanced data analysis, ranking, and statistical operations on the AirBnB database.

## Files
- `aggregations_and_window_functions.sql` - Complete SQL implementation

---

## Table of Contents
1. [Aggregation Functions](#aggregation-functions)
2. [Window Functions](#window-functions)
3. [Required Queries](#required-queries)
4. [Advanced Examples](#advanced-examples)
5. [Performance Tips](#performance-tips)

---

## Aggregation Functions

### What are Aggregation Functions?
Aggregation functions perform calculations on a set of rows and return a single value. They are typically used with `GROUP BY` clause.

### Common Aggregate Functions

| Function | Description | Example |
|----------|-------------|---------|
| `COUNT()` | Counts rows | `COUNT(booking_id)` |
| `SUM()` | Adds values | `SUM(total_price)` |
| `AVG()` | Calculates average | `AVG(rating)` |
| `MIN()` | Finds minimum | `MIN(pricepernight)` |
| `MAX()` | Finds maximum | `MAX(total_price)` |
| `STDDEV()` | Standard deviation | `STDDEV(pricepernight)` |
| `VARIANCE()` | Variance | `VARIANCE(rating)` |

---

## Window Functions

### What are Window Functions?
Window functions perform calculations across a set of rows related to the current row, WITHOUT collapsing rows like GROUP BY does.

### Common Window Functions

| Function | Description | Use Case |
|----------|-------------|----------|
| `ROW_NUMBER()` | Sequential number (no ties) | Pagination, unique ranking |
| `RANK()` | Ranking with gaps for ties | Competition ranking |
| `DENSE_RANK()` | Ranking without gaps | Academic grading |
| `NTILE(n)` | Divides into n groups | Quartiles, deciles |
| `LAG()` | Previous row value | Trend analysis |
| `LEAD()` | Next row value | Forecasting |
| `SUM() OVER()` | Running total | Cumulative metrics |
| `AVG() OVER()` | Moving average | Time series analysis |

---

## Required Queries

### Query 1: Total Bookings per User (Aggregation)

#### Basic Implementation
```sql
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name, u.email
ORDER BY total_bookings DESC;
```

#### How It Works:
1. **LEFT JOIN**: Includes all users, even those without bookings
2. **COUNT()**: Counts booking_id for each user
3. **GROUP BY**: Groups results by user (all non-aggregated columns must be in GROUP BY)
4. **ORDER BY**: Sorts by booking count (highest first)

#### Key Components:

**LEFT JOIN vs INNER JOIN:**
- `LEFT JOIN` - Shows all users (including those with 0 bookings)
- `INNER JOIN` - Shows only users with at least 1 booking

**COUNT vs COUNT(*):**
- `COUNT(b.booking_id)` - Counts non-NULL booking_ids
- `COUNT(*)` - Counts all rows (including NULLs)

#### Expected Output:
```
user_id     | first_name | last_name | email                      | total_bookings
------------|------------|-----------|----------------------------|---------------
550e...011  | Jane       | Smith     | jane.smith@example.com     | 3
550e...012  | David      | Brown     | david.brown@example.com    | 2
550e...013  | Lisa       | Anderson  | lisa.anderson@example.com  | 2
550e...020  | Admin      | User      | admin@airbnb.com           | 0
```

#### Enhanced Version with Multiple Aggregations:
```sql
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_spent,
    AVG(b.total_price) AS avg_booking_value,
    MIN(b.total_price) AS min_booking,
    MAX(b.total_price) AS max_booking
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY total_bookings DESC;
```

---

### Query 2: Rank Properties by Bookings (Window Functions)

#### Using ROW_NUMBER()
```sql
SELECT 
    p.property_id,
    p.name AS property_name,
    p.city,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_number_rank
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name, p.city
ORDER BY row_number_rank;
```

**ROW_NUMBER() Characteristics:**
- Assigns **unique** sequential numbers
- Even if properties have same booking count, they get different ranks
- No gaps in numbering: 1, 2, 3, 4, 5...
- **Best for**: Pagination, when you need unique identifiers

#### Using RANK()
```sql
SELECT 
    p.property_id,
    p.name AS property_name,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name
ORDER BY booking_rank;
```

**RANK() Characteristics:**
- Same values get **same rank**
- **Skips** numbers after ties
- Example: 1, 2, 2, 4, 5 (skips 3)
- **Best for**: Competition-style ranking (Olympic medals)

#### Using DENSE_RANK()
```sql
SELECT 
    p.property_id,
    p.name AS property_name,
    COUNT(b.booking_id) AS total_bookings,
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS dense_rank
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name
ORDER BY dense_rank;
```

**DENSE_RANK() Characteristics:**
- Same values get **same rank**
- **No gaps** in numbering after ties
- Example: 1, 2, 2, 3, 4 (no gap)
- **Best for**: Academic grading, when you want consecutive ranks

#### Comparison Example:

| Property | Bookings | ROW_NUMBER | RANK | DENSE_RANK |
|----------|----------|------------|------|------------|
| Beach House | 5 | 1 | 1 | 1 |
| Downtown Apt | 5 | 2 | 1 | 1 |
| Loft | 3 | 3 | 3 | 2 |
| Studio | 2 | 4 | 4 | 3 |
| Condo | 2 | 5 | 4 | 3 |

---

## Understanding Window Function Syntax

### Basic Syntax:
```sql
window_function() OVER (
    [PARTITION BY column]
    [ORDER BY column]
    [ROWS or RANGE frame_specification]
)
```

### Components:

**1. PARTITION BY** (Optional)
- Divides result set into partitions
- Window function applies separately to each partition
- Like GROUP BY, but doesn't collapse rows

```sql
-- Rank properties within each city
RANK() OVER (PARTITION BY p.city ORDER BY COUNT(b.booking_id) DESC)
```

**2. ORDER BY** (Required for most window functions)
- Defines order for window function calculation
- Different from query-level ORDER BY

**3. Frame Specification** (Optional)
- Defines which rows to include in calculation
- `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`
- `ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING`

---

## Advanced Window Function Examples

### Running Total (Cumulative Sum)
```sql
SELECT 
    booking_id,
    created_at,
    total_price,
    SUM(total_price) OVER (ORDER BY created_at) AS running_total
FROM Booking
ORDER BY created_at;
```

### Moving Average (Last 3 bookings)
```sql
SELECT 
    booking_id,
    created_at,
    total_price,
    AVG(total_price) OVER (
        ORDER BY created_at 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3
FROM Booking;
```

### Partition by City
```sql
SELECT 
    p.property_id,
    p.name,
    p.city,
    COUNT(b.booking_id) AS bookings,
    RANK() OVER (PARTITION BY p.city ORDER BY COUNT(b.booking_id) DESC) AS city_rank,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS overall_rank
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name, p.city
ORDER BY p.city, city_rank;
```

### LAG and LEAD (Compare with Previous/Next)
```sql
SELECT 
    user_id,
    created_at AS booking_date,
    total_price,
    LAG(created_at) OVER (PARTITION BY user_id ORDER BY created_at) AS previous_booking,
    LEAD(created_at) OVER (PARTITION BY user_id ORDER BY created_at) AS next_booking,
    total_price - LAG(total_price) OVER (PARTITION BY user_id ORDER BY created_at) AS price_change
FROM Booking;
```

---

## Common Patterns and Use Cases

### 1. Top N per Group
```sql
-- Top 3 properties per city by bookings
SELECT * FROM (
    SELECT 
        p.city,
        p.name,
        COUNT(b.booking_id) AS bookings,
        ROW_NUMBER() OVER (PARTITION BY p.city ORDER BY COUNT(b.booking_id) DESC) AS rn
    FROM Property p
    LEFT JOIN Booking b ON p.property_id = b.property_id
    GROUP BY p.property_id, p.city, p.name
) ranked
WHERE rn <= 3;
```

### 2. Percentage of Total
```sql
SELECT 
    p.property_id,
    p.name,
    COUNT(b.booking_id) AS bookings,
    COUNT(b.booking_id) * 100.0 / SUM(COUNT(b.booking_id)) OVER () AS percentage_of_total
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name;
```

### 3. Quartile Analysis
```sql
SELECT 
    property_id,
    name,
    pricepernight,
    NTILE(4) OVER (ORDER BY pricepernight) AS price_quartile
FROM Property;
```

---

## Key Differences: Aggregation vs Window Functions

| Feature | Aggregation (GROUP BY) | Window Functions |
|---------|------------------------|------------------|
| **Rows returned** | One per group | Same as input |
| **Collapse rows?** | Yes | No |
| **Access to individual rows** | No | Yes |
| **Use with GROUP BY** | Required for non-aggregated columns | Can use after GROUP BY |
| **Example** | `SUM(price) GROUP BY user` | `SUM(price) OVER (PARTITION BY user)` |

### Example Comparison:

**Aggregation (collapses rows):**
```sql
SELECT city, COUNT(*) AS property_count
FROM Property
GROUP BY city;
-- Returns: 3 rows (one per city)
```

**Window Function (keeps all rows):**
```sql
SELECT 
    property_id,
    name,
    city,
    COUNT(*) OVER (PARTITION BY city) AS properties_in_city
FROM Property;
-- Returns: 10 rows (all properties, each showing city count)
```

---

## Performance Optimization

### 1. Index Foreign Keys
```sql
CREATE INDEX idx_booking_user ON Booking(user_id);
CREATE INDEX idx_booking_property ON Booking(property_id);
```

### 2. Avoid Window Functions in WHERE Clause
```sql
-- DON'T DO THIS ❌
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (ORDER BY created_at) AS rn
    FROM Booking
)
WHERE rn = 1;

-- BETTER ✓
SELECT * FROM Booking ORDER BY created_at LIMIT 1;
```

### 3. Use Appropriate Function
- `ROW_NUMBER()` is usually faster than `RANK()` or `DENSE_RANK()`
- Use `EXISTS` instead of `COUNT(*)` for existence checks
- Consider materialized views for complex aggregations

### 4. Analyze Query Performance
```sql
EXPLAIN SELECT 
    u.user_id,
    COUNT(b.booking_id) AS total_bookings
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
GROUP BY u.user_id;
```

---

## Common Mistakes to Avoid

### 1. Forgetting GROUP BY columns
```sql
-- ERROR ❌
SELECT user_id, first_name, COUNT(booking_id)
FROM User u
JOIN Booking b ON u.user_id = b.user_id
GROUP BY user_id;  -- Missing first_name

-- CORRECT ✓
GROUP BY user_id, first_name;
```

### 2. Using aggregate in WHERE instead of HAVING
```sql
-- ERROR ❌
SELECT user_id, COUNT(*) 
FROM Booking 
WHERE COUNT(*) > 3  -- Can't use aggregate in WHERE
GROUP BY user_id;

-- CORRECT ✓
HAVING COUNT(*) > 3;  -- Use HAVING for aggregate conditions
```

### 3. Mixing window functions incorrectly
```sql
-- ERROR ❌
SELECT 
    user_id,
    COUNT(*) AS bookings,  -- Aggregation
    ROW_NUMBER() OVER (ORDER BY user_id) AS rn  -- Window function on wrong level
FROM Booking
GROUP BY user_id;

-- CORRECT ✓
SELECT 
    user_id,
    bookings,
    ROW_NUMBER() OVER (ORDER BY bookings DESC) AS rn
FROM (
    SELECT user_id, COUNT(*) AS bookings
    FROM Booking
    GROUP BY user_id
) subquery;
```

---

## Testing Your Queries

### Test Query 1: Aggregation
```sql
-- Verify counts
SELECT 
    (SELECT COUNT(DISTINCT user_id) FROM User) AS total_users,
    (SELECT COUNT(DISTINCT user_id) FROM Booking) AS users_with_bookings,
    (SELECT COUNT(*) FROM Booking) AS total_bookings;

-- Then run your aggregation query and verify numbers match
```

### Test Query 2: Window Functions
```sql
-- Verify ranking logic
SELECT 
    property_id,
    total_bookings,
    row_num,
    rnk,
    dense_rnk,
    CASE 
        WHEN row_num = rnk AND rnk = dense_rnk THEN 'All same (no ties)'
        WHEN rnk != row_num THEN 'Ties detected'
    END AS ranking_notes
FROM (
    SELECT 
        p.property_id,
        COUNT(b.booking_id) AS total_bookings,
        ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_num,
        RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rnk,
        DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS dense_rnk
    FROM Property p
    LEFT JOIN Booking b ON p.property_id = b.property_id
    GROUP BY p.property_id
) ranked;
```

---

## Summary

### Key Takeaways:
1. **Aggregation functions** reduce multiple rows to single values
2. **Window functions** preserve all rows while adding calculations
3. **ROW_NUMBER** = unique ranks, **RANK** = gaps after ties, **DENSE_RANK** = no gaps
4. Use **PARTITION BY** to create groups within window functions
5. **OVER()** clause is essential for window functions

### When to Use What:
- Need totals/counts per group? → **GROUP BY with COUNT/SUM**
- Need running totals? → **SUM() OVER()**
- Need ranking? → **ROW_NUMBER/RANK/DENSE_RANK**
- Need comparison with previous row? → **LAG/LEAD**
- Need to divide into groups? → **NTILE()**

---

**Project**: ALX AirBnB Database - Advanced SQL Querying  
**Task**: 2 - Apply Aggregations and Window Functions  
**Status**: ✅ Complete