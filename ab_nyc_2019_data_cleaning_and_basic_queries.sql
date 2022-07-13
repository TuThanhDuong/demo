-- Create a copy table 'ab_nyc_2019_2' to do data cleaning process
CREATE TABLE ab_nyc_2019_2 AS
	SELECT * FROM ab_nyc_2019;

-- Removing duplicates. Listings with identical name, host_id, room_type, and price are considered duplicates

DELETE a FROM 
ab_nyc_2019_2 a
JOIN ab_nyc_2019_2 b
	WHERE a.id < b.id 
    AND a.name = b.name
    AND a.host_id = b.host_id
    AND a.room_type = b.room_type
    AND a.price = b.price;

-- changing last review into DATE
ALTER TABLE ab_nyc_2019_2
MODIFY last_review DATE;

-- Removing some columns
ALTER TABLE ab_nyc_2019_2
DROP COLUMN latitude;
ALTER TABLE ab_nyc_2019_2
DROP COLUMN longitude;
ALTER TABLE ab_nyc_2019_2
DROP COLUMN host_id;
ALTER TABLE ab_nyc_2019_2
DROP COLUMN host_name;
ALTER TABLE ab_nyc_2019_2
DROP COLUMN calculated_host_listings_count;

-- Changing 'Entire home/apt' into 'Entire home'
UPDATE ab_nyc_2019_2 
SET room_type = SUBSTRING_INDEX(room_type,'/',1)
WHERE room_type = 'Entire home/apt';

-- Checking if there is price = 0
SELECT * FROM ab_nyc_2019_2 WHERE price = 0;

-- Some basic queries
	-- Total renting price for entire home of each neighbourhood_group 
SELECT neighbourhood_group, room_type, SUM(price) AS Total_price, ROUND(AVG(price)) AS avg_price, COUNT(room_type) AS number_of_room_listings
FROM ab_nyc_2019_2
GROUP BY neighbourhood_group, room_type
HAVING room_type = 'Entire home'
ORDER BY SUM(price) DESC;

	-- Total renting price for private room of each neighbourhood_group 
SELECT neighbourhood_group, room_type, SUM(price) AS Total_price, ROUND(AVG(price)) AS avg_price, COUNT(room_type) AS number_of_room_listings
FROM ab_nyc_2019_2
GROUP BY neighbourhood_group, room_type
HAVING room_type = 'shared room'
ORDER BY SUM(price) DESC;

	-- Top 10 listings with most number of reviews
SELECT name, neighbourhood_group, number_of_reviews
FROM ab_nyc_2019_2
ORDER BY number_of_reviews DESC
LIMIT 10;

-- Checking table
SELECT * FROM ab_nyc_2019_2
-- WHERE neighbourhood_group = 'Queens'
-- AND room_type = 'Entire home';