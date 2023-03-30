USE Quiz4
GO

--Drop Tables
DROP TABLE WageHistory
DROP TABLE SaleItem
DROP TABLE FunSeekerMembership
DROP TABLE Sale
DROP TABLE Item
DROP TABLE Membership
DROP TABLE FunSeeker
DROP TABLE ClubMembership
DROP TABLE RideLog
DROP TABLE Club
DROP TABLE Staff
DROP TABLE Task
DROP TABLE Ride
DROP TABLE Area
DROP TABLE Category
GO

--Create Tables
CREATE TABLE Category
(
	CategoryCode			INT	IDENTITY(1,1)	NOT NULL
												CONSTRAINT PK_Category_CategoryCode
													PRIMARY KEY CLUSTERED,
	CategoryName			VARCHAR(50) 		NOT NULL,
	MinimumHeight			SMALLINT			NOT NULL
)

CREATE TABLE Area
(
	AreaID					CHAR(4) 			NOT NULL
												CONSTRAINT PK_Area_AreaID
													PRIMARY KEY CLUSTERED,
	AreaName				VARCHAR(50)			NOT NULL,
	AreaDescription			VARCHAR(150)		NOT NULL
)

CREATE TABLE Ride
(
	RideID					INT	IDENTITY(1,1)	NOT NULL 
												CONSTRAINT PK_Ride_RideID
													PRIMARY KEY CLUSTERED,
	RideName				VARCHAR(50)			NOT NULL,
	RideDescription			VARCHAR(150)		NOT NULL,
	CategoryCode			INT					NOT NULL 
												CONSTRAINT FK_Ride_CategoryCode_To_Category_CategoryCode
													REFERENCES Category(CategoryCode),
	AreaID					CHAR(4)				NOT NULL 
												CONSTRAINT FK_Ride_AreaID_To_Area_AreaID
													REFERENCES Area(AreaID)
)

CREATE TABLE Task
(
	TaskID					INT	IDENTITY(1,1)	NOT NULL 
												CONSTRAINT PK_Task_TaskID
													PRIMARY KEY CLUSTERED,
	TaskDescription			VARCHAR(150)		NOT NULL
)

CREATE TABLE Staff
(
	StaffID					INT	IDENTITY(1,1)	NOT NULL 
												CONSTRAINT PK_Staff_StaffID
													PRIMARY KEY CLUSTERED,
	FirstName				VARCHAR(30)			NOT NULL,
	LastName				VARCHAR(30)			NOT NULL,
	HireDate				SMALLDATETIME		NOT NULL,
	ReleasedDate			SMALLDATETIME		NULL,
	Phone					CHAR(13)			NOT NULL,
	Wage					SMALLMONEY			NOT NULL
)

CREATE TABLE Club
(
	ClubCode				CHAR(2)				NOT NULL 
												CONSTRAINT PK_Club_ClubCode
													PRIMARY KEY CLUSTERED,
	ClubName				VARCHAR(50)			NOT NULL
)

CREATE TABLE RideLog
(
	RideID					INT					NOT NULL 
												CONSTRAINT FK_RideLog_RideID_To_Ride_RideID
													REFERENCES Ride(RideID),
	LogNumber				INT					NOT NULL,
	DateCompleted			SMALLDATETIME		NOT NULL,
	Notes					VARCHAR(150)		NOT NULL,
	TaskID					INT					NOT NULL 
												CONSTRAINT FK_RideLog_TaskID_To_Task_TaskID
													REFERENCES Task(TaskID),
	StaffID					INT					NOT NULL 
												CONSTRAINT FK_RideLog_StaffID_To_Staff_StaffID
													REFERENCES Staff(StaffID),
	CONSTRAINT PK_RideLog_RideID_LogNumber
		PRIMARY KEY CLUSTERED (RideID, LogNumber)
)

CREATE TABLE ClubMembership 
(
	StaffID					INT					NOT NULL 
												CONSTRAINT FK_ClubMembership_StaffID_To_Staff_StaffID
													REFERENCES Staff(StaffID),
	ClubCode				CHAR(2)				NOT NULL 
												CONSTRAINT FK_ClubMembership_ClubCode_To_Club_ClubCode
													REFERENCES Club(ClubCode),
	DateJoined				SMALLDATETIME		NOT NULL,
	CONSTRAINT PK_ClubMembership_StaffID_ClubCode
		PRIMARY KEY CLUSTERED (StaffID, ClubCode)
) 

CREATE TABLE FunSeeker
(
	FunSeekerID				INT	IDENTITY(1,1)	NOT NULL 
												CONSTRAINT PK_FunSeeker_FunSeekerID
													PRIMARY KEY CLUSTERED,
	FirstName				VARCHAR(30)			NOT NULL,
	LastName				VARCHAR(30)			NOT NULL,
	Address					VARCHAR(30)			NOT NULL,
	City					VARCHAR(30)			NOT NULL,
	Province				CHAR(2)				NOT NULL,
	PostalCode				CHAR(6)				NOT NULL,
	Status					VARCHAR(20)			NOT NULL
)

CREATE TABLE Membership
(
	MembershipID			INT	IDENTITY(1,1)	NOT NULL 
												CONSTRAINT PK_Membership_MembershipID
													PRIMARY KEY CLUSTERED,
	MembershipName			VARCHAR(100)		NOT NULL,
	MembershipDescription	VARCHAR(100)		NOT NULL,
	Cost					SMALLMONEY			NOT NULL
)

CREATE TABLE Item
(
	ItemNumber				INT	IDENTITY(1,1)	NOT NULL
												CONSTRAINT PK_Item_ItemNumber
													PRIMARY KEY CLUSTERED,
	Description				VARCHAR(50)			NOT NULL,
	Price					SMALLMONEY			NOT NULL
)

CREATE TABLE Sale
(
	SaleNumber				INT	IDENTITY(1,1)	NOT NULL 
												CONSTRAINT PK_Sale_SaleNumber
													PRIMARY KEY CLUSTERED,
	SaleDate				DATETIME			NOT NULL
												CONSTRAINT DF_Sale_SaleDate
													DEFAULT GETDATE(),
	SubTotal				SMALLMONEY			NOT NULL,
	GST						SMALLMONEY			NOT NULL,
	Total					SMALLMONEY			NOT NULL,
	FunSeekerID				INT					NOT NULL
												CONSTRAINT FK_Sale_SaleNumber_To_FunSeeker_FunSeekerID
													REFERENCES FunSeeker(FunSeekerID)
)

CREATE TABLE FunSeekerMembership
(
	FunSeekerID				INT					NOT NULL 
												CONSTRAINT FK_FunSeekerMembership_FunSeekerID_To_FunSeeker_FunSeekerID
													REFERENCES FunSeeker(FunSeekerID),
	MembershipID			INT					NOT NULL 
												CONSTRAINT FK_FunSeekerMembership_MembershipID_To_Membership_MembershipID
													REFERENCES Membership(MembershipID),
	StartDate				SMALLDATETIME		NOT NULL,
	EndDate					SMALLDATETIME		NOT NULL,
	StaffID					INT					NOT NULL 
												CONSTRAINT FK_FunSeekerMemership_StaffID_To_Staff_StaffID
													REFERENCES Staff(StaffID)
	CONSTRAINT PK_FunSeekerMembership_FunseekerID_MembershipID_StartDate 
		PRIMARY KEY CLUSTERED (FunseekerID, MembershipID, StartDate) 
)

CREATE TABLE SaleItem
(
	SaleNumber				INT					NOT NULL
												CONSTRAINT FK_SaleItem_SaleNumber_To_Sale_SaleNumber
													REFERENCES Sale(SaleNumber),
	ItemNumber				INT					NOT NULL
												CONSTRAINT FK_SaleItem_ItemNumber_To_Item_ItemNumber
													REFERENCES Item(ItemNumber),
	Quantity				SMALLINT			NOT NULL,
	Price					SMALLMONEY			NOT NULL,
	ExtendedPrice			SMALLMONEY			NOT NULL,
	CONSTRAINT PK_SaleItem_SaleNumber_ItemNumber
		PRIMARY KEY CLUSTERED (SaleNumber, ItemNumber)
)

CREATE TABLE WageHistory
(
	WageHistoryID			INT IDENTITY(1,1)	NOT NULL
												CONSTRAINT PK_WageHistory_WageHistoryID
													PRIMARY KEY CLUSTERED,
	StaffID					INT					NOT NULL,
	ChangedDate				DATETIME			NOT NULL,
	OldWage					SMALLMONEY			NOT NULL,
	NewWage					SMALLMONEY			NOT NULL
)
GO


-- Insert test data
INSERT INTO Category
	(CategoryName, MinimumHeight)
VALUES 
	('Little Riders', 36), 
	('Teen', 48), 
	('Adult', 60)
GO

INSERT INTO Area
	(AreaID, AreaName, AreaDescription)
VALUES 
	('A100', 'Scary Zone', 'Rides sure to scare you!'), 
	('A200', 'Wild Zone', 'Wild rides!'), 
	('A300', 'Fun Zone', 'All about fun'), 
	('A400', 'Mystery Zone', 'All about the mystery')
GO

INSERT INTO Ride
	(RideName, RideDescription, CategoryCode, AreaID)
VALUES
	('Normalization Drop', 'Triple loop Coaster', 2, 'A100'), 
	('Table Turner', 'Triple loop Coaster', 1, 'A200'), 
	('Dizzy DML Dive', 'Triple loop Coaster', 1, 'A100'), 
	('Stored Procedure Mystery Cavern', 'Triple loop Coaster', 1, 'A200'), 
	('View or View not', 'Triple loop Coaster', 1, 'A100'), 
	('Group by Garage', 'Triple loop Coaster', 1, 'A200'), 
	('DataType Drop', 'Triple loop Coaster', 1, 'A300'), 
	('Alter Reality', 'Triple loop Coaster', 1, 'A200'), 
	('Select Your Own Adventure', 'Triple loop Coaster', 1, 'A300')
GO

INSERT INTO Task
	(TaskDescription)
VALUES
	('Seat cleaning'), 
	('Harness Inspection'), 
	('Painting'), 
	('Greasing'), 
	('Test Drive'), 
	('Rust Prevention'), 
	('Scheduled Parts Replacement'), 
	('Unscheduled Parts Replacement'), 
	('Seat Repair'), 
	('Harness Repair')
GO

INSERT INTO Staff
	(FirstName, LastName, HireDate, ReleasedDate, Phone, wage)
VALUES
	('Jason', 'Normalform', 'Jan 1 2020', NULL, '(780)555-1234', 25), 
	('Susie', 'Orderby', 'Aug 6 2021', NULL, '(780)555-2345', 23), 
	('Sally', 'Having', 'Jun 24 2021', NULL, '(780)555-3456', 22), 
	('Jerry', 'Joins', 'Sep 2 2020', NULL, '(780)555-4567', 28), 
	('Ali', 'Alias', 'Sep 18 2021', NULL, '(780)555-5678', 21), 
	('Victoria', 'Viewster', 'Jan 20 2018', NULL, '(780)555-6789', 22)
GO

INSERT INTO Club
	(ClubCode, ClubName)
VALUES
	('NF', 'Normal Form Club'), 
	('RA', 'Raise Error Debate Club'), 
	('VW', 'View the World Travel Club'), 
	('TH', 'Target Happy Nerf Club'), 
	('JW', 'Join the World Charity Club')
GO

INSERT INTO RideLog
	(RideID, LogNumber, DateCompleted, Notes, TaskID, StaffID)
VALUES
	(8, 1, 'Apr 15 2020', 'No notes', 1, 1), 
	(9, 1, 'Jun 2 2020', 'No notes', 2, 1), 
	(1, 1, 'Jun 1 2021', 'No notes', 4, 1), 
	(1, 2, 'Jun 18 2021', 'No notes', 3, 1), 
	(5, 1, 'Jul 3 2021', 'No notes', 3, 1), 
	(6, 1, 'Sep 5 2021', 'No notes', 5, 1), 
	(8, 2, 'Jun 1 2021', 'No notes', 4, 1), 
	(9, 2, 'Jan 1 2022', 'No notes', 4, 1)
GO

INSERT INTO ClubMembership
	(StaffID, ClubCode, DateJoined)
VALUES
	(1, 'NF', 'Jan 1 2022'), 
	(1, 'JW', 'Feb 1 2022'), 
	(2, 'NF', 'Jan 1 2022'), 
	(3, 'NF', 'Jan 1 2022'), 
	(3, 'TH', 'Mar 1 2022'), 
	(4, 'NF', 'Jan 1 2022'), 
	(3, 'JW', 'Feb 1 2022')
GO

INSERT INTO FunSeeker
	(Firstname, LastName, Address, City, Province, PostalCode, status)
VALUES
	('Sheldon', 'Cooper', '101 Geek Street', 'Edmonton', 'AB', 'T8E1J3', 'Beginner'), 
	('Leonard', 'Hofstader', '101 Geek Street', 'Edmonton', 'AB', 'T8E1J3', 'Beginner'), 
	('Howard', 'Wolowitz', '23 Astronaut Avenue', 'Edmonton', 'AB', 'T8A1J4', 'Beginner'), 
	('Stuart', 'Bloom', '101 Geek Street', 'Edmonton', 'AB', 'T8E1H3', 'Beginner'), 
	('Barry', 'Kripke', '101 Geek Street', 'Edmonton', 'AB', 'T8E1J3', 'Beginner'), 
	('Amy', 'Farah Fowler', '101 Geek Street', 'Edmonton', 'AB', 'T8f1J3', 'Beginner'), 
	('Raj', 'Koothrappali', '101 Geek Street', 'Edmonton', 'AB', 'T8A1J3', 'Beginner'), 
	('Leslie', 'Winkle', '101 Geek Street', 'Edmonton', 'AB', 'T8L1J3', 'Beginner'), 
	('Bert', 'Kibbler', '101 Geek Street', 'Edmonton', 'AB', 'T8L1J3', 'Beginner')
GO

INSERT INTO Membership
	( MembershipName, MembershipDescription, Cost)
VALUES
	('Monthly Ride A Lot', 'One month ride all day pass', 50), 
	('Yearly Ride A Lot', 'One year ride all day pass', 500), 
	('Senior Monthly Ride A Lot', 'One month day senior ride all day pass', 20), 
	('Student Monthly Ride A Lot', 'One month day student ride all day pass', 25)
GO

INSERT INTO FunSeekerMembership
	(FunSeekerID, MembershipID, StartDate, EndDate, StaffID)
VALUES
	(1, 1, 'Dec 1 2011', 'Dec 31 2011', 1), 
	(1, 1, 'Jan 1 2021', 'Jan 31 2021', 1), 
	(2, 1, 'Jan 1 2022', 'Jan 31 2022', 2), 
	(4, 1, 'Jan 1 2022', 'Jan 31 2022', 2),
	(5, 2, 'Feb 1 2022', 'Feb 28 2022', 3),
	(6, 1, 'Mar 1 2022', 'Mar 31 2022', 4),
	(1, 1, 'Feb 1 2022', 'Feb 28 2022', 5), 
	(3, 1, 'Jan 1 2022', 'Jan 31 2022', 6),
	(6, 1, 'Sep 1 2020', 'Oct 1 2020', 5), 
	(6, 2, 'Jun 1 2021', 'Jun 1 2022', 5), 
	(6, 1, 'Nov 1 2020', 'Dec 1 2020', 5), 
	(6, 1, 'Dec 1 2020', 'Jan 1 2021', 5), 
	(2, 1, 'Aug 1 2021', 'Sep 1 2021', 5)
GO

INSERT INTO Item
	(Description, Price)
VALUES
	('T-Shirt', 10), 
	('Hat', 5), 
	('PostCard', 2), 
	('Coffee Mug', 4), 
	('Coloring Book', 2), 
	('Stuffed Mascot', 15), 
	('Collectable Coin', 10)
GO

INSERT INTO Sale
	(SubTotal, GST, Total, FunSeekerID)
VALUES
	(24, 1.2, 25.20, 1)
INSERT INTO SaleItem
	(SaleNumber, ItemNumber, Quantity, Price, ExtendedPrice)
VALUES
	(1, 1, 2, 10, 20)
INSERT INTO SaleItem
	(SaleNumber, ItemNumber, Quantity, Price, ExtendedPrice)
VALUES
	(1, 4, 1, 4, 4)
GO

INSERT INTO Sale
	(SubTotal, GST, Total, FunSeekerID)
VALUES
	(14, .7, 14.7, 2)
INSERT INTO SaleItem
	(SaleNumber, ItemNumber, Quantity, Price, ExtendedPrice)
VALUES
	(2, 3, 2, 2, 4)
INSERT INTO SaleItem
	(SaleNumber, ItemNumber, Quantity, Price, ExtendedPrice)
VALUES
	(2, 7, 1, 10, 10)
GO

INSERT INTO Sale
	(SubTotal, GST, Total, FunSeekerID)
VALUES
	(19, .95, 19.95, 3)
INSERT INTO SaleItem
	(SaleNumber, ItemNumber, Quantity, Price, ExtendedPrice)
VALUES
	(3, 5, 2, 2, 4)
INSERT INTO SaleItem
	(SaleNumber, ItemNumber, Quantity, Price, ExtendedPrice)
VALUES
	(3, 6, 1, 15, 15)
GO

INSERT INTO Sale
	(SubTotal, GST, Total, FunSeekerID)
VALUES
	(24, 1.2, 25.20, 1)
INSERT INTO SaleItem
	(SaleNumber, ItemNumber, Quantity, Price, ExtendedPrice)
VALUES
	(4, 1, 2, 10, 20)
INSERT INTO SaleItem
	(SaleNumber, ItemNumber, Quantity, Price, ExtendedPrice)
VALUES
	(4, 4, 1, 4, 4)
GO

INSERT INTO Sale
	(SubTotal, GST, Total, FunSeekerID)
VALUES
	(24, 1.2, 25.20, 1)
INSERT INTO SaleItem
	(SaleNumber, ItemNumber, Quantity, Price, ExtendedPrice)
VALUES
	(5, 1, 2, 10, 20)
INSERT INTO SaleItem
	(SaleNumber, ItemNumber, Quantity, Price, ExtendedPrice)
VALUES
	(5, 4, 1, 4, 4)
GO

INSERT INTO Sale
	(SubTotal, GST, Total, FunSeekerID)
VALUES
	(24, 1.2, 25.20, 1)
INSERT INTO SaleItem
	(SaleNumber, ItemNumber, Quantity, Price, ExtendedPrice)
VALUES
	(6, 1, 2, 10, 20)
INSERT INTO SaleItem
	(SaleNumber, ItemNumber, Quantity, Price, ExtendedPrice)
VALUES
	(6, 4, 1, 4, 4)
GO

-- Create the triggers below:
/*
1. Create a trigger called TR1 that will update the Sales SubTotal, GST (5%) and Total 
whenever a record is added to the SaleItem table. Ensure only one record will be added to 
the SaleItem table at a time. (4.5 marks)
*/
CREATE TRIGGER TR1
ON SaleItem FOR INSERT
AS
	IF @@ROWCOUNT > 1
		BEGIN
			RAISERROR('Only one record will be added to the Sale Item table at a time.',16,1)
			ROLLBACK TRANSACTION
		END
	ELSE
		BEGIN
			DECLARE @SaleNumber INT, @ExtendedPrice SMALLMONEY
			DECLARE @CurrentSubTotal SMALLMONEY
			DECLARE @NewSubTotal SMALLMONEY, @NewGST SMALLMONEY, @NewTotal SMALLMONEY

			-- Get Sale Number and Extended Price of the newly added Sale Item
			SELECT @SaleNumber=INSERTED.SaleNumber, @ExtendedPrice=INSERTED.ExtendedPrice FROM INSERTED

			-- Get the current Sub Total of the Sale Number
			SELECT @CurrentSubTotal=SubTotal FROM Sale WHERE SaleNumber=@SaleNumber
			PRINT 'Current Sub Total: ' + CONVERT(VARCHAR(50), @CurrentSubTotal)

			-- Calculate the new values
			SET @NewSubTotal = @CurrentSubTotal + @ExtendedPrice
			SET @NewGST = @NewSubTotal * 0.05
			SET @NewTotal = @NewSubTotal + @NewGST

			PRINT 'New Sub Total: ' + CONVERT(VARCHAR(50), @NewSubTotal)
			PRINT 'New GST: ' + CONVERT(VARCHAR(50), @NewGST)
			PRINT 'New Total: ' + CONVERT(VARCHAR(50), @NewTotal)

			-- Update Sale
			UPDATE Sale
			SET SubTotal=@NewSubTotal, GST=@NewGST, Total=@NewTotal
			WHERE SaleNumber=@SaleNumber

		END
RETURN
GO

-- Test trigger TR1 - INSERT one record
BEGIN TRANSACTION
SELECT * FROM Sale WHERE SaleNumber = 1
SELECT * FROM SaleItem WHERE SaleNumber = 1
INSERT INTO SaleItem (SaleNumber,ItemNumber,Quantity,Price,ExtendedPrice)
VALUES (1,7,1,10,10)
SELECT * FROM Sale WHERE SaleNumber = 1
SELECT * FROM SaleItem WHERE SaleNumber = 1
ROLLBACK TRANSACTION
GO
-- Test trigger TR1 - INSERT multiple records
BEGIN TRANSACTION
SELECT * FROM Sale WHERE SaleNumber = 1
SELECT * FROM SaleItem WHERE SaleNumber = 1
INSERT INTO SaleItem (SaleNumber,ItemNumber,Quantity,Price,ExtendedPrice)
VALUES (1,3,2,2,4),(1,7,1,10,10)
SELECT * FROM Sale WHERE SaleNumber = 1
SELECT * FROM SaleItem WHERE SaleNumber = 1
ROLLBACK TRANSACTION
GO

/*
2. Create a trigger called TR2 that will insert a record into the WageHistory table when a Staff 
Wage changes. Do not insert a WageHistory Record if the Wage value did not change to a 
different value. (3.5 marks)
*/
CREATE TRIGGER TR2
ON Staff FOR UPDATE
AS
	IF @@ROWCOUNT > 0 AND UPDATE(Wage)
		BEGIN
			INSERT INTO WageHistory (StaffID,ChangedDate,OldWage,NewWage)
			SELECT INSERTED.StaffID, GETDATE(), DELETED.Wage, INSERTED.Wage FROM INSERTED
			INNER JOIN DELETED ON INSERTED.StaffID=DELETED.StaffID
		END
RETURN
GO

-- Test Trigger TR2
BEGIN TRANSACTION
SELECT * FROM WageHistory
UPDATE Staff SET Wage = 30 WHERE StaffID=1
SELECT * FROM WageHistory
ROLLBACK TRANSACTION
GO

/*
3. Create a trigger called TR3 that will enforce a rule that Staff cannot join a club if they no 
longer work at Fun Seeker Amusement Park (i.e., staff has a date released). If this rule is 
broken, raise an error and do not allow the staff to join. Staff can be sneaky, ensure there is 
no way this can happen! (4.5 marks)
*/
CREATE TRIGGER TR3
ON ClubMembership FOR INSERT
AS
	IF @@ROWCOUNT > 0
		BEGIN
			IF EXISTS (SELECT 'X' FROM Staff
					INNER JOIN INSERTED ON Staff.StaffID=INSERTED.StaffID
					WHERE Staff.ReleasedDate IS NOT NULL)
				BEGIN
					RAISERROR('Staff cannot join a club if they no longer work at Fun Seeker Amusement Park.',16,1)
					ROLLBACK TRANSACTION
				END
		END
RETURN
GO

-- Test Trigger TR3
BEGIN TRANSACTION
SELECT * FROM Staff WHERE StaffID=6
UPDATE Staff SET ReleasedDate=GETDATE() WHERE StaffID=6
SELECT * FROM Staff WHERE StaffID=6
SELECT * FROM ClubMembership
INSERT INTO ClubMembership (StaffID,ClubCode,DateJoined)
VALUES (6,'JW',GETDATE())
SELECT * FROM ClubMembership
ROLLBACK TRANSACTION
GO

/*
4. No more Areas will be added to the park and only existing Area descriptions can be 
changed. Create a trigger called TR4 that will not allow new Areas to be created or any 
changes to the AreaID or AreaName of existing areas in the Area table. If an attempt is 
made, raise an error, and do not allow the changes to the Area table. (3.5 marks)
*/
CREATE TRIGGER TR4
ON Area FOR INSERT, UPDATE
AS
	IF @@ROWCOUNT > 0
		BEGIN
			IF UPDATE(AreaID) OR UPDATE(AreaName)
				BEGIN
					RAISERROR('You are not allowed to add or make changes to Area ID or Area Name.',16,1)
					ROLLBACK TRANSACTION
				END
		END
RETURN
GO

-- Test Trigger TR4 - INSERT new area
BEGIN TRANSACTION
SELECT * FROM Area
INSERT INTO Area (AreaID,AreaName,AreaDescription)
VALUES ('A500','Test','Test')
SELECT * FROM Area
ROLLBACK TRANSACTION
GO
-- Test Trigger TR4 - UPDATE only description
BEGIN TRANSACTION
SELECT * FROM Area
UPDATE Area SET AreaDescription='Test' WHERE AreaID='A100'
SELECT * FROM Area
ROLLBACK TRANSACTION
GO
-- Test Trigger TR4 - UPDATE Area Name
BEGIN TRANSACTION
SELECT * FROM Area
UPDATE Area SET AreaName='Test' WHERE AreaID='A100'
SELECT * FROM Area
ROLLBACK TRANSACTION
GO