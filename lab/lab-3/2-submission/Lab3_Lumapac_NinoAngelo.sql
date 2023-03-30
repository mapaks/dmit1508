/*	Short Discussion:
•	What you liked/disliked about the lab?
~I liked the lab because it practiced us to perform the objectives of the lab.
•	How long it took you to complete the lab?
~It took me three to four hours to complete the lab.
•	How prepared you felt you were for the lab?
~I felt confident answering the lab because we have practiced few different exercise examples.
•	If there are any known errors in your solution, please identify them in your 
discussion. Errors you have identified and simply could not find a solution for are 
more acceptable than undocumented errors.
~I have not identified any know errors in my solution
*/

-- DROP PROCEDURES
DROP PROCEDURE AddStaffType
DROP PROCEDURE UpdateReward
DROP PROCEDURE DeleteConsignmentDetail
DROP PROCEDURE LookUpCustomerHistory
DROP PROCEDURE UnusedCategories
DROP PROCEDURE LookUpStaffType
DROP PROCEDURE AddConsignmentItem
GO

/* 
1.	Write a stored procedure called AddStaffType that accepts a Description and will add 
a new StaffType to the StaffType table. Duplicate descriptions are not allowed! If the 
description being added is already in the StaffType table give an appropriate error 
message. Otherwise, add the new StaffType to the StaffType table and select the new 
StaffTypeID. (3 Marks)
*/
CREATE PROCEDURE AddStaffType (@Description VARCHAR(30)=NULL)
AS
	DECLARE @ErrorCode INT, @RowsAffected INT

	IF @Description IS NULL
		BEGIN
			RAISERROR('You must provide a staff type description.',16,1)
		END
	ELSE
		BEGIN
			-- check for duplicate staff type description
			IF EXISTS(SELECT StaffTypeDescription FROM StaffType WHERE StaffTypeDescription=@Description)
				BEGIN
					RAISERROR('The staff type description already exists!',16,1)
				END
			ELSE
				BEGIN
					-- insert new staff type
					INSERT INTO StaffType (StaffTypeDescription)
					VALUES (@Description)
					
					SELECT @ErrorCode=@@ERROR, @RowsAffected=@@ROWCOUNT

					IF @ErrorCode != 0
						BEGIN
							RAISERROR('Insert failed',16,1)
						END
					ELSE
						BEGIN
							IF @RowsAffected = 0
								BEGIN
									RAISERROR('No rows inserted',16,1)
								END
							ELSE
								BEGIN
									-- select the new staff type id
									SELECT @@IDENTITY 'New Staff Type ID'
								END
						END
				END
		END
RETURN
GO

/*
2.	Write a stored procedure called UpdateReward that accepts the RewardID, Description 
and DiscountPercentage. If no errors are raised update the record for that Reward. (2 Marks)
*/
CREATE PROCEDURE UpdateReward (@RewardID CHAR(4)=NULL, @Description VARCHAR(30)=NULL, @DiscountPercentage TINYINT=NULL)
AS
	DECLARE @ErrorCode INT, @RowsAffected INT

	IF @RewardID IS NULL OR @Description IS NULL OR @DiscountPercentage IS NULL
		BEGIN
			RAISERROR('You must provide a Reward ID, Reward Descirption, and Discount Percentage.',16,1)
		END
	ELSE
		BEGIN
			UPDATE Reward
			SET RewardDescription=@Description, DiscountPercentage=@DiscountPercentage
			WHERE RewardID=@RewardID

			SELECT @ErrorCode=@@ERROR, @RowsAffected=@@ROWCOUNT

			IF @ErrorCode != 0
				BEGIN
					RAISERROR('Update failed',16,1)
				END
			ELSE
				BEGIN
					IF @RowsAffected = 0
						BEGIN
							RAISERROR('No rows updated',16,1)
						END
				END
		END
RETURN
GO

/*
3.	Write a stored procedure called DeleteConsignmentDetail that will delete a single 
ConsignmentDetail record. If the record exists, delete the record from the 
ConsignmentDetail table. (4 Marks)
*/
CREATE PROCEDURE DeleteConsignmentDetail (@ConsignmentID INT=NULL, @LineID INT=NULL)
AS
	DECLARE @ErrorCode INT, @RowsAffected INT

	IF @ConsignmentID IS NULL OR @LineID IS NULL
		BEGIN
			RAISERROR('You must provide a Consignment ID and Line ID.',16,1)
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT 'x' FROM ConsignmentDetails WHERE ConsignmentID=@ConsignmentID AND LineID=@LineID)
				BEGIN
					RAISERROR('The consignment detail does not exist.',16,1)
				END
			ELSE
				BEGIN
					DELETE FROM ConsignmentDetails
					WHERE ConsignmentID=@ConsignmentID AND LineID=@LineID

					SELECT @ErrorCode = @@ERROR, @RowsAffected = @@ROWCOUNT

					IF @ErrorCode!=0
						BEGIN
							RAISERROR('Delete from consignment detail failed.',16,1)
						END
					ELSE
						BEGIN
							IF @RowsAffected=0
								BEGIN
									RAISERROR('No rows deleted',16,1)
								END
						END
				END
		END
RETURN
GO

/*
4.	Write a stored procedure called LookUpCustomerHistory that will return the customer’s 
full name, consignment dates and totals, and descriptions of the consignment Items for a 
single customer. (2 Marks)
*/
CREATE PROCEDURE LookUpCustomerHistory (@CustomerID INT=NULL)
AS
	DECLARE @ErrorCode INT, @RowsAffected INT

	IF @CustomerID IS NULL
		BEGIN
			RAISERROR('You must provide a Customer ID.',16,1)
		END
	ELSE
		BEGIN
			SELECT FirstName + ' ' + LastName 'Full Name', Date 'Consignment Date', Total, ItemDescription FROM Customer
			INNER JOIN Consignment ON Customer.CustomerID=Consignment.CustomerID
			INNER JOIN ConsignmentDetails ON Consignment.ConsignmentID=ConsignmentDetails.ConsignmentID
			WHERE Customer.CustomerID=@CustomerID
		END
RETURN
GO

/*
5.	Write a stored procedure called UnusedCategories that returns the CategoryCode and 
CategoryDescription of all the categories that have not been used on any 
consignments. Do not use a join. (2 Marks)
*/
CREATE PROCEDURE UnusedCategories
AS
	SELECT CategoryCode, CategoryDescription FROM Category
	WHERE CategoryCode NOT IN (SELECT CategoryCode FROM ConsignmentDetails)
RETURN
GO

/*
6.	Write a stored procedure called LookUpStaffType that accepts any part of a staff type 
description to search for. Return all the StaffType data for those staff types that have that 
part in their description. (2 Marks)
*/
CREATE PROCEDURE LookUpStaffType (@PartDescription VARCHAR(30)=NULL)
AS
	SELECT StaffTypeID, StaffTypeDescription FROM StaffType
	WHERE StaffTypeDescription LIKE '%' + @PartDescription + '%'
RETURN
GO

/*
7.	Write a stored procedure called AddConsignmentItem that will accept ConsignmentID, 
Description, StartPrice, LowPrice, and CategoryCode, to perform the following (All 
parameters, if passed in, will be valid): (8 marks)
	•	Add a record to the ConsignmentDetail table. Assume that the Consignment 
	record already exists in the Consignment table. The Line ID will start at 1 for each 
	consignment and increment by 1 for each additional item added on to that consignment.
	•	Update the appropriate Consignment table data to reflect the added 
	ConsignmentDetail record. Remember the following:
		o	The cost to consign an item is determined by the Category the consigned item is in
		o	Subtotal is calculated and recorded after any reward discounts have been subtracted
		o	GST is calculated after the Reward Program discounts are subtracted
		o	Total = SubTotal + GST
*/
CREATE PROCEDURE AddConsignmentItem (	@ConsignmentID INT=NULL, 
										@Description VARCHAR(40)=NULL, 
										@StartPrice SMALLMONEY=NULL,
										@LowPrice SMALLMONEY=NULL,
										@CategoryCode CHAR(3)=NULL)
AS
	DECLARE @ErrorCode INT, @RowsAffected INT

	IF @ConsignmentID IS NULL OR 
	@Description IS NULL OR 
	@StartPrice IS NULL OR 
	@LowPrice IS NULL OR 
	@CategoryCode IS NULL
		BEGIN
			RAISERROR('You must provide Consignment ID, Description, Start Price, Low Price, and Category Code.',16,1)
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT ConsignmentID FROM Consignment WHERE ConsignmentID=@ConsignmentID)
				BEGIN
					RAISERROR('Consignment ID does not exist in Consignment table.',16,1)
				END
			ELSE
				BEGIN
					IF NOT EXISTS (SELECT CategoryCode FROM Category WHERE CategoryCode=@CategoryCode)
						BEGIN
							RAISERROR('Category Code does not exist in Category table.',16,1)
						END
					ELSE
						BEGIN
							DECLARE @LineID INT

							SELECT @LineID=ISNULL(MAX(LineID), 0) FROM ConsignmentDetails
							WHERE ConsignmentID=@ConsignmentID

							BEGIN TRANSACTION
								INSERT INTO ConsignmentDetails (ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
								VALUES (@ConsignmentID, @LineID+1, @Description, @StartPrice, @LowPrice, @CategoryCode)

								SELECT @ErrorCode = @@ERROR, @RowsAffected = @@ROWCOUNT

								IF @ErrorCode != 0
									BEGIN
										ROLLBACK TRANSACTION
										RAISERROR('Insert into Consignment Details failed.',16,1)
									END
								ELSE
									BEGIN
										IF @RowsAffected = 0
											BEGIN
												ROLLBACK TRANSACTION
												RAISERROR('No rows affected',16,1)
											END
										-- insert into Consignment Details was successful
										ELSE
											BEGIN
												-- Get Cost from Category table
												DECLARE @Cost SMALLMONEY
												SELECT @Cost=Cost FROM Category
												WHERE CategoryCode=@CategoryCode

												-- Get current Subtotal, current Rewards Discount and Customer ID from Consignment table
												DECLARE @CurrentSubtotal SMALLMONEY, @CurrentRewardsDiscount DECIMAL(9,2), @CustomerID INT
												SELECT @CurrentSubtotal=Subtotal, @CurrentRewardsDiscount=RewardsDiscount, @CustomerID=CustomerID FROM Consignment
												WHERE ConsignmentID=@ConsignmentID

												-- Get Discount Percentage from Reward table
												DECLARE @DiscountPercentage TINYINT
												SELECT @DiscountPercentage=DiscountPercentage FROM Reward
												WHERE RewardID = (SELECT RewardID FROM Customer WHERE CustomerID=@CustomerID)

												-- Calculate Item Rewards Discount
												DECLARE @ItemRewardsDiscount DECIMAL(9,2)
												-- Initialize rewards discount
												SET @ItemRewardsDiscount = 0.00
												-- If there is a discount percentage, calculate the rewards discount
												-- And, deduct the rewards discount from the category cost
												IF @DiscountPercentage != 0
													BEGIN
														SET @ItemRewardsDiscount = @Cost * (@DiscountPercentage / 100.0)
													END

												-- Calculate Item Cost after Discount
												DECLARE @ItemCostAfterDiscount SMALLMONEY
												SET @ItemCostAfterDiscount = @Cost - @ItemRewardsDiscount

												-- Calculate new Subtotal, new GST, new Total, and new Rewards Discount
												DECLARE @NewSubtotal SMALLMONEY, @NewGST SMALLMONEY, @NewTotal SMALLMONEY, @NewRewardsDiscount DECIMAL(9,2)
												SET @NewSubtotal = @CurrentSubtotal + @ItemCostAfterDiscount
												SET @NewGST = @NewSubtotal * 0.05
												SET @NewTotal = @NewSubtotal + @NewGST
												SET @NewRewardsDiscount = @CurrentRewardsDiscount + @ItemRewardsDiscount

												UPDATE Consignment
												SET Subtotal=@NewSubtotal, GST=@NewGST, Total=@NewTotal, RewardsDiscount=@NewRewardsDiscount
												WHERE ConsignmentID=@ConsignmentID

												SELECT @ErrorCode = @@ERROR, @RowsAffected = @@ROWCOUNT

												IF @ErrorCode != 0
													BEGIN
														ROLLBACK TRANSACTION
														RAISERROR('Update consignment failed.',16,1)
													END
												ELSE
													BEGIN
														IF @RowsAffected = 0
															BEGIN
																ROLLBACK TRANSACTION
																RAISERROR('No rows affected',16,1)
															END
														-- there are no errors
														ELSE
															BEGIN
																COMMIT TRANSACTION
															END
													END
											END
									END
						END
				END
		END
RETURN
GO