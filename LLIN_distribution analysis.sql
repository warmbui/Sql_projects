-- Creating the database
CREATE DATABASE llin_analysis;
USE llin_analysis;

CREATE TABLE llin_distribution (
ID INT PRIMARY KEY,
    Number_distributed INT,
    Location VARCHAR(255),
    Country VARCHAR(255),
    year YEAR,
    By_whom VARCHAR(255),
    Country_code CHAR(3)
);

SELECT * FROM llin_analysis.llin_distribution;

-- Total number of LLINs distributed in each country
SELECT Country, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY Country
ORDER BY Total_LLINS_Distributed DESC;

-- Average number of LLINs distributed per distribution event
SELECT AVG(Number_distributed) AS Average_LLINS_Per_Event
FROM llin_distribution;

-- Earliest and latest distribution dates
SELECT MIN(year) AS Earliest_Distribution, MAX(year) AS Latest_Distribution
FROM llin_distribution;

-- Total number of LLINs distributed by each organization
SELECT By_whom, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY By_whom
ORDER BY Total_LLINS_Distributed DESC;

-- Total number of LLINs distributed each year
SELECT year, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY year
ORDER BY year;

-- Locations with the highest number of LLINs distributed
SELECT Location, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY Location
ORDER BY Total_LLINS_Distributed DESC
LIMIT 1;

-- Locations with the lowest number of LLINs distributed
SELECT Location, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY Location
ORDER BY Total_LLINS_Distributed ASC
LIMIT 1;

-- Significant difference in the number of LLINs distributed by different organizations
SELECT By_whom, AVG(Number_distributed) AS Avg_Distributed
FROM llin_distribution
GROUP BY By_whom
ORDER BY Avg_Distributed DESC;

-- Outliers in the number of LLINs distributed in specific locations
WITH stats AS (
    SELECT 
        AVG(Number_distributed) AS mean_number_distributed,
        STDDEV_POP(Number_distributed) AS stddev_number_distributed
    FROM llin_distribution
),

-- Identify outliers based on the calculated mean and standard deviation
outliers AS (
    SELECT 
        *,
        (Number_distributed - (SELECT mean_number_distributed FROM stats)) / (SELECT stddev_number_distributed FROM stats) AS z_score
    FROM 
        llin_distribution
    WHERE 
        Number_distributed > (SELECT mean_number_distributed + 3 * stddev_number_distributed FROM stats)
        OR Number_distributed < (SELECT mean_number_distributed - 3 * stddev_number_distributed FROM stats)
)
SELECT 
    (SELECT mean_number_distributed FROM stats) AS mean_number_distributed,
    (SELECT stddev_number_distributed FROM stats) AS stddev_number_distributed,
    outliers.*
FROM 
    outliers;
    
    -- Significant spikes in the number of LLINs distributed during specific periods
SELECT year, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY year
ORDER BY Total_LLINS_Distributed DESC
LIMIT 5;
