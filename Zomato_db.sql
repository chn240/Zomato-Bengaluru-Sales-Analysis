CREATE TABLE zomato_raw (
    url TEXT,
    address TEXT,
    name TEXT NOT NULL,
    online_order VARCHAR(5),
    book_table VARCHAR(5),
    rate TEXT,
    votes INTEGER,
    phone TEXT,
    location TEXT,
    rest_type TEXT,
    dish_liked TEXT,
    cuisines TEXT,
    approx_cost TEXT, -- Kept as TEXT for handling commas
    reviews_list TEXT,
    menu_item TEXT,
    listed_in_type TEXT,
    listed_in_city TEXT
);

COPY zomato_raw 
FROM 'C:\Users\Public\archive (1)\zomato.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ',', QUOTE '"', ENCODING 'utf8');

SELECT * FROM zomato_raw;

--Total number of restaurant in different areas
SELECT location, count(*) ttl_cnt FROM zomato_raw
GROUP BY location
ORDER BY location, ttl_cnt;

--Preferred ordering method 
SELECT online_order, book_table, count(*) total FROM zomato_raw
GROUP BY online_order, book_table
ORDER BY total DESC;

--Location with best rated food
SELECT location, ROUND(AVG(CAST(NULLIF(REPLACE(rate, '/5', ''), 'NEW') AS NUMERIC)), 2) as avg_rating
FROM zomato_raw
WHERE rate IS NOT NULL AND rate != '-' AND rate != 'NEW'
GROUP BY location
ORDER BY avg_rating DESC;

--Average cost in each area
SELECT location, ROUND(AVG(CAST(REPLACE(approx_cost,',','')AS NUMERIC)),2) AS avg_cost
FROM zomato_raw
WHERE approx_cost IS NOT NULL
GROUP BY location
ORDER BY avg_cost;

--Top 5 common restaurant types
SELECT rest_type, count(*) as ttl_types FROM zomato_raw
WHERE rest_type IS NOT NULL
GROUP BY rest_type
ORDER BY ttl_types DESC
LIMIT 5;

--Most votes in the area
SELECT name, location, MAX(votes) as max_votes
FROM zomato_raw
GROUP BY name, location
ORDER BY max_votes DESC
LIMIT 10;

--Highly rated and also under budget
SELECT name, location, rate, approx_cost FROM zomato_raw 
WHERE CAST(REPLACE(approx_cost, ',', '') AS NUMERIC) <= 500
AND CAST(NULLIF(REPLACE(rate, '/5', ''), 'NEW') AS NUMERIC) >= 4.0
AND rate IS NOT NULL AND rate != '-' AND rate != 'NEW'
ORDER BY location;

--High Price Low Rating
SELECT distinct name, location, rate, approx_cost FROM zomato_raw 
WHERE CAST(REPLACE(approx_cost, ',', '') AS NUMERIC) > 1500
AND CAST(NULLIF(REPLACE(rate, '/5', ''), 'NEW') AS NUMERIC) < 3.5
AND rate IS NOT NULL AND rate != '-' AND rate != 'NEW'
ORDER BY approx_cost;

--Restaurants with most cuisine
SELECT name, MAX(rate), MAX(cuisines),
       MAX(LENGTH(cuisines) - LENGTH(REPLACE(cuisines, ',', '')) + 1) as cuisine_count
FROM zomato_raw
WHERE cuisines IS NOT NULL
GROUP BY name
ORDER BY cuisine_count DESC
;

--Number of cuisine v/s rating
WITH CuisineMetrics AS (
    SELECT 
        name,
        (LENGTH(cuisines) - LENGTH(REPLACE(cuisines, ',', '')) + 1) AS c_count,
        CAST(NULLIF(REPLACE(rate, '/5', ''), 'NEW') AS NUMERIC) AS rating
    FROM zomato_raw
    WHERE cuisines IS NOT NULL 
      AND rate IS NOT NULL 
      AND rate NOT IN ('NEW', '-')
)
SELECT 
    CASE 
        WHEN c_count <= 2 THEN 'Specialty (1-2 Cuisines)'
        WHEN c_count BETWEEN 3 AND 5 THEN 'Multi-Cuisine (3-5)'
        ELSE 'Extensive Menu (6+ Cuisines)'
    END AS restaurant_category,
    COUNT(*) as total_restaurants,
    ROUND(AVG(rating), 2) as avg_rating
FROM CuisineMetrics
GROUP BY 1
ORDER BY avg_rating DESC;

--Popularity v/s Satisfaction
WITH Metrics AS (
    SELECT name, 
           CAST(NULLIF(REPLACE(rate, '/5', ''), 'NEW') AS NUMERIC) as r,
           MAX(votes) as v
    FROM zomato_raw
    WHERE rate IS NOT NULL AND rate != 'NEW' AND rate != '-'
	GROUP BY name, rate
)
SELECT name, r as rating, v as votes,
       CASE 
           WHEN v > 1000 AND r < 3.8 THEN 'High Hype / Low Satisfaction'
           WHEN v < 100 AND r > 4.2 THEN 'Hidden Gem'
           ELSE 'Standard'
       END as market_perception
FROM Metrics
ORDER BY v DESC;

--Hype on the basis of Cuisine
WITH SplitCuisines AS (
    SELECT 
        TRIM(UNNEST(STRING_TO_ARRAY(cuisines, ','))) as cuisine,
        CAST(NULLIF(REPLACE(rate, '/5', ''), 'NEW') AS NUMERIC) as r,
        votes as v
    FROM zomato_raw
    WHERE cuisines IS NOT NULL 
      AND rate IS NOT NULL 
      AND rate NOT IN ('NEW', '-')
)
SELECT 
    cuisine,
    COUNT(*) as restaurant_count,
    ROUND(AVG(r), 2) as avg_rating,
    SUM(v) as total_votes
FROM SplitCuisines
GROUP BY cuisine
HAVING COUNT(*) > 50 
ORDER BY total_votes DESC
LIMIT 10;



CREATE OR REPLACE VIEW v_market_analysis_base AS
SELECT 
    name,
    online_order,
    book_table,
    rate, -- To be cleaned via Regex in Python
    votes,
    location,
    rest_type,
    cuisines,
    approx_cost, -- To be cleaned via Regex in Python
    listed_in_type AS category,
    listed_in_city AS city
FROM zomato_raw
WHERE name IS NOT NULL 
  AND location IS NOT NULL
  AND rate IS NOT NULL 
  AND rate != 'NEW' 
  AND rate != '-';

SELECT * FROM v_market_analysis_base LIMIT 5;