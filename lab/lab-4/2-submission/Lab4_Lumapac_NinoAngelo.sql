/*
o	What you liked/disliked about the lab?
~	I liked the lab because it practiced us on how to create triggers.

o	How long it took you to complete the lab?
~	It took me more or less one hour to complete the lab.

o	How prepared you felt you were for the lab?
~	I felt confident answering the lab because we have practiced few different exercise examples.

o	If there are any known errors in your solution, please identify them in your discussion. Errors you have identified and simply could not find a solution for are more acceptable than undocumented errors.
~	I have not identified any known errors in my solution.
*/

DROP TRIGGER Lab4Q1
DROP TRIGGER Lab4Q2
DROP TRIGGER Lab4Q3
DROP TRIGGER Lab4Q4
GO

/*
1. Create a trigger called Lab4Q1 to ensure that the category cost will not increase by 
more than 15%. If this happens raise an error and do not allow the increase. (3.5 Marks)
*/
CREATE TRIGGER Lab4Q1
ON Category FOR UPDATE
AS
	IF @@ROWCOUNT > 0 AND UPDATE(Cost)
		BEGIN
			IF EXISTS (SELECT 'X' FROM INSERTED
					INNER JOIN DELETED ON INSERTED.CategoryCode=DELETED.CategoryCode
					WHERE INSERTED.Cost > DELETED.Cost * 1.15)
				BEGIN
					RAISERROR('Cannot increase category cost by more than 15 percent.',16,1)
					ROLLBACK TRANSACTION
				END
		END
RETURN
GO

-- Test the trigger
-- This will raise an error
UPDATE Category
SET Cost = Cost * 1.16
WHERE CategoryCode = 'VHC'
-- This will be successfull
UPDATE Category
SET Cost = Cost * 1.15
WHERE CategoryCode = 'VHC'
GO

/* 
2. Create a trigger called Lab4Q2 to ensure that a staff member cannot be assigned to 
a Consignment unless that staff member is in the 'Sales' StaffType. If 
this happens, raise an error, and do not allow the transaction to proceed. (3 Marks)
*/
CREATE TRIGGER LabQ2
ON Consignment FOR INSERT, UPDATE
AS
	IF @@ROWCOUNT > 0 AND UPDATE(StaffID)
		BEGIN
			IF NOT EXISTS (SELECT 'X' FROM INSERTED
					INNER JOIN Staff ON INSERTED.StaffID=Staff.StaffID
					INNER JOIN StaffType ON Staff.StaffTypeID=StaffType.StaffTypeID
					WHERE StaffTypeDescription='Sales')
				BEGIN
					RAISERROR('The staff member assigned is not from Sales.',16,1)
					ROLLBACK TRANSACTION
				END
		END
RETURN 
GO

-- Test the trigger
-- This will raise an error
UPDATE Consignment
SET StaffID='222222'
WHERE ConsignmentID=1
-- This will be successfull
UPDATE Consignment
SET StaffID='444444'
WHERE ConsignmentID=1
GO

/*
3. Create a trigger called Lab4Q3 on the ConsignmentDetails that prevents any 
modifications to the composite PK. In other words, do not allow a ConsignmentID 
or LineNumber to be changed. This restriction should not prevent the deleting of 
rows in ConsignmentDetails. (3 Marks)
*/
CREATE TRIGGER Lab4Q3
ON ConsignmentDetails FOR UPDATE
AS
	IF @@ROWCOUNT > 0 
		BEGIN
			DECLARE @Valid CHAR(1)
			SET @Valid='T'

			IF UPDATE(ConsignmentID)
				BEGIN
					IF NOT EXISTS(SELECT 'X' FROM INSERTED
							INNER JOIN DELETED ON INSERTED.ConsignmentID=DELETED.ConsignmentID)
						BEGIN
							RAISERROR('You are not allowed to update the Consignment ID.',16,1)
							SET @Valid='F'
						END
				END

			IF UPDATE(LineID)
				BEGIN
					IF NOT EXISTS(SELECT 'X' FROM INSERTED
							INNER JOIN DELETED ON INSERTED.LineID=DELETED.LineID)
						BEGIN
							RAISERROR('You are not allowed to update the Line ID',16,1)
							SET @Valid='F'
						END
				END

			IF @Valid='F'
				BEGIN
					ROLLBACK TRANSACTION
				END
		END
RETURN
GO

-- Test the trigger
-- Update the Consignment ID
UPDATE ConsignmentDetails
SET ConsignmentID=12
WHERE ConsignmentID=11 AND LineID=1
-- Update the Line ID
UPDATE ConsignmentDetails
SET LineID=2
WHERE ConsignmentID=11 AND LineID=1
GO

/*
4. Create a trigger called Lab4Q4 to add record(s) to the LogDiscountChange table 
when the DiscountPercentage of customer Reward changes. It will record the date 
and time of the change, the RewardID, the old DiscountPercentage and the new 
DiscountPercentage. Only add records where the DiscountPercentage value changes. (3 Marks)
*/
CREATE TRIGGER Lab4Q4
ON Reward FOR UPDATE
AS
	IF @@ROWCOUNT > 0 AND UPDATE(DiscountPercentage)
		BEGIN
			INSERT INTO LogDiscountChange (RewardID,DateChanged,OldDiscountPercentage,NewDiscountPercentage)
			SELECT INSERTED.RewardID,GETDATE(),DELETED.DiscountPercentage,INSERTED.DiscountPercentage FROM INSERTED
			INNER JOIN DELETED ON INSERTED.RewardID=DELETED.RewardID
		END
RETURN
GO

-- Test the trigger
UPDATE Reward
SET DiscountPercentage = 5
WHERE RewardID='A000'

UPDATE Reward
SET DiscountPercentage = 0
WHERE RewardID='A000'

SELECT RewardID, DateChanged, OldDiscountPercentage, NewDiscountPercentage 
FROM LogDiscountChange
GO