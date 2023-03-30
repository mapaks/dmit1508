/*  Quiz 3
 *  Student Name: Nino Angelo Lumapac
 *  
 *  Place your answers in the places provided
 */
 
USE Quiz3
GO

--Drop Tables
DROP TABLE ClubMembership
DROP TABLE Club
DROP TABLE RideLog
DROP TABLE Task
DROP TABLE Ride
DROP TABLE Area
DROP TABLE Category
DROP TABLE FunseekerMembership
DROP TABLE Membership
DROP TABLE SaleItem
DROP TABLE Item
DROP TABLE Sale
DROP TABLE Funseeker
DROP TABLE Staff
DROP TABLE ArchiveMemberships
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
	LastName				VARCHAR (30)		NOT NULL,
	HireDate				SMALLDATETIME		NOT NULL,
	ReleasedDate			SMALLDATETIME		NULL,
	Phone					CHAR(13)			NOT NULL,
	Wage					SMALLMONEY			NOT NULL
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

CREATE TABLE Club
(
	ClubCode				CHAR(2)				NOT NULL 
												CONSTRAINT PK_Club_ClubCode
													PRIMARY KEY CLUSTERED,
	ClubName				VARCHAR(50)			NOT NULL
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
													Default GETDATE(),
	SubTotal				SMALLMONEY			NOT NULL,
	GST						SMALLMONEY			NOT NULL,
	Total					SMALLMONEY			NOT NULL,
	FunSeekerID				INT					NOT NULL
												CONSTRAINT FK_Sale_SaleNumber_To_FunSeeker_FunSeekerID
													REFERENCES FunSeeker(FunSeekerID)
)

CREATE TABLE SaleItem
(
	SaleNumber				INT					NOT NULL,
	ItemNumber				INT					NOT NULL,
	Quantity				SMALLINT			NOT NULL,
	Price					SMALLMONEY			NOT NULL,
	ExtendedPrice			SMALLMONEY			NOT NULL,
	CONSTRAINT PK_SaleItem_SaleNumber_ItemNumber
		PRIMARY KEY CLUSTERED (SaleNumber, ItemNumber)
)

CREATE TABLE ArchiveMemberships
(
	FunSeekerID				INT					NOT NULL,
	MembershipID			INT					NOT NULL,
	StartDate				DATETIME			NOT NULL,
	EndDate					DATETIME			NOT NULL,
	StaffID					INT					NOT NULL,
	CONSTRAINT PK_ArchiveMemberships_FunseekerID_MembershipID_StartDate
		PRIMARY KEY CLUSTERED (FunseekerID, MembershipID, StartDate)
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
	('SELECT Your Own Adventure', 'Triple loop Coaster', 1, 'A300')
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

INSERT INTO Club
	(ClubCode, ClubName)
VALUES
	('NF', 'Normal Form Club'), 
	('RA', 'Raise Error Debate Club'), 
	('VW', 'View the World Travel Club'), 
	('TH', 'Target Happy Nerf Club'), 
	('JW', 'Join the World Charity Club')
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
	(2, 0.10, 2.10, 3)
INSERT INTO SaleItem
	(SaleNumber, ItemNumber, Quantity, Price, ExtendedPrice)
VALUES
	(3, 5, 1, 2, 2)
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

/* Create the stored procedures here */

-- Drop Procedures
DROP PROCEDURE AddCategory
DROP PROCEDURE ArchiveFunSeekerMemberships
DROP PROCEDURE AddSaleItem
GO

/*
Question 1:
Create a stored procedure called AddCategory to add a new category to the
Category table and select the new CategoryCode. Input parameters will be
CategoryName and MinimumHeight. Raise an error and do not add the new
category if the user provides a CategoryName that is already in the table.
*/
CREATE PROCEDURE AddCategory (@CategoryName VARCHAR(50)=NULL,@MinimumHeight SMALLINT=NULL)
AS
	DECLARE @ErrorCode INT, @RowsAffected INT

	IF @CategoryName IS NULL OR @MinimumHeight IS NULL
		BEGIN
			RAISERROR('You must provide a category name and minimum height',16,1)
		END
	ELSE
		BEGIN
			IF EXISTS (SELECT CategoryName FROM Category WHERE CategoryName=@CategoryName)
				BEGIN
					RAISERROR('The category name already exists!',16,1)
				END
			ELSE
				BEGIN
					INSERT INTO Category (CategoryName,MinimumHeight)
					VALUES (@CategoryName,@MinimumHeight)

					SELECT @ErrorCode=@@ERROR, @RowsAffected=@@ROWCOUNT

					IF @ErrorCode != 0
						BEGIN
							RAISERROR('Insert failed into Category table',16,1)
						END
					ELSE
						BEGIN
							IF @RowsAffected = 0
								BEGIN
									RAISERROR('No row(s) inserted into Category table',16,1)
								END
							ELSE
								BEGIN
									SELECT @@IDENTITY 'New Category Code'
								END
						END 
				END
		END
RETURN
GO

/*
Question 2:
Create a stored procedure called ArchiveFunSeekerMemberships that will move
FunSeekerMembership records that have an EndDate before today’s date to the
ArchiveMemberships table. The ArchiveMemberships Create Table statement in
included the Quiz3.sql script.
*/
CREATE PROCEDURE ArchiveFunSeekerMemberships
AS
	DECLARE @ErrorCode INT, @RowsAffected INT

	BEGIN TRANSACTION
		INSERT INTO ArchiveMemberships (FunSeekerID,MembershipID,StartDate,EndDate,StaffID)
		SELECT FunSeekerID,MembershipID,StartDate,EndDate,StaffID FROM FunSeekerMembership
		WHERE EndDate < GETDATE()

		SELECT @ErrorCode=@@ERROR,@RowsAffected=@@ROWCOUNT
		IF @ErrorCode!=0
			BEGIN
				ROLLBACK TRANSACTION
				RAISERROR('Archive Fun Seeker failed',16,1)
			END
		ELSE
			BEGIN
				DELETE FunSeekerMembership
				WHERE EndDate < GETDATE()

				IF @ErrorCode!=0
					BEGIN
						ROLLBACK TRANSACTION
						RAISERROR('Delete Fun Seeker Membership failed!',16,1)
					END
				ELSE
					IF @RowsAffected=0 
						BEGIN
							ROLLBACK TRANSACTION
							RAISERROR('No row(s) deleted from Fun Seeker Membership table!',16,1)
						END
					ELSE
						BEGIN
							COMMIT TRANSACTION
						END
			END
RETURN
GO

/*
Question 3:
Create a stored procedure called AddSaleItem that accepts SaleNumber, ItemNumber
and Quantity and will do the following:
 * Insert a record into the SaleItem table
 * Update the SubTotal, GST, and Total columns in the Sale table to reflect the
   new SaleItem record
 * Update the FunSeeker Status
 
All parameters, if passed in, will be valid.

The price of a SaleItem record will be the price of that ItemNumber from the
Item table. 

The FunSeeker’s status is based on the total quantity of all items they have
purchased. The status a funseeker can have are “Frugal”, “Big Spender”, and
“Shopping King”.
 * Number of items <2 is "Frugal"
 * Number of items <=2 and <=5 is "Big Spender"
 * Number of items >5 is "Shopping King"
*/
CREATE PROCEDURE AddSaleItem(@SaleNumber INT=NULL,@ItemNumber INT=NULL,@Quantity SMALLINT=NULL)
AS
	DECLARE @ErrorCode INT, @RowsAffected INT

	IF @SaleNumber IS NULL OR @ItemNumber IS NULL OR @Quantity IS NULL
		BEGIN
			RAISERROR('You must provide a Sale Number, Item Number, and Quantity!',16,1)
		END
	ELSE
		DECLARE @Price SMALLMONEY, @ExtendedPrice SMALLMONEY

		SELECT @Price=Price FROM Item WHERE ItemNumber=@ItemNumber
		SET @ExtendedPrice = @Price * @Quantity

		BEGIN TRANSACTION
			BEGIN
				INSERT INTO SaleItem (SaleNumber,ItemNumber,Quantity,Price,ExtendedPrice)
				VALUES (@SaleNumber,@ItemNumber,@Quantity,@Price,@ExtendedPrice)

				SELECT @ErrorCode=@@ERROR, @RowsAffected=@@ROWCOUNT
				IF @ErrorCode!=0 
					BEGIN
						ROLLBACK TRANSACTION
						RAISERROR('Insert into Sale Item failed!',16,1)
					END
				ELSE
					IF @RowsAffected=0
						BEGIN
							ROLLBACK TRANSACTION
							RAISERROR('No row(s) inserted into Sale Item!',16,1)
						END
					ELSE
						-- Update Sale table values
						BEGIN
							-- Declare variables for the current sale values
							DECLARE @CurrentSubTotal SMALLMONEY, @CurrentGST SMALLMONEY, @CurrentTotal SMALLMONEY, @FunSeekerID INT

							-- Get the current subtotal, current gst, current total, and fun seeker id
							SELECT @CurrentSubTotal=SubTotal, @CurrentGST=GST, @CurrentTotal=Total, @FunSeekerID=FunSeekerID FROM Sale
							WHERE SaleNumber=@SaleNumber

							-- Declare variables for the new sale values
							DECLARE @NewSubTotal SMALLMONEY, @NewGST SMALLMONEY, @NewTotal SMALLMONEY

							-- Calculate the new sale values
							SET @NewSubTotal = @CurrentSubTotal + @ExtendedPrice
							SET @NewGST = @CurrentGST + (@ExtendedPrice * 0.05)
							SET @NewTotal = @NewSubTotal + @NewGST

							UPDATE Sale
							SET SubTotal=@NewSubTotal, GST=@NewGST, Total=@NewTotal
							WHERE SaleNumber=@SaleNumber

							SELECT @ErrorCode=@@ERROR, @RowsAffected=@@ROWCOUNT
							IF @ErrorCode!=0 
								BEGIN
									ROLLBACK TRANSACTION
									RAISERROR('Update to Sale table failed!',16,1)
								END 
							ELSE
								BEGIN
									IF @RowsAffected = 0
										BEGIN
											ROLLBACK TRANSACTION
											RAISERROR('No row(s) updated from Sale table!',16,1)
										END
									ELSE
										-- Update Fun Seeker status
										BEGIN
											DECLARE @TotalItemQuantityPurchased INT, @Status VARCHAR(20)

											SELECT @TotalItemQuantityPurchased=ISNULL(SUM(Quantity), 0) FROM SaleItem
											INNER JOIN Sale ON SaleItem.SaleNumber=Sale.SaleNumber
											INNER JOIN FunSeeker ON Sale.FunSeekerID=FunSeeker.FunSeekerID
											WHERE FunSeeker.FunSeekerID=@FunSeekerID

											SET @TotalItemQuantityPurchased = @TotalItemQuantityPurchased + 1

											IF @TotalItemQuantityPurchased < 2
												BEGIN
													SET @Status = 'Frugal'
												END
											ELSE IF @TotalItemQuantityPurchased >= 2 AND @TotalItemQuantityPurchased <= 5
												BEGIN
													SET @Status = 'Big Spender'
												END
											ELSE
												BEGIN
													SET @Status = 'Shopping King'
												END

											UPDATE FunSeeker
											SET Status = @Status
											WHERE FunSeekerID=@FunSeekerID

											SELECT @ErrorCode=@@ERROR, @RowsAffected=@@ROWCOUNT
											IF @ErrorCode!=0 
												BEGIN
													ROLLBACK TRANSACTION
													RAISERROR('Update to Fun Seeker table failed!',16,1)
												END 
											ELSE
												BEGIN
													IF @RowsAffected = 0
														BEGIN
															ROLLBACK TRANSACTION
															RAISERROR('No row(s) updated from Fun Seeker table!',16,1)
														END
													ELSE
														BEGIN
															COMMIT TRANSACTION
														END
												END
										END
								END
						END
			END
RETURN
GO