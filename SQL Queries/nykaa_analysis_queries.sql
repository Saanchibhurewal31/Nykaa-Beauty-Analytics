-- ============================================================
-- NYKAA-STYLE ANALYSIS: MERGED SQL QUERIES
-- ============================================================

USE NYKKA;

-- ============================================================
-- 0. TABLE PREVIEWS
-- ============================================================

select * from customers;
select * from orders;
select * from order_payments;
select * from products;


-- ============================================================
-- 1. TOP 10 MOST SELLING PRODUCTS (by revenue)
-- ============================================================

select p.product_id, p.product_name, round(sum(op.final_price)) as revenue
from order_payments op
join products p
on p.product_id = op.product_id
group by p.product_id, p.product_name
order by revenue desc
limit 10;


-- ============================================================
-- 2. TOP 20 CUSTOMERS (by revenue)
-- ============================================================

select c.customer_id, round(sum(op.final_price)) as Revenue
from customers c
join
orders o
on c.customer_id = o.customer_id
join
order_payments op
on o.order_id = op.order_id
group by c.customer_id
order by revenue desc 
limit 20;


-- ============================================================
-- 3. REPEAT CUSTOMERS PERCENTAGE
-- ============================================================

with Repeated_cust as 
(
select customer_id,
count(customer_id) as Total_customers from orders
group by customer_id
having total_customers > 1
)
select 
round(
 count(distinct rc.customer_id) * 100
 /
 count(distinct o.customer_id), 2) 
as repeated_cust_perct
from orders o
left join repeated_cust rc
on o.customer_id = rc.customer_id;


-- ============================================================
-- 4. REVENUE DIFFERENCE: PREMIUM vs NON-PREMIUM MEMBERS
-- ============================================================

with premium_members as
 (
select c.is_premium_member, round(sum(op.final_price)) premium_revenue
from order_payments op
join 
orders o
on op.order_id = o.order_id 
join
customers c 
on c.customer_id = o.customer_id
where c.is_premium_member = "yes"
group by c.is_premium_member
),

 non_premium_members as (
select c.is_premium_member, round(sum(op.final_price)) as non_premium_revenue
from order_payments op
join 
orders o
on op.order_id = o.order_id 
join
customers c 
on c.customer_id = o.customer_id
where c.is_premium_member = "no"
group by c.is_premium_member
)
SELECT
    premium_revenue,
    non_premium_revenue,
    premium_revenue - non_premium_revenue AS revenue_difference
FROM premium_members
CROSS JOIN non_premium_members;


-- ============================================================
-- 5. REVENUE BY AGE GROUP
-- ============================================================

select
case
when c.age < 25 then 'Under_25'
when c.age between 25 and 34 then '25-34' 
WHEN c.age BETWEEN 35 AND 44 THEN '35-44'
ELSE '45+'
end as age_group,
    ROUND(SUM(op.final_price)) AS revenue
from order_payments op
join orders o
on op.order_id = o.order_id
join customers c
on o.customer_id = c.customer_id
group by age_group
order by revenue desc;


-- ============================================================
-- 6. REVENUE BY GENDER
-- ============================================================

select c.gender, round(sum(op.final_price)) as revenue 
from order_payments op
join 
orders o
on o.order_id = op.order_id
join 
customers c
on c.customer_id = o.customer_id
group by c.gender;


-- ============================================================
-- 7. Revenue and order count by product category
-- ============================================================

select category, 
count(order_id)as Total_order,
round(sum(final_price)) as Revenue
from order_payments 
group by category;

-- ============================================================
-- 8. Month-over-month revenue trend
-- ============================================================

select month(o.Order_date) as Order_month,
round(sum(op.final_price)) as revenue
from order_payments op
join orders o
on o.order_id = op.order_id
group by order_month
order by order_month asc;

-- ============================================================
-- 9. Average order value overall and by category
-- ============================================================

select category,
round(avg(final_price)) as Average_order_value
from order_payments 
group by category;

-- =========================================
-- 10. Revenue lost to discounts/coupons
-- =========================================

select round(sum(discount_amount)) as Lost_revenue
from order_payments;

-- =========================================
-- 11. Running total of revenue by month
-- =========================================

with Running_total as 
(
select month(o.order_date)	 as Order_month,
round(sum(op.final_price)) as Revenue
from Order_payments op
join 
orders o
on O.order_id = op.order_id
group by order_month
)
select 
order_month,
revenue,
sum(revenue) over( order by order_month asc) as running_total
from running_total;

-- =========================================
-- 12. Rank customers within each city by spend 
-- =========================================

with cust_rank as
( 
select c.customer_id, c.city,
round(sum(op.final_price)) as Revenue
from order_payments op
join orders o
on o.order_id = op.order_id
join customers c
on c.customer_id = o.customer_id
group by c.customer_id, c.city
)
select 
customer_id,
city,
revenue,
dense_rank() over(partition by city order by revenue desc) as cust_rank
from Cust_rank;

-- =========================================
-- 13. Customer lifetime value
-- =========================================

with Cust_value as 
( 
select c.customer_id,
round(sum(op.final_price)) as Revenue
from order_payments op
join 
orders o
on o.order_id = op.order_id
join customers c
on c.customer_id = o.customer_id
group by c.customer_id
)
select 
customer_id,
revenue,
dense_rank() over(order by revenue desc) as Customer_value
from cust_value;

-- last order date

select max(order_date) as last_order_date from orders;


-- =========================================
-- 14. Customers who haven't ordered in the last X days (churn-risk flag)
-- =========================================

with cust_churn as
(
select customer_id,
datediff('2026-03-31',max(order_date)) as Gap
from orders
group by customer_id
)
select 
customer_id,
gap,
case 
when gap > 200 then 'lost'
when gap between 120 and 200 then 'loyal'
when gap < 120 then 'Valuable' 
end as customer_status
from cust_churn;


with Returned_Revenue as 
(
select o.order_status,
round(sum(op.final_price)) as revenue
from order_payments op
join orders o
on o.order_id = op.order_id
join customers c
on c.customer_id = o.customer_id
group by O.order_status
having o.order_status = "returned"
),

new_customer_revenue 
as 
(
select 
count(distinct c.customer_id) as new_customers,
round(sum(op.final_price)) as revenue
from order_payments op
join orders o
on o.order_id = op.order_id
join customers c
on c.customer_id = o.customer_id
),

first_orders as (
select customer_id, 
min(order_date) as first_order_date
from orders
group by customer_id
)
select 
r.revenue as returned_revenue,
n.revenue as new_customer_revenue,
r.revenue - n.revenue as revenue_diff
from returned_revenue r 
cross join new_customer_revenue n;