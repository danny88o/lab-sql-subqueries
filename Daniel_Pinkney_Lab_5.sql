-- Lab 3.05 -- subqueries -- Finished
use sakila;
-- How many copies of the film Hunchback Impossible exist in the inventory system?

select count(i.inventory_id)
from inventory i
join 
	(
    select title, film_id from film
    where title = "Hunchback Impossible"
    ) f
    on f.film_id = i.film_id;

-- List all films longer than the average.
select Title, length
from film
where length in (
	select length from (
		select avg(length) as Average
		from film
		having length > Average
		order by Average desc
		) sub1

	);
    
-- Use subqueries to display all actors who appear in the film Alone Trip.
select concat(a.first_name, " ", a.last_name)
from film f1
join 
	(
    select title, film_id from film
    where title = "Alone Trip"
    ) f2
    on f1.film_id = f2.film_id
join film_actor fa on fa.film_id = f1.film_id
join actor a on a.actor_id = fa.actor_id
;

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select f.title
from film f
join film_category fcat on fcat.film_id = f.film_id
join (
	select category_id, name
    from category
    where name = "family"
    ) cat
    on cat.category_id = fcat.category_id;
    
-- Get name and email from customers from Canada using subqueries. Do the same with joins.
select concat(c.first_name, " ", c.last_name), c.email
from customer c
join address a on a.address_id = c.address_id
join city y on y.city_id = a.city_id
join (
	select country_id, country
    from country
    where country = "Canada"
    )tr
    on tr.country_id = y.country_id;

-- Which are films starred by the most prolific actor?
select a.film_id, af.actor_id
from film_actor a
join (
	select actor_id, count(film_id) as amount from film_actor
	group by actor_id
    having amount = max(amount)) as af
    on af.actor_id = a.actor_id
;

-- Films rented by most profitable customer.
select f.film_id, r.customer_id
from rental r
join inventory i on i.inventory_id  = r.inventory_id
join film f on f.film_id = i.film_id
join (select customer_id, max(profit) from 
	(
    select customer_id, sum(amount) as profit from payment
	group by customer_id
    )as y) as x
	on x.customer_id = r.customer_id
;
select customer_id, sum(amount) as profit from payment
where profit = max(profit)
group by customer_id
;
-- Customers who spent more than the average.
select concat(c.first_name, " ", c.last_name), p.amount
from payment p
join customer c on c.customer_id = p.customer_id
where p.amount in (
	select Average from (
		select avg(amount) as Average
		from payment
		having amount > Average
		) sub1

	);