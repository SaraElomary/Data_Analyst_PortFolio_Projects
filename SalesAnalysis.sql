--- Ispecting Data
SELECT * 
FROM [dbo].[RFM_Analysis_in_SQL]

---Checking Unique Values
SELECT DISTINCT STATUS FROM [dbo].[RFM_Analysis_in_SQL]
SELECT DISTINCT YEAR_ID FROM [dbo].[RFM_Analysis_in_SQL]
SELECT DISTINCT PRODUCTLINE FROM [dbo].[RFM_Analysis_in_SQL]
SELECT DISTINCT COUNTRY FROM [dbo].[RFM_Analysis_in_SQL]
SELECT DISTINCT DEALSIZE FROM [dbo].[RFM_Analysis_in_SQL]
SELECT DISTINCT TERRITORY FROM [dbo].[RFM_Analysis_in_SQL]

SELECT DISTINCT MONTH_ID FROM [dbo].[RFM_Analysis_in_SQL]
WHERE YEAR_ID = 2003


--------------------ANALYSIS----------------------------------

-------Grouping sales by productiveline
SELECT PRODUCTLINE, SUM(SALES) as Revenue
FROM [dbo].[RFM_Analysis_in_SQL]
Group by PRODUCTLINE
order by 2 desc

SELECT YEAR_ID, PRODUCTLINE, SUM(SALES) as Revenue
FROM [dbo].[RFM_Analysis_in_SQL]
Group by YEAR_ID, PRODUCTLINE
order by 1,3 desc

--- The highest revenues' year
SELECT YEAR_ID, SUM(SALES) as Revenue
FROM [dbo].[RFM_Analysis_in_SQL]
Group by YEAR_ID
order by 2 desc

--- The size that gets most revenues
SELECT DEALSIZE, SUM(SALES) as Revenue
FROM [dbo].[RFM_Analysis_in_SQL]
Group by DEALSIZE
order by 2 desc


---best month for sales in a specific year
SELECT YEAR_ID, MONTH_ID , SUM(SALES) as Revenue, count(ORDERNUMBER) as frequency
FROM [dbo].[RFM_Analysis_in_SQL]
---where YEAR_ID = 2003
Group by YEAR_ID, MONTH_ID
order by 1,3 desc

---The seller product in november
SELECT MONTH_ID, PRODUCTLINE, SUM(SALES) as Revenues, count(ORDERLINENUMBER) as frequency
FROM [dbo].[RFM_Analysis_in_SQL]
where YEAR_ID = 2005 and MONTH_ID = 5
group by MONTH_ID, PRODUCTLINE
order by 3 desc

--- The best customer
DROP TABLE IF EXISTS #rfm
;with rfm as 
(SELECT CUSTOMERNAME, 
	sum(SALES) as MontaryValues,	
	avg(SALES) as AvgMontaryValues,
	COUNT(ORDERNUMBER) as frequency,
	max(ORDERDATE) as last_order_date,
	(select max(ORDERDATE) from [dbo].[RFM_Analysis_in_SQL]) as max_order_date,
	DATEDIFF(DD, max(ORDERDATE),(select max(ORDERDATE) from [dbo].[RFM_Analysis_in_SQL])) as recency
FROM [dbo].[RFM_Analysis_in_SQL]
group by CUSTOMERNAME
),
rfm_calc as (

select r.*,
	NTILE(4) OVER (order by recency desc) rfm_recency,
	NTILE(4) OVER (order by frequency) rfm_frequency,
	NTILE(4) OVER (order by MontaryValues) rfm_montary
from rfm r
)
select c.*,
	rfm_recency	+ rfm_frequency + rfm_montary as rfm_cell,
	cast(rfm_recency  as nvarchar) + cast(rfm_frequency as nvarchar) + cast(rfm_montary as nvarchar) as rfm_cell_string
into #rfm
from rfm_calc c

select CUSTOMERNAME,
	rfm_recency	, rfm_frequency,  rfm_montary,
	case 
	 when rfm_cell_string in (111, 112, 121, 122, 123, 132,211,212,114,141) then 'lost_customers'
	 when rfm_cell_string in (133, 134, 143, 244, 334, 343,344, 144,221,421) then 'cannot lose'
	 when rfm_cell_string in (311, 411, 331) then 'new_customers'
	 when rfm_cell_string in (222, 223, 233, 322,232, 234) then 'potential churners'
	 when rfm_cell_string in (323, 333, 321, 422, 332, 432,423) then 'active'
	 when rfm_cell_string in (433,434,443,444) then 'loyal'
   end as rfm_segment

from #rfm

select * from RFM_Analysis_in_SQL 

--- Products are most often sold together
--select * from RFM_Analysis_in_SQL where ORDERNUMBER = 10388
select distinct ORDERNUMBER, stuff(

	(Select ',' + PRODUCTCODE
	from RFM_Analysis_in_SQL p
	where ORDERNUMBER IN
	 (Select ORDERNUMBER
		from(
			Select ORDERNUMBER, count(*) as row_nbr
			FROM RFM_Analysis_in_SQL
			where STATUS = 'Shipped'
			group by ORDERNUMBER
			) m
		where row_nbr = 3 ) 
		 
		and p.ORDERNUMBER = s.ORDERNUMBER
		for xml path(''))
		, 1, 1, '') ProductsCodes

from RFM_Analysis_in_SQL s 
order by 2 desc
