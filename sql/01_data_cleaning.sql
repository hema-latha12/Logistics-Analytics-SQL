-- Logistics Analytics Project
-- Data Cleaning Queries

create database Logistics_Analysis;

use Logistics_Analysis;

drop database Logistics_Analysis;

show tables;

rename table `logistics-performance-insights-v4-csv-customers` to customers;
rename table `logistics_analysis`.`logistics-performance-insights-v4-csv-orders` to orders;
rename table `logistics_analysis`.`logistics-performance-insights-v4-csv-products` to products;
rename table `logistics_analysis`.`logistics-performance-insights-v4-csv-reviews` to reviews;
rename table `logistics_analysis`.`logistics-performance-insights-v4-csv-warehouses` to warehouses;

-- check record count
select count(*) from customers;
select count(*) from orders;
select count(*) from products;
select count(*) from reviews;
select count(*) from warehouses;

-- inspect the data
select * from customers limit 10;
select * from orders limit 10;
select * from products limit 10;
select * from reviews limit 10;
select * from warehouses limit 10;

-- check null vals and do data profiling in customers_table
select count(*) from customers
where full_name is null or full_name = ''; -- 27

select count(*) from customers
where email is null or email = ''; -- 57

select count(*) from customers
where phone is null or phone = ''; -- 30

select count(*) from customers
where city is null or city = ''; -- 36

SELECT
    ROUND(100.0 * SUM(full_name IS NULL OR full_name = '') / COUNT(*), 2) AS missing_name_pct,
    ROUND(100.0 * SUM(email IS NULL OR email = '') / COUNT(*), 2) AS missing_email_pct,
    ROUND(100.0 * SUM(phone IS NULL OR phone = '') / COUNT(*), 2) AS missing_phone_pct,
    ROUND(100.0 * SUM(city IS NULL OR city = '') / COUNT(*), 2) AS missing_city_pct
FROM customers;

select * from orders where customer_id=6; 
select * from orders where customer_id=4; -- we cannot delete those customer ids they are ordering orders too...

-- check for duplicates
select id,count(*) from customers
group by id
having count(*)>1; -- not any

select email,count(*) from customers
where email is not null and email <> ''
group by email
having count(*)>1; -- 1 duplicate found

select id,email,email_count from
(select id,email,count(*) over (partition by email) as email_count
from customers
where email is not null and email <> '') t
where email_count>1; -- 2 id's found for 2 times with same email

select * from customers
where id in (9,200); -- means two people but same name not same people using same email within diff location

select phone,count(*) from customers
where phone is not null and phone <> ''
group by phone
having count(*)>1; -- some found

select id,phone,phone_count,city from
(select id,phone,city,count(*) over (partition by phone) as phone_count
from customers
where phone is not null and phone <> '') t
where phone_count>1; -- many found

select * from customers
where phone='+1-202-555-0119'; -- 2 members with same number diff loc

-- may be shared emails or phone numbers
SELECT
    email,
    COUNT(*) AS customer_count,
    GROUP_CONCAT(id) AS customer_ids,
    GROUP_CONCAT(city) AS cities
FROM customers
WHERE email IS NOT NULL
  AND TRIM(email) <> ''
GROUP BY email
HAVING COUNT(*) > 1;

SELECT
    phone,
    COUNT(*) AS customer_count,
    GROUP_CONCAT(id) AS customer_ids,
    GROUP_CONCAT(city) AS cities
FROM customers
WHERE phone IS NOT NULL
  AND TRIM(phone) <> ''
GROUP BY phone
HAVING COUNT(*) > 1;

-- make a copy for all tables
create table c as (select * from customers);
create table o as (select * from orders);
create table r as (select * from reviews);
create table p as (select * from products);
create table w as (select * from warehouses);

drop table c;
drop table o;
drop table r;
drop table w;
drop table p;


-- table created to handle empty strings
CREATE TABLE customers_cleaned AS
SELECT
    id,
    NULLIF(TRIM(full_name), '') AS full_name,
    NULLIF(TRIM(email), '') AS email,
    NULLIF(TRIM(phone), '') AS phone,
    NULLIF(TRIM(city), '') AS city
FROM customers;

select * from customers_cleaned;

-- change the id to customer_id
alter table customers_cleaned rename column id to customer_id;

select * from customers_cleaned;

-- check null vals and do data profiling in products_table
select * from products;
select category,count(*) from products
group by 1; -- only 2 cate

SELECT
    MIN(id) AS first_id,
    MAX(id) AS last_id,
    COUNT(*) AS total_records,
    COUNT(DISTINCT id) AS unique_ids
FROM products; -- 131

select * from products
where lower(category)='clothing'; -- not any 

desc products;

select * from products
where id between 5 and 12; -- no 8 means not showing missing id's

select id,product_name,category,price from products
order by id;

-- now we understood that clothing of 69 records were skipped we can add it like
create table products_clothing_import(
id int,
product_name text,
category text,
price text);
-- after converting price to text it imported the 69 records that are empty

select * from products_clothing_import;

insert into products (id,product_name,category,price)
select id,product_name,category,nullif(trim(price),'') from products_clothing_import;

-- whether the datatypes are showing correctly
desc products;

select * from products;

-- update product names to null
set sql_safe_updates=0;
update products
set product_name=null
where product_name='';

alter table products rename column id to product_id;

select category,count(*) from products
group by category;

-- check null vals and do data profiling in warehouse_table
select * from warehouses limit 10;

desc warehouses;

-- checking null values count
select count(*) from warehouses
where id is null or id = '';

select count(*) from warehouses
where location is null or location = '';

select count(*) from warehouses
where capacity is null or capacity = '';

select count(*) from warehouses
where current_stock is null or trim(current_stock) = '';

select count(*) from warehouses
where last_inventory_check is null or last_inventory_check = '';

alter table warehouses rename column id to warehouse_id;

-- check null vals and do data profiling in reviews_table
select * from reviews limit 10;

select count(*) from reviews
where id is null or id = '';

select count(*) from reviews
where order_id is null or order_id = '';

select count(*) from reviews
where rating is null or rating = '';

select count(*) from reviews
where comment is null or comment = ''; -- 9

select count(*) from reviews
where review_date is null or review_date = ''; -- 20

select count(*) from reviews;

-- check for duplicates
select id,count(*) from reviews
group by id
having count(*)>1;

desc reviews;

select * from reviews;

create table reviews_cleaned as(
select id,order_id,rating,
nullif(trim(comment),'') as comment,
str_to_date(nullif(trim(review_date),''),'%Y-%m-%d %H:%i:%s') as review_date from reviews);

select * from reviews_cleaned;

alter table reviews_cleaned rename column id to review_id;

desc reviews_cleaned;

select * from reviews_cleaned
where order_id=5;

-- now orders table
desc orders;

select * from orders limit 10;

-- check for null values
select 
sum(id is null or id='') as missing_ids,
sum(customer_id is null or customer_id='') as missing_custs,
sum(product_id is null or product_id='') as missing_prods,
sum(warehouse_id is null or warehouse_id='') as missing_warehouses,
sum(order_date is null or order_date='') as missing_dates,
sum(status is null or status='') as missing_status,
sum(total_amount is null or total_amount='') as missing_amount,
sum(shipping_cost is null or shipping_cost='') as missing_shipping
from orders;

select * from orders;

alter table orders rename column id to order_id;

select 
sum(order_id is null or order_id='') as missing_ids,
sum(customer_id is null or customer_id='') as missing_custs,
sum(product_id is null or product_id='') as missing_prods,
sum(warehouse_id is null or warehouse_id='') as missing_warehouses,
sum(order_date is null or order_date='') as missing_dates,
sum(status is null or status='') as missing_status,
sum(total_amount is null or total_amount='') as missing_amount,
sum(shipping_cost is null or shipping_cost='') as missing_shipping
from orders;

select status,count(*) as total_orders,
SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS missing_customer,
SUM(product_id IS NULL OR TRIM(product_id) = '') AS missing_product,
SUM(warehouse_id IS NULL OR TRIM(warehouse_id) = '') AS missing_warehouse,
SUM(order_date IS NULL OR TRIM(order_date) = '') AS missing_date
from orders
group by status;

create table orders_cleaned as(
select order_id,
cast(nullif(trim(customer_id),'') as unsigned) as customer_id,
cast(nullif(trim(product_id),'') as unsigned) as product_id,
cast(nullif(trim(warehouse_id),'') as unsigned) as warehouse_id,
str_to_date(nullif(trim(order_date),''), '%Y-%m-%d %H:%i:%s') as order_date,
nullif(trim(status),'') as status,
total_amount,shipping_cost
from orders);

select * from orders_cleaned;

desc orders_cleaned;

-- all checks
desc customers_cleaned;
desc products;
desc warehouses;
desc reviews_cleaned;
desc orders_cleaned;

-- change data types acc to the parent tables in child table(orders_cleaned)
alter table orders_cleaned
modify customer_id int null,
modify warehouse_id int null,
modify product_id int null;
