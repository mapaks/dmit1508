/* Short Discussion About The Lab
 *
 * What you liked/disliked about the lab?
 * ~ I liked the lab because it taught us how to create and alter tables and create indexes for the tables.
 *
 * How long it took you to complete the lab?
 * ~ It took me more or less 2 hours to complete the lab.
 *
 * How prepared you felt you were for the lab?
 * ~ I’m confident in answering the lab because we had done a few exercises before the lab activity.
 *
 * Recommendations for future labs (if any).
 * ~ I have no recommendations for future labs. However, I’m okay with the current lab setting.
 */

--- --- --- 0. Drop Tables --- --- ---
DROP TABLE ConsignmentDetails
DROP TABLE Consignment
DROP TABLE StaffTraining
DROP TABLE Staff
DROP TABLE Customer
DROP TABLE Category
DROP TABLE StaffType
DROP TABLE Training
DROP TABLE CustomerType
DROP TABLE Reward
GO

--- --- --- 1. Create Tables --- --- ---
CREATE TABLE Reward (
	RewardID CHAR(4) NOT NULL
		CONSTRAINT PK_Reward_RewardID PRIMARY KEY CLUSTERED,
	RewardDescription VARCHAR(30) NULL,
	DiscountPercentage TINYINT NOT NULL
)

CREATE TABLE CustomerType (
	CustomerTypeID CHAR(1) NOT NULL
		CONSTRAINT PK_CustomerType_CustomerTypeID PRIMARY KEY CLUSTERED,
	CustomerTypeDescription  VARCHAR(30) NOT NULL
)

CREATE TABLE Training (
	TrainingID INT IDENTITY(1,1) NOT NULL
		CONSTRAINT PK_Training_TrainingID PRIMARY KEY CLUSTERED,
	StartDate SMALLDATETIME NOT NULL,
	EndDate SMALLDATETIME NOT NULL,
	TrainingDescription VARCHAR(70) NOT NULL,
	CONSTRAINT CK_Training_EndDate CHECK (EndDate > StartDate)
)

CREATE TABLE StaffType (
	StaffTypeID SMALLINT IDENTITY(1,1) NOT NULL
		CONSTRAINT PK_StaffType_StaffTypeID PRIMARY KEY CLUSTERED,
	StaffTypeDescription VARCHAR(30) NOT NULL
)

CREATE TABLE Category (
	CategoryCode CHAR(3) NOT NULL
		CONSTRAINT PK_Category_CategoryCode PRIMARY KEY CLUSTERED,
	CategoryDescription VARCHAR(50) NOT NULL,
	Cost SMALLMONEY NOT NULL
		CONSTRAINT CK_Category_Cost CHECK (Cost >= 0)
)

CREATE TABLE Customer (
	CustomerID INT IDENTITY(1,1) NOT NULL
		CONSTRAINT PK_Customer_CustomerID PRIMARY KEY CLUSTERED,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	StreetAddress VARCHAR(30) NULL,
	City VARCHAR(20) NULL,
	Province CHAR(2) NULL
		CONSTRAINT CK_Customer_Province CHECK (Province LIKE '[A-Z][A-Z]')
		CONSTRAINT DF_Customer_Province DEFAULT 'AB',
	PostalCode CHAR(6) NULL
		CONSTRAINT CK_Customer_PostalCode CHECK (PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'),
	Phone CHAR(14) NULL
		CONSTRAINT CK_Customer_Phone CHECK (Phone LIKE '[0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
	RewardID CHAR(4) NOT NULL
		CONSTRAINT FK_Customer_RewardID FOREIGN KEY REFERENCES Reward(RewardID),
	CustomerTypeID CHAR(1) NOT NULL
		CONSTRAINT FK_Customer_CustomerTypeID FOREIGN KEY REFERENCES CustomerType(CustomerTypeID)
)

CREATE TABLE Staff (
	StaffID CHAR(6) NOT NULL
		CONSTRAINT PK_Staff_StaffID PRIMARY KEY CLUSTERED,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Active CHAR(1) NOT NULL,
	Wage SMALLMONEY NOT NULL,
	StaffTypeID SMALLINT NOT NULL
		CONSTRAINT FK_Staff_StaffTypeID FOREIGN KEY REFERENCES StaffType(StaffTypeID)
)

CREATE TABLE StaffTraining (
	TrainingID INT NOT NULL
		CONSTRAINT FK_StaffTraining_TrainingID FOREIGN KEY REFERENCES Training(TrainingID),
	StaffID CHAR(6)
		CONSTRAINT FK_StaffTraining_StaffID FOREIGN KEY REFERENCES Staff(StaffID),
	PassOrFail CHAR(1),
	CONSTRAINT PK_StaffTraining_TrainingID_StaffID PRIMARY KEY CLUSTERED (TrainingID, StaffID)
)

CREATE TABLE Consignment (
	ConsignmentID INT IDENTITY(1,1) NOT NULL
		CONSTRAINT PK_Consignment_ConsignmentID PRIMARY KEY CLUSTERED,
	Date DATETIME NOT NULL,
	Subtotal SMALLMONEY NOT NULL,
	GST SMALLMONEY NOT NULL,
	Total SMALLMONEY NOT NULL,
	RewardsDiscount DECIMAL(9,2) NOT NULL,
	CustomerID INT
		CONSTRAINT FK_Consignment_CustomerID FOREIGN KEY REFERENCES Customer(CustomerID),
	StaffID CHAR(6) NOT NULL
		CONSTRAINT FK_Consignment_StaffID FOREIGN KEY REFERENCES Staff(StaffID)
)

CREATE TABLE ConsignmentDetails (
	ConsignmentID INT NOT NULL
		CONSTRAINT FK_ConsignmentDetails_ConsignmentID FOREIGN KEY REFERENCES Consignment(ConsignmentID),
	LineID INT NOT NULL,
	ItemDescription VARCHAR(40) NOT NULL,
	StartPrice SMALLMONEY NOT NULL,
	LowestPrice SMALLMONEY NOT NULL,
	CategoryCode CHAR(3) NOT NULL
		CONSTRAINT FK_ConsignmentDetails_CategoryCode FOREIGN KEY REFERENCES Category(CategoryCode),
	CONSTRAINT PK_ConsignmentDetails_ConsignmentID_LineID PRIMARY KEY CLUSTERED (ConsignmentID, LineID)
)
GO

--- --- --- 2. Alter Tables --- --- ---
--- 2.a Customer Table
ALTER TABLE Customer
	ADD Email VARCHAR(30) NULL
	CONSTRAINT CK_Customer_Email CHECK (Email LIKE '%___@___%.__%')

--- 2.b Staff Table
ALTER TABLE Staff
	ADD CONSTRAINT DF_Staff_Active DEFAULT 'Y' FOR Active
GO

--- --- --- 3. Create Indexes --- --- ---
CREATE NONCLUSTERED INDEX IX_Customer_RewardID ON Customer(RewardID)
CREATE NONCLUSTERED INDEX IX_Customer_CustomerTypeID ON Customer(CustomerTypeID)
CREATE NONCLUSTERED INDEX IX_Staff_StaffTypeID ON Staff(StaffTypeID)
CREATE NONCLUSTERED INDEX IX_StaffTraining_TrainingID ON StaffTraining(TrainingID)
CREATE NONCLUSTERED INDEX IX_StaffTraining_StaffID ON StaffTraining(StaffID)
CREATE NONCLUSTERED INDEX IX_Consignment_CustomerID ON Consignment(CustomerID)
CREATE NONCLUSTERED INDEX IX_Consignment_StaffID ON Consignment(StaffID)
CREATE NONCLUSTERED INDEX IX_ConsignmentDetails_ConsignmentID ON ConsignmentDetails(ConsignmentID)
CREATE NONCLUSTERED INDEX IX_ConsignmentDetails_CategoryCode ON ConsignmentDetails(CategoryCode)
GO