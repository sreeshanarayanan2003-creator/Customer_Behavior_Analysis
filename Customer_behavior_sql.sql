select*from customer limit 10

--Q1. what is the total revenue genertaed by male vs female customers?
select gender,sum (purchase_amount) as revenue from customer group by gender

--Q2. which customers used a discount but still spent more than the average purchase amount?
select customer_id,purchase_amount from customer 
where discount_applied='yes' and purchase_amount >= (select AVG(purchase_amount) from customer)

--Q3. Which are the top 5 products with the highest avg review rating?
select item_purchased,avg(review_rating) as "Average product rating" from customer group by item_purchased
order by avg(review_rating)desc limit 5;

--Q4. compare the average purchase amounts between standard and express shipping
select shipping_type,AVG(purchase_amount) from customer where shipping_type in ('standard','express')
group by shipping_type

--Q5. Do subscribed customers spend more? compare avg spend and total revenue between subscribers and non-subscribers.
select subscription_status,
count (customer_id) as total_customers,
avg(purchase_amount) as avg_spend,
sum(purchase_amount) as total_revenue
from customer
group by subscription_status
order by total_revenue,avg_spend desc;

--Q6. which 5 products have the highest percentage of purchases with discounts applied?
select item_purchased,
(100 * SUM(CASE WHEN discount_applied='yes' THEN 1 ELSE 0 END)/COUNT(*),2) as discount_rate 
from customer
group by item_purchased
order by discount_rate desc limit 5;

--Q7. segment customers into new, returning and loyal based on their total number of previous purchase and show the count of each segment
with customer_type as(
select customer_id,previous_purchases,
CASE
WHEN previous_purchases = 1 THEN 'New'
WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
ELSE 'loyal'
END AS customer_segment
from customer)
select customer_segment, count(*) as "Number of customers"
from customer_type
group by customer_segment

--Q8. what are the top 3 most purchased products within each category?
with item_counts as(
select category,
item_purchased,
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id)DESC) as item_rank
from customer
group by category,item_purchased)
select item_rank,category,item_purchased,total_orders from item_counts
where item_rank <=3;

--Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status

--Q10. What is the revenue contribution of each age group?
select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;