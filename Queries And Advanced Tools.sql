--Querries

--1
Select P.Vendor, [Orders Made]=Count(Distinct O.[Order-ID]), [Total Profit]=sum(I.Quantity*P.Price), [Total Products sold]=sum(I.Quantity)
From Products As P join Includes As I on P.[Item Number]=I.[Item Number]
join Orders As O on I.[Order ID]= O.[Order-ID]
Where Year(O.DT)=2021
Group By P.Vendor
Order by 4 DESC

--2
Select O.[Customer Email],O.Name, [Total Price paid]= Round(Sum(I.Quantity*P.Price),2)
From Orders As O join Includes As I on O.[Order-ID]= I.[Order ID]
join Products As P on I.[Item Number]=P.[Item Number]
Where O.[Customer Email] is not null
Group by O.[Customer Email],O.Name
Having Round(Sum(I.Quantity*P.Price),2)>1000
Order By 3 DESC

---Nested Query
--3
SELECT Q.[Item Number], [NumberOfQuestions]=COUNT(*) 
FROM Questions AS Q
GROUP BY Q.[Item Number]
HAVING COUNT(*) > (SELECT AVG(NumOfQ.NumberOfQuestions1)
FROM (SELECT Q1.[Item Number], [NumberOfQuestions1]=COUNT(*) 
FROM Questions AS Q1
GROUP BY Q1.[Item Number]) As NumOfQ)


--4
SELECT DISTINCT C.Email, C.Name, [Number Of Searches]=COUNT(S.[Search DT])
FROM Customers AS C JOIN Searches AS S ON C.Email=S.Email
WHERE YEAR(C.[Join Date]) >= 2020 AND C.Email NOT IN (SELECT DISTINCT C1.Email
FROM Customers AS C1 JOIN Orders AS O ON C1.Email=O.[Customer Email])
GROUP BY C.Email, C.Name
ORDER BY 3 DESC

---Nested Query with other elements
---5
update ShippingPrices
set [Shipping Price] = ([Shipping Price]*0.9)
WHERE State IN (
SELECT TOP 3 NewTable.State
FROM(
SELECT O.[Order-ID], State=O.State
FROM Orders AS O
WHERE O.[Customer Email] IS NULL AND O.[Delivery Method]='Ship'
UNION
SELECT O.[Order-ID], State=A.State
FROM Orders AS O JOIN Addresses AS A ON O.[Customer Email]=A.Email AND O.Number=A.Number
WHERE O.[Customer Email] IS NOT NULL AND O.[Delivery Method]='Ship') AS NewTable  
GROUP BY NewTable.State
ORDER BY COUNT(*) DESC) AND [Delivery Method]='Ship'


--6
select O.Email, O.Name
From Orders As O join Includes As I on O.[Order-ID]=I.[Order ID] 
join Products As P on I.[Item Number]=P.[Item Number]
where Email is not null
Group By O.[Order-ID], O.Email, O.Name 
Having sum(I.Quantity*P.Price)<(
Select [Average Revenue]= AVG(SumMoney.[Total Money])
From(
Select O.[Order-ID], [Total Money]=sum(I.Quantity*P.Price) 
From Orders As O join Includes As I on O.[Order-ID]=I.[Order ID] 
join Products As P on I.[Item Number]=P.[Item Number]
Group by O.[Order-ID]) As SumMoney)
union 
select O.[Customer Email], O.Name
From Orders As O join Includes As I on O.[Order-ID]=I.[Order ID] 
join Products As P on I.[Item Number]=P.[Item Number]
where O.[Customer Email] is not null
Group By O.[Order-ID], O.[Customer Email], O.Name 
Having sum(I.Quantity*P.Price)<(
Select [Average Revenue]= AVG(SumMoney.[Total Money])
From(
Select O.[Order-ID],[Total Money]=sum(I.Quantity*P.Price) 
From Orders As O join Includes As I on O.[Order-ID]=I.[Order ID] 
join Products As P on I.[Item Number]=P.[Item Number]
Group by O.[Order-ID]) As SumMoney)



--Advance Tools

--View

--DROP VIEW V_OrderPerProduct
CREATE VIEW V_OrderPerProduct AS
Select P.[Item Number], [Number Of Orders]=Count(Distinct O.[Order-ID]), [Quantity Sold]=sum(I.Quantity),[Total Revenue] =Round(sum(I.Quantity*p.Price),2)
From Products As P join Includes As I on P.[Item Number]=I.[Item Number]
Join Orders As O on I.[Order ID]=O.[Order-ID] 
Group By P.[Item Number]

--using the view
Select Top 5 *
From V_OrderPerProduct
Order By V_OrderPerProduct.[Quantity Sold] DESC


--Functions

--1
--DROP FUNCTION NumOfOrdersToState
CREATE FUNCTION NumOfOrdersToState (@State varchar(20), @Year INT)
RETURNS INT
AS Begin
	declare @NumOfOrders int
		select @NumOfOrders = count(*)
		from Orders AS O LEFT Join Addresses AS A 
			ON O.Number = A.Number AND O.[Customer Email]=A.Email
		where o.[Delivery Method] = 'Ship' AND (O.State = @State or A.State= @State)
			  AND year(O.DT)=@Year

return @NumOfOrders
END

--using the function
Select SP.State, [Number Of Orders Shiped To State] = dbo.NumOfOrdersToState(SP.State, 2018)
FROM ShippingPrices AS SP
Group by SP.State
Order by [Number Of Orders Shiped To State] desc


--2
--DROP FUNCTION OrdersBetween
CREATE FUNCTION OrdersBetween(@start Date, @end Date)
returns table
as return(
	select O.[Order-ID], O.DT, O.[Delivery Method],[Total Products] =COUNT(P.[Item Number]),[Total Revenue]= SUM(I.Quantity*P.Price)
	from Orders as O JOIN
	Includes AS I ON O.[Order-ID]=I.[Order ID]  JOIN
	Products AS P ON P.[Item Number]=I.[Item Number]
	where O.DT >=@start and O.DT<=@end 
	group by O.[Order-ID],  O.DT, O.[Delivery Method]
)

--using the function
Select *
from dbo.OrdersBetween('2020-01-01', '2021-04-30')
Order by 5 desc


--Trigger

ALTER TABLE Products
add [Total units in Orders] int


--DROP Trigger UpdateUnitsInOrders
CREATE Trigger UpdateUnitsInOrders
ON includes
For insert, update, delete AS
UPDATE Products SET
		[Total units in Orders] = ISNULL([Total units in Orders],0) + 
		(Select I.Quantity From inserted AS I
		Where I.[Item Number]=Products.[Item Number])
where Products.[Item Number] in (select distinct ins.[Item Number] from inserted as ins)
UPDATE Products SET
		[Total units in Orders] = ISNULL([Total units in Orders],0) - 
		(Select D.Quantity From  deleted AS D
		Where D.[Item Number]=Products.[Item Number])
where Products.[Item Number] in (select distinct del.[Item Number] from deleted as del)


--Stored Procedure 
alter table products add Rank varchar(25)

--DROP procedure SP_UpdateProductsPopularity
create procedure SP_UpdateProductsPopularity (@NumOfPopulars int)
AS BEGIN 
Update Products 
SET Rank = (CASE
WHEN [Item Number] IN (Select Top (@NumOfPopulars) v1.[Item Number]
From V_OrderPerProduct as v1
Order By v1.[Quantity Sold] DESC, [Item Number]) THEN 'Most Popular'
WHEN [Item Number] IN (Select Top (@NumOfPopulars+@NumOfPopulars) V2.[Item Number]
From V_OrderPerProduct AS V2
Order By V2.[Quantity Sold] DESC,[Item Number]
EXCEPT Select Top (@NumOfPopulars) V3.[Item Number]
From V_OrderPerProduct AS V3
Order By V3.[Quantity Sold] DESC, [Item Number]) THEN 'Popular' 
ELSE 'Regular' END)
END

execute dbo.SP_UpdateProductsPopularity 10