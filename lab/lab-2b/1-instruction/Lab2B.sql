USE Lab2B	-- or whatever you named your database
GO

DROP TABLE ConsignmentDetails
DROP TABLE Consignment
DROP TABLE StaffTraining
DROP TABLE Staff
DROP TABLE Customer
DROP TABLE Category
DROP TABLE StaffType
DROP TABLE Training
DROP TABLE Reward
DROP TABLE CustomerType
GO

CREATE TABLE CustomerType
(
	CustomerTypeID 			CHAR(1) 		NOT NULL 
											CONSTRAINT PK_CustomerType_CustomerTypeID
												PRIMARY KEY CLUSTERED,
	CustomerTypeDescription VARCHAR(30)		NOT NULL
)

CREATE TABLE Reward
(
	RewardID 				CHAR(4)			NOT NULL 
											CONSTRAINT PK_Reward_RewardID
												PRIMARY KEY CLUSTERED,
	RewardDescription		VARCHAR(30) 	NULL,
	DiscountPercentage		TINYINT			NOT NULL
)

CREATE TABLE Training
(
	TrainingID				INT				IDENTITY(1,1)
											NOT NULL 
											CONSTRAINT PK_Training_TrainingID
												PRIMARY KEY CLUSTERED,
	StartDate				SMALLDATETIME	NOT NULL,
	EndDate					SMALLDATETIME	NOT NULL, 
	TrainingDescription		VARCHAR(70)		NOT NULL,
	CONSTRAINT CK_Training_EndDate_GreaterThan_StartDate
		CHECK (EndDate > StartDate)
)

CREATE TABLE StaffType
(
	StaffTypeID				smallint		IDENTITY(1,1)
											NOT NULL 
											CONSTRAINT PK_StaffType_StaffTypeID
												PRIMARY KEY CLUSTERED,
	StaffTypeDescription	VARCHAR(30)		NOT NULL	
)

CREATE TABLE Category
(
	CategoryCode			CHAR(3)			NOT NULL 
											CONSTRAINT PK_Category_CategoryCode
												PRIMARY KEY CLUSTERED,
	CategoryDescription		VARCHAR(50)		NOT NULL,
	Cost					SMALLMONEY		NOT NULL 
											CONSTRAINT CK_Category_Cost_GreaterOrEqualToZero
												CHECK (Cost >= 0 )
	
)

CREATE TABLE Customer
(
	CustomerID				INT				IDENTITY(1,1)
											NOT NULL 
											CONSTRAINT PK_Customer_CustomerID
												PRIMARY KEY CLUSTERED,
	FirstName				VARCHAR(30)		NOT NULL,
	LastName				VARCHAR(30)		NOT NULL,
	StreetAddress			VARCHAR(30)		NULL,
	City					VARCHAR(20)		NULL,
	Province				CHAR(2)			NULL 
											CONSTRAINT CK_Customer_Province_TwoCharacters
												CHECK (Province LIKE '[A-Z][A-Z]')
											CONSTRAINT df_Province
												DEFAULT 'AB',
	PostalCode				CHAR(6)			NULL 
											CONSTRAINT CK_Customer_PostalCode_Z9Z9Z9
												CHECK (PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'),
	Phone					CHAR(14)		NULL 
											CONSTRAINT CK_Customer_Phone_FullFormat
												CHECK (Phone LIKE '[0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
	CustomerTypeID			CHAR(1)			NOT NULL 
											CONSTRAINT FK_CustomerToCustomerType
												REFERENCES CustomerType(CustomerTypeID),
	RewardID				CHAR(4)			NOT NULL
											CONSTRAINT FK_CustomerToReward
												REFERENCES Reward(RewardID)
)

CREATE TABLE Staff
(
	StaffID					CHAR(6)			NOT NULL 
											CONSTRAINT PK_Staff_StaffID
												PRIMARY KEY CLUSTERED,
	FirstName				VARCHAR(30)		NOT NULL,
	LastName				VARCHAR(30)		NOT NULL,
	Active					CHAR(1)			NOT NULL,
	Wage					SMALLMONEY		NOT NULL,
	StaffTypeID				smallint		NOT NULL 
											CONSTRAINT FK_StaffToStaffType
												REFERENCES StaffType(StaffTypeID)
)

CREATE TABLE StaffTraining
(
	StaffID					CHAR(6)			NOT NULL 
											CONSTRAINT FK_StaffTrainingToStaff
												REFERENCES Staff(StaffID),
	TrainingID				INT				NOT NULL 
											CONSTRAINT FK_StaffTrainingToTraining
												REFERENCES Training(TrainingID),
	PassOrFail				CHAR(1)			NULL,
	CONSTRAINT PK_StaffTraining_StaffID_TrainingID
		PRIMARY KEY CLUSTERED (StaffID, TrainingID)
)

CREATE TABLE Consignment
(
	ConsignmentID			INT				IDENTITY(1,1)
											NOT NULL 
											CONSTRAINT PK_Consignment_ConsignmentID
												PRIMARY KEY CLUSTERED,
	Date					DATETIME		NOT NULL,
	Subtotal				SMALLMONEY		NOT NULL,
	GST						SMALLMONEY		NOT NULL,
	Total					SMALLMONEY		NOT NULL,
	RewardsDiscount			DECIMAL(9,2)	NOT NULL,
	CustomerID				INT				NOT NULL 
											CONSTRAINT FK_ConsignmentToCustomer
												REFERENCES Customer(CustomerID),
	StaffID					CHAR(6)			NOT NULL 
											CONSTRAINT FK_ConsignmentToStaff
												REFERENCES Staff(StaffID)
)

CREATE TABLE ConsignmentDetails
(
	ConsignmentID			INT				NOT NULL 
											CONSTRAINT FK_ConsignmentDetailsToConsignment
												REFERENCES Consignment(ConsignmentID),
	LineID					INT				NOT NULL,
	ItemDescription			VARCHAR(40)		NOT NULL,
	StartPrice				SMALLMONEY		NOT NULL,
	LowestPrice				SMALLMONEY		NOT NULL,
	CategoryCode			CHAR(3)			NOT NULL 
											CONSTRAINT FK_ConsignmentDetailsToCategory
												REFERENCES Category(CategoryCode),
	CONSTRAINT PK_ConsignmentDetails_ConsignmentID_LineID
		PRIMARY KEY CLUSTERED (ConsignmentID, LineID)
)
GO

--Insert Data
INSERT INTO CustomerType
	(CustomerTypeID, CustomerTypeDescription)
VALUES
	('B', 'Business Client'), 
	('I', 'Individual'), 
	('N', 'Non Profit')
GO

INSERT INTO Reward
	(RewardID, RewardDescription, DiscountPercentage)
VALUES
	('A000', 'No Reward', 0), 
	('A120', 'Exclusive Customer', 20), 
	('A115', 'Preferred Customer', 15), 
	('A110', 'Exclusive', 10)
GO

INSERT INTO Training
	(StartDate, EndDate, TrainingDescription)
VALUES
	('Jan 1 2022', 'Jan 3 2022', 'Customer Retention'), 
	('Jan 20 2022', 'Jan 25 2022', 'Sales For Dummies'), 
	('Jan 25 2022', 'Jan 26 2022', 'How To Sell')
GO

INSERT INTO StaffType
	(StaffTypeDescription)
VALUES
	('Sales'), 
	('Promotion'), 
	('Human Resources'), 
	('Payroll')
GO

INSERT INTO Category
	(CategoryCode, CategoryDescription, Cost)
VALUES
	('ELT', 'Electronics', 2), 
	('VAL', 'Valuables', 3), 
	('SPT', 'Sports', 1), 
	('BKS', 'Books', 0.5), 
	('COL', 'Collectables', 3), 
	('CLO', 'Clothing', 2), 
	('VHC', 'Vehicles', 100), 
	('HLD', 'Household', 1)
GO

INSERT INTO Customer
	(FirstName, LastName, StreetAddress, City, Province, PostalCode, Phone, CustomerTypeID, RewardID)
VALUES
	('Fred', 'Flinstone', '1234 Boulder Street', 'Bedrock City', 'AB', 'T9E1H1', '1-555-123-4567', 'I', 'A000'), 
	('Susan', 'Sampson', '742 Evergreen Terrace', 'Springfield', 'AB', 'T9S9L1', '1-555-234-5678', 'I', 'A110'), 
	('Luke', 'Skywalker', '800 The Resistance Drive', 'Alderaan', 'BC', 'D1D1D1', '1-555-000-0000', 'B', 'A115'), 
	('Ariana', 'Grande', '443 Somewhere Street', 'MooseJaw', 'SK', 'M4L1D2', '1-111-222-3333', 'I', 'A120')
GO

INSERT INTO Staff
	(StaffID, FirstName, LastName, Active, Wage, StaffTypeID)
VALUES
	('111111', 'Bob', 'Marley', 'Y', 20, 1), 
	('222222', 'Elvis', 'Presley', 'Y', 15, 2), 
	('333333', 'Tina', 'Turner', 'Y', 25, 3), 
	('444444', 'Joan', 'Jett', 'Y', 35, 1), 
	('555555', 'Buddy', 'Holly', 'Y', 18, 1), 
	('666666', 'Aretha', 'Franklin', 'Y', 35, 1), 
	('777777', 'Chuck', 'Barry', 'Y', 25, 2), 
	('888888', 'Stevie', 'Nicks', 'Y', 22, 2)
GO

INSERT INTO StaffTraining
	(StaffID, TrainingID, PassOrFail)
VALUES
	('111111', 1, 'P'), 
	('111111', 2, 'P'), 
	('222222', 3, 'P'), 
	('333333', 2, 'F'), 
	('222222', 2, 'P')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('May 07 2021', 3.00, 0.15, 3.15, 0, 1, 111111)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(1, 1, 'Stephen King Collection', 20, 15, 'BKS'), 
	(1, 2, 'Cooking for Dummies', 5, 4, 'BKS'), 
	(1, 3, 'PlayStation 2', 50, 40, 'ELT')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('May 24 2021', 103.00, 5.15, 108.15, 0, 1, 111111)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(2, 1, 'Nissan King Cab Truck', 5000, 4000, 'VHC'), 
	(2, 2, 'Stamp Collection', 100, 90, 'COL')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('Jul 10 2021', 5.00, 0.25, 5.25, 0, 1, 111111)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(3, 1, 'Fur Coat', 5000, 4000, 'CLO'), 
	(3, 2, 'Gold Ring', 100, 90, 'VAL')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('Jul 11 2021', 5.50, 0.28, 5.78, 0, 1, 444444)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(4, 1, 'FootBall', 10, 8, 'SPT'), 
	(4, 2, 'Signed Bobby Orr Jersey', 500, 400, 'SPT'), 
	(4, 3, 'Cooking With Yan', 5, 4, 'BKS'), 
	(4, 4, 'Diamond Necklace', 1000, 900, 'VAL')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('Aug 06 2021', 102, 4.59, 106.59, 10.2, 2, 555555)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(5, 1, 'Dash Cam', 100, 90, 'ELT'), 
	(5, 2, 'GMC Truck', 2000, 1900, 'VHC')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('Sep 10 2021', 6.00, 0.27, 6.27, 0.60, 2, 666666)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(6, 1, '55" TV', 100, 80, 'ELT'), 
	(6, 2, 'Pencil Sharpener', 5, 4, 'HLD'), 
	(6, 3, 'Lawn Mower', 150, 140, 'HLD'), 
	(6, 4, 'Camera', 50, 40, 'ELT')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('Sep 11 2021', 2.00, 0.09, 1.79, 0.30, 3, 555555)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(7, 1, 'Bed Frame', 50, 40, 'HLD'), 
	(7, 2, 'Soccer Ball', 10, 8, 'SPT')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('Dec 24 2021', 4.00, 0.17, 3.57, 0.60 , 3, 444444)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(8, 1, 'Lamp', 10, 8, 'HLD'), 
	(8, 2, 'Scanner', 80, 70, 'ELT'), 
	(8, 3, 'Bookcase', 20, 18, 'HLD')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('Jan 08 2022', 4.50, 0.18, 3.78, 0.90, 4, 111111)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(9, 1, 'Couch', 50, 48, 'HLD'), 
	(9, 2, 'Plate Collection', 100, 90, 'COL'), 
	(9, 3, 'SQL For Dummies', 5, 4, 'BKS')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('Feb 28 2022', 6.5, 0.33, 6.83, 0, 1, 444444)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(10, 1, 'IPhone', 500, 400, 'ELT'), 
	(10, 2, 'Basketball Shoes', 15, 12, 'SPT'), 
	(10, 3, 'How To Play Chess', 5, 4, 'BKS'), 
	(10, 4, 'Gold Crown', 10000, 9000, 'VAL')
GO