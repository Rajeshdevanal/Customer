use mysql;
select * from mytable limit 30;
select gender, sum(purchase_amount) as revenue
from mytable group by gender;

select customer_id , purchase_amount
from mytable
where discount_applied = "yes" and purchase_amount >= (select avg(purchase_amount)  from mytable);

/*select item_purchased ,
round(avg(cast(review_rating as decimal(10,2))),2) as "Average Product Rating"
from mytable
group by item_purchased
order by Average_Pruduct_Rating desc
limit 1;*/
SELECT item_purchased,
       ROUND(AVG(CAST(review_rating AS DECIMAL(10,2))), 2) AS Average_Product_Rating
FROM mytable
GROUP BY item_purchased
ORDER BY Average_Product_Rating DESC
LIMIT 1 offset 1;

select shipping_type,
round(avg(purchase_amount),2)
from mytable
where shipping_type in ("standard","express")
group by shipping_type;

select subscription_status , count(customer_id) as total_customer,
round(avg(purchase_amount)) as avg_spend,
round(sum(purchase_amount)) as total_revenue
from mytable
group by subscription_status
order by total_revenue,avg_spend desc;

select item_purchased,
round(sum(case when discount_applied = "yes" Then 1 else 0 end) /count(*) * 100,2) discount_rate
from mytable
group by item_purchased
order by discount_rate desc
limit 5;
use mysql;
WITH customer_type AS (
    SELECT 
        customer_id,
        previous_purchases,
        CASE 
            WHEN previous_purchases = 1 THEN 'new'
            WHEN previous_purchases BETWEEN 2 AND 10 THEN 'returning'
            ELSE 'loyal'
        END AS customer_segment
    FROM mytable
)
SELECT 
    customer_segment,
    COUNT(*) AS number_of_customers
FROM customer_type
GROUP BY customer_segment;

WITH item_counts AS (
    SELECT 
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM mytable
    GROUP BY category, item_purchased
)
SELECT
    item_rank,
    category,
    item_purchased,
    total_orders
FROM item_counts
WHERE item_rank <= 3;

select subscription_status,
count(customer_id) as repeat_buyers
from mytable
where previous_purchases > 5
group by subscription_status
order by subscription_status desc;

select age_group ,sum(purchase_amount) as total_revenue
from mytable 
group by age_group
order by total_revenue desc;
