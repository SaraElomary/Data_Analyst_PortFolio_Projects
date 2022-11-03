/****** Script for SelectTopNRows command from SSMS  ******/

--- Cleaning Data
SELECT TOP (50) [NAICS Codes]
      ,[NAICS Industry Description]
  FROM [Project].[dbo].[NAICS]

 SELECT [NAICS Industry Description],
 iif ([NAICS Industry Description] like '%–%', SUBSTRING([NAICS Industry Description], 8, 2), '') as LookUpCodes_if,
 --case when [NAICS Industry Description] like '%–%' then SUBSTRING([NAICS Industry Description], 8, 2) 
 end LookUpCodes_case
 FROM [Project].[dbo].[NAICS]


 select *
 into sba_naics_sector_codes_description
 from (
  SELECT [NAICS Industry Description],
 iif ([NAICS Industry Description] like '%–%', SUBSTRING([NAICS Industry Description], 8, 2), '') as LookUpCodes,
 iif ([NAICS Industry Description] like '%–%',ltrim(SUBSTRING([NAICS Industry Description], CHARINDEX('–', [NAICS Industry Description]) + 1, LEN([NAICS Industry Description]) )) , '')  sector
 FROM [Project].[dbo].[NAICS]) main
 where LookUpCodes !=''

 SELECT * from sba_naics_sector_codes_description
  order by LookUpCodes

 insert into sba_naics_sector_codes_description
 values ('Sector 31 – 33 – Manufacturing', 32, 'Manufacturing'),
 ('Sector 31 – 33 – Manufacturing', 33, 'Manufacturing'),('Sector 31 – 33 – Manufacturing', 32, 'Manufacturing'),

('Sector 44 - 45 – Retail Trade',45,'Retail Trade'),('Sector 48 - 49 – Transportation and Warehousing',49,'Transportation and Warehousing')

update sba_naics_sector_codes_description
set sector = 'Manufacturing'
where LookUpCodes= 31 
Delete from sba_naics_sector_codes_description where LookUpCodes= 32





---Exploring Data

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
FROM [Project].[dbo].[SAB_data]

---What is the summary of all approved PPP loans
SELECT year(DateApproved), COUNT(LoanNumber) as NumberofApproved,
CAST(SUM(InitialApprovalAmount) as bigint) as ApprovedAmount,
AVG(InitialApprovalAmount)
FROM [Project].[dbo].[SAB_data]
where year(DateApproved) = 2020
group by year(DateApproved)

UNION

SELECT year(DateApproved), COUNT(LoanNumber) as NumberofApproved,
CAST(SUM(InitialApprovalAmount) as bigint) as ApprovedAmount,
AVG(InitialApprovalAmount) as AverageLoanSize
FROM [Project].[dbo].[SAB_data]
where year(DateApproved) = 2021
group by year(DateApproved)


SELECT COUNT(distinct OriginatingLender) as OriginatingLender,
year(DateApproved),
COUNT(LoanNumber) as NumberofApproved,
CAST(SUM(InitialApprovalAmount) as bigint) as ApprovedAmount,
AVG(InitialApprovalAmount)
FROM [Project].[dbo].[SAB_data]
where year(DateApproved) = 2020
group by year(DateApproved)


UNION

SELECT COUNT(distinct OriginatingLender) as OriginatingLender,
year(DateApproved),
COUNT(LoanNumber) as NumberofApproved,
CAST(SUM(InitialApprovalAmount) as bigint) as ApprovedAmount,
AVG(InitialApprovalAmount)
FROM [Project].[dbo].[SAB_data]
where year(DateApproved) = 2021
group by year(DateApproved)


--- Top 15 Originating lenders by loan count, total amount and average in 20202 and 2021
SELECT TOP 15 
	OriginatingLender,
	COUNT(LoanNumber) as NumberofApproved,
	CAST(SUM(InitialApprovalAmount) as bigint) as ApprovedAmount,
	AVG(InitialApprovalAmount) as AverageAmount
FROM [Project].[dbo].[SAB_data]
	WHERE year(DateApproved) = 2021
group by
	OriginatingLender
order by 3 desc

---Top 20 industries that recieved the PPP loans in 2021 and 2020

 SELECT top 20 s.sector, year(DateApproved) as YearApproved,
	COUNT(LoanNumber) as NumberofApproved,
	CAST(SUM(InitialApprovalAmount) as bigint) as ApprovedAmount,
	AVG(InitialApprovalAmount) as AverageAmount
FROM [Project].[dbo].[SAB_data] p
	inner join [dbo].[sba_naics_sector_codes_description] s on left(p.NAICSCode, 2) = s.LookUpCodes
	
group by
	s.sector, year(DateApproved)
order by 3 desc

---How much of the ppp loans of 2021 have been fully forgiven

SELECT 
	COUNT(LoanNumber) as NumberofApproved,
	CAST(SUM(CurrentApprovalAmount) as BIGINT) as Current_Approval_Amount, 
	avg(CurrentApprovalAmount) as Current_Approval_loan_size,
	CAST(SUM(ForgivenessAmount)as bigint) as Forgiveness_Amount,
	SUM(ForgivenessAmount)/ SUM(CurrentApprovalAmount) * 100 as percent_Forgiveness
FROM  [Project].[dbo].[SAB_data]
WHERE year(DateApproved) = 2020
order by 3 desc

SELECT 
	COUNT(LoanNumber) as NumberofApproved,
	CAST(SUM(CurrentApprovalAmount) as BIGINT) as Current_Approval_Amount, 
	avg(CurrentApprovalAmount) as Current_Approval_loan_size,
	CAST(SUM(ForgivenessAmount)as bigint) as Forgiveness_Amount,
	SUM(ForgivenessAmount)/ SUM(CurrentApprovalAmount) * 100 as percent_Forgiveness
FROM  [Project].[dbo].[SAB_data]
WHERE year(DateApproved) = 2021
order by 3 desc

--- Year, month with the highest ppp loan approved
SELECT 
	COUNT(LoanNumber) as NumberofApproved,
	Year(DateApproved) as year , month(DateApproved) as month ,
	CAST(SUM(InitialApprovalAmount) as BIGINT) as Initial_Approval_Amount, 
	avg(InitialApprovalAmount) as Initial_Approval_loan_size
FROM  [Project].[dbo].[SAB_data]
group by month(DateApproved),Year(DateApproved)
order by 4 desc