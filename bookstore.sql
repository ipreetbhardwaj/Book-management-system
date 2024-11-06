-- Step 1: Create Database
CREATE DATABASE IF NOT EXISTS Bookstore;
USE Bookstore;

-- Step 2: Create Tables
-- Authors Table
CREATE TABLE IF NOT EXISTS Authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    bio TEXT
);

-- Books Table
CREATE TABLE IF NOT EXISTS Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    price DECIMAL(5,2),
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE SET NULL
);

-- Customers Table
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

-- Orders Table
CREATE TABLE IF NOT EXISTS Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

-- OrderDetails Table
CREATE TABLE IF NOT EXISTS OrderDetails (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    book_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE
);

-- Step 3: Insert Sample Data
-- Insert Authors
INSERT INTO Authors (name, bio) VALUES
    ('J.K. Rowling', 'Author of the Harry Potter series'),
    ('George R.R. Martin', 'Author of A Song of Ice and Fire'),
    ('J.R.R. Tolkien', 'Author of The Lord of the Rings');

-- Insert Books
INSERT INTO Books (title, genre, price, author_id) VALUES
    ('Harry Potter and the Philosopher''s Stone', 'Fantasy', 19.99, 1),
    ('A Game of Thrones', 'Fantasy', 24.99, 2),
    ('The Hobbit', 'Fantasy', 14.99, 3);

-- Insert Customers
INSERT INTO Customers (name, email, phone) VALUES
    ('Alice Johnson', 'alice@example.com', '123-456-7890'),
    ('Bob Smith', 'bob@example.com', '234-567-8901');

-- Insert Orders
INSERT INTO Orders (order_date, customer_id) VALUES
    ('2023-10-01', 1),
    ('2023-10-02', 2);

-- Insert Order Details
INSERT INTO OrderDetails (order_id, book_id, quantity) VALUES
    (1, 1, 2),
    (1, 3, 1),
    (2, 2, 1);

-- Step 4: Query Data
-- Get all books with their authors
SELECT Books.title, Authors.name AS author
FROM Books
JOIN Authors ON Books.author_id = Authors.author_id;

-- Get all orders with customer and book details
SELECT Orders.order_id, Orders.order_date, Customers.name AS customer, Books.title AS book, OrderDetails.quantity
FROM Orders
JOIN Customers ON Orders.customer_id = Customers.customer_id
JOIN OrderDetails ON Orders.order_id = OrderDetails.order_id
JOIN Books ON OrderDetails.book_id = Books.book_id;

-- Get total sales per book
SELECT Books.title, SUM(OrderDetails.quantity * Books.price) AS total_sales
FROM OrderDetails
JOIN Books ON OrderDetails.book_id = Books.book_id
GROUP BY Books.title;

-- Find customers who have ordered a specific book, e.g., "The Hobbit"
SELECT DISTINCT Customers.name, Customers.email
FROM Customers
JOIN Orders ON Customers.customer_id = Orders.customer_id
JOIN OrderDetails ON Orders.order_id = OrderDetails.order_id
JOIN Books ON OrderDetails.book_id = Books.book_id
WHERE Books.title = 'The Hobbit';
