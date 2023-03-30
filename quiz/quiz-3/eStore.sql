PRINT '+-----------------------------------+'
PRINT '| Database Name: eStore             |'
PRINT '|        Author: Allan Anderson     |'
PRINT '|  Created Date: September 30, 2021 |'
PRINT '| Modified Date: April 5, 2022      |'
PRINT '+-----------------------------------+'

-- Create the database:
--  - the code below will search for and delete the old database if it exists
--    then create the new database.
USE Model
GO

IF EXISTS (SELECT * FROM master.sys.databases WHERE name='eStore')
	BEGIN
		PRINT 'Deleting old database ....'
		DROP DATABASE eStore
	END
GO

PRINT 'Creating new database ....'
CREATE DATABASE eStore
GO
USE eStore
GO

-- Create the tables
PRINT 'Creating tables'
CREATE TABLE Category
(
	CategoryID INT NOT NULL IDENTITY(10,1)
		CONSTRAINT PK_Category PRIMARY KEY CLUSTERED,
	CategoryName VARCHAR(30) NOT NULL,
	Description VARCHAR(100) NULL
)
GO

CREATE TABLE Supplier
(
	SupplierID INT NOT NULL IDENTITY(200,1)
		CONSTRAINT PK_Supplier PRIMARY KEY CLUSTERED,
	SupplierName VARCHAR(60) NOT NULL,
	ContactLastName VARCHAR(30) NOT NULL,
	ContactFirstName VARCHAR(30) NOT NULL,
	Phone VARCHAR(15) NOT NULL,
	Address VARCHAR(60) NOT NULL,
	City	VARCHAR(60) NOT NULL,
	Province CHAR(2) NOT NULL
		CONSTRAINT CK_SupplierProvince CHECK(Province IN ('AB','BC','MB','NB','NL','NS','NT','NU','ON','PE','QC','SK','YT'))
		CONSTRAINT DF_SupplierProvince DEFAULT('AB'),
	PostalCode CHAR(6) NOT NULL
		CONSTRAINT CK_SupplierPostalCode CHECK(PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]')
)
GO

CREATE TABLE Product
(
	ProductID INT NOT NULL IDENTITY(300,1)
		CONSTRAINT PK_Product PRIMARY KEY CLUSTERED,
	ProductName	VARCHAR(60) NOT NULL,
	SKU CHAR(10) NOT NULL,
	CategoryID INT NOT NULL
		CONSTRAINT FK_Product_Category FOREIGN KEY REFERENCES Category(CategoryID),
	Description VARCHAR(100) NULL,
	SupplierID INT NOT NULL
		CONSTRAINT FK_Product_Supplier FOREIGN KEY REFERENCES Supplier(SupplierID),
	OrderCost DECIMAL(8,2) NOT NULL
		CONSTRAINT CK_Product_OrderCost CHECK(OrderCost>0),
	SellingPrice DECIMAL(8,2) NOT NULL
		CONSTRAINT CK_Product_SellingPrice CHECK(SellingPrice>0),
	QuantityOnHand SMALLINT NOT NULL
		CONSTRAINT CK_Product_QuantityOnHand CHECK(QuantityOnHand>=0),
	ReOrderLevel SMALLINT NOT NULL
		CONSTRAINT CK_Product_ReOrderLevel CHECK(ReOrderLevel>0),
	OnOrder SMALLINT NOT NULL DEFAULT 0
		CONSTRAINT CK_Product_OnOrder CHECK(OnOrder>=0),
	CONSTRAINT CK_Product_OrderCost_SellingPrice CHECK(SellingPrice>=OrderCost)
)
GO

CREATE TABLE Customer
(
	CustomerID INT NOT NULL IDENTITY(100,1)
		CONSTRAINT PK_Customer PRIMARY KEY CLUSTERED,
	LastName VARCHAR(30) NOT NULL,
	FirstName VARCHAR(30) NOT NULL,
	Phone CHAR(10) NOT NULL
		CONSTRAINT CK_Phone CHECK(Phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	Email NVARCHAR(60) NOT NULL,
	Address VARCHAR(60) NOT NULL,
	City	VARCHAR(60) NOT NULL,
	Province CHAR(2) NOT NULL
		CONSTRAINT CK_CustomerProvince CHECK(Province IN ('AB','BC','MB','NB','NL','NS','NT','NU','ON','PE','QC','SK','YT'))
		CONSTRAINT DF_CustomerProvince DEFAULT('AB'),
	PostalCode CHAR(6) NOT NULL
		CONSTRAINT CK_PostalCode CHECK(PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]')
)
GO

CREATE TABLE EmployeeType
(
	EmployeeTypeID INT IDENTITY(1,1) NOT NULL
		CONSTRAINT PK_EmployeeType PRIMARY KEY CLUSTERED,
	TypeName CHAR(2) NOT NULL,
	TypeDescription VARCHAR(100) NULL
)
GO

CREATE TABLE Employee
(
	EmployeeID INT NOT NULL IDENTITY(1000,1)
		CONSTRAINT PK_Employee PRIMARY KEY CLUSTERED,
	EmployeeTypeID INT NOT NULL
		CONSTRAINT FK_Employee_EmployeeType FOREIGN KEY REFERENCES EmployeeType(EmployeeTypeID),
	LastName VARCHAR(30) NOT NULL,
	FirstName VARCHAR(30) NOT NULL,
	WorkPhone CHAR(10) NOT NULL
		CONSTRAINT CK_WorkPhone CHECK(WorkPhone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	Email NVARCHAR(60) NOT NULL,
	Address VARCHAR(60) NOT NULL,
	City	VARCHAR(60) NOT NULL,
	Province CHAR(2) NOT NULL
		CONSTRAINT CK_EmployeeProvince CHECK(Province IN ('AB','BC','MB','NB','NL','NS','NT','NU','ON','PE','QC','SK','YT'))
		CONSTRAINT DF_EmployeeProvince DEFAULT('AB'),
	PostalCode CHAR(6) NOT NULL
		CONSTRAINT CK_EmployeePostalCode CHECK(PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'),
	HiredDate DATE NOT NULL
		CONSTRAINT CK_Employee_HiredDate CHECK(HiredDate<= GETDATE()),
	ReleasedDate DATE NULL
)
GO

CREATE TABLE SalesOrder
(
	OrderNumber INT NOT NULL IDENTITY(400,1)
		CONSTRAINT PK_SalesOrder_OrderNumber PRIMARY KEY CLUSTERED,
	OrderDate DATETIME NOT NULL
		CONSTRAINT CK_SalesOrder_OrderDate CHECK(OrderDate<=GETDATE())
		CONSTRAINT DF_SalesOrder_OrderDate DEFAULT GETDATE(),
	CustomerID INT NOT NULL
		CONSTRAINT FK_SalesOrder_Customer FOREIGN KEY REFERENCES Customer(CustomerID),
	EmployeeID INT NULL
		CONSTRAINT FK_SalesOrder_Employee FOREIGN KEY REFERENCES Employee(EmployeeID)
)
GO

CREATE TABLE SalesOrderDetail
(
	OrderNumber INT NOT NULL
		CONSTRAINT FK_SalesOrderDetail_SalesOrder FOREIGN KEY REFERENCES SalesOrder(OrderNumber),
	ProductID INT NOT NULL
		CONSTRAINT FK_SalesOrderDetail_Product FOREIGN KEY REFERENCES Product(ProductID),
	Quantity SMALLINT NOT NULL
		CONSTRAINT CK_SalesOrderDetail_Quantity CHECK(Quantity>0),
	CONSTRAINT PK_SalesOrderDetail PRIMARY KEY CLUSTERED (OrderNumber,ProductID)
)
GO

CREATE TABLE PurchaseOrder
(
	PurchaseOrderNumber	INT NOT NULL IDENTITY(500,1)
		CONSTRAINT PK_PurchaseOrder PRIMARY KEY CLUSTERED,
	OrderDate DATETIME NOT NULL
		CONSTRAINT CK_OrderDate CHECK(OrderDate<=GETDATE())
		CONSTRAINT DF_OrderDate DEFAULT GETDATE(),
	EmployeeID INT NOT NULL
		CONSTRAINT FK_PurchaseOrder_Employee FOREIGN KEY REFERENCES Employee(EmployeeID),
	SupplierID INT NOT NULL
		CONSTRAINT FK_PurchaseOrder_Supplier FOREIGN KEY REFERENCES Supplier(SupplierID),
	ReceivedDate DATETIME NULL
)
GO

CREATE TABLE PurchaseOrderDetail
(
	PurchaseOrderNumber INT NOT NULL
		CONSTRAINT FK_PurchaseOrderDetail_PurchaseOrder FOREIGN KEY REFERENCES PurchaseOrder(PurchaseOrderNumber),
	ProductID INT NOT NULL
		CONSTRAINT FK_PurchaseOrderDetail_Product FOREIGN KEY REFERENCES Product(ProductID),
	OrderQuantity INT NOT NULL
		CONSTRAINT CK_PurchaseOrderDetail_OrderQuantity CHECK(OrderQuantity>0),
	CONSTRAINT PK_PurchaseOrderDetail PRIMARY KEY CLUSTERED (PurchaseOrderNumber,ProductID)
)
GO

-- ALTER TABLE commands
PRINT 'ALTER TABLE commands for:'
PRINT ' - Customer ....'
ALTER TABLE Customer
	ADD CONSTRAINT CK_Customer_Email CHECK (Email LIKE '%___@___%.__%')
ALTER TABLE Customer
	ADD Birthday DATE NULL
	CONSTRAINT CK_Customer_Birthday CHECK(Birthday <= GETDATE())
ALTER TABLE Customer
	ADD CONSTRAINT CK_Customer_Phone CHECK(Phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
PRINT ' - Employee ....'
ALTER TABLE Employee
	ADD CONSTRAINT CK_Employee_Email CHECK (Email LIKE '%___@___%.__%')
ALTER TABLE Employee
	ADD HomePhone CHAR(10) NULL
	CONSTRAINT CK_HomePhone CHECK (HomePhone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
ALTER TABLE Employee
	ADD CONSTRAINT CK_Employee_ReleasedDate CHECK(ReleasedDate>=HiredDate)
PRINT ' - Supplier ....'
ALTER TABLE Supplier
	ADD CONSTRAINT CK_Supplier_Phone CHECK(Phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
PRINT ' - PurchaseOrder ....'
ALTER TABLE PurchaseOrder
	ADD CONSTRAINT CK_PurchaseOrder_ReceivedDate CHECK(ReceivedDate >= OrderDate)


	
-- Create INDEXes on Foreign Keys
PRINT 'Creating indexes on all Foreign Keys for:'
PRINT ' - Product ....'
CREATE NONCLUSTERED INDEX IX_Product_CategoryID 
	ON Product(CategoryID)
CREATE NONCLUSTERED INDEX IX_Product_SupplierID
	ON Product(SupplierID)
PRINT ' - Employee ....'
CREATE NONCLUSTERED INDEX IX_Employee_EmployeeTypeID 
	ON Employee(EmployeeTypeID)
PRINT ' - SalesOrder ....'
CREATE NONCLUSTERED INDEX IX_SalesOrder_CustomerID
	ON SalesOrder(CustomerID)
CREATE NONCLUSTERED INDEX IX_SalesOrder_EmployeeID
	ON SalesOrder(EmployeeID)
PRINT ' - SalesOrderDetail ....'
CREATE NONCLUSTERED INDEX IX_SalesOrderDetail_ProductID
	ON SalesOrderDetail(ProductID)
CREATE NONCLUSTERED INDEX IX_SalesOrderDetail_OrderNumber
	ON SalesOrderDetail(OrderNumber)
PRINT ' - PurchaseOrder ....'
CREATE NONCLUSTERED INDEX IX_PurchaseOrder_EmployeeID
	ON PurchaseOrder(EmployeeID)
CREATE NONCLUSTERED INDEX IX_PurchaseOrder_SupplierID
	ON PurchaseOrder(SupplierID)
PRINT ' - PurchaseOrderDetail ....'
CREATE NONCLUSTERED INDEX IX_PurchaseOrderDetail_ProductID
	ON PurchaseOrderDetail(ProductID)
CREATE NONCLUSTERED INDEX IX_PurchaseOrderDetail_PurchaseOrderNumber
	ON PurchaseOrderDetail(PurchaseOrderNumber)

-- Insert data into Identity tables
-- Category
PRINT 'INSERT INTO Category ....'
INSERT INTO Category(CategoryName,Description)
VALUES
	('Fruit','Various fruits in season'),
	('Vegetables','Various vegetables in season'),
	('Drinks','Non-alcoholic drinks'),
	('Alcohol','Selected beer and wines'),
	('Meat','Selection of meat and meat products'),
	('Bread','Various bread and grain products'),
	('Candy','Assorted sweet treats'),
	('Cooking','Spices, sauces, and cooking needs'),
	('Cleaners','Various cleaning products'),
	('Snacks','Selection of non-sweet snacks'),
	('Housewares','Pots, pans, dishes, knives and eating utensils')
GO

-- EmployeeType
PRINT 'INSERT INTO EmployeeType ....'
INSERT INTO EmployeeType(TypeName,TypeDescription)
VALUES
	('MA','Managerial level employee'),
	('SP','Sales staff involved with creating a Sale'),
	('PD','Staff involved with creating a Purchase Order'),
	('EM','General employee (includes janitorial and maintenance staff)')
GO

-- Employee
PRINT 'INSERT INTO Employee ....'
INSERT INTO Employee(EmployeeTypeID,FirstName,LastName,WorkPhone, HomePhone,Email,Address,City,Province,PostalCode,HiredDate,ReleasedDate) VALUES
	(1,'Bob','Waters','7804718888','5872341290','bwaters@estore.com','111-11 St.','Edmonton','AB','T1U2V3','01/01/2013',NULL),
	(1,'Dave','Tipper','7804744545',NULL,'dtipper@estore.com','2408-133Ave.','Edmonton','AB','T2V3W2','01/01/2013',NULL),
	(3,'Mary','Makkers','7804769876',NULL,'mmakers@estore.com','14-10133-124 St.','Edmonton','AB','T1W2V2','01/02/2013',NULL),
	(3,'Bob','Ceats','7804734521','5874081979','bceats@estore.com','327-10101-101Ave.','Edmonton','AB','T2V2S3','01/03/2013',NULL),
	(2,'Daisy','Plant','7804718888','4034081981','dplant@estore.com','111-101 St.','Edmonton','AB','T5Z4B5','01/05/2013',NULL),
	(2,'Shirley','Ujest','7804722233',NULL,'sujest@estore.com','111-118-178 St.','Edmonton','AB','T5J3A1','01/05/2013',NULL),
	(4,'Harry','Knuckles','7804738888','5875874401','hknuckles@estore.com','15877-66 St.','Edmonton','AB','T2C3C3','01/10/2013',NULL),
	(3,'Edie','Rhein','7804762349',NULL,'erhein@estore.com','618 - 110 St.','Edmonton','AB','T5S6Q7','02/14/2013',NULL),
	(2,'Edmundo','Tse','7809992345','4033047021','etse@estore.com','7750 - 63 St.','St Albert','AB','T8N9I4','03/15/2013',NULL),
	(4,'Edra','Difronzo','7802381907',NULL,'edifronzo@estore.com','3075 - 95 St.','Sherwood Park','AB','T8A4X4','04/01/2013',NULL)
GO

-- Supplier
PRINT 'INSERT INTO Supplier ....'
INSERT INTO Supplier(SupplierName,ContactFirstName,ContactLastName,Phone,Address,City,Province,PostalCode) VALUES
	('Best Western Fruit','Brock','Todd','7802381721','8755 Strathearn Cr.','Edmonton','AB','T6C4C5'),
	('Garden Vegetables','Jagger','Plemons','7802130998','7141 130 Ave.','Edmonton','AB','T5C1X8'),
	('CoreMark','Sasha','Macgillvary','7802231875','9361 50 St.','Edmonton','AB','T6B2L5'),
	('Spirts World','Annette','Oldham','2047812345','Box 10','The Pas','MB','R9A1K2'),
	('Country Meats','Thomas','Hilliard','7804751235','13333 Dovercourt Ave.','Edmonton','AB','T5L4E3'),
	('Organic Meats','Collins','Layton','7802241910','911 153 Ave.','Edmonton','AB','T5Y6C8'),
	('Prarie Gold','Pierre','Blancett','7804671902','3601 16A Ave.','Edmonton','AB','T6L2N3'),
	('Sweetees Sweets','Wallingford','Sumrall','7804972307','13711 Mark Messier Tr.','Edmonton','AB','T6V1H4'),
	('General Store','Martin','Stumfoll','7804973409','12715 St. Albert Tr.','Edmonton','AB','T5L4H5'),
	('Household Supplies','Tonio','Atenciolucas','4037863409','1403 Bow Valley Rd.','Calgary','AB','T9L4Z4'),
	('Totally Clean','Garrett','Nevitt','7804564560','166 Galland Cr.','Edmonton','AB','T5T6P4'),
	('We R Nutty','Trish','Michael','7804569872','5735 97 St.','Edmonton','AB','T6E3H9'),
	('Everything Kitchen','Lesley','Tinoco','7809993511','9049 Ottewell Rd.','Edmonton','AB','T6B2C6'),
	('Dollar Store','Kit','Ramey','7809992349','11415 120 St.','Edmonton','AB','T5G2Y3'),
	('OK Growers','Neil','Haven','7802239999','9035 135A Ave.','Edmonton','AB','T5E1S4')
GO

-- Customer
PRINT 'INSERT INTO Customer ....'
INSERT INTO Customer(FirstName,LastName,Phone,Email,Birthday,Address,City,Province,PostalCode) VALUES
	('Trista','Gandy','7899231209','trishag@outlook.com','1969-08-28','Box 234','Gibbons','AB','T0A1N0'),
	('Mouth','Luther','7802389876','mouthl@outlook.com','1969-09-09','Box 27','Leduc','AB','T9E2W9'),
	('Anthony','Hazlett','7802291095','anthonyh@outlook.com','1969-10-17','13104 Sherbrooke Ave.','Edmonton','AB','T5L4G2'),
	('Ruby','Natkin','7802382381','rubyn@outlook.com','1969-12-02','920 Graham Wynd','Edmonton','AB','T5T6L5'),
	('Wei','Miao','5879998888','weimiao@outlook.cn','1970-02-28','Box 999','Bon Accord','AB','T0B1B0'),
	('Cesar','Langford','5871234567','cesarl@outlook.com','1970-06-06','12345 121 St.','Edmonton','AB','T5L4Y7'),
	('Nancy','Oleary','7804971038','nancyol@outlook.com','1970-09-14','825 Breckinridge Bay','Edmonton','AB','T5T6J8'),
	('Kylie','Cone','7804971063','kyliec@outlook.com',NULL,'14309 92A Ave.','Edmonton','AB','T5R5E3'),
	('Victoria','Tompkins','7802389001','victoriat@outlook.com',NULL,'9120 Connors Rd.','Edmonton','AB','T6C4P9'),
	('Willis','Dregots','5879991209','willisd@outlook.com','1970-10-19','13104 122A Ave.','Edmonton','AB','T5L2W6'),
	('Paige','Bain','7804560007','paigeb@outlook.com','1970-11-20','703 Burley Dr.','Edmonton','AB','T6R1Y2'),
	('Lorraine','Arndt','7802388888','lorrainea@outlook.com','1971-07-23','555 Lessard Dr. NW','Edmonton','AB','T6M1A9'),
	('Elizabeth','Mulhollen','7802387777','elizabethm@outlook.com','1971-10-13','#5 15710 Beaumaris Rd.','Edmonton','AB','T5X5E2'),
	('Arielle','Mosley','7809993636','ariellem@outlook.com',NULL,'8737 178 Ave.','Edmonton','AB','T5Z0B8'),
	('Ally','Ely','7809994646','allye@outlook.com','1972-03-09','767 Hooke Rd.','Edmonton','AB','T5A5E8'),
	('Amber','Hutchison','5872381207','amberh@outlook.com','1972-06-01','10421 64 Ave.','Edmonton','AB','T6H1S8'),
	('Laurel','Hedge','7802334576','laurelh@outlook.com','1972-07-20','5729 118 Ave.','Edmonton','AB','T5W1E2'),
	('Samuel','Surkont','7802386541','samuels@outlook.com','1972-07-24','136 Fraser Way','Edmonton','AB','T5Y3M8'),
	('Dabney','Player','7804552239','dabneyp@outlook.com','1972-08-02','211 Dunvegan Rd.','Edmonton','AB','T5L5C6'),
	('Del','Donelow','7802381077','deld@outlook.com',NULL,'9327 104 Ave.','Edmonton','AB','T5H0H9'),
	('Tao','Ren','4038887777','taoren@outlook.cn',NULL,'123-44Ave','Red Deer','AB','T9B4B5'),
	('Lahoma','Ayres','7802281987','lahomaa@outlook.com','1973-01-17','420 Wilkin Way','Edmonton','AB','T6M2H8'),
	('Flo','Strand','7802388761','flos@outlook.com','1973-01-23','13548 Victoria Tr.','Edmonton','AB','T5A5C9'),
	('Craig','Hufford','5871202098','craigh@outlook.com','1973-03-02','260 Wakina Dr.','Edmonton','AB','T5T2X7'),
	('Ming Yue','Li','4037778888','mingli@outlook.cn',NULL,'4403 22 Ave','Red Deer','AB','T8B3C4'),
	('Jenna','Walls','2509992307','jennaw@outlook.com','1973-05-22','729 4th Ave.','Prince George','BC','V2L3H4'),
	('Colleen','Herbin','7809992307','colleenh@outlook.com','1973-05-29','12804 82 St.','Edmonton','AB','T5E2T2'),
	('Michelle','Sharon','5575555555','michelles@outlook.com','1973-06-06','Box 127','Beaumont','AB','T4X1L2'),
	('Cameron','Zornes','7802382323','cameronz@outlook.com','1973-10-26','5 Galaxy Pl.','St. Albert','AB','T8N1Z6'),
	('Jennifer','Algere','5572381209','jennifera@outlook.com','1974-02-08','230 Bancroft Cl.','Edmonton','AB','T5T6B5'),
	('Olivia','Willie','7804512209','oliviaw@outlook.com','1974-03-11','36 Hummingbird Rd.','Sherwood Park','AB','T8A0A2'),
	('Lincoln','Hagerty','3062291905','lincolnh@outlook.com','1974-04-25','Box 123','Meadow Lake','SK','S9X1L2')
GO

-- Product
PRINT 'INSERT INTO Product ....'
INSERT INTO Product(ProductName,SKU,CategoryID,Description,SupplierID,OrderCost,SellingPrice,QuantityOnHand,ReOrderLevel,OnOrder) VALUES
	('Apple','F-Apple-01',10,'Small apples',200,1.25,2.10,150,55,0),
	('Tomato','V-Tomat-02',11,'Orgainc Fresh Tomato',214,2.25,3.25,30,20,0),
	('Cabbage','V-Cabbg-01',11,'Large Cabbage',201,2.45,3.25,40,50,0),
	('Apple','F-Apple-02',10,'Medium apples',200,1.35,2.20,140,45,0),
	('Pepsi','D-Pepsi-01',12,'Pepsi',202,0.95,1.55,100,75,0),
	('Molson Canadian','A-MolCd-01',13,'Molson Canadian - IMPORTED',203,2.25,5.00,20,20,0),
	('Chicken Burger','M-CkBgr-01',14,'Plain chicken burger pattie',205,2.60,3.25,50,40,0),
	('Smarties','S-Smrty-01',16,'Smarties',207,1.65,2.40,75,50,0),
	('Sugar','K-Sugar-01',17,'Bag of sugar',208,2.00,4.00,50,75,0),
	('Doritos','J-Dorts-02',19,'Bag of Jalapeno Doritos',211,1.95,2.75,25,20,0),
	('Kitchen Utensils','H-KUtns-01',20,'Complete set of kitchen utensils',209,8.95,12.25,40,20,0),
	('Oreo Cookies','J-Oreos-01',19,'Package of Oreo cookies',211,1.75,2.95,60,40,0),
	('Joy','C-DSJoy-01',18,'Bottle of Joy dish detergent',210,4.25,6.15,25,20,0),
	('Jelly Beans','S-JlyBn-01',16,'Assorted Jelly Beans',207,1.75,2.45,50,75,100),
	('White Bread','B-White-02',15,'Large loaf of white bread',206,2.95,3.40,20,10,0),
	('Chicken Wings','M-Wings-01',14,'Cajun spiced chicken wings',205,4.55,5.25,40,75,100),
	('Beef Sausage','M-BfSge-01',14,'Large Beef Sausage',204,4.15,6.25,20,10,0),
	('Imported Beer','A-Imprt-01',13,'Bottle of Imported Beer',203,2.15,5.00,20,30,40),
	('Orange Juice','D-OrgJu-01',12,'Minute Maid Orange Juice',202,1.65,3.25,60,40,0),
	('Carrot','V-Carrt-03',11,'Orgaincally grown carrot',214,1.75,13.25,50,60,20),
	('Mango','F-Mango-01',10,'Imported Orgainc Mango',214,2.34,3.50,40,35,0),
	('Apple','F-Apple-03',10,'Large apples',200,1.45,2.60,130,40,0),
	('Beef Sausage','M-BfSge-02',14,'Small Beef Sausage',204,3.56,4.65,20,20,0),
	('Hot Dog Buns','B-DBuns-01',15,'Package of hot dog buns',206,5.05,6.70,15,30,50),
	('Candied Ginger','S-CdGgr-01',16,'Chewy candied ginger',207,0.55,1.75,60,50,0),
	('Salt','K-TSalt-01',17,'Bag of salt',208,1.55,2.45,60,50,25),
	('Tide','C-LTide-01',18,'Small bag of Tide laundry soap',209,3.25,4.75,40,30,0),
	('BBQ Chips','J-BBQCh-01',19,'Bag of BBQ Potato Chips',211,1.25,2.45,60,40,0),
	('Rice Cooker','H-RcCkr-02',20,'Propane Rice Cooker',212,19.95,24.95,30,10,0),
	('Bleach','C-Bleac-01',18,'Bottle of bleach',209,1.95,2.45,50,30,0),
	('Garlic','K-Garlc-01',17,'Garlic bulb',208,1.15,2.15,30,25,0),
	('Canola Oil','K-CnOil-02',17,'Large bottle of Canola cooking oil',208,4.25,9.75,45,60,100),
	('Crown Royal','A-CrwnR-01',13,'Crown Royal - IMPORTED',203,12.95,35.55,10,5,0),
	('Grape Juice','D-GrpJu-01',12,'Freshly squeezed grape juice',202,1.87,2.99,20,30,00),
	('Coke Zero','D-Coke0-01',12,'Coke Zero',202,0.95,1.55,25,50,0),
	('Carrot','V-Carrt-02',11,'Garden Fresh Baby Carrot',201,1.35,1.85,200,100,0),
	('Banana','F-Banan-01',10,'Organic bananas',214,2.34,3.99,40,20,0),
	('Labat''s Blue','A-LabBl-02',13,'24 Pack of Labat''s Blue',203,10.10,24.00,60,45,0),
	('Pork Sausage','M-PkSge-02',14,'Breakfast Sausage',204,2.75,3.55,40,50,0),
	('Brown Bread','B-Brown-01',15,'Small loaf of brown bread',206,1.85,2.25,20,20,0),
	('Dove Choc Bar','S-DvBar-02',16,'Large Dove chocolate bar',207,2.25,3.75,50,25,0),
	('Canola Oil','K-CnOil-01',17,'Small bottle of Canola cooking oil',208,1.65,2.15,50,50,25),
	('Tide','C-LTide-02',18,'Large bag of Tide laundry soap',209,5.25,7.15,30,25,0),
	('Ritz Crackers','J-RitzC-01',19,'Box of Ritz crackers',211,2.00,3.25,40,50,25),
	('Wok','H-IrWok-01',20,'Cast iron wok',209,4.95,6.25,25,15,0),
	('Scrubbies','C-Scrbs-01',18,'Package of scrubbing pads',208,3.05,4.10,50,40,0),
	('MSG','K-MnSdG-01',17,'Bag of MSG',208,0.95,1.75,35,50,75),
	('Yogurt Candy','S-YgCdy-01',16,'Soft yogurt candy',207,1.35,1.95,60,50,0),
	('Texas Toast','B-TxTst-01',15,'Texas toast',206,3.25,4.95,30,25,0),
	('Budweiser','A-Budws-01',13,'Budweiser - IMPORTED',203,2.10,4.95,20,20,0),
	('Apple Juice','D-AppJu-01',12,'Apple Juice',202,1.55,3.25,50,40,0),
	('Diet Coke','D-CokeD-01',12,'Diet Coke',202,0.95,1.55,25,60,0),
	('Cabbage','V-Cabbg-02',11,'Small Cabbage',201,1.85,2.55,60,30,0),
	('Pineapple','F-PineA-01',10,'Imported Orgainc Pineapple',214,4.75,6.25,50,60,20),
	('Chicken Burger','M-CkBgr-02',14,'Spicy chicken burger pattie',205,2.65,3.30,40,50,20),
	('Hamburger Buns','B-HBuns-01',15,'Package of hamburger buns',206,5.10,6.75,30,25,0),
	('Mango','S-CdMgo-01',16,'Dried mango candy',207,2.05,4.10,60,40,0),
	('Pepper','K-Peppr-01',17,'Bag of pepper corns',208,1.46,3.75,50,75,0),
	('Dawn','C-DsDwn-01',18,'Bottle of Dawn dish detergent',210,4.15,6.10,30,20,0),
	('Doritos','J-Dorts-01',19,'Bag of Nacho Doritos',211,1.95,2.75,25,10,0),
	('Rice Cooker','H-RcCkr-01',20,'Electric Rice Cooker',209,25.75,36.95,20,15,0),
	('Dove Choc Bar','S-DvBar-01',16,'Small Dove chocolate bar',207,1.35,2.25,60,30,0),
	('Cracker Jax','J-CrkJx-01',19,'Box of Cracker Jax',211,0.55,1.15,100,50,0),
	('Chopsticks','H-ChpSt-01',20,'Package of 50 chopsticks',209,5.25,7.35,50,50,25),
	('White Bread','B-White-01',15,'Small loaf of white bread',206,1.95,2.35,20,10,0),
	('Pork Sausage','M-PkSge-01',14,'Large Pork Sausage',204,3.75,4.55,30,25,0),
	('Labat''s Blue','A-LabBl-01',13,'Bottle of Labat''s Blue',203,1.15,2.00,30,50,0),
	('Sprite','D-Sprit-01',12,'Sprite',202,0.95,1.55,90,70,0),
	('Carrot','V-Carrt-01',11,'Garden Fresh Carrot',201,1.45,1.95,100,55,0),
	('Banana','F-Banan-02',10,'Imported bananas',200,1.74,2.38,67,70,0),
	('Snow Beer','A-SnwBr-02',13,'Large can of Snow Beer',203,1.10,2.00,120,50,0),
	('Brown Bread','B-Brown-02',15,'Large loaf of brown bread',206,2.85,3.10,20,30,10),
	('Windex','C-WindX-01',18,'Bottle of Windex glass and surface cleaner',210,3.75,6.50,20,20,20),
	('Cheezies','J-Cheez-01',19,'Bag of Hawkins Cheezies',211,2.05,2.95,60,50,100),
	('Knife Set','H-KnfSt-01',20,'Complete kitchen knife set',209,23.95,32.50,25,20,0),
	('Tomato','V-Tomat-01',11,'Garden Fresh Tomato',201,1.75,2.75,80,50,0),
	('Cutting Board','H-CutBd-01',20,'Wooden cutting board',212,2.15,3.65,60,30,0)
GO

-- PurchaseOrder
PRINT 'INSERT INTO PurchaseOrder ....'
-- update the dates to a more recent date
INSERT INTO PurchaseOrder(OrderDate,EmployeeID,SupplierID,ReceivedDate) VALUES
	('02/15/2021 09:10:11',1002,200,'02/23/2021 11:15:25'),
	('02/23/2021 08:34:45',1002,201,'03/01/2021 10:05:20'),
	('02/24/2021 10:21:35',1003,202,'03/02/2021 08:45:01'),
	('03/04/2021 13:14:15',1007,203,'03/09/2021 09:44:51'),
	('03/04/2021 14:10:10',1002,204,'03/11/2021 11:34:41'),
	('03/09/2021 08:31:27',1003,205,NULL),
	('03/09/2021 11:11:11',1007,206,NULL),
	('03/09/2021 13:45:13',1002,207,NULL),
	('03/10/2021 09:29:37',1007,208,NULL),
	('03/21/2021 15:21:46',1003,209,NULL),
	('03/22/2021 10:45:01',1007,210,NULL),
	('04/01/2021 09:19:54',1003,211,NULL),
	('04/01/2021 16:28:15',1003,214,NULL)
GO

-- PurchaseOrderDetail
PRINT 'INSERT INTO PurchaseOrderDetail ....'
INSERT INTO PurchaseOrderDetail(PurchaseOrderNumber,ProductID,OrderQuantity) VALUES
	(500,304,30),
	(501,312,20),
	(502,314,75),
	(502,315,80),
	(502,320,50),
	(503,321,80),
	(504,331,25),
	(505,333,20),
	(505,334,100),
	(506,338,10),
	(506,340,50),
	(507,342,100),
	(508,349,25),
	(508,350,60),
	(508,351,25),
	(508,354,75),
	(509,372,25),
	(510,359,20),
	(511,365,25),
	(511,369,100),
	(512,305,20),
	(512,311,20)
GO

-- SalesOrder & SalesOrderDetail
PRINT 'INSERT INTO SalesOrder ....'
INSERT INTO SalesOrder(OrderDate,CustomerID,EmployeeID) VALUES
	('12/01/2020 14:40:02',100,NULL),
	('12/01/2020 14:56:03',102,NULL),
	('12/01/2020 18:18:21',104,NULL),
	('12/02/2020 09:51:17',110,NULL),
	('12/03/2020 10:13:23',109,1004),
	('01/02/2021 13:21:04',131,1008),
	('01/05/2021 12:00:47',124,NULL),
	('01/22/2021 08:19:19',120,NULL),
	('02/02/2021 09:29:31',104,1005),
	('02/14/2021 14:14:14',127,NULL),
	('02/22/2021 21:35:21',128,NULL),
	('03/01/2021 15:23:34',100,NULL),
	('03/12/2021 11:11:24',125,1008),
	('03/23/2021 10:59:34',101,NULL),
	('04/04/2021 12:30:00',118,NULL),
	('04/06/2021 12:45:21',115,1004),
	('04/06/2021 13:45:32',105,1004),
	('04/29/2021 07:21:34',116,NULL),
	('05/01/2021 08:33:34',125,NULL),
	('05/05/2021 15:21:47',108,NULL),
	('05/05/2021 16:21:16',113,1005),
	('05/06/2021 21:33:00',123,NULL),
	('05/07/2021 08:08:08',131,NULL),
	('05/08/2021 09:46:11',100,NULL),
	('05/08/2021 09:59:59',124,NULL),
	('05/09/2021 11:23:56',115,1004),
	('05/10/2021 14:23:35',109,1004),
	('05/30/2021 10:30:45',122,NULL),
	('06/02/2021 09:27:34',116,NULL),
	('06/02/2021 10:23:13',128,NULL),
	('06/06/2021 11:01:28',117,NULL),
	('06/13/2021 13:13:13',113,NULL),
	('06/30/2021 15:14:13',125,NULL),
	('07/02/2021 06:45:59',131,NULL),
	('07/03/2021 07:49:12',102,NULL),
	('07/04/2021 08:39:46',101,1004),
	('07/05/2021 09:56:01',103,NULL),
	('07/05/2021 14:23:34',127,NULL),
	('07/06/2021 13:34:12',100,NULL),
	('07/17/2021 11:23:56',104,1004),
	('07/18/2021 11:45:13',105,NULL),
	('07/25/2021 14:12:25',109,NULL),
	('07/26/2021 10:34:14',110,NULL),
	('07/30/2021 14:12:15',123,NULL),
	('08/04/2021 08:04:56',106,1008),
	('08/08/2021 19:56:00',113,NULL),
	('08/09/2021 13:25:23',108,NULL),
	('08/12/2021 13:14:15',109,1004),
	('08/15/2021 16:42:00',131,NULL),
	('08/24/2021 14:12:48',117,NULL),
	('08/31/2021 11:36:27',122,NULL),
	('09/03/2021 09:01:37',114,1005),
	('09/12/2021 19:56:00',128,NULL),
	('09/23/2021 10:45:32',101,NULL),
	('09/30/2021 15:23:43',125,NULL),
	('10/13/2021 10:11:13',124,NULL),
	('10/14/2021 09:46:24',107,NULL),
	('10/23/2021 13:26:39',102,NULL),
	('10/24/2021 15:12:38',103,1004),
	('10/30/2021 16:16:17',104,NULL),
	('10/31/2021 13:13:13',113,NULL)
GO
 
PRINT 'INSERT INTO SalesOrderDetail ....'
INSERT INTO SalesOrderDetail(OrderNumber,ProductID,Quantity) VALUES
	(400,364,1),(400,365,1),(400,344,2),
	(401,334,1),(401,341,1),
	(402,342,2),(402,338,2),
	(402,363,2),(403,357,1),
	(403,361,1),(403,362,1),
	(403,360,1),(403,359,1),
	(404,340,2),(404,347,2),(404,351,1),(404,367,1),(404,373,2),
	(405,328,1),(405,311,1),(405,365,1),
	(406,360,1),(406,324,1),(406,352,1),(406,353,2),
	(407,370,2),
	(408,346,1),(408,315,1),(408,331,1),(408,335,1),
	(409,305,2),(409,309,2),(409,327,1),(409,349,1),
	(410,300,2),(410,320,1),(410,336,2),
	(411,323,1),(411,355,1),(411,354,2),(411,304,4),
	(412,376,1),(412,374,1),(412,344,1),
	(413,347,3),(413,313,3),(413,324,2),
	(414,312,1),(414,329,1),(414,345,2),(414,372,1),
	(415,353,1),(415,356,1),
	(416,362,1),(416,359,2),(416,307,2),
	(417,348,2),(417,354,2),(417,337,1),
	(418,301,2),(418,302,1),(418,319,2),(418,335,2),
	(419,322,1),(419,334,2),(419,339,2),(419,343,1),(419,313,3),(419,370,1),
	(420,344,1),(420,310,1),
	(421,328,1),
	(422,311,2),(422,343,2),(422,373,3),
	(423,357,1),(423,301,2),(423,325,1),(423,371,1),
	(424,330,1),(424,357,1),(424,325,1),
	(425,344,1),(425,341,1),(425,330,1),(425,352,1),
	(426,336,2),(426,353,1),(426,333,2),
	(427,364,1),(427,338,1),(427,349,2),
	(428,347,2),(428,334,6),
	(429,313,6),(429,311,2),(429,327,2),
	(430,314,2),(430,315,2),(430,317,6),
	(431,313,3),(431,333,2),
	(432,326,1),(432,329,1),
	(433,317,2),(433,327,2),
	(434,321,6),(434,333,2),(434,348,1),
	(435,360,1),
	(436,344,1),(436,346,1),(436,341,1),(436,302,2),
	(437,373,1),(437,334,1),
	(438,316,2),(438,375,2),(438,352,1),
	(439,332,1),
	(440,315,2),(440,351,2),(440,373,1),
	(441,340,2),(441,313,2),(441,304,2),
	(442,305,2),(442,337,2),(442,309,4),
	(443,374,1),(443,346,1),(443,312,1),(443,310,1),
	(444,326,1),(444,372,1),(444,331,1),
	(445,347,1),(445,311,1),(445,327,1),
	(446,363,2),(446,344,1),(446,325,1),(446,346,1),(446,357,1),(446,352,1),
	(447,333,1),(447,350,1),(447,318,1),
	(448,374,1),(448,312,1),(448,345,2),
	(449,305,6),(449,327,4),
	(450,339,1),(450,364,1),(450,308,1),(450,307,2),(450,311,1),
	(451,344,1),(451,376,1),(451,374,1),(451,310,1),(451,363,1),(451,328,1),(451,325,1),(451,357,1),(451,346,1),
	(452,313,1),(452,333,1),(452,340,2),(452,334,2),(452,373,2),
	(453,368,2),(453,341,1),(453,352,1),(453,330,2),
	(454,354,2),(454,304,1),(454,334,1),
	(455,375,2),(455,307,2),
	(456,308,1),(456,353,1),(456,343,1),(456,347,2),
	(457,360,1),
	(458,311,1),(458,340,1),(458,347,1),(458,307,1),
	(459,369,2),(459,303,2),(459,350,1),
	(460,332,1),(460,309,1),(460,311,1),(460,316,2),(460,339,1)
GO
PRINT 'End of eStore.sql  ....'
