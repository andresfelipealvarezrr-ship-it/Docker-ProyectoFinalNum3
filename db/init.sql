CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO users (name, email) VALUES
    ('Richard Betancur', 'richard@example.com'),
    ('Ana Gomez', 'ana@example.com')
ON CONFLICT (email) DO NOTHING;
