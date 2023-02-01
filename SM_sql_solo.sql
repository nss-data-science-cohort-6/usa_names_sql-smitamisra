--1. How many rows are in the names table?
SELECT COUNT(*) 
FROM names;
--It has 1957046 rows
--2. How many total registered people appear in the dataset?

SELECT SUM (num_registered)
FROM names;

--total registered people in database 351653025
--3. Which name had the most appearances in a single year in the dataset?
SELECT name, num_registered, year
FROM names
ORDER BY (num_registered) DESC;

-- Linda is the name that appears 99689 times in 1947, max in a year
--4.  What range of years are included?
SELECT MAX(year) AS max_yr,
MIN (year) AS min_yr
FROM names;

--max_yr: 2018; min_year:1880

--5. What year has the largest number of registrations?
SELECT year, SUM(num_registered) AS sum_reg
FROM names
GROUP BY year
ORDER BY sum_reg DESC;

--Year 1957 has highest registerations 4200022

--6. How many different (distinct) names are contained in the dataset?
SELECT COUNT (DISTINCT name) AS distinct_names
FROM names;

---- there are 98400 distinct names in the database
--7. Are there more males or more females registered?
SELECT gender, SUM(num_registered) AS gender_sum
FROM names
GROUP BY gender
ORDER BY gender_sum DESC;

--There are more males (177573793) than females (174079232) registered.
--8. What are the most popular male and female names overall (i.e., the most total registrations)?
SELECT name, SUM(num_registered) AS female_name_sum
FROM names
WHERE gender = 'F'
GROUP BY name
ORDER BY female_name_sum DESC;

--Mary is the most popular female name
SELECT DISTINCT (name), SUM(num_registered) AS female_name_sum
FROM names
WHERE gender = 'F'
GROUP BY name
ORDER BY female_name_sum DESC;

--"Mary"(total = 4125675) is the most popular female name followed by "Elizabeth"	1638349

SELECT DISTINCT (name), SUM(num_registered) AS male_name_sum
FROM names
WHERE gender = 'M'
GROUP BY name
ORDER BY male_name_sum DESC;
--"James"(total=5164280) is the most populat male name followed by "John"	5124817

(SELECT name, gender, SUM(num_registered) AS total
FROM names
WHERE gender = 'M'
GROUP BY gender, name
ORDER BY total DESC
LIMIT 1)
UNION --using union
(SELECT name, gender, SUM(num_registered) AS total
FROM names
WHERE gender = 'F'
GROUP BY gender, name
ORDER BY total DESC
LIMIT 1);


--9. What are the most popular boy and girl names of the first decade of the 2000s (2000 - 2009)?
SELECT name, gender, SUM(num_registered) AS decade2000_name
FROM names
WHERE year BETWEEN 2000 AND 2009
GROUP BY name, gender
ORDER BY decade2000_name DESC;

--Jacob and Emily are the most popular male and female names respectively for the years 2000-2009.


--10. Which year had the most variety in names (i.e. had the most distinct names)?

SELECT year, COUNT(DISTINCT name) as dist_name_year
FROM names
GROUP BY year
ORDER BY dist_name_year DESC;
--year 2008 had the most variety in names 32518 distinct names.

--11. What is the most popular name for a girl that starts with the letter X?
SELECT name, SUM (num_registered) as most_x
FROM names
WHERE name LIKE 'X%' AND gender = 'F'
GROUP BY name
ORDER BY most_x DESC;

--"Ximena" is the most popular name starts with X for females.

--12. How many distinct names appear that start with a 'Q', but whose second letter is not 'u'?
SELECT name, SUM (num_registered) as most_q
FROM names
WHERE name Like 'Q%' AND name NOT LIKE '_u%'
GROUP BY name
ORDER BY most_q DESC;

--46

SELECT COUNT(DISTINCT name) AS count_q
FROM names
WHERE name Like 'Q%' AND name NOT LIKE '_u%';

--46 names
--this is fusing the regex with SQL
SELECT name, SUM (num_registered) AS most_q
FROM names
WHERE name SIMILAR TO 'Q[^u]%'
GROUP BY name
ORDER BY most_q DESC;

--output is 46
--13. Which is the more popular spelling between "Stephen" and "Steven"? Use a single query to answer this question.

SELECT name, SUM (num_registered) AS count_ste
FROM names
WHERE name LIKE 'Stephen' OR name LIKE 'Steven'
GROUP BY name
ORDER BY count_ste DESC;
--"Steven" is more preferd it occurs 1286951 times and Stephen is 860972.

--14. What percentage of names are "unisex" - that is what percentage of names have been used both for boys and for girls?
SELECT 
(SELECT COUNT(DISTINCT name)
 FROM names
 WHERE gender='F'
  AND name IN (SELECT DISTINCT name
     FROM names
     WHERE gender='M')) * 100/
   CAST( COUNT(DISTINCT name) AS DOUBLE PRECISION)AS perc_unisex
FROM names
------
(SELECT DISTINCT name
FROM names
WHERE gender = 'F')
INTERSECT
(SELECT DISTINCT name
FROM names
WHERE gender = 'M');



-------
SELECT ROUND(sum(unisex_names) * 100.0 /count(*), 2)
FROM (
SELECT name, CASE WHEN COUNT(DISTINCT(gender)) > 1  THEN 1
END AS unisex_names
FROM names
GROUP BY name) as sub1
-------
SELECT COUNT(DISTINCT xyz.uni) AS unisex_tot, 
	COUNT(DISTINCT(name)) AS all_names, 
	ROUND((100.0*COUNT(DISTINCT xyz.uni)/COUNT(DISTINCT(name))), 1) AS perc

FROM(SELECT name AS uni, COUNT(DISTINCT gender) AS count
	FROM names
	GROUP BY name 
	HAVING COUNT(DISTINCT gender) > 1) AS xyz

----10.98  % are unisex names.
--Q15. How many names have made an appearance in every single year since 1880?
SELECT name, 
       COUNT(DISTINCT names.name) AS name_count
  FROM names
 WHERE year BETWEEN 1880 AND 2018
 GROUP BY  names.name
HAVING COUNT(DISTINCT names.year) = 139;
-- ORDER BY name_count DESC;
--There are 921 names that have occured every year in the table.
--From Ajay
SELECT COUNT(name)
FROM
(
	SELECT DISTINCT name
	FROM names
	GROUP BY name
	HAVING COUNT(DISTINCT year) = (SELECT COUNT(DISTINCT year) FROM names)
) AS Sub1


--Q16. How many names have only appeared in one year?
SELECT name, 
	COUNT(DISTINCT names.name) AS name_oneyearonly
  FROM names
 WHERE year BETWEEN 1880 AND 2018
 GROUP BY  names.name
HAVING COUNT(DISTINCT names.year) = 1;

--tHERE ARE 21123 NAMES that only appear once. Looks a little too much need to revis the code

--Q17 How many names only appeared in the 1950s?
SELECT name
FROM names
GROUP BY name
HAVING MIN(year)>=1950
	AND MAX(year)<=1959;
--661 names
-------
SELECT name
FROM names
GROUP BY name
HAVING MIN(year) BETWEEN 1950 AND 1959
	AND MAX(year) BETWEEN 1950 AND 1959;
-------
SELECT COUNT( DISTINCT Name)
FROM names
WHERE name NOT IN
(
	SELECT DISTINCT name
	FROM names
	WHERE year <  1950 OR year > 1959
)
AND Year BETWEEN 1950 and 1959
--------------
--Q18. How many names made their first appearance in the 2010s?
SELECT name
FROM names
GROUP BY name
HAVING MIN(year)>=2010

--Q19. Find the names that have not be used in the longest.
SELECT name, MAX(year)AS last_year_used
FROM names
GROUP BY name
ORDER BY last_year_used DESC;

-----do the bonus questions------------------
--b1 Find the longest name contained in this dataset. What do you notice about the long names?

SELECT *, CHAR_LENGTH(name) AS LengthOfName
FROM names
ORDER BY lengthofName DESC
LIMIT 5;
