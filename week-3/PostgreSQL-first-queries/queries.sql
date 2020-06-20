SELECT * FROM data limit 5

-- 1. What are the different genres?
SELECT DISTINCT prime_genre 
FROM data
ORDER BY prime_genre;

-- 2. Which is the genre with the most apps rated?
SELECT prime_genre, SUM(rating_count_tot) 
FROM data 
GROUP BY prime_genre 
ORDER BY SUM(rating_count_tot) DESC
LIMIT 1;

-- 3. Which is the genre with most apps?
SELECT prime_genre, COUNT(id) FROM data 
GROUP BY prime_genre 
ORDER BY COUNT(id) DESC 
LIMIT 1;

-- 4. Which is the one with least?
SELECT prime_genre, COUNT(id) 
FROM data 
GROUP BY prime_genre 
ORDER BY COUNT(id) ASC 
LIMIT 1;

-- 5. Find the top 10 apps most rated.
SELECT track_name, rating_count_tot 
FROM data 
ORDER BY rating_count_tot DESC 
LIMIT 10;

-- 6. Find the top 10 apps best rated by users.
SELECT track_name, rating_count_tot, user_rating 
FROM data 
ORDER BY user_rating DESC, rating_count_tot DESC 
LIMIT 10;

-- 7. Take a look at the data you retrieved in question 5. Give some insights.

-- 8. Take a look at the data you retrieved in question 6. Give some insights.

-- 9. Now compare the data from questions 5 and 6. What do you see?

-- 10. How could you take the top 3 regarding both user ratings and number of votes?
SELECT track_name, rating_count_tot, user_rating 
FROM data 
ORDER BY user_rating DESC, rating_count_tot DESC 
LIMIT 3;

-- 11. Do people care about the price of an app?
SELECT price, SUM(rating_count_tot) as sum_rating_count 
FROM data 
GROUP BY price 
ORDER BY sum_rating_count DESC;

SELECT price, user_rating, SUM(rating_count_tot) as sum_rating_count
FROM data 
GROUP BY price, user_rating
ORDER BY sum_rating_count DESC, user_rating DESC;

-- Bonus: Find the total number of games available in more than 1 language.
SELECT COUNT(id) 
from data 
WHERE "lang.num" > 1 AND prime_genre = 'Games';

-- Bonus2: Find the number of free vs paid apps
SELECT * 
FROM 
	(SELECT COUNT(id) as total 
	 FROM data 
	 GROUP BY price 
	 HAVING price = 0) as free
UNION ALL
SELECT COUNT(paid.id) as total_paid 
FROM 
	(SELECT id, price 
	 FROM data 
	 WHERE price > 0) as paid;
	 
-- Bonus2: Different approach
SELECT 
CASE
WHEN price = 0 THEN 'Free'
ELSE 'Paid'
END AS burden,
COUNT(id)
FROM data
GROUP BY burden;

-- Bonus3: Find the number of free vs paid apps for each genre
SELECT free.prime_genre, free.total_free, paid.total_paid 
FROM
	(SELECT prime_genre, COUNT(id) as total_free 
	 FROM data 
	 GROUP BY price, prime_genre 
	 HAVING price = 0) as free
FULL OUTER JOIN
	(SELECT p.prime_genre, SUM(p.total) as total_paid 
	 FROM 
	 	(SELECT prime_genre, price, COUNT(id) as total 
		 FROM data 
		 GROUP BY price, prime_genre 
		 HAVING price > 0) as p
	 GROUP BY p.prime_genre) as paid
ON free.prime_genre = paid.prime_genre
ORDER BY free.prime_genre;

-- Bonus3: Differente approach
SELECT prime_genre,
CASE
WHEN price = 0 THEN 'Free'
ELSE 'Paid'
END AS cost,
COUNT(id) as total
FROM data
GROUP BY prime_genre, cost
ORDER BY prime_genre;
