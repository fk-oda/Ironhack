
-- Challenge 1 - Who Have Published What At Where?
DROP TABLE IF EXISTS authors_complete;

CREATE TABLE authors_complete
AS
SELECT unique_au_id AS author_id, 
		y.au_lname AS last_name, 
		y.au_fname AS first_name, 
		y.titlename AS title, 
		pub.pub_name AS publisher
FROM
	(
		(
			(SELECT au_id AS unique_au_id, 
			 au_lname, 
			 au_fname 
			FROM authors) AS a
		LEFT JOIN
			(SELECT au_id,
			 title_id AS unique_title_id
			FROM titleauthor) AS ta
		ON a.unique_au_id = ta.au_id) as x
	LEFT JOIN
	(SELECT title_id, 
	 title AS titlename,
	 pub_id AS unique_pub_id
	FROM titles) AS t
	ON x.unique_title_id = t.title_id) AS y
LEFT JOIN
	(SELECT pub_id,
	 pub_name 
	 FROM publishers) as pub
ON y.unique_pub_id = pub.pub_id;


/*
CREATE TABLE authors_complete
AS
SELECT unique_au_id AS author_id, y.au_lname AS last_name, y.au_fname AS first_name, y.titlename AS title, pub.pub_name AS publisher
FROM
	((
	(SELECT au_id, au_lname, au_fname 
	FROM authors) AS a
LEFT JOIN
	(SELECT au_id AS unique_au_id, title_id AS unique_title_id
	FROM titleauthor) AS ta
ON ta.unique_au_id = a.au_id) AS x
	LEFT JOIN
		(SELECT title_id, title AS titlename, pub_id AS unique_pub_id
		FROM titles) AS t
	ON x.unique_title_id = t.title_id) AS y
		LEFT JOIN
			(SELECT pub_id, pub_name FROM publishers) as pub
		ON y.unique_pub_id = pub.pub_id;
*/
		
-- ## Challenge 2 - Who Have Published How Many At Where?
SELECT author_id, last_name, first_name, publisher, COUNT(title) as title_count
FROM authors_complete
GROUP BY author_id, last_name, first_name, publisher
ORDER BY title_count DESC;

-- ## Challenge 3 - Best Selling Authors
SELECT complete_info.author_id,
		complete_info.last_name,
		complete_info.first_name,
		SUM(complete_info.final_qty) AS total
FROM
(SELECT author_id, 
 		last_name,
 		first_name, 
		unique_title_id,
 		title_id,
 		CASE WHEN
 		qty IS NULL THEN 0
 		ELSE qty
 		END as final_qty
FROM 
(SELECT unique_au_id AS author_id,
 		y.au_lname AS last_name,
 		y.au_fname AS first_name,
 		y.unique_title_id
FROM
	(((SELECT au_id AS unique_au_id, 
	 	au_lname, 
	 	au_fname 
		FROM authors) AS a	
LEFT JOIN
	  (SELECT au_id, 
	   title_id AS unique_title_id
		FROM titleauthor) AS ta
ON a.unique_au_id = ta.au_id ) AS x
	LEFT JOIN
		(SELECT title_id, 
		 title AS titlename, 
		 pub_id AS unique_pub_id
		FROM titles) AS t
	ON x.unique_title_id = t.title_id) AS y
		LEFT JOIN
			(SELECT pub_id, 
			 pub_name 
			 FROM publishers) as pub
		ON y.unique_pub_id = pub.pub_id) as base_info
			LEFT JOIN
			(SELECT title_id, 
			 qty
			FROM sales) as qty_sale
			ON base_info.unique_title_id = qty_sale.title_id
) as complete_info
GROUP BY complete_info.author_id,
		complete_info.last_name,
		complete_info.first_name
ORDER BY total DESC
LIMIT 3;

-- ## Challenge 4 - Best Selling Authors Ranking
SELECT complete_info.author_id,
		complete_info.last_name,
		complete_info.first_name,
		SUM(complete_info.final_qty) AS total
FROM
(SELECT author_id, 
 		last_name,
 		first_name, 
		unique_title_id,
 		title_id,
 		CASE WHEN
 		qty IS NULL THEN 0
 		ELSE qty
 		END as final_qty
FROM 
(SELECT unique_au_id AS author_id,
 		y.au_lname AS last_name,
 		y.au_fname AS first_name,
 		y.unique_title_id
FROM
	(((SELECT au_id AS unique_au_id, 
	 	au_lname, 
	 	au_fname 
		FROM authors) AS a	
LEFT JOIN
	  (SELECT au_id, 
	   title_id AS unique_title_id
		FROM titleauthor) AS ta
ON a.unique_au_id = ta.au_id ) AS x
	LEFT JOIN
		(SELECT title_id, 
		 title AS titlename, 
		 pub_id AS unique_pub_id
		FROM titles) AS t
	ON x.unique_title_id = t.title_id) AS y
		LEFT JOIN
			(SELECT pub_id, 
			 pub_name 
			 FROM publishers) as pub
		ON y.unique_pub_id = pub.pub_id) as base_info
			LEFT JOIN
			(SELECT title_id, 
			 qty
			FROM sales) as qty_sale
			ON base_info.unique_title_id = qty_sale.title_id
) as complete_info
GROUP BY complete_info.author_id,
		complete_info.last_name,
		complete_info.first_name
ORDER BY total DESC;