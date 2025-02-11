--  Query to categorize products based on their prices
SELECT
      ProductID,  -- select the unique identifier for each product
      ProductName, -- select the name of each product
      Price,       -- select the price of each product
	  CASE -- categorizes the products into  price category : Low, Medium, High
	       WHEN Price < 50 THEN 'Low'  -- if price is less then 50 categorize as Low
	       WHEN Price BETWEEN 50 AND 200 THEN 'Medium'  -- if price is between 50 and 200 categorize as Medium
	       ELSE 'High'  -- if price is more than 200 categorize as High
          END AS PriceCategory
FROM dbo.products ;
