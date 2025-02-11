-- Query to clean and normalize the engagement_data table



SELECT 
   EngagementID, -- Selects the unique identifier for each engagement record
   ContentID,  -- Selects the unique identifier for each piece of content
   CampaignID,   -- Selects the unique identifier for each marketing campaign
   ProductID,  -- Selects the unique identifier for each product
   CASE  -- changing the ContentType to specific format, removing inconsistency
     WHEN ContentType = 'SOCIALMEDIA' THEN 'Social Media'  -- changing the format, SOCIALMEDIA to Social Media
	   WHEN ContentType = 'Socialmedia' THEN 'Social Media'  -- changing the format, Socialmedia to Social Media
	   WHEN  ContentType = 'video' THEN 'Video'     -- changing the format, video to Video
	   WHEN  ContentType = 'BLOG' THEN 'Blog'     -- changing the format, BLOG to Blog
	   ELSE ContentType  -- otherwise keep the original format
   END AS ContentType,
   LEFT(ViewsClicksCombined,CHARINDEX('-',ViewsClicksCombined)-1) AS Views,  -- Extracts the Views part from the ViewsClicksCombined column by taking the substring before the '-' character
   RIGHT(ViewsClicksCombined,LEN(ViewsClicksCombined) - CHARINDEX('-',ViewsClicksCombined)) AS Clicks,  -- Extracts the Clicks part from the ViewsClicksCombined column by taking the substring after the '-' character
   FORMAT(CONVERT(DATE,EngagementDate),'dd-MM-yyyy') AS EngagementDate, -- Converts and formats the date as dd.mm.yyyy,
   Likes   -- Selects the number of likes the content received
FROM dbo.engagement_data 
WHERE ContentType != 'Newsletter';
