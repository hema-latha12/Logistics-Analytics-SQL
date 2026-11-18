-- Solving business questions
select * from orders_cleaned;

-- What is the total number of orders, and how are they distributed 
-- across different statuses?
select status,count(order_id) as total_orders from orders_cleaned
group by status;

-- What is the overall cancellation rate and delivery rate?
select round((canceled_orders/total_orders)*100.0,2) as cancellation_rate,
round((delivered_orders/total_orders)*100.0,2) as delivery_rate from
(select count(*) as total_orders,
sum(case when status='canceled' then 1 else 0 end) as canceled_orders,
sum(case when status='delivered' then 1 else 0 end) as delivered_orders
from orders_cleaned) t;

-- How does the number of orders and total order value change month by month?
select date_format(order_date, '%Y-%m') as year_mon,count(*) as num_orders,
round(sum(total_amount),2) as month_wise_amnt
from orders_cleaned
where order_date is not null
group by date_format(order_date, '%Y-%m');

-- Who are the top 5 customers based on total spending?
select * from customers_cleaned;
select * from orders_cleaned;

select c.customer_id,round(sum(total_amount+shipping_cost),2) as total_spending
from orders_cleaned o
inner join customers_cleaned c
on o.customer_id=c.customer_id
where c.customer_id is not null and o.customer_id is not null
group by o.customer_id
order by total_spending desc
limit 5;


-- Which cities generate the highest revenue?
select c.city,round(sum(total_amount+shipping_cost),2) as total_revenue
from orders_cleaned o
inner join customers_cleaned c
on c.customer_id=o.customer_id
where c.city is not null
group by c.city
order by total_revenue desc;

-- Who are the customers with spending above the average customer spending?
select c.customer_id,c.full_name, 
round(sum(o.total_amount),2) as total_cust_spending
from orders_cleaned o
inner join customers_cleaned c
on o.customer_id=c.customer_id
where o.customer_id is not null
group by c.customer_id,c.full_name
having total_cust_spending > 
(select avg(total_spending) from (
select 
round(sum(o.total_amount),2) as total_spending
from orders_cleaned o
inner join customers_cleaned c
on o.customer_id=c.customer_id
where o.customer_id is not null
group by c.customer_id,c.full_name) as cust_data);

-- Which product categories generate the highest revenue?
select * from products;

select p.category, round(sum(o.total_amount),2) as revenue from products p
inner join orders_cleaned o
on p.product_id=o.product_id
group by p.category
order by revenue desc
limit 1;

-- What are the top 5 best-selling products based on order frequency?
select p.product_name,count(order_id) as order_count
from orders_cleaned o 
inner join products p 
on p.product_id=o.product_id
where product_name is not null
group by p.product_name
order by order_count desc
limit 5;

-- 	Which products have never been ordered?
select p.product_id,p.product_name from products p 
left join orders_cleaned o 
on o.product_id=p.product_id
where o.product_id is null and p.product_name is not null;

-- Which warehouses handle the highest number of orders?
select * from warehouses;

select w.warehouse_id, count(order_id) as num_orders from warehouses w 
inner join orders_cleaned o 
on w.warehouse_id=o.warehouse_id
group by w.warehouse_id
order by num_orders desc;

-- What is the stock utilisation percentage of each warehouse?
select * from warehouses;

select warehouse_id,
round((current_stock/capacity)*100.0,2) as stock_utilisation
from warehouses
group by warehouse_id
order by stock_utilisation desc;

-- Which orders have shipping costs greater than 10% of their order value?
select order_id from orders_cleaned 
where shipping_cost > total_amount*0.1;

-- What is the average customer rating, and how are ratings distributed?
select * from reviews_cleaned;
select round(avg(rating),1) as avg_rating from reviews_cleaned;

select rating,count(*) from reviews_cleaned
group by rating;

-- Which products have the highest average customer ratings?
select p.product_id,p.product_name,round(avg(rating),2) as avg_rating from reviews_cleaned r 
inner join orders_cleaned o
on o.order_id=r.order_id
inner join products p
on p.product_id=o.product_id
where p.product_name is not null
group by p.product_name,p.product_id
order by avg_rating desc;

-- Rank the top 5 customers by revenue using window functions.
select c.customer_id,round(sum(o.total_amount),2) as revenue
from customers_cleaned c 
inner join orders_cleaned o 
on c.customer_id=o.customer_id
group by c.customer_id
order by revenue desc
limit 5;

with cust_revenue as (select c.customer_id,
round(sum(o.total_amount),2) as revenue
from customers_cleaned c 
inner join orders_cleaned o 
on c.customer_id=o.customer_id
group by c.customer_id,c.full_name),

cust_ranking as (select customer_id,
full_name,revenue,rank() over (order by revenue desc) as revenue_rnk)

select * from cust_ranking
where revenue_rnk<=5
order by revenue_rank;
