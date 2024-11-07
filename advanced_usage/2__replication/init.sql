CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    price DECIMAL
);

INSERT INTO products (name, price) VALUES
('Product A', 10.99),
('Product B', 20.50),
('Product C', 15.00);
