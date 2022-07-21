-- Section 6. Grouping data
select customer_id, year(order_date) order_year, count(order_id) order_placed
from sales.orders
group by customer_id, year(order_date)
having COUNT(order_id) >= 2
order by customer_id, order_year
;

---------------------------------------------------------------
-- HOW to generate multiple grouping sets with single query ?

-- 1. GROUPING SETS : 
-- generates multiple grouping sets in single query instead of using union all
-- = groupingSet1 UNION ALL groupingset2 UNIon ALL groupingset2 ...
SELECT
    b.brand_name AS brand,
    c.category_name AS category,
    p.model_year,
    round(
        SUM (
            quantity * i.list_price * (1 - discount)
        ),
        0
    ) sales INTO sales.sales_summary -- create new table
FROM
    sales.order_items i
INNER JOIN production.products p ON p.product_id = i.product_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year
ORDER BY
    b.brand_name,
    c.category_name,
    p.model_year
;

SELECT *
FROM sales.sales_summary
ORDER BY brand, category, model_year
;

select 
	GROUPING(brand) grouping_brand,
	GROUPING(category) grouping_category,
	brand, category, sum(sales) sales
from sales.sales_summary
group by GROUPING SETS (
	(brand, category),
	(brand),
	(category),
	()
)
order by brand, category
;

-- GROUPING function
-- indicates whether a specified column in a GROUP BY clause is aggregated or not. 
-- It returns 1 for aggregated or 0 for not aggregated in the result set.

-----------------------------------------------------

-- 2. CUBE : 
-- generate multible grouping sets for  all dimension
-- CUBE (A,B,C) -> generate 2^N = 2^3 grouping sets

select brand, category, sum(sales) sales
from sales.sales_summary
group by CUBE(brand, category) 
order by brand, category
;
/*
grouping sets = 2^2 = 4
(brand, category)
(brand)
(category)
()
*/
-- partial cube -> 3 GS = brand with (category, ())
select brand, category, sum(sales) sales
from sales.sales_summary
group by 
	brand, 
	CUBE(category) 
;

-----------------------------------------------------

-- 3. ROLLUP :
-- ROLLUP(A,B,C) -> generate n+1 sets -> (hierarchy)
-- order is important
-- (), (A), (A,B), (A,B,C) 

-- (brand), (brand,category)
select  brand, category, sum(sales) sales
from sales.sales_summary
group by ROLLUP(brand, category); 
--       ()            = null, null
--     (brand)         = brand, null
-- (brand, category)

-- partial ROLLUP
select  brand, category, sum(sales) sales
from sales.sales_summary
group by 
	brand,
	ROLLUP(category); 

-- brand + ()         , brand + null
-- brand + (category)