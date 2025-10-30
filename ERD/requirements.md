Entity-Relationship Diagram Requirements
Project: AirBnB Database Design

1. Entities
1.1 User
Description: Represents all users in the system (guests, hosts, and admins).
Attributes:

user_id (PK, UUID, Indexed) - Unique identifier for each user
first_name (VARCHAR, NOT NULL) - User's first name
last_name (VARCHAR, NOT NULL) - User's last name
email (VARCHAR, UNIQUE, NOT NULL) - User's email address
password_hash (VARCHAR, NOT NULL) - Hashed password for authentication
phone_number (VARCHAR, NULL) - Optional contact number
role (ENUM: guest, host, admin, NOT NULL) - User's role in the system
created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP) - Account creation timestamp

1.2 Property
Description: Represents rental properties listed by hosts.
Attributes:

property_id (PK, UUID, Indexed) - Unique identifier for each property
host_id (FK → User.user_id) - Reference to the property owner
name (VARCHAR, NOT NULL) - Property name/title
description (TEXT, NOT NULL) - Detailed property description
location (VARCHAR, NOT NULL) - Property location/address
pricepernight (DECIMAL, NOT NULL) - Nightly rental rate
created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP) - Listing creation timestamp
updated_at (TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP) - Last update timestamp

1.3 Booking
Description: Represents reservations made by guests for properties.
Attributes:

booking_id (PK, UUID, Indexed) - Unique identifier for each booking
property_id (FK → Property.property_id) - Reference to booked property
user_id (FK → User.user_id) - Reference to guest making the booking
start_date (DATE, NOT NULL) - Check-in date
end_date (DATE, NOT NULL) - Check-out date
total_price (DECIMAL, NOT NULL) - Total booking cost
status (ENUM: pending, confirmed, canceled, NOT NULL) - Booking status
created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP) - Booking creation timestamp

1.4 Payment
Description: Represents payment transactions for bookings.
Attributes:

payment_id (PK, UUID, Indexed) - Unique identifier for each payment
booking_id (FK → Booking.booking_id) - Reference to associated booking
amount (DECIMAL, NOT NULL) - Payment amount
payment_date (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP) - Payment timestamp
payment_method (ENUM: credit_card, paypal, stripe, NOT NULL) - Payment method used

1.5 Review
Description: Represents guest reviews and ratings for properties.
Attributes:

review_id (PK, UUID, Indexed) - Unique identifier for each review
property_id (FK → Property.property_id) - Reference to reviewed property
user_id (FK → User.user_id) - Reference to reviewer (guest)
rating (INTEGER, CHECK: 1-5, NOT NULL) - Numeric rating (1 to 5 stars)
comment (TEXT, NOT NULL) - Written review text
created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP) - Review creation timestamp

1.6 Message
Description: Represents messages exchanged between users.
Attributes:

message_id (PK, UUID, Indexed) - Unique identifier for each message
sender_id (FK → User.user_id) - Reference to message sender
recipient_id (FK → User.user_id) - Reference to message recipient
message_body (TEXT, NOT NULL) - Message content
sent_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP) - Message timestamp


2. Relationships
2.1 User ↔ Property (One-to-Many)

Relationship Name: Hosts/Owns
Cardinality: One User (host) can own multiple Properties
Foreign Key: Property.host_id references User.user_id
Business Rule: A property must have exactly one host; a host can list multiple properties

2.2 User ↔ Booking (One-to-Many)

Relationship Name: Makes/Books
Cardinality: One User (guest) can make multiple Bookings
Foreign Key: Booking.user_id references User.user_id
Business Rule: A booking must be made by exactly one guest; a guest can make multiple bookings

2.3 Property ↔ Booking (One-to-Many)

Relationship Name: Has/Is Booked
Cardinality: One Property can have multiple Bookings
Foreign Key: Booking.property_id references Property.property_id
Business Rule: A booking is for exactly one property; a property can have multiple bookings (different dates)

2.4 Booking ↔ Payment (One-to-One)

Relationship Name: Has/Pays For
Cardinality: One Booking has one Payment
Foreign Key: Payment.booking_id references Booking.booking_id
Business Rule: Each booking should have exactly one payment; each payment is for exactly one booking

2.5 User ↔ Review (One-to-Many)

Relationship Name: Writes/Authors
Cardinality: One User (guest) can write multiple Reviews
Foreign Key: Review.user_id references User.user_id
Business Rule: A review is written by exactly one user; a user can write multiple reviews

2.6 Property ↔ Review (One-to-Many)

Relationship Name: Receives/Has
Cardinality: One Property can have multiple Reviews
Foreign Key: Review.property_id references Property.property_id
Business Rule: A review is for exactly one property; a property can have multiple reviews

2.7 User ↔ Message (Sender) (One-to-Many)

Relationship Name: Sends
Cardinality: One User can send multiple Messages
Foreign Key: Message.sender_id references User.user_id
Business Rule: A message has exactly one sender; a user can send multiple messages

2.8 User ↔ Message (Recipient) (One-to-Many)

Relationship Name: Receives
Cardinality: One User can receive multiple Messages
Foreign Key: Message.recipient_id references User.user_id
Business Rule: A message has exactly one recipient; a user can receive multiple messages


3. Constraints Summary
3.1 Primary Key Constraints

All entities have UUID primary keys
All primary keys are automatically indexed

3.2 Foreign Key Constraints

Property.host_id → User.user_id
Booking.property_id → Property.property_id
Booking.user_id → User.user_id
Payment.booking_id → Booking.booking_id
Review.property_id → Property.property_id
Review.user_id → User.user_id
Message.sender_id → User.user_id
Message.recipient_id → User.user_id

3.3 Unique Constraints

User.email must be unique

3.4 Check Constraints

Review.rating must be between 1 and 5 (inclusive)

3.5 NOT NULL Constraints

All required fields as specified in the entity definitions

3.6 ENUM Constraints

User.role: {guest, host, admin}
Booking.status: {pending, confirmed, canceled}
Payment.payment_method: {credit_card, paypal, stripe}


4. Indexing Strategy
4.1 Primary Key Indexes (Automatic)

User.user_id
Property.property_id
Booking.booking_id
Payment.payment_id
Review.review_id
Message.message_id

4.2 Additional Indexes

User.email (for unique constraint and login queries)
Property.property_id (for faster property lookups)
Booking.property_id (for property booking queries)
Booking.booking_id (for payment and booking status queries)

4.3 Recommended Additional Indexes (Performance Optimization)

Property.host_id (for host property listings)
Booking.user_id (for user booking history)
Review.property_id (for property review aggregation)
Review.user_id (for user review history)
Message.sender_id (for sent messages queries)
Message.recipient_id (for inbox queries)


5. ER Diagram Representation Notes
Notation to Use:

Rectangles: Entities
Ovals/Ellipses: Attributes
Diamonds: Relationships
Lines: Connections between entities and relationships
Cardinality Notation:

1 for one
M or N for many
1:1 for one-to-one
1:M for one-to-many
M:N for many-to-many



Key Visual Elements:

Primary keys should be underlined
Foreign keys should be clearly marked
Relationship cardinalities should be labeled
Entity names should be in singular form
Use consistent formatting and alignment


6. Business Rules

User Registration: Users must provide email, password, name, and role
Property Listing: Only users with 'host' role can create properties
Booking Creation: Only users with 'guest' role can create bookings
Payment Processing: Every confirmed booking must have an associated payment
Review Submission: Only guests who have completed bookings can review properties
Message Exchange: All users can send and receive messages
Status Management: Bookings can transition: pending → confirmed → canceled
Date Validation: Booking end_date must be after start_date
Price Calculation: Booking total_price = (end_date - start_date) × pricepernight


7. Implementation Tools
Recommended ER Diagram Tools:

Draw.io (diagrams.net) - Free, web-based
Lucidchart - Professional, feature-rich
dbdiagram.io - Database-specific, code-driven
MySQL Workbench - MySQL-specific with reverse engineering
ERDPlus - Educational, simple interface


8. Deliverables

ER Diagram Image: Visual representation showing:

All 6 entities
All attributes per entity
All 8 relationships with cardinality
Primary and foreign key indicators


Requirements Document: This document containing:

Entity definitions
Relationship descriptions
Constraints and business rules
Indexing strategy


File Structure:

   alx-airbnb-database/
   └── ERD/
       ├── requirements.md (this file)
       └── airbnb_erd.png (ER diagram image)

Document Version

Version: 1.0
Date: October 30, 2025
Author: Database Design Team