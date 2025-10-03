SELECT * FROM netflix;
CREATE TABLE netflix_new (LIKE netflix Including ALL);
SELECT * FROM netflix_new;
INSERT INTO netflix_new(
SELECT * FROM netflix);

WITH duplicates AS (SELECT *,
ROW_NUMBER() OVER(
PARTITION BY type,title,release_year ORDER BY show_id) AS row_num
FROM netflix_new)
SELECT * FROM duplicates
WHERE row_num>1;

WITH duplicates AS (SELECT *,
ROW_NUMBER() OVER(
PARTITION BY type,title,release_year ORDER BY show_id) AS row_num
FROM netflix_new)
DELETE FROM netflix_new
WHERE show_id IN(SELECT show_id FROM duplicates WHERE row_num > 1);

UPDATE netflix_new
SET director = 'Unknown' WHERE director IS NULL;
UPDATE netflix_new
SET country = 'Unknown' WHERE country IS NULL;

ALTER TABLE netflix_new ADD COLUMN date_added_clean DATE;
UPDATE netflix_new
SET date_added_clean = TO_DATE(date_added, 'MM/DD/YYYY');

ALTER TABLE netflix_new DROP COLUMN date_added;
ALTER TABLE netflix_new RENAME COLUMN date_added_clean TO date_added;

SELECT * FROM netflix_new
WHERE  director = 'Unknown';