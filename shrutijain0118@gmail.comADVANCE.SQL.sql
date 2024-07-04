--SQL Advance Case Study


--Q1--BEGIN 
         SELECT C.STATE --, SUM(B.Quantity) QTTY
         FROM DIM_CUSTOMER A
         LEFT JOIN FACT_TRANSACTIONS B 
         ON A.IDCustomer = B.IDCustomer
         LEFT JOIN DIM_LOCATION C
         ON B.IDLocation= C.IDLocation
         WHERE YEAR(DATE) >= 2005 
         GROUP BY C.State	


--Q1--END

--Q2--BEGIN
	select   top 1 d.state from DIM_MANUFACTURER a
	inner join DIM_MODEL b
	on a.IDManufacturer = b.IDManufacturer
	left join fact_transactions c
	on b.IDModel = c.IDMOdel
	left join dim_location d
	on c.idlocation = d.idlocation
	where a.Manufacturer_Name = 'samsung' and Country='US'
	group by d.state 
	order by count(Quantity) desc


--Q2--END

--Q3--BEGIN      
	  SELECT A.ZIPCODE,A.STATE,COUNT(IDMODEL) Transactions
	  FROM DIM_LOCATION A
	  INNER JOIN FACT_TRANSACTIONS B ON A.IDLocation=B.IDLocation
      GROUP BY ZIPCODE,State


--Q3--END

--Q4--BEGIN
      SELECT MODEL_NAME, UNIT_PRICE
	  FROM DIM_MODEL
      WHERE Unit_price = (SELECT MIN (UNIT_PRICE) FROM DIM_MODEL)

--Q4--END

--Q5--BEGIN
      select top 5 model_name,avg(unit_price) as average_price 
	  from DIM_MODEL a 
	  inner join FACT_TRANSACTIONS B
	  on a.IDModel=b.IDModel group by Model_Name order by avg(Unit_price) desc

--Q5--END

--Q6--BEGIN
      select customer_name,avg(b.totalprice)
	  from DIM_CUSTOMER a 
	  inner join FACT_TRANSACTIONS b on a.idcustomer=b.idcustomer 
      and year(date)='2009'
	  group by customer_name
	  having avg (b.totalprice)>500


--Q6--END
	
--Q7--BEGIN  
	  select Model_Name 
from (
		select top 5  count(quantity) as quantity,
		Model_Name from DIM_MODEL m
		inner join FACT_TRANSACTIONS f
		on m.IDModel = f.IDModel
		where year(date) in (2008,2009,2010)
		group by Model_Name
		order by quantity desc
	)
as S

--Q7--END	
--Q8--BEGIN

with sales 
as (
		select * ,DENSE_RANK() over(order by Sales desc) denserank
		from (
				select --count(d.IDManufacturer) as id_manu, 
				d.Manufacturer_Name,sum(f.TotalPrice) Sales from DIM_MODEL m
				inner join  DIM_MANUFACTURER d 
				on m.idmanufacturer = d.idmanufacturer 
				inner join FACT_TRANSACTIONS f
				on m.IDModel = f.IDModel
				where year(date) =2009
				group by  d.Manufacturer_Name
			 ) as Z
union
		select * , dense_rank () over (order by Sales desc)  as denserank
		from(
				select --count(d.IDManufacturer) as id_manu, 
				d.Manufacturer_Name,sum(f.TotalPrice)  Sales --,DENSE_RANK() over(order by TotalPrice desc)  
				from DIM_MODEL m
				inner join  DIM_MANUFACTURER d 
				on m.idmanufacturer = d.idmanufacturer 
				inner join FACT_TRANSACTIONS f
				on m.IDModel = f.IDModel
				where year(date) =2010
				group by  d.Manufacturer_Name
			) as y
	) 
select Manufacturer_Name,Sales from sales
where denserank = 2

--Q8--END
--Q9--BEGIN
	select m.Manufacturer_Name from FACT_TRANSACTIONS f
  left join DIM_MODEL d 
  on f.IDModel = d.IDModel
  left join DIM_MANUFACTURER m
  on d.IDManufacturer = m.IDManufacturer
  where year (date) =2010
except
  select m.Manufacturer_Name from FACT_TRANSACTIONS f
  left join DIM_MODEL d 
  on f.IDModel = d.IDModel
  left join DIM_MANUFACTURER m
  on d.IDManufacturer = m.IDManufacturer
  where Year(date) = 2009

--Q9--END

--Q10--BEGIN
	
	select *,(((avg_price-pre_year)/(pre_year))*100 ) as Nxt_year from (
select *,lag (avg_price ,1) over (partition by IDCustomer order by [year]) as pre_year from (
select c.IDCustomer,c.Customer_Name ,year( t.Date) [year],avg(t.TotalPrice)  avg_price,avg(t.Quantity) avg_Qty   from  DIM_CUSTOMER c
inner join FACT_TRANSACTIONS  t
on c.IDCustomer = t.IDCustomer
where c.IDCustomer  in (select top 10 IDCustomer from FACT_TRANSACTIONS group by  IDCustomer order by sum(TotalPrice) desc)
group by  c.IDCustomer,c.Customer_Name , year( t.Date) 
--order by c.IDCustomer 
) as x) as z

--Q10--END
	