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