select * from customer limit 20


--Q.1 what is the total renevue genrated by men vs. women customer?
 select gender , sum (purchase_amount) as revenue
 from customer
 group by gender

 --Q.2 which customer used a discount but still spent more than the average purchase amount?
 select customer_id , purchase_amount
 from customer
 where discount_applied= 'Yes' and Purchase_amount>=(select AVG (purchase_amount) from customer

 --Q.3 which are the top 5 products with the highest avg review rating?
 select item_purchased , ROUND (AVG(review_rating :: numeric),2)as "Average product rating"
 from customer
 group by item_purchased
 order by AVG (review_rating) desc
 limit 5;

 --Q.4 compare the avg purchase amount betn stand and express shipping?
 select shipping_type,
 ROUND (avg (purchase_amount),2)
 from customer 
 where shipping_type in ('Standard','Express')
 group by shipping_type

 --Q.5 do subscribe customers spend more?compare avg spend and total revenue betn subsribers and non 
 select subscription_status,
 count (customer_id) as total_customers,
 ROUND(AVG(purchase_amount),2) as average_spent, 
 ROUND(sum(purchase_amount),2) as total_revenue
 from customer
 group by subscription_status
 order by total_revenue, average_spent desc;

 --Q.6 which 5 products have the hightest percentage of purchases with discounts applied?
 select item_purchased ,
 ROUND(100 * sum(case when discount_applied= 'Yes' then 1 else 0 end)/ count (*),2 ) as discount_rate
 from customer
 group by item_purchased
 order by discount_rate desc limit 5;

 --Q.7segment customers into new , returning and loyal based on their total number of previous purchased and show count of each segment.
 with customer_type as (
select customer_id, previous_purchases,
case
when previous_purchases=1 then 'New'
when previous_purchases between 2 and 10 then 'Returning'
else 'Loyal'
end as customer_segment
from customer
 )
 select customer_segment, count(*) as "Number of customers"
 from customer_type
 group by customer_segment

 --Q.8 what are the top 3 most purchased products within each categoy?
 with item_counts as (
select category,
item_purchased,
count(customer_id) as total_orders,
row_number () over (Partition by category order by count (customer_id) desc) as item_rank 
from customer
group by category , item_purchased
)
select item_rank , category,item_purchased,total_orders
from item_counts
where item_rank <=3;

--Q.9 are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe:
select Subscription_status,
count (customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by Subscription_status

--10. what is the revenue contribution of each age group?
select age_group,
sum (purchase_amount) as total_revenue 
from customer
group by age_group
order by total_revenue desc;