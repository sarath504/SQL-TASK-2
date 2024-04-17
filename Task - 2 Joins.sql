use Sarath_DB_Task2;


--1. Get the firstname and lastname of the employees who placed orders between 15th August,1996 and 15th August,1997
select FirstName,
       LastName 
  from Employee,
	   Orders 
 where Employee.EmployeeID=Orders.EmployeeID 
   and Orders.OrderDate between '1996-08-15' and '1997-08-15';



--2. Get the distinct EmployeeIDs who placed orders before 16th October,1996.
select distinct Employee.EmployeeID 
           from Employee, Orders 
          where Employee.EmployeeId=Orders.EmployeeId 
			and Orders.OrderDate < '1996-10-16';



--3. How many products were ordered in total by all employees between 13th of January,1997 and 16th of April,1997.
select count(OrderDetails.ProductID) as 'Total Products' 
  from Orders, OrderDetails 
 where Orders.OrderID = OrderDetails.OrderID 
   and Orders.OrderDate between '1997-01-13' and '1997-04-16';



--4. What is the total quantity of products for which Anne Dodsworth placed orders between 13th of January,1997 and 16th of April,1997.
select count(Orders.OrderId) as 'Total Orders' 
  from Employee, 
       Orders 
 where Employee.EmployeeID = Orders.EmployeeID 
   and Employee.FirstName = 'Anne'
   and Employee.LastName = 'Dodsworth'
   and Orders.OrderDate between '1997-01-13' and '1997-04-16';



--5. How many orders have been placed in total by Robert King.
select count(Orders.OrderID) as 'Total Orders' 
  from Employee, 
       Orders 
 where Employee.EmployeeID = Orders.EmployeeID 
   and Employee.FirstName = 'Robert' 
   and Employee.LastName = 'King';




--6. How many products have been ordered by Robert King between 15th August,1996 and 15th August,1997.
select count(Orders.OrderID) as 'Total Orders' 
  from Employee, 
       Orders 
 where Employee.EmployeeID = Orders.EmployeeID 
   and Employee.FirstName = 'Robert' 
   and Employee.LastName = 'King' 
   and OrderDate between '1996-08-15'and '1997-08-15';



/*7. I want to make a phone call to the employees to wish them on the occasion of Christmas who placed 
orders between 13th of January,1997 and 16th of April,1997. I want the EmployeeID, Employee Full Name, 
HomePhone Number.*/
select distinct e.EmployeeID,
                FirstName+' '+LastName as 'Full Name', 
				e.HomePhone 
		   from Employee e,
		        Orders o
		  where e.EmployeeID = o.EmployeeID 
		    and o.OrderDate between '1997-01-13' and '1997-04-16';


--8.Which product received the most orders. Get the product's ID and Name and number of orders it received.
select top 1 p.ProductID,
           p.ProductName,
           count(distinct o.OrderID) as 'No of Orders'
      from Products p,
	       OrderDetails o 
     where p.ProductID = o.ProductID 
  group by p.ProductID, 
		   p.ProductName 
  order by count(distinct o.OrderID) desc;


--9. Which are the least shipped products. List only the top 5 from your list.
select top 5 Products.ProductName, 
           Products.ProductID,
		   count(Orders.ShipperID) as 'No of times shipped' 
      from OrderDetails, 
	       Orders, 
		   Products 
	 where OrderDetails.OrderID = Orders.OrderID 
	   and OrderDetails.ProductID = Products.ProductID 
  group by Products.ProductName, 
           Products.ProductID 
  order by count(Orders.ShipperID);


--10. What is the total price that is to be paid by Laura Callahan for the order placed on 13th of January,1997
select (UnitPrice*Quantity-(Discount)*UnitPrice*Quantity) as 'Total Price' 
  from Employee, 
       Orders, 
	   OrderDetails 
 where Employee.EmployeeID = Orders.EmployeeID 
   and Employee.FirstName = 'Laura' 
   and Employee.LastName = 'Callahan' 
   and Orders.OrderID = OrderDetails.OrderID 
   and Orders.OrderDate = '1997-01-13';


--11. How many number of unique employees placed orders for Gorgonzola Telino or Gnocchi di nonna Alice or 
--Raclette Courdavault or Camembert Pierrot in the month January,1997.
select count(distinct Orders.EmployeeID) as 'Total No of Employees' 
  from Orders, 
       OrderDetails, 
       Products 
 where Products.ProductID = OrderDetails.ProductID 
   and OrderDetails.OrderID = Orders.OrderID 
   and Products.ProductName 
    in ('Gorgonzola Telino',
	    'Gnocchi di nonna Alice',
		'Raclette Courdavault',
		'Camembert Pierrot') 
   and Orders.OrderDate between '1997-01-01' and '1997-01-31';


--12. What is the full name of the employees who ordered Tofu between 13th of January,1997 and 30th of January,1997
select FirstName+' '+LastName as 'Full Name' 
  from Employee, 
       Orders, 
	   Products, 
	   OrderDetails
 where OrderDetails.ProductID = Products.ProductID 
   and OrderDetails.OrderID = Orders.OrderID 
   and Orders.EmployeeID = Employee.EmployeeID 
   and Products.ProductName = 'Tofu' 
   and Orders.OrderDate between '1997-01-13' and '1997-01-30';



--13. What is the age of the employees in days, months and years who placed orders during the month of August. Get employeeID and full name as well
select 
distinct Employee.EmployeeID, 
         FirstName+' '+LastName as 'Full Name',
         datediff(year,Employee.BirthDate,getdate()) as 'Age in Years',
         datediff(month,Employee.BirthDate,getdate()) as 'Age in Months',
         datediff(day,Employee.BirthDate,getdate()) as 'Age in Days'
    from Employee, 
	     Orders 
   where Employee.EmployeeID=Orders.EmployeeID 
     and datename(month,Orders.OrderDate)='August';




--14. Get all the shipper's name and the number of orders they shipped.
	select Shippers.ShipperID,
		   CompanyName,
		   count(Orders.OrderID) as 'No of Orders Shipped'
	  from Orders, 
		   Shippers 
	 where Orders.ShipperID = Shippers.ShipperID 
  group by Shippers.ShipperID,CompanyName 
  order by Shippers.ShipperID;



--15. Get all shipper's name and the number of products they shipped.
	select Shippers.ShipperID,
			CompanyName,
			count(OrderDetails.ProductID) as 'No of Products Shipped' 
	   from Shippers, 
			Orders, 
			OrderDetails 
	  where Shippers.ShipperID = Orders.ShipperID 
		and Orders.OrderID = OrderDetails.OrderID 
   group by Shippers.ShipperID,
			Shippers.CompanyName
   order by Shippers.ShipperID;




--16. Which shipper has bagged most orders. Get the shipper's id, name and the number of orders.
select top 1 Shippers.ShipperID,
           CompanyName,
		   count(Orders.OrderID) as 'No of Orders Shipped'
      from Orders, 
	       Shippers 
     where Orders.ShipperID = Shippers.ShipperID 
  group by Shippers.ShipperID,CompanyName 
  order by count(Orders.OrderID) desc;




/*17. Which shipper supplied the most number of products between 10th August,1996 and 20th 
September,1998. Get the shipper's name and the number of products*/
select top 1 Shippers.ShipperID,
           CompanyName,
		   count(OrderDetails.ProductID) as 'No of Products Shipped' 
	  from Shippers, 
	       Orders, 
		   OrderDetails 
	 where Shippers.ShipperID = Orders.ShipperID 
	   and Orders.OrderID = OrderDetails.OrderID 
	   and Orders.OrderDate between '1996-08-10' and '1998-09-20'
  group by Shippers.ShipperID,Shippers.CompanyName
  order by count(OrderDetails.ProductID) desc;




--18. Which employee didn't order any product 4th of April 1997.
select Employee.EmployeeID 
  from Employee
 where Employee.EmployeeID 
not in (
       select 
       distinct 
				Employee.EmployeeID 
		   from Employee, 
				Orders 
		  where Employee.EmployeeID=Orders.EmployeeID 
		    and Orders.OrderDate = '1997-04-04'
	   );




--19. How many products where shipped to Steven Buchanan.
select count(OrderDetails.ProductID) as 'No of Products Shipped' 
  from Employee,Orders,
       OrderDetails 
 where Orders.OrderID = OrderDetails.OrderID 
   and Employee.EmployeeID = Orders.EmployeeID 
   and Employee.FirstName = 'Steven' 
   and Employee.LastName = 'Buchanan';




--20. How many orders where shipped to Michael Suyama by Federal Shipping.
select count(Orders.OrderID) as 'No of Orders Shipped' 
  from Employee, 
       Orders, 
	   Shippers 
 where Shippers.ShipperID = Orders.ShipperID 
   and Employee.EmployeeID = Orders.EmployeeID 
   and Employee.FirstName = 'Michael' 
   and Employee.LastName = 'Suyama' 
   and Shippers.CompanyName = 'Federal Shipping';




--21. How many orders are placed for the products supplied from UK and Germany.
select count(distinct OrderDetails.OrderID) as 'No of Orders' 
  from OrderDetails, 
       Products, 
	   Suppliers 
 where Products.SupplierID = Suppliers.SupplierID 
   and Products.ProductID = OrderDetails.ProductID 
   and Suppliers.Country 
   in ('UK','Germany');




--22. How much amount Exotic Liquids received due to the order placed for its products in the month of January,1997.
select sum(Quantity*OrderDetails.UnitPrice-Discount*Quantity*OrderDetails.UnitPrice) as 'Total Quantity' 
  from Products, 
       Suppliers, 
	   OrderDetails,
	   Orders 
 where Suppliers.SupplierID = Products.SupplierID 
   and Products.ProductID = OrderDetails.ProductID 
   and Suppliers.CompanyName = 'Exotic Liquids' 
   and Orders.OrderID = OrderDetails.OrderID 
   and Orders.OrderDate between '1997-01-01' and '1997-01-31';


--23. In which days of January, 1997, the supplier Tokyo Traders haven't received any orders.
WITH DateCTE AS (
    SELECT CAST('1997-01-01' AS DATE) AS Date
     UNION ALL
    SELECT DATEADD(DAY, 1, Date)
      FROM DateCTE
     WHERE Date < '1997-01-31'
)

select Date 
  from DateCTE 
 where Date 
 not in (
		select OrderDate 
		  from Orders, 
		       Products, 
			   Suppliers, 
			   OrderDetails 
		 where Orders.OrderID = OrderDetails.OrderID 
		 and OrderDetails.ProductID = Products.ProductID 
		 and Products.SupplierID = Suppliers.SupplierID 
		 and CompanyName = 'Tokyo Traders' 
		 and Orders.OrderDate between '1997-01-01' and '1997-01-31'
		 );




--24. Which of the employees did not place any order for the products supplied by Ma Maison in the month of May.
select EmployeeID,
       FirstName+' '+LastName as [Name]
  from Employee 
 where EmployeeID 
 not in
       (
		select 
		distinct EmployeeID 
		    from Orders, 
			     OrderDetails, 
				 Suppliers, 
				 Products 
		   where Suppliers.SupplierID = Products.SupplierID 
		     and Products.ProductID = OrderDetails.ProductID 
			 and OrderDetails.OrderID = Orders.OrderID 
			 and datename(month,OrderDate) = 'May' 
			 and CompanyName = 'Ma Maison'
		);





--25. Which shipper shipped the least number of products for the month of September and October,1997 combined.
select distinct top 1 Shippers.ShipperID,
                    Shippers.CompanyName,
					count(OrderDetails.ProductID) as 'No of Products'
               from Orders, 
			        OrderDetails, 
					Shippers 
		   	  where Shippers.ShipperID = Orders.ShipperID 
			    and Orders.OrderID = OrderDetails.OrderID 
				and OrderDate between '1997-09-01' and '1997-10-31' 
		   group by Shippers.ShipperID,
		            CompanyName
           order by count(OrderDetails.ProductID);




--26. What are the products that weren't shipped at all in the month of August, 1997.
select ProductID,
       ProductName 
  from Products 
 where ProductID 
 not in (
		select Products.ProductID 
		  from Orders, 
		       OrderDetails, 
			   Products 
		 where Orders.OrderID = OrderDetails.OrderID 
		   and Products.ProductID = OrderDetails.ProductID 
		   and datename(month,ShippedDate) = 'August' 
		   and datename(year,ShippedDate)='1997'
		);




--27. What are the products that weren't ordered by each of the employees. List each employee and the products that he didn't order..
	select 
	distinct FirstName+' '+LastName as 'Name',
  STRING_AGG (ProductName, ', ') AS AllProductNames
	    from Employee,
	         Products 
		where 
 not exists (
			 select 
			 distinct EmployeeID,
			          ProductID 
				 from Orders,
				      OrderDetails 
			    where Orders.OrderID = OrderDetails.OrderID 
				  and Employee.EmployeeID = Orders.EmployeeID 
				  and OrderDetails.ProductID = Products.ProductID
			)
    group by FirstName+' '+LastName;




--28. Who is busiest shipper in the months of April, May and June during the year 1996 and 1997.
select  top 1 CompanyName,
            count(Orders.OrderID) as 'No. of Orders',
			count(OrderDetails.ProductID) as 'No. of Products' 
	   from Orders, 
	        OrderDetails, 
			Shippers 
	  where Shippers.ShipperID = Orders.ShipperID 
	    and Orders.OrderID = OrderDetails.OrderID 
		and datename(month,OrderDate) 
		 in ('April','May','June') 
		and datename(year,OrderDate) 
		 in ('1996','1997')
   group by CompanyName 
   order by count(Orders.OrderID) desc ;




--29. Which country supplied the maximum products for all the employees in the year 1997.
select top 1 Suppliers.Country,
           count(OrderDetails.ProductID) as 'No of Products Supplied'
      from Suppliers, 
	       Products, 
		   OrderDetails,
		   Orders 
	 where Suppliers.SupplierID = Products.SupplierID 
	   and Products.ProductID = OrderDetails.ProductID 
	   and Orders.OrderID = OrderDetails.OrderID 
	   and datename(year,OrderDate) = '1997' 
  group by Suppliers.Country
  order by count(OrderDetails.ProductID) desc;




/*30. What is the average number of days taken by all shippers to ship the product after the order has been 
placed by the employees.*/
select sum(datediff(day,OrderDate,ShippedDate))/(select count(*) from Orders) as 'Average Days to Ship'
  from Shippers, 
       Orders 
 where Shippers.ShipperID = Orders.ShipperID;





--31. Who is the quickest shipper of all.
select top 1 CompanyName,
           sum(datediff(day,OrderDate,ShippedDate))/(select count(Shippers.ShipperID)) as 'AverageDays' 
	  from Shippers, 
	       Orders 
     where Shippers.ShipperID = Orders.ShipperID 
  group by CompanyName 
  order by AverageDays;




--32. Which order took the least number of shipping days. Get the orderid, employees full name, number of 
--products, number of days took to ship and shipper company name.


/*
select * from(
select distinct CompanyName, Orders.OrderID,FirstName+' '+LastName as 'Name',datediff(day,OrderDate,ShippedDate) 
as 'Shipping_Days',count(OrderDetails.ProductID) as 'No of Products' ,
rank() over(order by datediff(day,OrderDate,ShippedDate))  as Rank
from
Employee,Orders,OrderDetails,Shippers where 
Shippers.ShipperID = Orders.ShipperID and Orders.OrderID = OrderDetails.OrderID and 
Employee.EmployeeID = Orders.EmployeeID and datediff(day,OrderDate,ShippedDate) is not null
group by CompanyName,Orders.OrderID,FirstName+' '+LastName,datediff(day,OrderDate,ShippedDate)) as Query
where Rank<=1;
*/

	select Orders.OrderID,
	       LastName+' '+FirstName as 'Full_Name', 
	       count(OrderDetails.ProductID) as 'No of Products',
	       datediff(day,OrderDate,ShippedDate)  as 'Shipped_Days',CompanyName
	  from Employee,
	       Orders,
		   OrderDetails,
		   Shippers
	 where Employee.EmployeeID = Orders.EmployeeID 
	   and Orders.OrderID = OrderDetails.OrderID 
	   and Shippers.ShipperID = Orders.ShipperID 
	   and datediff(day,OrderDate,ShippedDate) = (
	                                              select min(datediff(day,OrderDate,ShippedDate)) 
													from Orders
												 ) 
  group by Orders.OrderID,
           LastName+' '+FirstName,
		   datediff(day,OrderDate,ShippedDate),
		   CompanyName;






--UNIONS

/*33.Which orders took the least number and maximum number of shipping days? Get the orderid, employees 
full name, number of products, number of days taken to ship the product and shipper company name. Use 
1 and 2 in the final result set to distinguish the 2 orders.*/

select Orders.OrderID,
       LastName+' '+FirstName as 'Full_Name', 
       count(OrderDetails.ProductID) as 'No of Products',
       datediff(day,OrderDate,ShippedDate)  as 'Shipped_Days',
	   CompanyName
  from Employee,
       Orders,
	   OrderDetails,
	   Shippers
 where Employee.EmployeeID = Orders.EmployeeID 
   and Orders.OrderID = OrderDetails.OrderID 
   and Shippers.ShipperID = Orders.ShipperID 
   and datediff(day,OrderDate,ShippedDate) = (
											  select min(datediff(day,OrderDate,ShippedDate)) 
											    from Orders
											 ) 
group by Orders.OrderID,
         LastName+' '+FirstName,
		 datediff(day,OrderDate,ShippedDate),
		 CompanyName

union all

select Orders.OrderID,
       LastName+' '+FirstName as 'Full_Name', 
       count(OrderDetails.ProductID) as 'No of Products',
       datediff(day,OrderDate,ShippedDate)  as 'Shipped_Days',
	   CompanyName
  from Employee,
       Orders,
	   OrderDetails,
	   Shippers
 where Employee.EmployeeID = Orders.EmployeeID 
   and Orders.OrderID = OrderDetails.OrderID 
   and Shippers.ShipperID = Orders.ShipperID 
   and datediff(day,OrderDate,ShippedDate) = (
											  select max(datediff(day,OrderDate,ShippedDate)) 
											    from Orders
											 ) 
group by Orders.OrderID,
         LastName+' '+FirstName,
		 datediff(day,OrderDate,ShippedDate),
		 CompanyName



/*34.Which is cheapest and the costliest of products purchased in the second week of October, 1997. Get the 
product ID, product Name and unit price. Use 1 and 2 in the final result set to distinguish the 2 products.*/

select OrderDetails.ProductID, 
       ProductName,
	   OrderDetails.UnitPrice 
  from Orders, 
       OrderDetails, 
	   Products 
 where Orders.OrderID = OrderDetails.OrderID 
   and OrderDetails.ProductID = Products.ProductID 
   and OrderDate between '1997-10-08' and '1997-10-14' 
   and OrderDetails.UnitPrice = (
								select min(UnitPrice) 
								  from OrderDetails,
								       Orders 
								 where Orders.OrderID = OrderDetails.OrderID 
								   and OrderDate between '1997-10-08' and '1997-10-14'
								)
union all 

select OrderDetails.ProductID, 
       ProductName,
	   OrderDetails.UnitPrice 
  from Orders, 
       OrderDetails, 
	   Products 
 where Orders.OrderID = OrderDetails.OrderID 
   and OrderDetails.ProductID = Products.ProductID 
   and OrderDate between '1997-10-08' and '1997-10-14' 
   and OrderDetails.UnitPrice = (
								select max(UnitPrice) 
								  from OrderDetails,
								       Orders 
								 where Orders.OrderID = OrderDetails.OrderID 
								   and OrderDate between '1997-10-08' and '1997-10-14'
								)




/*35.Find the distinct shippers who are to ship the orders placed by employees with IDs 1, 3, 5, 7
Show the shipper's name as "Express Speedy" if the shipper's ID is 2 and "United Package" if the shipper's 
ID is 3 and "Shipping Federal" if the shipper's ID is 1.*/
select 
distinct ShipperID,
         Employee.EmployeeID,
		 FirstName+' '+LastName as 'Name',
		case 
			when ShipperID = 1 then 'Shipping Federal'
			when ShipperID = 2 then 'Express Speedy'
			when ShipperID = 3 then 'UnitedPackage'
			else NULL
		end as "Shipper'sName"
    from Employee,
	     Orders 
   where Employee.EmployeeID = Orders.EmployeeID 
     and Employee.EmployeeID 
	  in (1,3,5,7);




