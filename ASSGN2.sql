
CREATE SCHEMA order_schema;

CREATE TABLE order_schema.product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    stock_quantity INT
);

INSERT INTO order_schema.product (product_id, product_name, price, stock_quantity)
VALUES
    (1, 'Laptop', 999.99, 50),
    (2, 'Smartphone', 499.99, 100),
    (3, 'Headphones', 149.99, 200),
    (4, 'Monitor', 199.99, 75);

CREATE TABLE order_schema.customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(15)
);

INSERT INTO order_schema.customer (customer_id, first_name, last_name, email, phone_number)
VALUES
    (1, 'John', 'Doe', 'john.doe@example.com', '555-1234'),
    (2, 'Jane', 'Smith', 'jane.smith@example.com', '555-5678'),
    (3, 'Emily', 'Jones', 'emily.jones@example.com', '555-8765');

CREATE TABLE order_schema.status (
    status_id INT PRIMARY KEY,
    status_name VARCHAR(50)
);

INSERT INTO order_schema.status (status_id, status_name)
VALUES
    (1, 'Shipped'),
    (2, 'Pending'),
    (3, 'Cancelled');

CREATE TABLE order_schema.orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    status_id INT,
    FOREIGN KEY (customer_id) REFERENCES order_schema.customer(customer_id),
    FOREIGN KEY (status_id) REFERENCES order_schema.status(status_id)
);	

INSERT INTO order_schema.orders (order_id, customer_id, order_date, total_amount, status_id)
VALUES
    (1, 1, '2025-02-15', 1499.98, 1),
    (2, 2, '2025-02-16', 199.99, 2),
    (3, 3, '2025-02-17', 499.99, 1),
    (4, 1, '2025-02-18', 149.99, 3);

CREATE TABLE order_schema.order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES order_schema.orders(order_id),
    FOREIGN KEY (product_id) REFERENCES order_schema.product(product_id)
);

INSERT INTO order_schema.order_items (order_item_id, order_id, product_id, quantity, price)
VALUES
    (1, 1, 1, 1, 999.99),  -- 1 Laptop in Order 1
    (2, 1, 2, 1, 499.99),  -- 1 Smartphone in Order 1
    (3, 2, 3, 2, 149.99),  -- 2 Headphones in Order 2
    (4, 3, 2, 1, 499.99),  -- 1 Smartphone in Order 3
    (5, 4, 3, 1, 149.99);  -- 1 Headphones in Order 4

CREATE TABLE order_schema.order_history (
    history_id INT PRIMARY KEY,
    order_id INT,
    status_change_date DATE,
    status_description VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES order_schema.orders(order_id)
);

INSERT INTO order_schema.order_history (history_id, order_id, status_change_date, status_description)
VALUES
    (1, 1, '2025-02-15', 'Order Placed'),
    (2, 1, '2025-02-16', 'Payment Processed'),
    (3, 2, '2025-02-16', 'Order Placed'),
    (4, 3, '2025-02-17', 'Order Placed'),
    (5, 3, '2025-02-18', 'Payment Processed'),
    (6, 4, '2025-02-18', 'Order Placed');

--QUESTION 1
SELECT c.customer_id,c.first_name,c.last_name,s.status_name
FROM  order_schema.orders o JOIN order_schema.customer c ON o.customer_id=c.customer_id
JOIN order_schema.status s ON o.status_id=s.status_id;

--QUESTION 2
SELECT customer_id,SUM(total_amount) FROM
order_schema.orders WHERE
order_date BETWEEN '2025-02-15' AND '2025-02-16'
GROUP BY customer_id;

--QUESTION 3
SELECT order_id,order_date,customer_id,total_amount FROM
order_schema.orders ORDER BY total_amount DESC
LIMIT 1;

--QUESTION 4
SELECT p.product_id,product_name , SUM(o.price*quantity) AS revenue FROM
order_schema.product p JOIN order_schema.order_items o
ON p.product_id=o.product_id
GROUP BY p.product_id;

--QUESTION 5
SELECT order_id,customer_id,(CASE WHEN total_amount IS NULL THEN 0.00 ELSE total_amount END )AS total_amount
FROM order_schema.orders;

--QUESTION 6
SELECT o.customer_id,o.order_date,o.total_amount,status_description,quantity,product_name,
p.price FROM
order_schema.orders o JOIN order_schema.order_history oh ON o.order_id=oh.order_id
JOIN order_schema .order_items oi ON o.order_id=oi.order_id
JOIN order_schema.product p ON oi.product_id=p.product_id 
WHERE o.customer_id=3;

--QUESTION 7
SELECT customer_id , AVG(total_amount) AS avg_amount FROM
order_schema.orders WHERE order_date>=CURRENT_DATE-INTERVAL '30 days'
GROUP BY customer_id;

--QUESTION 8
SELECT product_name,total_sold FROM(
SELECT  product_name,SUM(oi.quantity) AS total_sold ,RANK() OVER (ORDER BY SUM(oi.quantity) DESC)
AS rnk FROM 
order_schema.order_items oi JOIN order_schema.product p
ON oi.product_id=p.product_id
GROUP BY p.product_id
) t
WHERE rnk<=5;

--QUESTION 9
SELECT customer_id,first_name,last_name FROM(
SELECT c.customer_id,first_name,last_name,MAX(o.order_date) AS last_order FROM
order_schema.customer c JOIN order_schema.orders o 
ON c.customer_id=o.customer_id
GROUP BY c.customer_id ) t
WHERE last_order<CURRENT_DATE-INTERVAL '60 days';
)

--QUESTION 10
SELECT o.order_id,product_id,order_date FROM
order_schema.order_items oi JOIN 
order_schema.orders o 
ON oi.order_id=o.order_id
WHERE quantity>1 
ORDER BY order_date;

--QUESTION 11
SELECT status_description ,COUNT(*) AS total_orders , SUM(total_amount) AS revenue 
FROM order_schema.orders o JOIN order_schema.order_history oh 
ON o.order_id=oh.order_id
GROUP BY status_description;

SET search_path to order_schema;

--QUESTION 12
SELECT first_name, last_name FROM 
customer c JOIN orders o ON
c.customer_id=o.customer_id
JOIN order_items oi ON
o.order_id=oi.order_id
WHERE quantity>1;

--QUESTION 13
SELECT product_name FROM 
product p LEFT JOIN order_items oi 
ON p.product_id=oi.product_id
WHERE quantity IS NULL;

--QUESTION 14
SELECT SUM(quantity) AS number_orders_last_seven_days 
FROM orders o JOIN order_items oi
ON o.order_id=oi.order_id
WHERE order_date>CURRENT_DATE-INTERVAL '7 days';

--QUESTION 15
CREATE VIEW view_product AS 
SELECT * FROM product;


--QUESTION 16
CREATE VIEW order_summary AS 
SELECT o.order_id,customer_id,order_date,total_amount,
status_description AS status_name 
FROM orders o JOIN order_history oh 
ON o.order_id=oh.order_id;

