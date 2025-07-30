CREATE DATABASE dataset1;
USE dataset1;
CREATE TABLE dataset (
    Date DATE,
    Coal_RB_4800_FOB_London_Close_USD FLOAT,
    Coal_RB_5500_FOB_London_Close_USD FLOAT,
    Coal_RB_5700_FOB_London_Close_USD FLOAT,
    Coal_RB_6000_FOB_CurrentWeek_Avg_USD FLOAT,
    Coal_India_5500_CFR_London_Close_USD FLOAT,
    Price_WTI FLOAT,
    Price_Brent_Oil FLOAT,
    Price_Dubai_Brent_Oil FLOAT,
    Price_ExxonMobil FLOAT,
    Price_Shenhua FLOAT,
    Price_All_Share FLOAT,
    Price_Mining FLOAT,
    Price_LNG_Japan_Korea_Marker_PLATTS FLOAT,
    Price_ZAR_USD FLOAT,
    Price_Natural_Gas FLOAT,
    Price_ICE FLOAT,
    Price_Dutch_TTF FLOAT,
    Price_Indian_en_exg_rate FLOAT
);

SET GLOBAL LOCAL_INFILE=ON;
LOAD DATA LOCAL INFILE 'C:/Users/ghada/OneDrive/Desktop/cleaned_dataset.csv' INTO TABLE dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
SELECT * FROM dataset
#mean
SELECT AVG(Price_WTI) AS Mean_Price_WTI FROM dataset;

  WITH Ordered AS (
    SELECT 
        Price_WTI,
        ROW_NUMBER() OVER (ORDER BY Price_WTI) AS row_num,
        COUNT(*) OVER () AS total_rows
    FROM dataset
    WHERE Price_WTI IS NOT NULL
)
#median
SELECT AVG(Price_WTI) AS Median_Price_WTI
FROM Ordered
WHERE 
    row_num = FLOOR((total_rows + 1) / 2)
    OR row_num = FLOOR((total_rows + 2) / 2);
    #mode
    SELECT Price_WTI, COUNT(*) AS freq
FROM dataset
GROUP BY Price_WTI
ORDER BY freq DESC
LIMIT 1;
#variance
SELECT VAR_POP(Price_WTI) AS Variance_Price_WTI FROM dataset;
#Range
SELECT
MAX(Price_WTI) AS Max_WTI,
MIN(Price_WTI) AS Min_WTI,
MAX(Price_WTI) - MIN(Price_WTI) AS
Range_WTI
FROM dataset;
#standard deviation
SELECT STDDEV_POP(Price_WTI) AS StdDev_Price_WTI FROM dataset;
#Skewness
SELECT 
  (SUM(POWER(Price_WTI - avg_value, 3)) / COUNT(Price_WTI)) / 
  POWER(SQRT(SUM(POWER(Price_WTI - avg_value, 2)) / COUNT(Price_WTI)), 3) AS skewness
FROM 
  dataset,
  (SELECT AVG(Price_WTI) AS avg_value FROM dataset) AS avg_table;
  
  #kurtosis
  SELECT 
  (SUM(POWER(Price_WTI - avg_value, 4)) / COUNT(Price_WTI)) / 
  POWER(SQRT(SUM(POWER(Price_WTI - avg_value, 2)) / COUNT(Price_WTI)), 2) - 3 AS kurtosis
FROM 
  dataset,
  (SELECT AVG(Price_WTI) AS avg_value FROM dataset) AS avg_table;