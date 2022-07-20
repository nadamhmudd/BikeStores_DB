-- Section 3. Limiting rows, using with order by

-- 1: OFFSET and FETCH
-- The OFFSET and FETCH clauses are preferable for implementing the query paging solution than the TOP clause.

select product_id, product_name, list_price 
from production.products 
order by list_price, product_name
offset 10 rows /* skip first 10 rows */
fetch next 10 rows only   /* optional */
;

select product_id, product_name, list_price 
from production.products 
order by list_price desc, product_name
offset 0 rows /* get top rows */
fetch next /*first*/ 10 rows only   /* optional */
;


-- 2: SELECT TOP
select top 10 /*percent*/ /*with ties*/
	product_id, product_name, list_price 
from production.products 
order by list_price desc, product_name
;

-- Using TOP to return a percentage of rows
select top 1 percent --(1%)
	product_id, product_name, list_price 
from production.products 
order by list_price desc, product_name
;

-- Include rows that match the values in the last row, may be return more than 3 rows
select top 3 with ties
	product_name, list_price
from production.products
order by list_price desc
;
