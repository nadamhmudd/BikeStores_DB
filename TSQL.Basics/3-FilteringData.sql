-- Section 4. Filtering data

--DISTINCT 
--select distinct values in one or more columns of a table.
--similar to group by 
--However, you should use the GROUP BY clause with an aggregate function.
select distinct
	city, state
	-- phone, -- kept only one null
from sales.customers
order by city /* phone */
;
select city, state
from sales.customers
group by city, state
order by city 
;
---------------------------------------------------------------------
select * from production.products
--where category_id = 1 and model_year = 2018 
--where list_price > 300 and model_year = 2018 
--where list_price > 3000 or model_year = 2018 
--where list_price between 1899 and 1999.99 -- get a range
--where list_price in (299.99,466.99,489.99) -- matching values
where product_name like '%Cruiser%'
order by list_price desc
;

--WHERE 
--filter rows in the output of a query based on one or more conditions.

--AND (highest priority)
--combine two Boolean expressions and return true if all expressions are true.

--OR (execute aftr and opr)
--combine two Boolean expressions and return true if either of conditions is true.

--IN , NOT IN
--check whether a value matches any value in a list or a subquery.
-- col IN (v1, 2, v3, ...) 
-- col IN (subquery)
-- if a list contains NULL, the result of IN or NOT IN will be UNKNOWN.
select product_id, product_name 
from production.products
where product_id IN 
	(select s.product_id
	 from production.stocks s
	 where s.store_id = 1 and s.quantity >= 30
	)
;

--BETWEEN , NOT BETWEEN
--test if a value is between a range of values.
select * from sales.orders
where order_date between '20170115' and '20170117' --date format: YYYYMMDD
order by order_date
;

--LIKE , NOT LIKE
--check if a character string matches a specified pattern.

-- (%) match any seq of char
select customer_id, first_name, last_name 
From sales.customers
where last_name like 't%s'
order by first_name
;

-- (_) match any single char
select customer_id, first_name, last_name 
From sales.customers
where last_name like '_u%' -- second letter is u
order by first_name
;

-- [list of characters] match one of char in the list (single char)
select customer_id, first_name, last_name 
From sales.customers
where last_name like '[YZ]%' -- first char = y or z
order by last_name
;

-- [char-char] match single char between the range
select customer_id, first_name, last_name 
From sales.customers
where last_name like '[A-C]%' -- first char in ragnge A-C
order by first_name
;

-- [^charList] or [^char-char] => not in / not between
select customer_id, first_name, last_name 
From sales.customers
where last_name like '[^A-X]%' -- not in range between a-x
order by last_name
;

-- NOT LIKE
select customer_id, first_name, last_name 
From sales.customers
where first_name like '[^A]%' -- first char not A
order by first_name
;
--OR
select customer_id, first_name, last_name 
From sales.customers
where first_name NOT like 'A%' -- first char not A
order by first_name
;

-- like with escape char (example in NOTES.sql)

--Column & table aliases 
select first_name + ' ' + last_name as 'Full Name'
from sales.customers
order by first_name
;