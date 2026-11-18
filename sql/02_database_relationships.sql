-- database relation
-- we did not just created tables before importing the data
-- so we need to create relations
-- join
select * from orders_cleaned o
left join customers_cleaned c
on o.customer_id=c.customer_id
where o.customer_id is not null and c.customer_id is null;


select * from orders_cleaned o
left join products p
on o.product_id=p.product_id
where o.product_id is not null and p.product_id is null;

select * from orders_cleaned o
left join warehouses w
on o.warehouse_id=w.warehouse_id
where o.warehouse_id is not null and w.warehouse_id is null;

select * from reviews_cleaned r
left join orders_cleaned o
on o.order_id=r.order_id
where r.order_id is not null and o.order_id is null;

-- duplicate primary id's
SELECT customer_id, COUNT(*)
FROM customers_cleaned
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT warehouse_id, COUNT(*)
FROM warehouses
GROUP BY warehouse_id
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*)
FROM orders_cleaned
GROUP BY order_id
HAVING COUNT(*) > 1;

-- create foreign key constraints
alter table orders_cleaned -- child
add constraint fk_orders_customers -- constraint name
foreign key (customer_id) -- orders table column
references customers_cleaned(customer_id); -- parent

-- error
-- columns should be index col means primary key or unique

-- modifying the cols to primary key cols
alter table customers_cleaned
add primary key (customer_id);

alter table reviews_cleaned
add primary key (review_id);

alter table orders_cleaned
add primary key (order_id);

alter table products
add primary key (product_id);

alter table warehouses
add primary key (warehouse_id);

-- adding foreign key cols

alter table orders_cleaned
add constraint fk_orders_customers
foreign key (customer_id)
references customers_cleaned(customer_id);

alter table orders_cleaned
add constraint fk_orders_products
foreign key (product_id)
references products(product_id);

alter table orders_cleaned
add constraint fk_orders_warehouse
foreign key (warehouse_id)
references warehouses(warehouse_id);

alter table reviews_cleaned
add constraint fk_reviews_customers
foreign key (order_id)
references orders_cleaned(order_id);
