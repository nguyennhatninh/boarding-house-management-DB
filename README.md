

# Boarding House Management Database

[<img alt="Boarding House Management" src="https://raw.githubusercontent.com/nguyennhatninh/boarding-house-management-DB/main/drawSQL-image-export-2024-08-26.png" >](https://raw.githubusercontent.com/nguyennhatninh/boarding-house-management-DB/main/drawSQL-image-export-2024-08-26.png)
  
```sql
1. List all boarding houses along with their owners (lessors) and their verification status. Sort the boarding houses by price in descending order.

way1: 
select * from boarding_houses 
where boarding_houses.lessor_id in 
( select lessors.id from lessors where verify_ownership = true )
order by boarding_houses.price desc

way2:
select * from boarding_houses 
where exists
( select lessors.id from lessors where lessors.verify_ownership = true 
and boarding_houses.lessor_id = lessors.id )
order by boarding_houses.price desc

way3: 
select * from boarding_houses 
join lessors on boarding_houses.lessor_id = lessors.id 
where lessors.verify_ownership = true
order by boarding_houses.price desc

2. Find the renter who has the highest total number of contracts and list the details of their contracts (including the boarding house and lessor information).

WITH RenterContractCounts AS (
    SELECT 
        renter_id, 
        COUNT(*) AS contract_count
    FROM 
        contracts
    GROUP BY 
        renter_id
)
SELECT 
    contracts.id,
    contracts.renter_id,
	boarding_houses.name,
    boarding_houses.description,
   CONCAT(users.first_name, ' ', users.last_name) AS lessor_name,
    contracts.date_start,
    contracts.date_end,
    contracts.contract_term
FROM 
    contracts
JOIN 
    RenterContractCounts ON contracts.renter_id = RenterContractCounts.renter_id
JOIN 
    boarding_houses ON contracts.boarding_house_id = boarding_houses.id
JOIN 
    lessors ON contracts.lessor_id = lessors.id
JOIN 
    users ON lessors.user_id = users.id
WHERE 
    RenterContractCounts.contract_count = (
        SELECT MAX(contract_count) FROM RenterContractCounts
    );

3. List boarding houses that are fully booked (capacity is at max) along with their categories and the total number of comments. Only show boarding houses with 5 or more comments.

select boarding_houses.id, boarding_houses.category, boarding_houses.capacity, count(comments.rate) as count_comment 
from public.comments
join 
	contracts on comments.contract_id = contracts.id
join
	boarding_houses on contracts.boarding_house_id = boarding_houses.id
group by boarding_houses.id 
having count(comments.rate) >= 5
;

4. Query the list of lessors and the number of boarding houses they own, sorted by the number of boarding houses in descending order, showing only lessors with more than 3 properties.

select users.id, 
CONCAT(users.first_name, ' ', users.last_name) AS lessor_name
, users.phone, lessors.verify_ownership ,
count(boarding_houses.lessor_id) as count_house 
from public.boarding_houses
join
	lessors on boarding_houses.lessor_id = lessors.id
join
	users on lessors.user_id = users.id
group by users.id, lessors.id having count(boarding_houses.lessor_id) >= 3
order by count(boarding_houses.lessor_id) desc
;

5. List all contracts from the most recent month, along with the renter’s name, the total number of payments made for each contract, and the contract details. Sort the results by contract end date.

SELECT 
    contracts.id,
    contracts.date_start,
    contracts.date_end,
	contracts.contract_term,
    CONCAT(users.first_name, ' ', users.last_name) AS renter_name,
    SUM(boarding_houses.price) AS total_payments
FROM 
    contracts
JOIN 
    renters ON contracts.renter_id = renters.id
JOIN 
    users ON renters.user_id = users.id
JOIN 
    boarding_houses ON contracts.boarding_house_id = boarding_houses.id
WHERE 
    contracts.date_start >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
    AND contracts.date_end < DATE_TRUNC('month', CURRENT_DATE)
GROUP BY 
    contracts.id,renter_name, contracts.date_start, contracts.date_end
ORDER BY 
    contracts.date_end;

6. Find the boarding houses that have a price higher than the average price of all boarding houses in their category. List the boarding house name, price, and category.

SELECT 
    b.name AS boarding_house_name,
    b.price,
    b.category
FROM 
    boarding_houses b
INNER JOIN 
    (SELECT 
        category, 
        AVG(price) AS avg_price
     FROM 
        boarding_houses
     GROUP BY 
        category) c
ON 
    b.category = c.category
WHERE 
    b.price > c.avg_price;

7. List all lessors and the number of payments received from renters. Show only lessors who have received more than 10 payments and sort by the total number of payments in descending order.
SELECT 
    lessors.id, 
    CONCAT(users.first_name, ' ', users.last_name) AS lessor_name, 
    COUNT(lessors.id) AS total_contract, 
    SUM(boarding_houses.price) AS total_payment_received 
FROM 
    contracts
JOIN 
    boarding_houses ON contracts.boarding_house_id = boarding_houses.id
JOIN 
    lessors ON boarding_houses.lessor_id = lessors.id
JOIN 
    users ON lessors.user_id = users.id
GROUP BY 
    lessors.id, lessor_name
HAVING 
    COUNT(lessors.id) >= 10
ORDER BY 
    total_payment_received DESC;
8. List renters who have marked at least 2 boarding houses as favorites and have at least 1 ongoing contract. Display their email, total number of favorite boarding houses, and the number of active contracts.

SELECT 
    users.email, 
    COUNT(DISTINCT favorites.boarding_house_id) AS count_house_favorite,
    COUNT(DISTINCT contracts.id) AS count_contract_active
FROM 
    renters
JOIN 
    favorites ON renters.id = favorites.renter_id
JOIN 
    contracts ON contracts.renter_id = renters.id
JOIN 
    users ON renters.user_id = users.id
WHERE 
    contracts.date_end >= CURRENT_DATE
GROUP BY 
    users.email
HAVING 
    COUNT(DISTINCT favorites.boarding_house_id) >= 2 
AND 
    COUNT(DISTINCT contracts.id) >= 1;

9. List all renter comments along with the boarding house name, contract content, and rating. Only show boarding houses with an average rating above 4, and sort the results by the average rating in descending order.

WITH AvgRatings AS (
    SELECT 
        contracts.boarding_house_id, 
        AVG(rate) AS avg_rate
    FROM 
        public.comments
	JOIN 
		contracts ON comments.contract_id = contracts.id
    GROUP BY 
        contracts.boarding_house_id
    HAVING 
        AVG(rate) >= 4
)
SELECT 
    comments.content, 
    comments.rate AS comment_rate, 
    boarding_houses.name, 
    AvgRatings.avg_rate AS boarding_house_avg_rate
FROM 
    public.comments
LEFT JOIN 
    contracts ON comments.contract_id = contracts.id
LEFT JOIN 
    boarding_houses ON boarding_houses.id = contracts.boarding_house_id
LEFT JOIN 
    AvgRatings ON boarding_houses.id = AvgRatings.boarding_house_id
WHERE 
    AvgRatings.avg_rate IS NOT NULL
ORDER BY 
    AvgRatings.avg_rate DESC;


10. Find users (both renters and lessors) who have never sent a message in any chat. List their details along with their roles and creation dates.

SELECT 
    users.id ,
    CONCAT(users.first_name ,' ', users.last_name ) as user_name,
    users.role,
    users.created_at
FROM 
    users
LEFT JOIN 
    messages ON users.id = messages.user_id
WHERE 
    messages.id IS NULL;

11. List all contracts with status 'completed', along with boarding house information, renter details, and the total number of payments made for each contract. Sort by the total number of payments in descending order.

SELECT 
    payments.status ,
	CONCAT(users.first_name ,' ', users.last_name ) as renter_name,
	boarding_houses."name",
	boarding_houses.price
FROM 
    payments
JOIN 
    contracts ON contracts.id = payments.contract_id
JOIN 
    boarding_houses ON boarding_houses.id = contracts.boarding_house_id
JOIN 
    renters ON renters.id = contracts.renter_id
JOIN 
    users ON users.id = renters.user_id
WHERE 
    payments.status = 'paid'
ORDER BY boarding_houses.price DESC

12. Query the list of boarding houses along with their lessors and the total number of comments they have received. Only show boarding houses with 3 or more comments and sort by the number of comments in descending order.

SELECT 
    boarding_houses.id, 
    boarding_houses.name, 
    CONCAT(users.first_name, ' ', users.last_name) AS lessor_name,
    COUNT(comments.id) AS total_comments
FROM 
    comments
JOIN 
    contracts ON contracts.id = comments.contract_id
JOIN 
    boarding_houses ON boarding_houses.id = contracts.boarding_house_id
JOIN 
    lessors ON boarding_houses.lessor_id = lessors.id
JOIN 
    users ON lessors.user_id = users.id
GROUP BY 
    boarding_houses.id, boarding_houses.name, lessor_name
HAVING 
    COUNT(comments.id) >= 3
ORDER BY 
    total_comments DESC;

13. List renter names and the total amount they have paid in payments for contracts related to boarding houses located in a specific city, sorted by the total amount paid in descending order.

SELECT 
    renters.id,
    CONCAT(users.first_name, ' ', users.last_name) AS renter_name,
    SUM(boarding_houses.price) AS total_payments
FROM 
    boarding_houses
JOIN 
    contracts ON boarding_houses.id = contracts.boarding_house_id
JOIN 
    renters ON contracts.renter_id = renters.id
JOIN 
    users ON renters.user_id = users.id 
WHERE 
    boarding_houses.address = 'Da Nang'
GROUP BY 
    renters.id, renter_name
ORDER BY 
    total_payments DESC;


14. Find boarding houses with a rating higher than the average rating of all boarding houses in the same category. List the boarding house name, rating, and category.

SELECT 
    boarding_houses.name,
    boarding_houses.rate,
    boarding_houses.category
FROM 
    boarding_houses
INNER JOIN 
    (SELECT 
        category, 
        AVG(rate) AS avg_rating
     FROM 
        boarding_houses
     GROUP BY 
        category) avg_ratings
ON 
    boarding_houses.category = avg_ratings.category
WHERE 
    boarding_houses.rate > avg_ratings.avg_rating;


15. List all chats and the messages within each chat, along with the details of the users who sent the messages. Only display chats with at least 2 participants and sort by chat title.

SELECT 
    chats.title,
    messages.content,
     CASE
        WHEN users.role = 'renter' THEN CONCAT(users.first_name, ' ', users.last_name) || ' (Renter)'
        WHEN users.role = 'lessor' THEN CONCAT(users.first_name, ' ', users.last_name) || ' (Lessor)'
        ELSE CONCAT(users.first_name, ' ', users.last_name)
    END AS sender_name
FROM 
    chats 
JOIN 
    messages ON chats.id = messages.chat_id
JOIN 
    renters ON renters.id = chats.renter_id
JOIN 
    boarding_houses ON boarding_houses.id = chats.boarding_house_id
JOIN 
    lessors ON lessors.id = boarding_houses.lessor_id
JOIN 
    users ON messages.user_id = users.id
WHERE 
    chats.id IN (
        SELECT chat_id
        FROM messages
        GROUP BY chat_id
        HAVING COUNT(DISTINCT user_id) >= 2
    )
ORDER BY 
    chats.title;
```
