-- Step 1: Creating Sample Data
-- Ensure tables have sample data
-- Insert sample data into Sales.SalesOrderDetail table
IF NOT EXISTS (SELECT 1 FROM Sales.SalesOrderDetail)
BEGIN
    INSERT INTO Sales.SalesOrderDetail (SalesOrderID, ProductID, UnitPrice, OrderQty, UnitPriceDiscount)
    VALUES
    (1, 1, 10.00, 5, 0),
    (1, 2, 20.00, 2, 0),
    (2, 3, 30.00, 1, 0);
END


---------------------------------------------------


-- Step 2: Create the DeleteOrderDetails Stored Procedure
CREATE PROCEDURE DeleteOrderDetails
    @OrderID INT,
    @ProductID INT
AS
BEGIN
    -- Variable to store the number of affected rows
    DECLARE @RecordCount INT;
    
    -- Check if the OrderID exists
    IF NOT EXISTS (SELECT 1 FROM SalesOrderDetail WHERE SalesOrderID = @OrderID)
    BEGIN
        PRINT 'Error: OrderID does not exist.';
        RETURN -1;
    END
    
    -- Check if the ProductID exists for the given OrderID
    IF NOT EXISTS (SELECT 1 FROM SalesOrderDetail WHERE SalesOrderID = @OrderID AND ProductID = @ProductID)
    BEGIN
        PRINT 'Error: ProductID does not exist for the given OrderID.';
        RETURN -1;
    END
    
    -- Delete the record from Order Details table
    DELETE FROM SalesOrderDetail
    WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;
    
    -- Check the number of affected rows
    SET @RecordCount = @@ROWCOUNT;
    
    -- If no rows were deleted, print an error message
    IF @RecordCount = 0
    BEGIN
        PRINT 'Error: No records were deleted.';
        RETURN -1;
    END
    
    -- If the record was successfully deleted, print a success message
    PRINT 'Success: Record deleted successfully.';
    RETURN 0;
END;
GO


---------------------------------------------------


-- Step 3: Testing the Stored Procedure
-- Test with valid parameters
EXEC DeleteOrderDetails @OrderID = 1, @ProductID = 1;

-- Test with an invalid OrderID
EXEC DeleteOrderDetails @OrderID = 999, @ProductID = 1;

-- Test with an invalid ProductID within a valid OrderID
EXEC DeleteOrderDetails @OrderID = 1, @ProductID = 999;




