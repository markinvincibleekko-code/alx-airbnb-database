-- =====================================================
-- AirBnB Database - Sample Data (XAMPP Compatible)
-- Fixed version - No foreign key errors
-- =====================================================

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Clear existing data in correct order (if any)
DELETE FROM Message;
DELETE FROM Review;
DELETE FROM Payment;
DELETE FROM Booking;
DELETE FROM Property;
DELETE FROM User;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- 1. INSERT USERS (15 total: 5 hosts, 8 guests, 2 admins)
-- =====================================================

INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
-- Hosts
('550e8400-e29b-41d4-a716-446655440001', 'John', 'Doe', 'john.doe@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+1-415-555-0101', 'host', '2024-01-15 10:00:00'),
('550e8400-e29b-41d4-a716-446655440002', 'Sarah', 'Johnson', 'sarah.johnson@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+1-305-555-0102', 'host', '2024-02-20 14:30:00'),
('550e8400-e29b-41d4-a716-446655440003', 'Michael', 'Chen', 'michael.chen@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+1-212-555-0103', 'host', '2024-03-10 09:15:00'),
('550e8400-e29b-41d4-a716-446655440004', 'Emma', 'Williams', 'emma.williams@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+44-20-7946-0104', 'host', '2024-04-05 16:45:00'),
('550e8400-e29b-41d4-a716-446655440005', 'Carlos', 'Rodriguez', 'carlos.rodriguez@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+34-91-123-0105', 'host', '2024-05-12 11:20:00'),

-- Guests
('550e8400-e29b-41d4-a716-446655440011', 'Jane', 'Smith', 'jane.smith@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+1-310-555-0111', 'guest', '2024-01-20 08:00:00'),
('550e8400-e29b-41d4-a716-446655440012', 'David', 'Brown', 'david.brown@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+1-512-555-0112', 'guest', '2024-02-14 12:30:00'),
('550e8400-e29b-41d4-a716-446655440013', 'Lisa', 'Anderson', 'lisa.anderson@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+1-617-555-0113', 'guest', '2024-03-01 15:45:00'),
('550e8400-e29b-41d4-a716-446655440014', 'Robert', 'Taylor', 'robert.taylor@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+1-206-555-0114', 'guest', '2024-03-15 10:00:00'),
('550e8400-e29b-41d4-a716-446655440015', 'Maria', 'Garcia', 'maria.garcia@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+34-93-456-0115', 'guest', '2024-04-10 14:20:00'),
('550e8400-e29b-41d4-a716-446655440016', 'James', 'Wilson', 'james.wilson@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+44-161-496-0116', 'guest', '2024-05-05 09:30:00'),
('550e8400-e29b-41d4-a716-446655440017', 'Patricia', 'Martinez', 'patricia.martinez@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+1-713-555-0117', 'guest', '2024-06-01 11:15:00'),
('550e8400-e29b-41d4-a716-446655440018', 'Daniel', 'Lee', 'daniel.lee@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+1-404-555-0118', 'guest', '2024-06-15 13:45:00'),

-- Admins
('550e8400-e29b-41d4-a716-446655440020', 'Admin', 'User', 'admin@airbnb.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+1-800-555-0120', 'admin', '2024-01-01 00:00:00'),
('550e8400-e29b-41d4-a716-446655440021', 'Support', 'Team', 'support@airbnb.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ztP9W8bvZ1eS', '+1-800-555-0121', 'admin', '2024-01-01 00:00:00');

-- =====================================================
-- 2. INSERT PROPERTIES (10 properties)
-- =====================================================

INSERT INTO Property (property_id, host_id, name, description, street_address, city, state, country, postal_code, latitude, longitude, pricepernight, created_at, updated_at) VALUES
('650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Cozy Downtown Apartment', 'Beautiful 2-bedroom apartment in the heart of San Francisco with stunning city views. Walking distance to major attractions.', '123 Market Street, Unit 5B', 'San Francisco', 'California', 'USA', '94102', 37.7749, -122.4194, 150.00, '2024-01-15 10:30:00', '2024-01-15 10:30:00'),
('650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'Modern Studio Near Golden Gate', 'Stylish studio apartment with modern amenities, located near Golden Gate Park.', '789 Fulton Street, Apt 12', 'San Francisco', 'California', 'USA', '94117', 37.7739, -122.4312, 120.00, '2024-02-01 11:00:00', '2024-02-01 11:00:00'),
('650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', 'Beach House Paradise', 'Stunning 3-bedroom beach house with direct ocean access. Features a private pool and spectacular sunset views.', '456 Ocean Drive', 'Miami Beach', 'Florida', 'USA', '33139', 25.7617, -80.1918, 300.00, '2024-02-20 14:45:00', '2024-02-20 14:45:00'),
('650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', 'Art Deco Condo in South Beach', 'Charming 1-bedroom condo in historic Art Deco building. Walking distance to South Beach.', '234 Collins Avenue, Unit 8C', 'Miami Beach', 'Florida', 'USA', '33139', 25.7810, -80.1300, 180.00, '2024-03-05 15:20:00', '2024-03-05 15:20:00'),
('650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440003', 'Manhattan Luxury Loft', 'Spacious 2-bedroom loft in trendy SoHo neighborhood. High ceilings, exposed brick, modern kitchen.', '567 Broadway, Loft 4', 'New York', 'New York', 'USA', '10012', 40.7231, -73.9969, 250.00, '2024-03-10 09:30:00', '2024-03-10 09:30:00'),
('650e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440003', 'Brooklyn Heights Brownstone', 'Elegant 3-bedroom brownstone apartment with historic charm and private garden.', '89 Montague Street, Floor 2', 'Brooklyn', 'New York', 'USA', '11201', 40.6943, -73.9910, 220.00, '2024-03-25 10:15:00', '2024-03-25 10:15:00'),
('650e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440004', 'Chic London Flat Near Tower Bridge', 'Modern 1-bedroom flat with stunning views of Tower Bridge and the Thames.', '12 Shad Thames', 'London', 'England', 'United Kingdom', 'SE1 2YE', 51.5045, -0.0714, 175.00, '2024-04-05 17:00:00', '2024-04-05 17:00:00'),
('650e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440004', 'Covent Garden Studio', 'Charming studio in the heart of Covent Garden theater district.', '45 Floral Street, Flat 3', 'London', 'England', 'United Kingdom', 'WC2E 9DA', 51.5121, -0.1229, 160.00, '2024-04-20 12:30:00', '2024-04-20 12:30:00'),
('650e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440005', 'Gothic Quarter Apartment', 'Historic 2-bedroom apartment in Barcelona Gothic Quarter with balcony overlooking plaza.', '23 Carrer del Bisbe', 'Barcelona', 'Catalonia', 'Spain', '08002', 41.3832, 2.1767, 140.00, '2024-05-12 11:45:00', '2024-05-12 11:45:00'),
('650e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440005', 'Beachfront Apartment in Barceloneta', 'Modern 1-bedroom apartment right on Barceloneta beach with Mediterranean sea views.', '78 Passeig Maritim', 'Barcelona', 'Catalonia', 'Spain', '08003', 41.3793, 2.1896, 190.00, '2024-05-28 14:00:00', '2024-05-28 14:00:00');

-- =====================================================
-- 3. INSERT BOOKINGS (15 bookings)
-- =====================================================

INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, pricepernight, total_price, status, created_at) VALUES
('750e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440011', '2024-06-01', '2024-06-05', 150.00, 600.00, 'confirmed', '2024-05-15 10:00:00'),
('750e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440012', '2024-06-10', '2024-06-17', 300.00, 2100.00, 'confirmed', '2024-05-20 14:30:00'),
('750e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440013', '2024-07-01', '2024-07-04', 250.00, 750.00, 'confirmed', '2024-06-10 09:15:00'),
('750e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440014', '2024-07-15', '2024-07-20', 175.00, 875.00, 'confirmed', '2024-06-25 16:45:00'),
('750e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440015', '2024-08-01', '2024-08-08', 140.00, 980.00, 'confirmed', '2024-07-05 11:20:00'),
('750e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440016', '2025-11-15', '2025-11-18', 120.00, 360.00, 'confirmed', '2025-10-20 08:30:00'),
('750e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440017', '2025-12-01', '2025-12-05', 180.00, 720.00, 'confirmed', '2025-10-25 13:45:00'),
('750e8400-e29b-41d4-a716-446655440008', '650e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440018', '2025-12-20', '2025-12-27', 220.00, 1540.00, 'confirmed', '2025-11-01 10:00:00'),
('750e8400-e29b-41d4-a716-446655440009', '650e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440011', '2026-01-05', '2026-01-10', 160.00, 800.00, 'confirmed', '2025-11-10 15:20:00'),
('750e8400-e29b-41d4-a716-446655440010', '650e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440012', '2026-01-15', '2026-01-22', 190.00, 1330.00, 'confirmed', '2025-11-15 12:00:00'),
('750e8400-e29b-41d4-a716-446655440011', '650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440013', '2026-02-01', '2026-02-05', 150.00, 600.00, 'pending', '2025-10-28 09:30:00'),
('750e8400-e29b-41d4-a716-446655440012', '650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440014', '2026-02-10', '2026-02-14', 300.00, 1200.00, 'pending', '2025-10-29 14:15:00'),
('750e8400-e29b-41d4-a716-446655440013', '650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440015', '2026-03-01', '2026-03-07', 250.00, 1500.00, 'pending', '2025-10-30 11:00:00'),
('750e8400-e29b-41d4-a716-446655440014', '650e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440016', '2024-09-15', '2024-09-20', 175.00, 875.00, 'canceled', '2024-08-10 10:30:00'),
('750e8400-e29b-41d4-a716-446655440015', '650e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440017', '2024-10-01', '2024-10-05', 140.00, 560.00, 'canceled', '2024-09-01 15:45:00');

-- =====================================================
-- 4. INSERT PAYMENTS (10 payments - only for confirmed bookings)
-- =====================================================

INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method) VALUES
('850e8400-e29b-41d4-a716-446655440001', '750e8400-e29b-41d4-a716-446655440001', 600.00, '2024-05-15 10:15:00', 'credit_card'),
('850e8400-e29b-41d4-a716-446655440002', '750e8400-e29b-41d4-a716-446655440002', 2100.00, '2024-05-20 14:45:00', 'stripe'),
('850e8400-e29b-41d4-a716-446655440003', '750e8400-e29b-41d4-a716-446655440003', 750.00, '2024-06-10 09:30:00', 'paypal'),
('850e8400-e29b-41d4-a716-446655440004', '750e8400-e29b-41d4-a716-446655440004', 875.00, '2024-06-25 17:00:00', 'credit_card'),
('850e8400-e29b-41d4-a716-446655440005', '750e8400-e29b-41d4-a716-446655440005', 980.00, '2024-07-05 11:35:00', 'stripe'),
('850e8400-e29b-41d4-a716-446655440006', '750e8400-e29b-41d4-a716-446655440006', 360.00, '2025-10-20 08:45:00', 'credit_card'),
('850e8400-e29b-41d4-a716-446655440007', '750e8400-e29b-41d4-a716-446655440007', 720.00, '2025-10-25 14:00:00', 'paypal'),
('850e8400-e29b-41d4-a716-446655440008', '750e8400-e29b-41d4-a716-446655440008', 1540.00, '2025-11-01 10:15:00', 'stripe'),
('850e8400-e29b-41d4-a716-446655440009', '750e8400-e29b-41d4-a716-446655440009', 800.00, '2025-11-10 15:35:00', 'credit_card'),
('850e8400-e29b-41d4-a716-446655440010', '750e8400-e29b-41d4-a716-446655440010', 1330.00, '2025-11-15 12:15:00', 'stripe');

-- =====================================================
-- 5. INSERT REVIEWS (12 reviews)
-- =====================================================

INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at) VALUES
('950e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440011', 5, 'Absolutely amazing apartment! The location was perfect, just steps from everything in downtown San Francisco. Would definitely book again!', '2024-06-06 14:30:00'),
('950e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440012', 5, 'Paradise found! This beach house exceeded all expectations. The private pool was amazing and the sunset views were breathtaking!', '2024-06-18 11:15:00'),
('950e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440013', 4, 'Great loft in an unbeatable SoHo location. The space was exactly as described. Minor street noise at night but that is typical for NYC. Would stay again.', '2024-07-05 16:45:00'),
('950e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440014', 5, 'Stunning flat with incredible views of Tower Bridge! The location could not be better. Emma was an excellent and responsive host.', '2024-07-21 10:20:00'),
('950e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440015', 4, 'Charming apartment in the heart of Barcelona Gothic Quarter. Great location for exploring the old city. The balcony was a nice touch!', '2024-08-09 13:30:00'),
('950e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440012', 5, 'Perfect San Francisco experience! The apartment was spotlessly clean, cozy, and the location was excellent. John was very helpful with local recommendations.', '2024-07-15 09:00:00'),
('950e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440013', 5, 'Our dream beach vacation! Direct beach access was fantastic. The house had everything we needed and more. Cannot wait to return!', '2024-08-20 15:45:00'),
('950e8400-e29b-41d4-a716-446655440008', '650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440011', 4, 'Lovely Art Deco condo with lots of character. Perfect South Beach location within walking distance of restaurants and nightlife.', '2024-09-10 12:30:00'),
('950e8400-e29b-41d4-a716-446655440009', '650e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440014', 5, 'Beautiful Brooklyn brownstone! The apartment was spacious and tastefully decorated. The private garden was a wonderful surprise and perfect for morning coffee.', '2024-09-25 14:00:00'),
('950e8400-e29b-41d4-a716-446655440010', '650e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440015', 4, 'Great central London location in Covent Garden. Easy access to theaters and restaurants. The studio was cozy and had everything needed for our stay.', '2024-10-05 11:15:00'),
('950e8400-e29b-41d4-a716-446655440011', '650e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440016', 5, 'Beachfront bliss! Mediterranean views were absolutely unforgettable. Modern, spacious, and perfectly located on Barceloneta beach.', '2024-10-15 16:30:00'),
('950e8400-e29b-41d4-a716-446655440012', '650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440017', 5, 'Wonderful studio near Golden Gate Park! Had everything we needed for our San Francisco adventure. John was very helpful and responsive.', '2024-09-30 10:45:00');

-- =====================================================
-- 6. INSERT MESSAGES (20 sample messages)
-- =====================================================

INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
('A50e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440001', 'Hi John! Is your downtown apartment available for the dates I requested?', '2024-05-14 15:30:00'),
('A50e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440011', 'Hi Jane! Yes, the apartment is available. Looking forward to hosting you!', '2024-05-14 16:15:00'),
('A50e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440002', 'Hello Sarah! Does the beach house have parking for two cars?', '2024-05-19 10:00:00'),
('A50e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440012', 'Yes David! There is space for 2 cars in the driveway. See you soon!', '2024-05-19 11:30:00'),
('A50e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440013', '550e8400-e29b-41d4-a716-446655440003', 'Michael, what is the check-in time for the SoHo loft?', '2024-06-09 14:00:00'),
('A50e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440013', 'Hi Lisa! Check-in is anytime after 3 PM. I will meet you there!', '2024-06-09 14:45:00'),
('A50e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440014', '550e8400-e29b-41d4-a716-446655440004', 'Emma, is the flat pet-friendly? We have a small dog.', '2024-06-24 09:30:00'),
('A50e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440014', 'Hi Robert! Unfortunately, the flat is not pet-friendly. Sorry about that!', '2024-06-24 10:15:00'),
('A50e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440015', '550e8400-e29b-41d4-a716-446655440005', 'Carlos, do you provide beach towels and umbrellas at the Barcelona apartment?', '2024-07-04 12:00:00'),
('A50e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440015', 'Hi Maria! Yes, beach towels and umbrellas are provided. Enjoy the beach!', '2024-07-04 13:20:00'),
('A50e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440016', '550e8400-e29b-41d4-a716-446655440001', 'John, can I arrange an early check-in? My flight arrives at 10 AM.', '2025-10-19 16:00:00'),
('A50e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440016', 'Hi James! Early check-in should be fine. I will have the place ready by 11 AM.', '2025-10-19 17:30:00'),
('A50e8400-e29b-41d4-a716-446655440013', '550e8400-e29b-41d4-a716-446655440017', '550e8400-e29b-41d4-a716-446655440002', 'Sarah, is there a washer and dryer in the condo?', '2025-10-24 11:00:00'),
('A50e8400-e29b-41d4-a716-446655440014', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440017', 'Hi Patricia! Yes, there is a washer and dryer in the unit. Detergent is provided too!', '2025-10-24 12:15:00'),
('A50e8400-e29b-41d4-a716-446655440015', '550e8400-e29b-41d4-a716-446655440018', '550e8400-e29b-41d4-a716-446655440003', 'Michael, are there good restaurants nearby?', '2025-10-31 15:30:00'),
('A50e8400-e29b-41d4-a716-446655440016', '550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440018', 'Hi Daniel! Brooklyn Heights has amazing restaurants. I will send you my favorites list!', '2025-10-31 16:45:00'),
('A50e8400-e29b-41d4-a716-446655440017', '550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440004', 'Emma, thank you for a wonderful stay! The view was spectacular!', '2024-07-21 11:00:00'),
('A50e8400-e29b-41d4-a716-446655440018', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440011', 'Thank you Jane! It was a pleasure hosting you. Come back anytime!', '2024-07-21 12:30:00'),
('A50e8400-e29b-41d4-a716-446655440019', '550e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440002', 'Sarah, we left a small gift as a thank you. Check the kitchen counter!', '2024-06-17 10:00:00'),
('A50e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440012', 'David, how sweet! Thank you so much. Hope to host you again soon!', '2024-06-17 11:15:00');

-- =====================================================
-- VERIFICATION QUERIES (Optional - for testing)
-- =====================================================

-- Count all records
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

-- =====================================================
-- END OF SEED DATA
-- =====================================================