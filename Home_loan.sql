SELECT  * FROM Banker_Data
SELECT  * FROM Customer_Data
SELECT  * FROM Home_Loan_Data
SELECT  * FROM Loan_Records_Data

--Q1. Call the stored procedure `city_and_above_loan_amt` you created above, based on the city San Francisco and loan amount cutoff of $1.5 million 

CREATE PROCEDURE city_and_above_loan_amt
    @city_name NVARCHAR(255),
    @loan_amt_cutoff DECIMAL(18, 2)
AS
BEGIN
    SET NOCOUNT ON

    SELECT *
    FROM Home_Loan_Data
    WHERE city = 'SAN FRANCISCO'
    AND (property_value* loan_percent/100)>= @loan_amt_cutoff
END

EXEC city_and_above_loan_amt 'dallas', 1500000


---Q2.  Find the number of Chinese customers with joint loans with property values less than $2.1 million, and served by female bankers.

SELECT COUNT(*) AS NumberOfCustomers
FROM Customer_Data AS C
JOIN Loan_Records_Data AS L ON C.customer_id = L.customer_id
JOIN Banker_Data AS B ON L.banker_id = B.banker_id
JOIN Home_Loan_Data AS H ON L.loan_id = H.loan_id
WHERE C.nationality = 'China'
AND H.joint_loan = 'Yes'
AND property_value < 2100000
AND B.gender = 'Female'


--Q3. Find the top 3 transaction dates (and corresponding loan amount sum) for which the sum of loan amount issued on that date is the highest. 


SELECT TOP 3
    transaction_date,
    SUM(property_value*loan_percent/100) AS total_loan_amount
FROM
    Home_Loan_Data AS H
JOIN Loan_Records_Data AS L ON L.loan_id = h.loan_id
GROUP BY
    transaction_date
ORDER BY
    transaction_date DESC


---Q4.  Create a stored procedure called `recent_joiners` that returns the ID, concatenated full name, date of birth,
---     and join date of bankers who joined within the recent 2 years (as of 1 Sep 2022) 

---    Call the stored procedure `recent_joiners` you created above.


	create procedure recent_joiners
	as 
		select banker_id,CONCAT(first_name,'',last_name) Full_name, dob as dateofbirth ,date_joined from Banker_Data
		where date_joined >dateadd(year,-2,'2022-09-01')

exec recent_joiners



--Q5. Find the ID and full name (first name concatenated with last name)
---- of customers who were served by bankers aged below 30 (as of 1 Aug 2022)


SELECT C.customer_id AS ID,
       CONCAT(C.first_name, ' ', C.last_name) AS Full_Name
FROM Customer_Data AS C
JOIN Loan_Records_Data AS L ON C.customer_id = L.customer_id
JOIN Banker_Data AS B ON L.banker_id = B.banker_id
WHERE DATEDIFF(YEAR, B.dob, '2022-08-01') < 30


---Q6. Find the number of bankers involved in loans where the loan amount is greater than the average loan amount.


select count(*) total_bankers from Banker_Data b
inner join Loan_Records_Data l on l.banker_id = b.banker_id
inner join Home_Loan_Data h  on h.loan_id = l.loan_id
where (property_value*loan_percent/100) > (select avg(property_value*loan_percent/100) FROM Home_Loan_Data)


---Q7. Create a view called `dallas_townhomes_gte_1m` which returns all the details of loanS
---   involving properties of townhome type, located in Dallas, and have loan amount of >$1 million
SELECT * FROM Home_Loan_Data

CREATE VIEW dallas_townhomes_gte_1m AS
SELECT *
FROM home_loan_data
WHERE property_type = 'townhome'
AND city = 'Dallas'
AND (property_value*loan_percent/100) > 1000000

select * from dallas_townhomes_gte_1m

--Q8. Find the sum of the loan amounts ((i.e., property value x loan percent / 100) for each banker ID,
---   excluding properties based in the cities of Dallas and Waco. The sum values should be rounded to nearest integer.

SELECT * FROM Loan_Records_Data

SELECT banker_id, ROUND(SUM(property_value * loan_percent / 100),0) AS loan_sum
FROM Home_Loan_Data AS H
JOIN Loan_Records_Data AS L ON H.loan_id = L.loan_id
WHERE city NOT IN ('Dallas', 'Waco')
GROUP BY banker_id



--Q9. Find the ID, first name and last name of customers with properties of value between $1.5 and $1.9 million,
---   along with  a new column 'tenure' that categorizes how long the customer has been with WBG. 


SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    CASE
        WHEN c.customer_since < '2015-01-01' THEN 'Long'
        WHEN c.customer_since >= '2015-01-01' AND c.customer_since < '2019-01-01' THEN 'Mid'
        ELSE 'Short'
    END AS tenure
FROM
    Customer_Data c
JOIN
   Loan_Records_Data AS L ON c.customer_id = L.customer_id
JOIN
    Home_Loan_Data AS H ON H.loan_id = L.loan_id
WHERE
    H.property_value BETWEEN 1500000 AND 1900000

















