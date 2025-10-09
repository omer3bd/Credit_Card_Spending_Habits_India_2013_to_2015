-- the data is from 2013-10-04 to 2015-05-26


-- create and import the credit card transactions table
CREATE TABLE "cr_card_habits_india" (
        "index"	INT,
        City VARCHAR(80),
        "Date" date,
        "Card Type" VARCHAR(80),
        "Exp Type" VARCHAR(100),
        Gender VARCHAR(20),
        Amount INT
        );

-- three holidays tables created 2013-15
CREATE TABLE "indian_holidays_2015" ("Date" date,
        "Days" VARCHAR(13),
        "Name" VARCHAR(50),
        "Type"  VARCHAR(50)
        );



-- 26,052 raw records
SELECT * FROM cr_card_habits_india;

-- gender abbrivations
SELECT *,
CASE 
    WHEN gender = 'F' THEN 'Female'
    WHEN gender = 'M' THEN 'Male'
    END
FROM cr_card_habits_india AS cr;

-- city and country column with a delimiter
SELECT
    split_part("cr".city, ',', 1) AS city,
    split_part("cr".city, ',', 2) AS country
FROM cr_card_habits_india;

-- convert date into day 
SELECT "Date", to_char( "Date", 'Day') AS day_name FROM cr_card_habits_india;

/*
scraped using python from the website "https://www.timeanddate.com/holidays/india/2013"
*/

-- show holidays on dates
SELECT *
FROM cr_card_habits_india AS cr
    LEFT JOIN indian_holidays_2013 AS i13 ON "cr"."Date" = "i13"."Date"
    LEFT JOIN indian_holidays_2014 AS i14 ON "cr"."Date" = "i14"."Date"
    LEFT JOIN indian_holidays_2015 AS i15 ON "cr"."Date" = "i15"."Date";


-- convert all queries into a view for simplification
CREATE VIEW "cr_card_habits_india_cleaned" AS
SELECT
    split_part("cr".city, ',', 1) AS city,
    split_part("cr".city, ',', 2) AS country,
    CASE 
        WHEN "cr".gender = 'F' THEN 'Female'
        WHEN "cr".gender = 'M' THEN 'Male'
        END AS "Gender",
    "cr"."Date", "cr"."Card Type", "cr"."Exp Type", "cr".amount,
    to_char( "cr"."Date", 'Day') AS day_name,
    COALESCE("i13"."Name","i14"."Name","i15"."Name") AS "holiday_name",
    COALESCE("i13"."Type","i14"."Type","i15"."Type") AS "holiday_type"
FROM cr_card_habits_india AS cr
    LEFT JOIN indian_holidays_2013 AS i13 ON "cr"."Date" = "i13"."Date"
    LEFT JOIN indian_holidays_2014 AS i14 ON "cr"."Date" = "i14"."Date"
    LEFT JOIN indian_holidays_2015 AS i15 ON "cr"."Date" = "i15"."Date";


SELECT * FROM cr_card_habits_india_cleaned;