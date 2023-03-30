-- Insert Test Data

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
	('Jan 1 2021', 'Jan 3 2021', 'Customer Retention'), 
	('Jan 20 2021', 'Jan 25 2021', 'Sales For Dummies'), 
	('Jan 25 2021', 'Jan 26 2021', 'How To Sell')
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
	('Homer', 'Simpson', '742 Evergreen Terrace', 'Springfield', 'AB', 'T9S9L1', '1-555-234-5678', 'I', 'A110'), 
	('Luke', 'Skywalker', '800 The Resistance Drive', 'Alderaan', 'BC', 'V1D1D1', '1-555-000-0000', 'B', 'A115'), 
	('Sue', 'Sampson', '443 Somewhere Street', 'MooseJaw', 'SK', 'M4L1D2', '1-111-222-3333', 'I', 'A120')
GO

INSERT INTO Staff
	(StaffID, FirstName, LastName, Active, wage, StaffTypeID)
VALUES
	('111111', 'Bob', 'Marley', 'Y', 20, 1), 
	('222222', 'Elvis', 'Presley', 'Y', 15, 2), 
	('333333', 'Patti', 'Page', 'Y', 25, 3), 
	('444444', 'Doris', 'Day', 'Y', 15, 1), 
	('555555', 'Buddy', 'Holly', 'Y', 18, 1), 
	('666666', 'Faith', 'Hill', 'Y', 15, 1), 
	('777777', 'Chuck', 'Barry', 'Y', 25, 1), 
	('888888', 'Harry', 'Bellafonte', 'Y', 19, 1)
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
	('Dec 3 2020', 3.00, 0.15, 3.15, 0, 1, 111111)
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
	('Dec 20 2020', 103.00, 5.15, 108.15, 0, 1, 111111)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(2, 1, 'Nissan King Cab Truck', 5000, 4000, 'VHC'), 
	(2, 2, 'Stamp Collection', 100, 90, 'COL')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('Feb 5 2021', 5.00, 0.25, 5.25, 0, 1, 111111)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(3, 1, 'Fur Coat', 5000, 4000, 'CLO'), 
	(3, 2, 'Gold Ring', 100, 90, 'VAL')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('Feb 6 2021', 5.50, 0.28, 5.78, 0, 1, 444444)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(4, 1, 'FootBall', 10, 8, 'SPT'), 
	(4, 2, 'Signed Wayne Gretzky Jersey', 500, 400, 'SPT'), 
	(4, 3, 'Cooking With Yan', 5, 4, 'BKS'), 
	(4, 4, 'Diamond Necklace', 1000, 900, 'VAL')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('March 3 2021', 102, 4.59, 106.59, 10.2, 2, 555555)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(5, 1, 'Dash Cam', 100, 90, 'ELT'), 
	(5, 2, 'Ford Truck', 2000, 1900, 'VHC')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('April 7 2021', 6.00, 0.27, 6.27, 0.60, 2, 666666)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(6, 1, '32" TV', 100, 80, 'ELT'), 
	(6, 2, 'Pencil Sharpener', 5, 4, 'HLD'), 
	(6, 3, 'Lawn Mower', 150, 140, 'HLD'), 
	(6, 4, 'Camera', 50, 40, 'ELT')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('April 8 2021', 2.00, 0.09, 1.79, 0.30, 3, 555555)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(7, 1, 'Bed Frame', 50, 40, 'HLD'), 
	(7, 2, 'Soccer Ball', 10, 8, 'SPT')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('July 21 2021', 4.00, 0.17, 3.57, 0.60 , 3, 444444)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(8, 1, 'Lamp', 10, 8, 'HLD'), 
	(8, 2, 'Printer', 80, 70, 'ELT'), 
	(8, 3, 'Bookcase', 20, 18, 'HLD')
GO

INSERT INTO Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
VALUES
	('August 5 2021', 4.50, 0.18, 3.78, 0.90, 4, 111111)
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
	('Sep 25 2021', 6.5, 0.33, 6.83, 0, 1, 444444)
INSERT INTO ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
VALUES 
	(10, 1, 'IPhone', 500, 400, 'ELT'), 
	(10, 2, 'Baseball Shoes', 15, 12, 'SPT'), 
	(10, 3, 'How To Play Checkers', 5, 4, 'BKS'), 
	(10, 4, 'Gold Crown', 10000, 9000, 'VAL')
GO