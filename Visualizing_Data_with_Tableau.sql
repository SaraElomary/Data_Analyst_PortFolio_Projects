Create view ppp_main as

SELECT
	n.sector,
	year(DateApproved) as year_approved,
	month(DateApproved) as month_approved,
	OriginatingLender,
	BorrowerState,
	Race,
	Gender,
	Ethnicity,
	COUNT(LoanNumber) as Number_of_approved,
	SUM(CurrentApprovalAmount) as Current_Approval_Amount,
	avg(CurrentApprovalAmount) as Current_Average_loan_size,
	SUM(ForgivenessAmount) as Forgiveness_Amount,

	SUM(InitialApprovalAmount)as Initial_Approval_Amount,
	avg(InitialApprovalAmount) as Average_loan_size
	
FROM SAB_data s
	 inner join sba_naics_sector_codes_description  n
	 on left(s.NAICSCode, 2) = n.LookUpCodes

group by 
n.sector,
	year(DateApproved),
	month(DateApproved),
	OriginatingLender,
	BorrowerState,
	Race,
	Gender,
	Ethnicity