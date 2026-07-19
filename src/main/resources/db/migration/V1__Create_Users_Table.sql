CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    status ENUM('ACTIVE', 'INACTIVE') NOT NULL
);

-- Insert prerequisite data
INSERT INTO users (username, email, status) VALUES 
('john_doe', 'john@example.com', 'ACTIVE'),
('jane_smith', 'jane@example.com', 'INACTIVE'),
('bob_wilson', 'bob@example.com', 'ACTIVE')
ON DUPLICATE KEY UPDATE username=username;