-- This database contains 8 tables: Customers, Products, ProductLines, Orders,
-- OrderDetails, Payments, Employees, and Offices.
-- Below is a brief description of each table and how they are linked:

-- 1. customers: Stores customer information.
--    Linked to: orders (customerNumber), payments (customerNumber),
--               employees (salesRepEmployeeNumber).

-- 2. products: Stores product details.
--    Linked to: productlines (productLine), orderdetails (productCode).

-- 3. productlines: Categories of products.
--    Linked to: products (productLine).

-- 4. orders: Contains orders placed by customers.
--    Linked to: orderdetails (orderNumber), customers (customerNumber).

-- 5. orderdetails: Line items of orders.
--    Linked to: orders (orderNumber), products (productCode).

-- 6. payments: Stores customer payments.
--    Linked to: customers (customerNumber).

-- 7. employees: Contains employee data.
--    Linked to: customers (salesRepEmployeeNumber), offices (officeCode), self (reportsTo).

-- 8. offices: Stores office details.
--    Linked to: employees (officeCode).

-- Customers
SELECT 'Customers' AS table_name, 
       (SELECT COUNT(*) FROM pragma_table_info('customers')) AS number_of_attributes,
       (SELECT COUNT(*) FROM customers) AS number_of_rows
UNION ALL

-- Products
SELECT 'Products', 
       (SELECT COUNT(*) FROM pragma_table_info('products')),
       (SELECT COUNT(*) FROM products)
UNION ALL

-- ProductLines
SELECT 'ProductLines', 
       (SELECT COUNT(*) FROM pragma_table_info('productlines')),
       (SELECT COUNT(*) FROM productlines)
UNION ALL

-- Orders
SELECT 'Orders', 
       (SELECT COUNT(*) FROM pragma_table_info('orders')),
       (SELECT COUNT(*) FROM orders)
UNION ALL

-- OrderDetails
SELECT 'OrderDetails', 
       (SELECT COUNT(*) FROM pragma_table_info('orderdetails')),
       (SELECT COUNT(*) FROM orderdetails)
UNION ALL

-- Payments
SELECT 'Payments', 
       (SELECT COUNT(*) FROM pragma_table_info('payments')),
       (SELECT COUNT(*) FROM payments)
UNION ALL

-- Employees
SELECT 'Employees', 
       (SELECT COUNT(*) FROM pragma_table_info('employees')),
       (SELECT COUNT(*) FROM employees)
UNION ALL

-- Offices
SELECT 'Offices', 
       (SELECT COUNT(*) FROM pragma_table_info('offices')),
       (SELECT COUNT(*) FROM offices);
	   
	   
	   -- Step 1 & 2: Define CTEs
WITH low_stock_cte AS (
  SELECT 
    p.productCode,
    ROUND(
      (SELECT SUM(od.quantityOrdered)
       FROM orderdetails od
       WHERE od.productCode = p.productCode) * 1.0 / p.quantityInStock, 2
    ) AS low_stock
  FROM products p
  GROUP BY p.productCode
  ORDER BY low_stock DESC
  LIMIT 10
),
performance_cte AS (
  SELECT 
    od.productCode,
    SUM(od.quantityOrdered * od.priceEach) AS product_performance
  FROM orderdetails od
  GROUP BY od.productCode
  ORDER BY product_performance DESC
  LIMIT 10
)

-- Step 3: Join the two on productCode using IN
SELECT 
  l.productCode,
  l.low_stock
FROM low_stock_cte l
WHERE l.productCode IN (
  SELECT p.productCode FROM performance_cte p
);

SELECT customerNumber, SUM(ODS.quantityOrdered)* (ODS.priceEach - p.buyPrice) AS profit 
FROM orderdetails AS ODS
JOIN orders AS O
ON o.orderNumber = ODS.orderNumber
JOIN products AS p
ON p.productCode = ODS.productCode
GROUP BY customerNumber
ORDER BY profit  DESC;



WITH Profit AS (
  SELECT 
    o.customerNumber, 
    SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)) AS profit
  FROM products p
  JOIN orderdetails od ON p.productCode = od.productCode
  JOIN orders o ON o.orderNumber = od.orderNumber
  GROUP BY o.customerNumber
),

-- Step 2: Top 5 VIP customers
Top_Five AS (
  SELECT 
    c.contactLastName,
    c.contactFirstName,
    c.city,
    c.country,
    p.profit
  FROM customers c
  JOIN Profit p ON c.customerNumber = p.customerNumber
  ORDER BY p.profit DESC
  LIMIT 5
),

-- Step 3: Bottom 5 least-engaged customers
Bottom_Five AS (
  SELECT 
    c.contactLastName,
    c.contactFirstName,
    c.city,
    c.country,
    p.profit
  FROM customers c
  JOIN Profit p ON c.customerNumber = p.customerNumber
  ORDER BY p.profit ASC
  LIMIT 5
)

-- Final step: Combine both sets
SELECT * FROM Top_Five
UNION ALL
SELECT * FROM Bottom_Five;
    
---Average Customer Profit
WITH Profit AS (
  SELECT 
    o.customerNumber, 
    SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)) AS profit
  FROM products p
  JOIN orderdetails od ON p.productCode = od.productCode
  JOIN orders o ON o.orderNumber = od.orderNumber
  GROUP BY o.customerNumber
)
SELECT 
  ROUND(AVG(profit), 2) AS avg_customer_profit
FROM Profit;
    