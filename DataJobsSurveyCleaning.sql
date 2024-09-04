SELECT *
FROM data_jobs.datajobssurvey;

SELECT *
FROM data_jobs.datajobssurveyquestions;

DROP TABLE datajobssurvey_cleaning;

CREATE TABLE datajobssurvey_cleaning
LIKE datajobssurvey;
INSERT datajobssurvey_cleaning
SELECT *
FROM datajobssurvey;

SELECT *
FROM data_jobs.datajobssurvey_cleaning;

ALTER TABLE datajobssurvey_cleaning CHANGE `ï»¿Unique ID` Unique_ID text;

WITH duplicate_cte AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY Unique_ID) As unique_check
FROM datajobssurvey_cleaning
)
SELECT *
FROM duplicate_cte
WHERE unique_check > 1;

ALTER TABLE datajobssurvey_cleaning
DROP COLUMN `Date Taken (America/New_York)`,
DROP COLUMN `Time Taken (America/New_York)`,
DROP COLUMN Browser,
DROP COLUMN OS,
DROP COLUMN City,
DROP COLUMN Country,
DROP COLUMN Referrer,
DROP COLUMN Email,
DROP COLUMN `Time Spent`;





-- Q1



SELECT Q1, substring(Q1, 24)
FROM datajobssurvey_cleaning
WHERE Q1 LIKE "Other%";

UPDATE datajobssurvey_cleaning
SET Q1 = substring(Q1, 24)
WHERE Q1 LIKE "Other%";

SELECT DISTINCT Q1
FROM datajobssurvey_cleaning
ORDER BY Q1;

UPDATE datajobssurvey_cleaning
SET Q1 = TRIM(Q1);

UPDATE datajobssurvey_cleaning
SET Q1 = CASE
    WHEN Q1 = '' OR Q1 IS NULL THEN 'Other'
    WHEN Q1 = 'Does a social media analyst count?' THEN 'Social Media Analyst'
    WHEN Q1 = 'Business Analys' THEN 'Business Analyst'
    WHEN Q1 = 'BI consultant' THEN 'Business Intelligence Consultant'
    WHEN Q1 = 'BI Developer' THEN 'Business Intelligence Developer'
    WHEN Q1 = 'BI Manager' THEN 'Business Intelligence Manager'
    WHEN Q1 = 'I work with data tools and can create simple dashboards but I am not a data scientist' THEN 'Data Analyst'
    WHEN Q1 = 'Jr. Data Scientist' THEN 'Data Scientist Junior'
    WHEN Q1 = 'Finance Analyst' THEN 'Financial Analyst'
    WHEN Q1 LIKE 'Software E%' THEN 'Software Engineer'
    WHEN Q1 = 'Student working as a data analyst intern' THEN 'Data Analyst Intern'
    WHEN Q1 = 'Technical consulta' THEN 'Technical consultant'
    WHEN Q1 = 'Reporting Adm' THEN 'Reporting Admin'
    WHEN Q1 = 'Educator' THEN 'Teacher'
    WHEN Q1 = 'Manager of a team of Data Analysts' THEN 'Data Analysts Manager'
    ELSE Q1
END;







-- Q3

ALTER TABLE datajobssurvey_cleaning
ADD COLUMN Q3_int INT;

UPDATE datajobssurvey_cleaning
SET Q3_int = 
    CASE 
        WHEN TRIM(Q3) = '' THEN NULL
        ELSE (
            CAST(TRIM(TRAILING 'k' FROM REPLACE(SUBSTRING_INDEX(Q3, '-', 1), '+', '')) AS UNSIGNED) +
            CAST(TRIM(TRAILING 'k' FROM REPLACE(SUBSTRING_INDEX(Q3, '-', -1), '+', '')) AS UNSIGNED)
        ) / 2
    END;

ALTER TABLE datajobssurvey_cleaning
DROP COLUMN Q3,
CHANGE Q3_int Q3 int;


-- Q4

SELECT Q4, substring(Q4, 24)
FROM datajobssurvey_cleaning
WHERE Q4 LIKE "Other%";

UPDATE datajobssurvey_cleaning
SET Q4 = substring(Q4, 24)
WHERE Q4 LIKE "Other%";

SELECT DISTINCT Q4
FROM datajobssurvey_cleaning
ORDER BY 1;

UPDATE datajobssurvey_cleaning
SET Q4 = TRIM(Q4);

UPDATE datajobssurvey_cleaning
SET Q4 = CASE
    WHEN Q4 = '' OR Q4 IS NULL THEN 'Other'
    WHEN Q4 = 'Air transpo' THEN 'Air Transport'
    WHEN Q4 = 'Arrosp' THEN 'Aerospace'
    WHEN Q4 = 'Avia' THEN 'Aviation'
    WHEN Q4 LIKE 'Auto%' THEN 'Automotive'
    WHEN Q4 LIKE 'Consumer%' THEN 'Consumer'
    WHEN Q4 = 'Cobsukting' OR Q4 = 'Consulti' THEN 'Consulting'
    WHEN Q4 = 'Cons' THEN 'Construction'
    WHEN Q4 = 'Beverage and foods' THEN 'Food and Drink'
    WHEN Q4 = 'Currently studying . Previously worked in Power Generation' THEN 'None'
    WHEN Q4 = 'Digital Mar' THEN 'Digital Marketing'
    WHEN Q4 LIKE 'Ecom%' THEN 'E-commerce'
    WHEN Q4 = 'Energy (oil and gas)' THEN 'Energy'
    WHEN Q4 LIKE 'Food %' THEN 'Food and Drink'
    WHEN Q4 LIKE 'Foodservice%' THEN 'Food Service'
    WHEN Q4 LIKE 'Gover%' THEN 'Government'
    WHEN Q4 = 'hospitality' THEN 'Hospitality '
    WHEN Q4 = 'Home maker' THEN 'None'
    WHEN Q4 = 'Igaming' THEN 'Gaming'
    WHEN Q4 = 'Interning in Sciences, Weather and Meteorological data' THEN 'Weather'
    WHEN Q4 = 'last mile delivery logistics' THEN 'Logistics'
    WHEN Q4 = 'Logistics and warehousing' THEN 'Logistics'
    WHEN Q4 = 'Looking for job' THEN 'None'
    WHEN Q4 LIKE "Manu%" THEN 'Manufacturing'
    WHEN Q4 LIKE "none%" or  Q4 LIKE "not%" or Q4 LIKE '%student%' THEN 'None'
    WHEN Q4 LIKE "Non%profit%" THEN 'Non Profit'
    WHEN Q4 LIKE "Ret%" THEN 'Retail'
    WHEN Q4 = 'State Government' THEN 'State'
    WHEN Q4 = 'Supply Chain - warehousing, transpiration and' THEN 'Supply Chain'
    WHEN Q4 = 'Third Party Logistics' THEN 'Logistics'
    WHEN Q4 = 'Unemployed, trying to switch career' THEN 'None'
    WHEN Q4 = 'Utili' THEN 'Utilities'
    WHEN Q4 = 'Fmcg' THEN 'Consumer'
    WHEN Q4 = 'fashion/online store' THEN 'Fashion'
    WHEN Q4 = 'Taking bootcamp' or Q4 = 'Urbanism' THEN 'None'
    WHEN Q4 LIKE 'sports%' THEN 'Sports'
    WHEN Q4 = 'Homelessness' THEN 'None'
    ELSE Q4
END;


-- Q5

SELECT DISTINCT Q5
FROM datajobssurvey_cleaning
ORDER BY 1;

SELECT Q5, substring(Q5, 7)
FROM datajobssurvey_cleaning
WHERE Q5 LIKE "Other%";

UPDATE datajobssurvey_cleaning
SET Q5 = substring(Q5, 7)
WHERE Q5 LIKE "Other%";

UPDATE datajobssurvey_cleaning
SET Q5 = TRIM(Q5);

UPDATE datajobssurvey_cleaning
SET Q5 = CASE
    WHEN Q5 = '' OR Q5 IS NULL THEN 'Other'
    WHEN Q5 = 'c#' THEN 'C#'
    WHEN Q5 = 'Dont require' or Q5 = 'DAX' OR Q5 = 'NA' OR Q5 = 'Power bi' OR Q5 = 'Qlik sense script' OR Q5 = 'Altery' OR Q5 = 'unknown' OR Q5 = 'Just started learning' THEN 'None'
    WHEN Q5 = 'Knowledge of Excel and SQL yet' THEN 'Excel/SQL'
    WHEN Q5 = 'Mainly use Excel' THEN 'Excel'
    WHEN Q5 LIKE 'None%' THEN 'None'
    WHEN Q5 LIKE 'SQ%' THEN 'SQL'
    WHEN Q5 = 'i mean, i mostly work in SQL and its variants?' or Q5 = 'Mostly use sql but thatâ€™s not programming language..' THEN 'SQL'
    WHEN Q5 = 'SAS SQL' THEN 'SAS/SQL'
    WHEN Q5 LIKE 'I %' THEN 'None'
    ELSE Q5
END;

-- Q6, Q7,  Q9

-- The query below was for all Q6 columns, Q7 and Q9
SELECT DISTINCT Q9
FROM datajobssurvey_cleaning;

-- Q8

SELECT Q8, substring(Q8, 24)
FROM datajobssurvey_cleaning
WHERE Q8 LIKE "Other%";

UPDATE datajobssurvey_cleaning
SET Q8 = substring(Q8, 24)
WHERE Q8 LIKE "Other%";

SELECT DISTINCT Q8
FROM datajobssurvey_cleaning;

-- Q10

SELECT MIN(Q10), MAX(Q10)
FROM datajobssurvey_cleaning;

ALTER TABLE datajobssurvey_cleaning
ADD COLUMN Q10_bracket text;

SELECT Q10, CONCAT('<', (FLOOR(Q10 / 10) * 10 + 10)) AS label
FROM datajobssurvey_cleaning;

UPDATE datajobssurvey_cleaning
SET Q10_bracket = CONCAT('<', (FLOOR(Q10 / 10) * 10 + 10));

 SELECT DISTINCT Q10_bracket
 FROM datajobssurvey_cleaning;

-- Q11

SELECT Q11, substring(Q11, 24)
FROM datajobssurvey_cleaning
WHERE Q11 LIKE "Other%";

UPDATE datajobssurvey_cleaning
SET Q11 = substring(Q11, 24)
WHERE Q11 LIKE "Other%";

SELECT DISTINCT Q11
FROM datajobssurvey_cleaning
ORDER BY 1;

UPDATE datajobssurvey_cleaning
SET Q11 = TRIM(Q11);

UPDATE datajobssurvey_cleaning
SET Q11 = CASE
    WHEN Q11 = '' OR Q11 IS NULL THEN 'Other'
    WHEN Q11 = 'Africa (Nigeria)' THEN 'Nigeria'
    WHEN Q11 = 'Aisa' THEN 'Other'
    WHEN Q11 = 'Argentine' THEN 'Argentina'
    WHEN Q11 = 'Austr' THEN 'Australia'
    WHEN Q11 = 'Brazik' THEN 'Brazil'
    WHEN Q11 = 'Fin' THEN 'Finland'
    WHEN Q11 = 'indonesia' THEN 'Indonesia'
    WHEN Q11 = 'Ire' OR Q11 = 'Irel' THEN 'Ireland'
    WHEN Q11 = 'Kenua' THEN 'Kenya'
    WHEN Q11 = 'Leba' THEN 'Lebanon'
    WHEN Q11 = 'PerÃº' THEN 'Peru'
    WHEN Q11 = 'Portugsl' THEN 'Portugal'
    WHEN Q11 = 'SG' THEN 'Singapore'
    WHEN Q11 = 'TUNISIA' THEN 'Tunisia'
    WHEN Q11 = 'uzb' THEN 'Uzbekistan'
    ELSE Q11
END;

-- Q12

SELECT DISTINCT Q12
FROM datajobssurvey_cleaning;

UPDATE datajobssurvey_cleaning
SET Q12 = 'None/Other'
WHERE Q12 = "";


-- Q13

SELECT Q13, substring(Q13, 24)
FROM datajobssurvey_cleaning
WHERE Q13 LIKE "Other%";

UPDATE datajobssurvey_cleaning
SET Q13 = substring(Q13, 24)
WHERE Q13 LIKE "Other%";

SELECT DISTINCT Q13
FROM datajobssurvey_cleaning
ORDER BY Q13;

UPDATE datajobssurvey_cleaning
SET Q13 = TRIM(Q13);

UPDATE datajobssurvey_cleaning
SET Q13 = CASE
    WHEN Q13 = '' OR Q13 IS NULL THEN 'Prefer Not To Say'
    WHEN Q13 = 'Bi-racial people should be able to check 2 options in 2022.' THEN 'Bi-racial'
    WHEN Q13 = 'Bla' THEN 'Black'
    WHEN Q13 = 'Egyp' THEN 'Egyptian'
    WHEN Q13 = 'Human' THEN 'Prefer Not To Say'
    WHEN Q13 = 'Melayu' THEN 'Malay'
    WHEN Q13 = 'Middleeas' THEN 'Middle East'
    WHEN Q13 = 'N/A' THEN 'Prefer Not To Say'
    WHEN Q13 = 'Mixed ( Caucasian / African-American )' THEN 'Mixed'
    WHEN Q13 = 'Prefer not to ans' OR Q13 = "Race isn't a thing" THEN 'Prefer Not To Say'
    ELSE Q13
END;

--

SELECT *
FROM datajobssurvey_cleaning;