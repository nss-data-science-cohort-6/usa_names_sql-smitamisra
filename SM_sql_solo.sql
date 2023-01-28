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

----10.98  % are unisex names.


-- SELECT
--  (SELECT COUNT(*)
--    FROM (SELECT name
--    FROM names
--    GROUP BY name
--    HAVING COUNT(DISTINCT gender ) = 2) AS sub) /
--    CAST( COUNT(DISTINCT name) AS DOUBLE PRECISION)AS perc_unisex
-- FROM names

------
-- SELECT 
--  (SELECT COUNT(DISTINCT name)
--  FROM names
--  WHERE gender='F'
--   AND name IN (SELECT DISTINCT name
--      FROM names
--      WHERE gender='M')) /
--  CAST( COUNT(DISTINCT name) AS DOUBLE PRECISION) AS perc_unisex
-- FROM names



