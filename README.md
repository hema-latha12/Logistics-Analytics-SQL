
# Logistics Analytics using SQL

## Project Overview

The **Logistics Analytics** project focuses on analyzing logistics and supply chain operations using MySQL. The project involves data cleaning, database management, relational table creation, and solving 15 real-world business questions using SQL queries.

The objective is to gain insights into order performance, customer spending, product demand, warehouse operations, shipping costs, and customer feedback.

## Tools & Technologies

- **Database:** MySQL
- **IDE:** MySQL Workbench 8.0.46
- **Language:** SQL
- **Concepts:** Data Cleaning, Joins, Aggregate Functions, Subqueries, CTEs, Window Functions, Primary Keys, Foreign Keys

## Dataset Overview

The project uses a logistics dataset containing five main tables:

| Table | Number of Records |
|---|---:|
| Customers | 300 |
| Products | 200 |
| Warehouses | 50 |
| Orders | 500 |
| Reviews | 150 |

## Data Cleaning & Preparation

Data preparation was performed to improve data consistency and support accurate analysis.

Key activities included:

- Handling missing and empty values.
- Converting columns into appropriate data types.
- Cleaning customer, order, and review data.
- Validating primary and foreign key relationships.
- Identifying missing product information without inventing replacement values.

## Database Structure

The project uses the following tables:

- `customers_cleaned`
- `products`
- `warehouses`
- `orders_cleaned`
- `reviews_cleaned`

Relationships were established using primary keys and foreign keys to maintain referential integrity.

## Business Questions & Analysis

The project answers 15 business questions, including:

1. What is the total number of orders, and how are they distributed by status?
2. What are the overall cancellation and delivery rates?
3. How do order volume and order value change monthly?
4. Who are the top 5 customers based on total spending?
5. Which cities generate the highest order value?
6. Which customers spend more than the average customer?
7. Which product categories generate the highest order value?
8. What are the top 5 best-selling products?
9. Which products have never been ordered?
10. Which warehouses handle the highest number of orders?
11. What is the stock utilisation percentage of each warehouse?
12. Which orders have shipping costs greater than 10% of their order value?
13. What is the average customer rating and rating distribution?
14. Which products have the highest average customer ratings?
15. Who are the top 5 customers ranked by revenue using window functions?

## Key SQL Concepts Used

- SELECT, WHERE, ORDER BY
- GROUP BY and HAVING
- INNER JOIN and LEFT JOIN
- Aggregate Functions: COUNT, SUM, AVG
- CASE Statements
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions: RANK()
- Date Functions
- Data Cleaning Functions: TRIM(), NULLIF(), STR_TO_DATE()

## Repository Structure

```text
Logistics-Analytics-SQL/
│
├── README.md
│
├── data/
│   └── Original dataset CSV files
│
├── sql/
│   ├── 01_data_cleaning.sql
│   ├── 02_database_relationships.sql
│   └── 03_business_analysis.sql
│
└── insights/
    └── business_insights.md
```

## Project Outcomes

- Practiced cleaning and preparing real-world-style logistics data.
- Built relational database relationships using primary and foreign keys.
- Applied SQL techniques to solve business problems.
- Analyzed customer, product, order, warehouse, and shipping data.
- Developed analytical thinking and data interpretation skills.

## Author

**Hemalatha Chilukuri**

B.Tech – Computer Science and Engineering

Interested in Data Analytics, SQL, Python, and Business Intelligence.
