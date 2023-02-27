
--views for visual tools - sales report and CEO dashboard

--orders and products 
CREATE VIEW V_ProductSummery AS
Select P.[Item Number], O.DT, [Product Profit]= I.Quantity*P.Price
From Products As P join Includes As I on P.[Item Number]=I.[Item Number]
Join Orders As O on I.[Order ID]=O.[Order-ID] 

Select V.[Item Number], [Total]=sum(v.[Product Profit])
From  V_ProductSummery AS V
Group by V.[Item Number]
Order by 2 desc

CREATE VIEW V_ProductSummeryNew AS
Select O.[Order-ID],P.[Item Number], O.DT, [Product Profit]= sum(I.Quantity*P.Price)
From Orders As O join Includes As I on I.[Order ID]=O.[Order-ID]
join Products As P on I.[Item Number]=P.[Item Number]
Group By O.[Order-ID],P.[Item Number], O.DT

CREATE VIEW V_OrderPerProductCategories AS
Select P.[Item Number], PC.Category,[Number Of Orders]=Count(Distinct O.[Order-ID]), [Quantity Sold]=sum(I.Quantity),[Total Revenue] =Round(sum(I.Quantity*p.Price),2)
From Products As P join Includes As I on P.[Item Number]=I.[Item Number]
Join Orders As O on I.[Order ID]=O.[Order-ID] JOIN ProductsCategories AS PC ON P.[Item Number]=PC.[Item Number]
Group By P.[Item Number], PC.Category

Select  V.Category, SUM(V.[Quantity Sold])
From V_OrderPerProductCategories AS V
Group by Category
ORDER BY 2 DESC

CREATE VIEW V_QUARTER AS
SELECT O.[Order-ID] ,O.DT, QUARTER=(CASE WHEN MONTH(O.DT) IN (1,2,3) THEN 1 WHEN MONTH(O.DT) IN (4,5,6) THEN 2 WHEN MONTH(O.DT) IN (7,8,9) THEN 3 ELSE 4 END), TotalSum=SUM(I.Quantity*P.Price)
FROM Orders AS O join Includes AS I ON O.[Order-ID]=I.[Order ID] join Products AS P ON I.[Item Number]=P.[Item Number] 
GROUP BY O.[Order-ID], O.DT

CREATE VIEW V_QUARTERPerYear AS
Select Year=Year(DT),QUARTER, [Sum OF Orders]=Count([Order-ID]), FULLDATE=CAST(Year(DT) AS varchar(10)) +' - '+CAST(QUARTER AS varchar(10)), Totalsum=sum(V_QUARTER.TotalSum)
From V_QUARTER
Group BY Year(DT),QUARTER

CREATE VIEW V_RegisteredThatDidntMakeAnOrder As
Select *
From Customers
Except
Select *
From Customers
Where Email in (
Select [Customer Email]


--VENDORS
CREATE VIEW V_VendorsSummery AS
Select P.Vendor, [Orders Made]=Count(Distinct O.[Order-ID]), [Total Profit]=sum(I.Quantity*P.Price), [Total Products sold]=sum(I.Quantity)
From Products As P join Includes As I on P.[Item Number]=I.[Item Number]
join Orders As O on I.[Order ID]= O.[Order-ID]
Group By P.Vendor, P.price

SELECT TOP 10 V.Vendor, V.[Total Profit]
FROM  V_VendorsSummery AS V
ORDER BY 2 DESC


CREATE VIEW V_ProductVendor AS
Select  p.Vendor,P.[Item Number], P.Name, [Product Profit]= sum(I.Quantity*P.Price)
From Products As P right join Includes As I on P.[Item Number]=I.[Item Number]
Group by P.Vendor, P.[Item Number], P.Name


Create VIEW VENDOR_CATEGORIES AS
Select P.Vendor, PG.Category, total=COUNT(*)
From Products As P join Includes As I on P.[Item Number]=I.[Item Number]
join Orders As O on I.[Order ID]= O.[Order-ID]  join ProductsCategories AS PG ON P.[Item Number]=PG.[Item Number]
Group by P.Vendor, PG.Category


CREATE VIEW V_VendorsSummery3 AS
Select P.Vendor, PG.Category,P.[Item Number], [Orders Made]=Count(Distinct O.[Order-ID]), [Total Profit]=sum(I.Quantity*P.Price), [Total Products sold]=sum(I.Quantity)
From Products As P join Includes As I on P.[Item Number]=I.[Item Number]
join Orders As O on I.[Order ID]= O.[Order-ID] join ProductsCategories AS PG ON P.[Item Number]=PG.[Item Number]
Group By P.Vendor, P.price, P.[Item Number], PG.Category


--STATES
CREATE VIEW V_ProductsAndAmountsPerState As
Select HelpTable.State,HelpTable.[Item Number], [Amount per Product] =Count(HelpTable.[Item Number])
From(
Select O.[Order-ID],O.State,I.[Item Number]
From Orders AS O join Includes AS I ON O.[Order-ID] = I.[Order ID] JOIN Products AS P ON I.[Item Number]=P.[Item Number] 
Where O.[Delivery Method]='Ship' and o.State is not null
GROUP BY O.[Order-ID],O.State,I.[Item Number]
Union
Select O.[Order-ID],A.State,I.[Item Number]
From Orders As O join Addresses As A on O.[Customer Email]=A.Email join Includes AS I ON O.[Order-ID] = I.[Order ID] JOIN Products AS P ON I.[Item Number]=P.[Item Number] 
Where O.[Delivery Method]='Ship' And O.Number=A.Number and O.State is not null
GROUP BY O.[Order-ID],A.State,I.[Item Number]
) As HelpTable
Group By HelpTable.State,HelpTable.[Item Number]


CREATE VIEW V_CountCategoryPerState as 
SELECT State, Category,total=COUNT(*)
FROM(
Select O.[Order-ID] ,O.State, PG.Category
From Orders AS O join Includes AS I ON O.[Order-ID] = I.[Order ID] JOIN Products AS P ON I.[Item Number]=P.[Item Number] join ProductsCategories AS PG ON P.[Item Number]=PG.[Item Number]
Where O.[Delivery Method]='Ship' and o.State is not null
GROUP BY O.[Order-ID],O.State, PG.Category
Union
Select O.[Order-ID], A.State, PG.Category
From Orders As O join Addresses As A on O.[Customer Email]=A.Email join Includes AS I ON O.[Order-ID] = I.[Order ID] JOIN Products AS P ON I.[Item Number]=P.[Item Number] join ProductsCategories AS PG ON P.[Item Number]=PG.[Item Number]
Where O.[Delivery Method]='Ship' And O.Number=A.Number
GROUP BY O.[Order-ID], A.State, PG.Category
) AS TABLE1
GROUP BY State, Category


CREATE VIEW V_OrdersPerState AS
select tabel1.State, NumOfOrders=count(*), TotalAmount=sum(TotalAmount)
from(
Select O.[Order-ID],O.State, TotalAmount=SUM(I.Quantity*P.Price)
From Orders AS O join Includes AS I ON O.[Order-ID] = I.[Order ID] JOIN Products AS P ON I.[Item Number]=P.[Item Number]
Where O.[Delivery Method]='Ship' and o.State is not null
GROUP BY O.[Order-ID],O.State
Union
Select O.[Order-ID],A.State, TotalAmount=SUM(I.Quantity*P.Price)
From Orders As O join Addresses As A on O.[Customer Email]=A.Email join Includes AS I ON O.[Order-ID] = I.[Order ID] JOIN Products AS P ON I.[Item Number]=P.[Item Number] 
Where O.[Delivery Method]='Ship' And O.Number=A.Number
GROUP BY O.[Order-ID],A.State
) as tabel1
group by tabel1.State