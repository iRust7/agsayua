-- Add Admin User for Testing
-- Password: Admin123! (hashed with bcrypt cost 10)

-- Insert admin user
INSERT INTO users (email, password_hash, full_name, phone, role, is_active, created_at, updated_at)
VALUES (
    'admin@ecommerce.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMye7Ij08xdJ7xc7qLY4RqX6H1TLqKzGfPq', -- bcrypt hash for 'Admin123!'
    'Admin User',
    '+1234567890',
    'admin',
    1,
    NOW(),
    NOW()
) ON DUPLICATE KEY UPDATE email=email;

-- Verify admin user was created
SELECT id, email, full_name, role, is_active, created_at FROM users WHERE role = 'admin';
