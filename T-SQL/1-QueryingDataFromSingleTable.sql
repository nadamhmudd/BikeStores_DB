-- Section 1 / 2 :  

-- Show you how to query data against a single table.
select city, count(*) 
From [sales].[customers]
where [state] = 'CA'
group by city
Having count(*) > 10
order by count(*), city desc;

-- Sort a result set by a column that is not in the select list
select city, first_name, last_name
from sales.customers
order by state;

-- Sort a result set by an expression
select first_name, last_name
from sales.customers
order by len(first_name), first_name/*1*/ ; --length,
-- bad : 1 mean ordinal positions of columns in select = first_name