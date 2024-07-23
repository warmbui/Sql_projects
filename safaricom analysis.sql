CREATE DATABASE stock_analysis;
USE stock_analysis;

CREATE TABLE safaricom_stock_prices (
id INT AUTO_INCREMENT PRIMARY KEY,
date DATE,
open DECIMAL(5,2),
high DECIMAL(5,2),
low DECIMAL(5,2),
close DECIMAL(5,2),
volume INT,
change_percentage DECIMAL(5,4)
);

-- Select all records from safaricom stock prices table
SELECT * FROM stock_analysis.safaricom_stock_prices;

# Descriptive Stats
-- Earliest and Latest Date, Count of records
SELECT
	min(Date) AS earliest_date,
    max(Date) AS latest_date,
    count(*) AS record_count
FROM
	safaricom_stock_prices;
