/* 
Short Discussion About The Lab

What you liked/disliked about the lab?
~ I liked the lab because it practice us how to perform different kinds of queries.

How long it took you to complete the lab?
~ It took me more or less 2 hours to complete the lab.

How prepared you felt you were for the lab?
~ I’m confident in answering the lab because we had done a few exercises before the lab activity.

Recommendations for future labs (if any).
~ I have no recommendations for future labs. However, I’m okay with the current lab setting.
*/

--1.	Queries
--1a.	Select the full name and city for the customer with customer ID of 2. Show first name and last name as one column. (1 Mark)
SELECT FirstName + ' ' + LastName 'Customer Full Name', City FROM Customer
WHERE CustomerID=2

--1b.	For all staff, select the staff first name, last name, and the number of consignments they have. (3 Marks)
SELECT FirstName, LastName, COUNT(*) 'Number of Consignments' FROM Staff
INNER JOIN Consignment ON Staff.StaffID=Consignment.StaffID
GROUP BY FirstName, LastName

--1c.	Select the minimum Category Cost. (1 Mark)
SELECT MIN(Cost) 'Minimum Category Cost' FROM Category

--1d.	Select the customer first name and last name for all customers whose total consignment subtotals are more than $100.00. (3 Marks)
SELECT FirstName, LastName, SUM(Subtotal) 'Total Consignmnet Subtotals' FROM Customer
INNER JOIN Consignment ON Customer.CustomerID=Consignment.CustomerID
GROUP BY FirstName, LastName
HAVING SUM(Subtotal) > 100

--1e.	Select all the staff full names with the customer full names of the consignments they have worked on.
--		Include staff that have not worked on any consignments (3 Marks)
SELECT DISTINCT Staff.FirstName + ' ' + Staff.LastName 'Staff Full Name', Customer.FirstName + ' ' + Customer.LastName 'Customer Full Name' FROM Staff
LEFT JOIN Consignment ON Staff.StaffID=Consignment.StaffID
LEFT JOIN Customer ON Consignment.CustomerID=Customer.CustomerID

--1f.	Select the first name and last name of all the staff whose last name starts with ‘P’, ‘B’, or ‘J’. (1 Mark)
SELECT FirstName, LastName FROM Staff
WHERE LastName LIKE 'P%' OR LastName LIKE 'B%' OR LastName LIKE 'J%'

--1g.	Select the amount of money that was made each month for the previous calendar year. Show the month name and amount.
--		List the months in chronological order by month. Do not include GST in the totals. (3 Marks)
SELECT DATENAME(MM, Date) [Month], SUM(Subtotal) 'Amount' FROM Consignment
WHERE YEAR(Date)=2021
GROUP BY DATENAME(MM, Date), MONTH(Date)

--1h.	Select the staff type descriptions of the staff types that have no staff in them. (2 Marks)
SELECT StaffTypeDescription FROM StaffType
WHERE StaffTypeID NOT IN (SELECT StaffTypeID FROM Staff)

--1i.	Select the category description of the category that was used the most number of times. 
--		You must use at least one subquery in your answer, and the TOP clause is not acceptable anywhere in your solution. (4 Marks)
SELECT CategoryDescription FROM Category
INNER JOIN ConsignmentDetails ON Category.CategoryCode=ConsignmentDetails.CategoryCode
GROUP BY CategoryDescription
HAVING COUNT(*) >= ALL(SELECT COUNT(*) FROM ConsignmentDetails GROUP BY CategoryCode)

--1j.	Select the full names of all the people in the database whose lastname is between 4 and 7 characters long. (2 Marks)
SELECT FirstName + ' ' + LastName 'Full Name' FROM Customer
WHERE LEN(LastName) BETWEEN 4 AND 7
UNION ALL
SELECT FirstName + ' ' + LastName FROM Staff
WHERE LEN(LastName) BETWEEN 4 AND 7

--2.	Views
--2a.	Create a view called CustomerSummary that contains customer ID, first name, last name, 
--		and the descriptions of the items they are selling.
--		Assume all customers have at least one item on consignment. (2 Marks)
GO
CREATE VIEW CustomerSummary
AS
SELECT Customer.CustomerID, FirstName, LastName, ItemDescription FROM Customer
INNER JOIN Consignment ON Customer.CustomerID=Consignment.CustomerID
INNER JOIN ConsignmentDetails ON Consignment.ConsignmentID=ConsignmentDetails.ConsignmentID
GO

--2b.	Using the CustomerSummary view select the customer ID, full name, 
--		and the number of items they have on consignment. (2 Marks)
SELECT CustomerID, FirstName + ' ' + LastName 'Full Name', COUNT(*) 'Number of Items' FROM CustomerSummary
GROUP BY CustomerID, FirstName, LastName


--3.	DML
--3a.	Insert the following records into the staff table given the following data, and do not hard code any values not given
INSERT INTO Staff (StaffID, FirstName, LastName, Active, Wage, StaffTypeID)
VALUES ('231464', 'Tim', 'McGraw', 'N', 27.00, 2)

INSERT INTO Staff (StaffID, FirstName, LastName, Active, Wage, StaffTypeID)
VALUES ('456585', 'Otis', 'Redding', 'Y', (SELECT AVG(Wage) FROM Staff), 3)

--3b.	Increase the discount percentage by 4 of any reward whose description includes the word “Customer”. (2 Marks)
UPDATE Reward
SET DiscountPercentage = DiscountPercentage + 4
WHERE RewardDescription LIKE '%Customer%'

--3c.	The human resources department is getting a raise! Increase the wage of all the HR staff by 12%. (3 Marks)
UPDATE Staff
SET Wage =  (Wage * 0.12) + Wage
WHERE StaffTypeID = (SELECT StaffTypeID FROM StaffType WHERE StaffTypeDescription = 'Human Resources')

--3d.	Remove all the staff types that have no staff. (2 Marks)
DELETE FROM StaffType
WHERE StaffTypeID NOT IN (SELECT StaffTypeID FROM Staff)