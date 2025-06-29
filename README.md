# sql-analytics-retail-db
A SQL project analyzing a retail database using advanced queries. Includes customer profitability, product performance, low stock detection, and summary reports using CTEs and subqueries.

# SQL Analytics: Retail Database Insights

This project explores a normalized retail database schema through a series of structured SQL queries. The project showcases skills in SQL querying, data summarization, and business insights generation using subqueries, Common Table Expressions (CTEs), aggregation, and filtering.

## 🔍 Project Overview

The database consists of 8 interconnected tables:
- **customers**
- **products**
- **productlines**
- **orders**
- **orderdetails**
- **payments**
- **employees**
- **offices**

These queries were written using SQLite.

## 📊 Key Insights and Queries

- **Table Structure Summary**: Automatically counts the number of attributes and rows in each table using `PRAGMA table_info()` and `COUNT(*)`.
- **Low Stock Analysis**: Identifies products with high demand relative to stock using correlated subqueries and ranks top 10.
- **Product Performance**: Ranks products by total revenue using sales data from `orderdetails`.
- **Priority Restocking**: Combines low stock and high performance products using CTEs and `IN` to recommend restocking candidates.
- **Customer Profitability**: Calculates total profit per customer based on price and cost difference.
- **Top 5 VIP and Bottom 5 Least-Engaged Customers**: Uses CTEs to identify customer segments for marketing and engagement.
- **Average Customer Profit**: Computes the average profit across all customers.

## 🧠 Skills Demonstrated
- SQL joins and aggregation
- Correlated subqueries
- Common Table Expressions (CTEs)
- Ranking and filtering
- Business logic implementation in SQL

## 📁 Files

- `project.sql`: Contains all queries and explanatory comments.

## 🛠️ Tech Stack

- SQLite (via DB Browser or any SQLite-compatible tool)
- GitHub for version control

---

## 📬 Contact

Mohammed Baaoum  
[GitHub Profile](https://github.com/mbaaoum)
