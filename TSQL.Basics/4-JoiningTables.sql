-- Section 5. Joining tables
use BikeStores;

-- INNER JOIN
select 
	c.id candidate_id , c.fullname candidate_name,
	e.id employee_id  , e.fullname employee_name
from hr.candidates c join hr.employees e
	on c.fullname = e.fullname
;


-- LEFT JOIN
select 
	c.id candidate_id , c.fullname candidate_name,
	e.id employee_id  , e.fullname employee_name
from hr.candidates c left join hr.employees e
	on c.fullname = e.fullname
--where e.id is null -- show rows only in left table
;


-- RIGHT JOIN
select 
	c.id candidate_id , c.fullname candidate_name,
	e.id employee_id  , e.fullname employee_name
from hr.candidates c right join hr.employees e
	on c.fullname = e.fullname
;


-- FULL OUTER JOIN
select 
	c.id candidate_id , c.fullname candidate_name,
	e.id employee_id  , e.fullname employee_name
from hr.candidates c full join hr.employees e
	on c.fullname = e.fullname
;
select m.name memebr, p.title project
from pm.members m full join pm.projects p
	on m.project_id = p.id
;


-- CROSS JOIN, return n x m rows
-- have no on condition

-- SELF JOIN
-- used table alias to avoid erros

-- 1) Using self join to query hierarchical data
--select emplyee, ISNULL(manager, 'TOP MANAGER')
--from (
select 
	e.first_name + ' ' + e.last_name emplyee,
	m.first_name + ' ' + m.last_name manager
from sales.staffs e
left join sales.staffs m on  e.manager_id = m.staff_id
--) q
order by manager
;

-- 2) Using self join to compare rows within a table
select 
	c1.city, 
	c1.first_name + ' ' + c1.last_name customer1,
	c2.first_name + ' ' + c2.last_name customer2
from sales.customers c1
join sales.customers c2 on c1.city = c2.city and c1.customer_id > c2.customer_id
order by c1.city, customer1, customer2
;


-- TASK:
-- find the products that have no sales across the stores:

-- first get all sales products 
select st.store_id, st.product_id, ISNULL(salesProducts.sales, 0) sales
from production.stocks st -- stock table is croos join between stores and products
left join (
	select
		st.store_id, st.product_id, 
		sum(i.quantity * i.list_price) sales
	from production.stocks st
		join sales.orders o on o.store_id = st.store_id
		join sales.order_items i on o.order_id = i.order_id and i.product_id = st.product_id
	group by st.product_id, st.store_id
	) salesProducts on st.store_id = salesProducts.store_id
					and st.product_id = salesProducts.product_id
where sales is null
order by st.product_id, st.store_id
;