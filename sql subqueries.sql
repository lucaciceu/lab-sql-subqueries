use sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
select f.title, count(i.inventory_id) as numbr_of_copies from film f
join inventory i
on f.film_id = i.film_id
where f.title = "Hunchback Impossible";

-- 2. List all films whose length is longer than the average of all the films.
select film_id, title, length, (select avg(length) from film) as average from film
where length > (select avg(length) from film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
select a.actor_id, concat(a.first_name, " ", a.last_name), (select title from film where title = "Alone Trip") as titlu from film f
join film_actor fa on f.film_id = fa.actor_id
join actor a on fa.actor_id = a.actor_id
group by a.actor_id;

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select f.film_id, f.title, fc.category_id from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c.name = "Family"
order by f.film_id;

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select customer_id, concat(first_name, " ", last_name) as customer_name, email, address_id from customer
where address_id in (select address_id from address where city_id in (select city_id from city where country_id = (select country_id from country where country = "canada")));
 
select c.customer_id, concat(c.first_name, " ", c.last_name) as customer_name, c.email, co.country from customer c
join address a on c.address_id = a.address
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
where co.country = "canada";

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select f.film_id, f.title, fa.actor_id from film f
join film_actor fa on f.film_id = fa.film_id
where fa.actor_id = (select actor_id from (select actor_id , count(film_id) as films_acted from film_actor
group by actor_id
order by films_acted desc
limit 1) as abc);


-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select * from customer c
join rental r on c.customer_id = r.customer_id
join payment p on r.rental_id = p.payment_id;

select c.customer_id, sum(amount) as total from customer c 
join rental r on c.customer_id = r.customer_id
join payment p on r.rental_id = p.payment_id
group by c.customer_id
order by total desc
limit 1;

select f.film_id, f.title, c.customer_id from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join customer c on r.customer_id = c.customer_id
where c.customer_id = (select customer_id from (select c.customer_id, sum(amount) as total from customer c 
join rental r on c.customer_id = r.customer_id
join payment p on r.rental_id = p.payment_id
group by c.customer_id
order by total desc
limit 1) as abc);

-- 8. Customers who spent more than the average payments.
select c.customer_id, sum(p.amount) as what_he_paid from customer c 
join rental r on c.customer_id = r.customer_id
join payment p on r.rental_id = p.payment_id
group by c.customer_id
having sum(amount) > (select avg(total) from (select c.customer_id, sum(amount) as total from customer c 
join rental r on c.customer_id = r.customer_id
join payment p on r.rental_id = p.payment_id
group by c.customer_id) as abc)
order by what_he_paid asc;


select avg(total) from (select c.customer_id, sum(amount) as total from customer c 
join rental r on c.customer_id = r.customer_id
join payment p on r.rental_id = p.payment_id
group by c.customer_id) as abc;