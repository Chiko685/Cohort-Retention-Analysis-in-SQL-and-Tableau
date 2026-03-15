SELECT count(*) FROM `cohort-analysis-490121.cohort_analysis.online_retail_data` 
--TOTAL RECORDS = 541909 ROWS

--1. CHECKING NULL VALUES 
-- 2. CHECKING DUPLICATES 
SELECT * FROM `cohort-analysis-490121.cohort_analysis.online_retail_data`

-- Total records customer ID != 0 is 406829
-- Total records dengan customer ID is NULL = 135080
SELECT count(*) as C FROM `cohort-analysis-490121.cohort_analysis.online_retail_data` 
WHERE CustomerID is not NULL


-- CHECKING DUPLICATES USING ROW_NUMBER(), why I use row_number instead of rank or dense rank? 
-- Because row_number will present the unique value ranking for each data
-- I want create a clean dataset without dupliactes and I will create a permanent table. I tried temp table but it last one session only and thats not effective.
drop table if exists `cohort-analysis-490121.cohort_analysis.online_retail_clean`


create table `cohort-analysis-490121.cohort_analysis.online_retail_clean` as 
with missing_value_check as (
SELECT * FROM `cohort-analysis-490121.cohort_analysis.online_retail_data` 
WHERE CustomerID is not NULL
),
duplicate_value_check as(
    select *, row_number() over (partition by InvoiceNo, StockCode, Quantity order by InvoiceNo) as duplicates
    from missing_value_check
)
select * 
from duplicate_value_check
where duplicates = 1;

-- Here I have total 401548 clean data with no duplicates and have Customer ID 
select * from `cohort-analysis-490121.cohort_analysis.online_retail_clean`


--BEGIN COHORT ANALYSIS 
-- Initial Start Date (First Invoice Date)
--COHORT = group of customer who have something in common
-- COHORT ANALYSIS =  is an analysis of several different cohorts  to get better understanding of behaviors, patterns and trends
-- In this project I want to analyst a retention analysis of the customer. So its time based cohort. 
create table `cohort-analysis-490121.cohort_analysis.cohort` as
select CustomerID,
    min(InvoiceDate) as first_purchase_date, 
    DATE_TRUNC(DATE (MIN(InvoiceDate)), month) as cohort_date
from `cohort-analysis-490121.cohort_analysis.online_retail_clean`
group by 1;

select * from `cohort-analysis-490121.cohort_analysis.cohort`;

-- COHORT INDEX = is an integer representation of the number of months that has passed since the customer first engagement

-- Create COHORT INDEX, using join clean dataset and cohort dataset 
-- Here i want to use left join because I want to extract all the data from online_retail_clean and left join chort_date(year and month)

-- formula for Cohort Index = ((year transaction - year Cohort) * 12) + (month transaction - month Cohort) + 1

 create table `cohort-analysis-490121.cohort_analysis.cohort_retention` as
 select 
    ccc.*,
    year_diff * 12 + month_diff + 1 as cohort_index
 from 
 (
    select cc.*,
        invoice_year - cohort_year as year_diff,
        invoice_month - cohort_month as month_diff
    from 
    (
        select 
            orc.*,
            c.cohort_date,
            EXTRACT (year from orc.InvoiceDate) as invoice_year,
            EXTRACT (month from orc.InvoiceDate) as invoice_month,
            EXTRACT (year from c.cohort_date) as cohort_year,
            EXTRACT (month from c.cohort_date) as cohort_month
        from `cohort-analysis-490121.cohort_analysis.online_retail_clean` orc
        left join `cohort-analysis-490121.cohort_analysis.cohort` c on orc.CustomerID = c.CustomerID
        ) as cc
    ) as ccc

select * from `cohort-analysis-490121.cohort_analysis.cohort_retention`;
--where ccc.CustomerID = 12359

--- In the Cohort Index = 1 , meaning that the customers made second purchase in the same month as their first purchase, so Cohort Index gives us how many months that has passed after the first purchase. Cohort Index = 2 meaning that the customers made second purchase in the following month/next month ex= from Jan to Feb
-- in the result data above we can now "SAVE AND DOWNLOAD" so we can use it for visualization in tableau

-- PIVOT TABLE
--
create table `cohort-analysis-490121.cohort_analysis.cohort_pivot` as
select *
from 
(
        select 
            CustomerID, 
            cohort_date,
            cohort_index
        from `cohort-analysis-490121.cohort_analysis.cohort_retention`
        order by 1, 3
)
PIVOT (
    COUNT(CustomerID)
    for cohort_index IN (1,2,3,4,5,6,7,8,9,10,11,12, 13)
)

-- to know how many cohort_index or month we have in our data 
-- the result is 13 months
select distinct(cohort_index) as c 
from `cohort-analysis-490121.cohort_analysis.cohort_retention` 
order by 1

--I want to know if the table already created as cohort_pivot 
select * 
from `cohort-analysis-490121.cohort_analysis.cohort_pivot`
order by cohort_date

-- Next is I want to create the precentage of the cohort, here I want to know how much precentage of customer return the next month 
--To see that [1] must be the based to calculate the following month customer 
SELECT *
FROM `cohort-analysis-490121.cohort_analysis.cohort_pivot`
order by cohort_date

SELECT 
    *,
    ROUND(SAFE_DIVIDE(_1, _1) * 100, 2) AS retention_1,
    ROUND(SAFE_DIVIDE(_2, _1) * 100, 2) AS retention_2,
    ROUND(SAFE_DIVIDE(_3, _1) * 100, 2) AS retention_3,
    ROUND(SAFE_DIVIDE(_4, _1) * 100, 2) AS retention_4,
    ROUND(SAFE_DIVIDE(_5, _1) * 100, 2) AS retention_5,
    ROUND(SAFE_DIVIDE(_6, _1) * 100, 2) AS retention_6,
    ROUND(SAFE_DIVIDE(_7, _1) * 100, 2) AS retention_7,
    ROUND(SAFE_DIVIDE(_8, _1) * 100, 2) AS retention_8,
    ROUND(SAFE_DIVIDE(_9, _1) * 100, 2) AS retention_9,
    ROUND(SAFE_DIVIDE(_10, _1) * 100, 2) AS retention_10,
    ROUND(SAFE_DIVIDE(_11, _1) * 100, 2) AS retention_11,
    ROUND(SAFE_DIVIDE(_12, _1) * 100, 2) AS retention_12,
    ROUND(SAFE_DIVIDE(_13, _1) * 100, 2) AS retention_13
FROM `cohort-analysis-490121.cohort_analysis.cohort_pivot`
ORDER BY cohort_date;
--INTERPRETATION=
-- RETENTION_1 : 100% is a baseline (all must divided by the baseline)
-- RETENTION_ 2 : 40.99% customer still active in month 2/next month 
-- RETENTION_3 : 34.5% customer still active in month 3





