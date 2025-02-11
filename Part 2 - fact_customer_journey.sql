-- DATA QUALITY ISSUE
-- Common Table Expression (CTE) to identify and tag duplicate records
SELECT * FROM dbo.customer_journey ;

WITH DuplicateRecords AS (
    SELECT 
        JourneyID,  -- Select the unique identifier for each journey 
        CustomerID,  -- Select the unique identifier for each customer
        ProductID,  -- Select the unique identifier for each product
        VisitDate,  -- Select the date of the visit, which helps in determining the timeline of customer interactions
        Stage,  -- Select the stage of the customer journey (e.g.Homepage, Checkout etc.)
        Action,  -- Select the action taken by the customer (e.g., View, Click, Purchase)
        Duration,  -- Select the duration of the action or interaction
        -- Use ROW_NUMBER() to assign a unique row number to each record within the partition defined below
        ROW_NUMBER() OVER (
            -- PARTITION BY groups the rows based on the specified columns that should be unique
            PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action  
            -- ORDER BY defines how to order the rows within each partition (usually by a unique identifier like JourneyID)
            ORDER BY JourneyID  
        ) AS row_num  -- This creates a new column 'row_num' that numbers each row within its partition
    FROM 
        dbo.customer_journey  -- Specifies the source table from which to select the data
)

-- Select all records from the CTE where row_num > 1, which indicates duplicate entries
    
SELECT *
FROM DuplicateRecords
-- WHERE row_num > 1  -- Filters out the first occurrence (row_num = 1) and only shows the duplicates (row_num > 1)
ORDER BY JourneyID ; 

=======================================================================================================================
  
-- Data cleaning and preprocessing
SELECT 
        JourneyID,  -- Select the unique identifier for each journey 
        CustomerID,  -- Select the unique identifier for each customer
        ProductID,  -- Select the unique identifier for each product
        VisitDate,  -- Select the date of the visit, which helps in determining the timeline of customer interactions
        Stage,  -- Select the stage of the customer journey (e.g.Homepage, Checkout etc.)
        Action,  -- Select the action taken by the customer (e.g., View, Click, Purchase)
        ROUND(COALESCE(Duration,avg_duration),2) AS Duration  --  Replaces missing durations with the average duration for the corresponding date
FROM
   ( SELECT 
        JourneyID,  -- Select the unique identifier for each journey (and any other columns you want to include in the final result set)
        CustomerID,  -- Select the unique identifier for each customer
        ProductID,  -- Select the unique identifier for each product
        FORMAT(CONVERT(DATE,VisitDate),'dd-MM-yyyy') AS VisitDate,  -- Changing the format of VisitDate from yyyy-MM-dd to dd-MM-yyyy

        CASE   -- Replacing ProductPage to Productpage to maintain the consistency in data analysis
		     WHEN Stage = 'ProductPage' THEN 'Productpage'
		     ELSE Stage
		END AS Stage	 ,  -- Select the stage of the customer journey (e.g.Homepage, Checkout etc.)

        Action,  -- Select the action taken by the customer (e.g., View, Click, Purchase)
        Duration , -- Uses Duration directly, assuming it's already a numeric type
        AVG(Duration) OVER(PARTITION BY VisitDate) AS avg_duration,  -- Select the duration of the action or interaction
        -- Use ROW_NUMBER() to assign a unique row number to each record within the partition defined below
        ROW_NUMBER() OVER (
            -- PARTITION BY groups the rows based on the specified columns that should be unique
            PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action  
            -- ORDER BY defines how to order the rows within each partition (usually by a unique identifier like JourneyID)
            ORDER BY JourneyID  
        ) AS row_num  -- This creates a new column 'row_num' that numbers each row within its partition
    FROM 
        dbo.customer_journey  -- Specifies the source table from which to select the data
) AS T
-- Keeps only the first occurrence of each duplicate group identified in the subquery
WHERE row_num = 1
ORDER BY JourneyID ;
