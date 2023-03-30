USE Quiz2
GO

-- Drop tables
DROP TABLE ClubMembership
DROP TABLE Club
DROP TABLE RideLog
DROP TABLE FunSeekerMembership
DROP TABLE Membership
DROP TABLE FunSeeker
DROP TABLE Staff
DROP TABLE Task
DROP TABLE Ride
DROP TABLE Area
DROP TABLE Category
GO

-- PART A - Constraints
-- Add the following constraints to the existing CREATE TABLE definitions (DO NOT use the alter table statement). 
-- If you are having difficulties executing the insert script with your constraints, comment out your constraint(s) and continue
-- with the rest of the quiz, or consider doing this question last so it does not interfere with the creation of the tables and
-- inserting the test data. (4 marks)

-- Table			Column(s)				Default			Check
-- ClubMembership	DateJoined				Today’s date	
-- Staff			HiredDate, ReleasedDate					ReleasedDate >= HiredDate
-- Staff			Phone									(###)###-####
-- Category			MinimumHeight	 						>= 0

-- # signifies any digit between 0 and 9

-- Create tables
CREATE TABLE Category
(
	CategoryCode			INT	IDENTITY(1,1)	NOT NULL
		CONSTRAINT PK_Category_CategoryCode PRIMARY KEY CLUSTERED,
	CategoryName			VARCHAR(50) 		NOT NULL,
	MinimumHeight			SMALLINT			NOT NULL
		CONSTRAINT CK_Category_MinimumHeight CHECK (MinimumHeight >= 0)
)


CREATE TABLE Area
(
	AreaID					CHAR(4) 			NOT NULL
		CONSTRAINT PK_Area_AreaID PRIMARY KEY CLUSTERED,
	AreaName				VARCHAR(50)			NOT NULL,
	AreaDescription			VARCHAR(150)		NOT NULL
)

CREATE TABLE Ride
(
	RideID					INT	IDENTITY(1,1)	NOT NULL 
		CONSTRAINT PK_Ride_RideID PRIMARY KEY CLUSTERED,
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
		CONSTRAINT PK_Task_TaskID PRIMARY KEY CLUSTERED,
	TaskDescription			VARCHAR(150)		NOT NULL
)

CREATE TABLE Staff
(
	StaffID					INT	IDENTITY(1,1)	NOT NULL 
		CONSTRAINT PK_Staff_StaffID PRIMARY KEY CLUSTERED,
	FirstName				VARCHAR(30)			NOT NULL,
	LastName				VARCHAR (30)		NOT NULL,
	HireDate				SMALLDATETIME		NOT NULL,
	ReleasedDate			SMALLDATETIME		NULL,
	Phone					CHAR(13)			NOT NULL
		CONSTRAINT CK_Staff_Phone CHECK (Phone LIKE '([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
	Wage					SMALLMONEY			NOT NULL,
	CONSTRAINT CK_Staff_HiredDate_ReleasedDate CHECK (ReleasedDate >= HireDate)
)

CREATE TABLE FunSeeker
(
	FunSeekerID				INT	IDENTITY(1,1)	NOT NULL 
		CONSTRAINT PK_FunSeeker_FunSeekerID PRIMARY KEY CLUSTERED,
	FirstName				VARCHAR(30)			NOT NULL,
	LastName				VARCHAR(30)			NOT NULL,
	Address					VARCHAR(30)			NOT NULL,
	City					VARCHAR(30)			NOT NULL,
	Province				CHAR(2)				NOT NULL,
	PostalCode				CHAR(6)				NOT NULL
)

CREATE TABLE Membership
(
	MembershipID			INT	IDENTITY(1,1)	NOT NULL 
		CONSTRAINT PK_Membership_MembershipID PRIMARY KEY CLUSTERED,
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
	CONSTRAINT PK_RideLog_RideID_LogNumber PRIMARY KEY CLUSTERED (RideID, LogNumber)
)

CREATE TABLE Club
(
	ClubCode				CHAR(2)				NOT NULL 
		CONSTRAINT PK_Club_ClubCode PRIMARY KEY CLUSTERED,
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
	DateJoined				SMALLDATETIME		NOT NULL
		CONSTRAINT DF_ClubMembership_DateJoined DEFAULT GETDATE(),
	CONSTRAINT PK_ClubMembership_StaffID_ClubCode PRIMARY KEY CLUSTERED (StaffID, ClubCode)
)
GO

-- Insert test data
INSERT INTO Category (CategoryName, MinimumHeight) VALUES 
	('Little Riders', 36), 
	('Teen', 48), 
	('Adult', 60), 
	('Everyone', 0)
GO

INSERT INTO Area (AreaID, AreaName, AreaDescription) VALUES 
	('A100', 'Scary Zone', 'Rides sure to scare you!'), 
	('A200', 'Wild Zone', 'Wild rides!'), 
	('A300', 'Fun Zone', 'All about fun!'), 
	('A500', 'Wet Zone', 'Who wants to get wet?'), 
	('A400', 'Adventure Zone', 'Let''s GO on an adventure!'), 
	('A000', 'New Area', 'No Description Yet')
GO

INSERT INTO Ride (RideName, RideDescription, CategoryCode, AreaID) VALUES
	('Normalization Drop', 'Triple loop coaster', 2, 'A100'), 
	('Table Turner', 'Spinning ables', 1, 'A200'), 
	('Dizzy DML Dive', 'Super circular dive', 1, 'A100'), 
	('Stored Procedure Mystery Cavern', 'Mystery around every corner', 1, 'A200'), 
	('View or View not', 'Laszer tag', 1, 'A100'), 
	('Group by Garage', 'Car racing', 1, 'A200'), 
	('DataType Drop', 'How far will you drop?', 1, 'A300'), 
	('Alter Reality', 'Virtual reality', 1, 'A200'), 
	('Select Your Own Adventure', 'Interactive adventure', 1, 'A300')
GO

INSERT INTO Task (TaskDescription) VALUES
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
INSERT INTO Staff (FirstName, LastName, HireDate, ReleasedDate, Phone, Wage) VALUES
	('Jason', 'Normalform', 'Jan 1 2020', NULL, '(780)555-1234', 25), 
	('Susie', 'Orderby', 'Aug 6 2021', NULL, '(780)555-2345', 23), 
	('Sally', 'Having', 'Jun 24 2021', NULL, '(780)555-3456', 22), 
	('Jerry', 'Joins', 'Sep 2 2020', NULL, '(780)555-4567', 28), 
	('Ali', 'Alias', 'Sep 18 2021', NULL, '(780)555-5678', 21), 
	('Victoria', 'Viewster', 'Jan 20 2018', NULL, '(780)555-6789', 22)
GO

INSERT INTO RideLog (RideID, LogNumber, DateCompleted, Notes, TaskID, StaffID) VALUES
	(8, 1, 'Apr 15 2020', 'No notes', 1, 1), 
	(9, 1, 'Jun 2 2020', 'No notes', 2, 1), 
	(1, 1, 'Jun 1 2021', 'No notes', 4, 1), 
	(1, 2, 'Jun 18 2021', 'No notes', 3, 1), 
	(5, 1, 'Jul 3 2021', 'No notes', 3, 1), 
	(6, 1, 'Sep 5 2021', 'No notes', 5, 1), 
	(8, 2, 'Jun 1 2021', 'No notes', 4, 1), 
	(9, 2, 'Jan 1 2022', 'No notes', 4, 1)
GO

INSERT INTO Club (ClubCode, ClubName) VALUES
	('NF', 'Normal Form Club'), 
	('RA', 'Raise Error Debate Club'), 
	('VW', 'View the World Travel Club'), 
	('TH', 'Target Happy Nerf Club'), 
	('JW', 'Join the World Charity Club')
GO
INSERT INTO ClubMembership (StaffID, ClubCode, DateJoined) VALUES
	(1, 'NF', 'Jan 1 2022'), 
	(1, 'JW', 'Feb 1 2022'), 
	(2, 'NF', 'Jan 1 2022'), 
	(3, 'NF', 'Jan 1 2022'), 
	(3, 'TH', 'Mar 1 2022'), 
	(4, 'NF', 'Jan 1 2022'), 
	(3, 'JW', 'Feb 1 2022')
GO

INSERT INTO FunSeeker (Firstname, LastName, Address, City, Province, PostalCode) VALUES
	('Sheldon', 'Cooper', '101 Geek Street', 'Edmonton', 'AB', 'T8E1J3'), 
	('Leonard', 'Hofstader', '101 Geek Street', 'Edmonton', 'AB', 'T8E1J3'), 
	('Howard', 'Wolowitz', '23 Astronaut Avenue', 'Edmonton', 'AB', 'T8A1J4'), 
	('Stuart', 'Bloom', '101 Geek Street', 'Edmonton', 'AB', 'T8E1H3'), 
	('Barry', 'Kripke', '101 Geek Street', 'Edmonton', 'AB', 'T8E1J3'), 
	('Amy', 'Farah Fowler', '101 Geek Street', 'Edmonton', 'AB', 'T8f1J3'), 
	('Raj', 'Koothrappali', '101 Geek Street', 'Edmonton', 'AB', 'T8A1J3'), 
	('Leslie', 'Winkle', '101 Geek Street', 'Edmonton', 'AB', 'T8L1J3'), 
	('Bert', 'Kibbler', '101 Geek Street', 'Edmonton', 'AB', 'T8L1J3')
GO

INSERT INTO Membership (MembershipName, MembershipDescription, Cost) VALUES
	('Monthly Ride A Lot', 'One month ride all day pass', 50), 
	('Yearly Ride A Lot', 'One year ride all day pass', 500), 
	('Senior Monthly Ride A Lot', 'One month day senior ride all day pass', 20), 
	('Student Monthly Ride A Lot', 'One month day student ride all day pass', 25)
GO
INSERT INTO FunSeekerMembership (FunSeekerID, MembershipID, StartDate, EndDate, StaffID) VALUES
	(1, 1, 'Dec 1 2011', 'Dec 31 2011', 1), 
	(1, 1, 'Jan 1 2021', 'Jan 31 2021', 1), 
	(2, 1, 'Jan 1 2022', 'Jan 31 2022', 2), 
	(4, 1, 'Jan 1 2022', 'Jan 31 2022', 2),
	(5, 1, 'Feb 1 2022', 'Feb 28 2022', 3),
	(6, 1, 'Mar 1 2022', 'Mar 31 2022', 4),
	(1, 1, 'Feb 1 2022', 'Feb 28 2022', 5), 
	(3, 1, 'Jan 1 2022', 'Jan 31 2022', 6)
GO

-- PART B - Indexes

-- Create non clustered indexes on the foreign keys in the Ride and RideLog Tables. (1 mark)
-- Ride Table
CREATE NONCLUSTERED INDEX IX_Ride_CategoryCode
	ON Ride(CategoryCode)
CREATE NONCLUSTERED INDEX IX_Ride_AreaID
	ON Ride(AreaID)

-- RideLog Table
CREATE NONCLUSTERED INDEX IX_RideLog_RideID
	ON RideLog(RideID)
CREATE NONCLUSTERED INDEX IX_RideLog_LogNumber
	ON RideLog(LogNumber)
CREATE NONCLUSTERED INDEX IX_RideLog_TaskID
	ON RideLog(TaskID)
CREATE NONCLUSTERED INDEX IX_RideLog_StaffID
	ON RideLog(StaffID)
GO

-- PART C – Alter Table

-- Assuming the tables have data in them already, use the alter table statement to place a default of 0 for
-- MinimumHeight in the Category table. (1 mark)
ALTER TABLE Category
	ADD CONSTRAINT DF_Category_MinimumHeight DEFAULT 0 FOR MinimumHeight
GO

-- PART D - Queries
-- Use only the information you are given, do not hard-code values unless given.
-- Write the following queries:

-- 1. Select the names of the clubs that have more than 2 members. (3 marks)
SELECT ClubName FROM Club
INNER JOIN ClubMembership ON Club.ClubCode=ClubMembership.ClubCode
GROUP BY ClubName
HAVING COUNT(*) > 2

-- 2. Select all the AreaIDs, Area names, Ride names, and Ride Descriptions for all Areas. (2 marks)
SELECT Area.AreaID, AreaName, RideName, RideDescription FROM Area
LEFT JOIN Ride ON Area.AreaID=Ride.AreaID

-- 3. How many Fun Seeker memberships are sold from each area? An area is different if the first three characters of their
--    postal code are different. For example, postal codes starting with 'F3F' are one area, 'F3S' are another, and so on.
--    Select the first three characters of the postal code of all areas and the number of Fun Seeker memberships sold from
--    that area. (3 marks)
SELECT SUBSTRING(PostalCode, 1, 3) 'First three characters of the postal code', COUNT(*) 'Number of Fun Seeker memberships sold' FROM FunSeeker
INNER JOIN FunSeekerMembership ON FunSeeker.FunSeekerID=FunSeekerMembership.FunSeekerID
GROUP BY PostalCode

-- 4. Select the club names that have no staff in them. Do not use a join. (2 marks)
SELECT ClubName FROM Club
WHERE ClubCode NOT IN (SELECT ClubCode FROM ClubMembership)

-- 5. For no particular reason 😊, create a single list that contains the full names (one column in the format "LastName,
--    FirstName") of all the staff and all the Fun Seekers. List the names in alphabetical order by LastName. (2 marks)
SELECT LastName + ', ' + FirstName 'Full Name'
FROM Staff
UNION ALL
SELECT LastName + ', ' + FirstName
FROM FunSeeker
ORDER BY 'Full Name'
GO

--PART E - DML

-- 1. To promote job/recreation balance, staff that belong to more than 1 club will have $1.00 added to their wage.
--    Update all the employees’ wages (that meet this criteria) to reward them for joining clubs. (3 marks) 
UPDATE Staff
SET Wage = Wage + 1
WHERE StaffID IN (SELECT StaffID FROM ClubMembership GROUP BY StaffID HAVING COUNT(*) > 1)
GO

-- 2. Delete all the Fun Seeker Memberships that are more than 10 years old (3 marks)
DELETE FROM FunSeekerMembership
WHERE DATEDIFF(YY, EndDate, GETDATE()) > 10
GO

--PART F - Views

-- 1. Create a view called TaskHistory that selects all the TaskID, TaskDescription, RideDescription, LogNumber,
--    and Notes. (2 marks)
CREATE VIEW TaskHistory
AS
SELECT Task.TaskID, TaskDescription, RideDescription, LogNumber, Notes FROM Task
INNER JOIN RideLog ON Task.TaskID=RideLog.TaskID
INNER JOIN Ride ON RideLog.RideID=Ride.RideID
GO

-- 2. Using the TaskHistory view select the TaskID, TaskDescription, RideDescription, LogNumber, Notes for TaskID 4.
--    (2 marks)
SELECT TaskID, TaskDescription, RideDescription, LogNumber, Notes FROM TaskHistory
WHERE TaskID = 4