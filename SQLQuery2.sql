


ALTER TABLE dbo.Sales_Fact ALTER COLUMN Product_ID INT;
ALTER TABLE dbo.Sales_Fact ALTER COLUMN Employee_ID INT;
ALTER TABLE dbo.Products ALTER COLUMN Product_ID INT;
ALTER TABLE dbo.Employees ALTER COLUMN Employee_ID INT;

SELECT 
    C.Customer_Segment,
    C.Loyalty_Level,
    SUM(ISNULL(SF.Sales_Amount, 0)) AS Revenue,
    COUNT(DISTINCT SF.Order_ID) AS Frequency
FROM dbo.Customers AS C
LEFT JOIN [dbo].[Sales_Fact (1)] AS SF ON C.Customer_ID = SF.Customer_ID
GROUP BY C.Customer_Segment, C.Loyalty_Level
ORDER BY Revenue DESC;

SELECT 
    O.Delivery_Method,
    O.Delivery_Status,
    COUNT(SF.Order_ID) AS Total_Orders,
    SUM(CASE WHEN O.Return_Flag = 1 THEN 1 ELSE 0 END) AS Total_Returns,
    AVG(CAST(O.Customer_Rating AS FLOAT)) AS Avg_Rating
FROM [dbo].[Sales_Fact (1)] AS SF
JOIN dbo.Operations AS O ON SF.Order_ID = O.Order_ID
GROUP BY O.Delivery_Method, O.Delivery_Status;

SELECT 
    P.Product_Name,
    P.Category,
    P.Brand,
    SUM(ISNULL(SF.Quantity, 0)) AS Total_Units_Sold,
    SUM(ISNULL(SF.Sales_Amount, 0)) AS Total_Revenue,
    AVG(P.Selling_Price - P.Cost_Price) AS Avg_Profit_Margin
FROM [dbo].[Products(1)] AS P
LEFT JOIN [dbo].[Sales_Fact (1)] AS SF ON P.Product_ID = SF.Product_ID
GROUP BY P.Product_Name, P.Category, P.Brand
ORDER BY Total_Revenue DESC;

SELECT 
    E.Employee_Name,
    E.Department,
    SUM(ISNULL(SF.Sales_Amount, 0)) AS Total_Sales_Generated,
    COUNT(SF.Order_ID) AS Total_Orders_Handled,
    E.Performance_Rating
FROM [dbo].[Employees(1)] AS E
LEFT JOIN [dbo].[Sales_Fact (1)] AS SF ON E.Employee_ID = SF.Employee_ID
GROUP BY E.Employee_Name, E.Department, E.Performance_Rating
ORDER BY Total_Sales_Generated DESC;

-- Query 5: Regional and Branch Performance
SELECT 
    SF.Branch_ID,
    SUM(SF.Sales_Amount) AS Total_Branch_Revenue,
    SUM(SF.Profit) AS Total_Branch_Profit,
    COUNT(SF.Order_ID) AS Total_Transactions
FROM [dbo].[Sales_Fact (1)] AS SF
GROUP BY SF.Branch_ID
ORDER BY Total_Branch_Revenue DESC;

-- Query 6: Payment Method Analysis
SELECT 
    O.Payment_Method,
    COUNT(SF.Order_ID) AS Total_Transactions,
    SUM(SF.Sales_Amount) AS Total_Volume
FROM [dbo].[Sales_Fact (1)] AS SF
JOIN dbo.Operations AS O ON SF.Order_ID = O.Order_ID
GROUP BY O.Payment_Method
ORDER BY Total_Volume DESC;


SELECT 
    P.Product_Name,
    P.Launch_Date,
    SUM(SF.Sales_Amount) AS Total_Revenue,
    DATEDIFF(MONTH, P.Launch_Date, GETDATE()) AS Months_Since_Launch
FROM [dbo].[Products(1)] AS P
LEFT JOIN [dbo].[Sales_Fact (1)] AS SF ON P.Product_ID = SF.Product_ID
GROUP BY P.Product_Name, P.Launch_Date
ORDER BY Total_Revenue DESC;

SELECT 
    C.Customer_Name,
    C.City,
    SUM(SF.Sales_Amount) AS Lifetime_Value
FROM dbo.Customers AS C
JOIN [dbo].[Sales_Fact (1)] AS SF ON C.Customer_ID = SF.Customer_ID
GROUP BY C.Customer_Name, C.City
HAVING SUM(SF.Sales_Amount) > 5000
ORDER BY Lifetime_Value DESC;



-- Query 9: Sales Target vs Actual Performance
SELECT 
    SF.Order_ID,
    SF.Sales_Amount,
    SF.Sales_Target,
    CASE 
        WHEN SF.Sales_Amount >= SF.Sales_Target THEN 'Achieved'
        ELSE 'Below Target'
    END AS Performance_Status
FROM [dbo].[Sales_Fact (1)] AS SF;

-- Query 10: Monthly Sales Trend
SELECT 
    DATEPART(YEAR, SF.Order_Date) AS Sales_Year,
    DATEPART(MONTH, SF.Order_Date) AS Sales_Month,
    SUM(SF.Sales_Amount) AS Monthly_Revenue
FROM [dbo].[Sales_Fact (1)] AS SF
GROUP BY DATEPART(YEAR, SF.Order_Date), DATEPART(MONTH, SF.Order_Date)
ORDER BY Sales_Year, Sales_Month;


SELECT 
    O.Return_Reason,
    COUNT(SF.Order_ID) AS Total_Returns
FROM [dbo].[Sales_Fact (1)] AS SF
JOIN dbo.Operations AS O ON SF.Order_ID = O.Order_ID
WHERE O.Return_Flag = 1
GROUP BY O.Return_Reason
ORDER BY Total_Returns DESC;


SELECT 
    C.Customer_Name,
    COUNT(SF.Order_ID) AS Order_Count,
    AVG(O.Customer_Rating) AS Avg_Rating
FROM dbo.Customers AS C
JOIN [dbo].[Sales_Fact (1)] AS SF ON C.Customer_ID = SF.Customer_ID
JOIN dbo.Operations AS O ON SF.Order_ID = O.Order_ID
GROUP BY C.Customer_Name
HAVING COUNT(SF.Order_ID) > 1
ORDER BY Order_Count DESC;



-- Query 13: Delivery Efficiency Analysis
SELECT 
    O.Delivery_Method,
    AVG(CAST(O.Delivery_Days AS FLOAT)) AS Avg_Delivery_Time,
    COUNT(SF.Order_ID) AS Total_Orders
FROM [dbo].[Sales_Fact (1)] AS SF
JOIN dbo.Operations AS O ON SF.Order_ID = O.Order_ID
GROUP BY O.Delivery_Method
ORDER BY Avg_Delivery_Time ASC;

-- Query 14: Employee vs Monthly Target Achievement
SELECT 
    E.Employee_Name,
    E.Monthly_Target,
    SUM(SF.Sales_Amount) AS Actual_Sales,
    (SUM(SF.Sales_Amount) - E.Monthly_Target) AS Variance
FROM [dbo].[Employees(1)] AS E
LEFT JOIN [dbo].[Sales_Fact (1)] AS SF ON E.Employee_ID = SF.Employee_ID
GROUP BY E.Employee_Name, E.Monthly_Target
ORDER BY Variance DESC;


SELECT 
    P.Product_Name,
    P.Selling_Price,
    P.Cost_Price,
    (P.Selling_Price - P.Cost_Price) AS Unit_Profit,
    ((P.Selling_Price - P.Cost_Price) / P.Selling_Price) * 100 AS Profit_Margin_Percentage
FROM [dbo].[Products(1)] AS P
ORDER BY Profit_Margin_Percentage DESC;


SELECT 
    P.Category,
    COUNT(DISTINCT SF.Customer_ID) AS Unique_Customers,
    SUM(SF.Quantity) AS Total_Units_Sold
FROM [dbo].[Sales_Fact (1)] AS SF
JOIN [dbo].[Products(1)] AS P ON SF.Product_ID = P.Product_ID
GROUP BY P.Category
ORDER BY Unique_Customers DESC;


-- Query 17: Payment Status Report
SELECT 
    O.Payment_Status,
    COUNT(SF.Order_ID) AS Order_Count,
    SUM(SF.Sales_Amount) AS Total_Sales
FROM [dbo].[Sales_Fact (1)] AS SF
JOIN dbo.Operations AS O ON SF.Order_ID = O.Order_ID
GROUP BY O.Payment_Status;

-- Query 18: Customer Demographics by Region
SELECT 
    C.Country,
    C.City,
    COUNT(C.Customer_ID) AS Total_Customers,
    AVG(C.Age) AS Avg_Customer_Age
FROM dbo.Customers AS C
GROUP BY C.Country, C.City
ORDER BY Total_Customers DESC;

-- Query 19: Product Supplier Performance
SELECT 
    P.Supplier,
    COUNT(DISTINCT P.Product_ID) AS Unique_Products,
    SUM(SF.Quantity) AS Total_Units_Sold
FROM [dbo].[Products(1)] AS P
LEFT JOIN [dbo].[Sales_Fact (1)] AS SF ON P.Product_ID = SF.Product_ID
GROUP BY P.Supplier
ORDER BY Total_Units_Sold DESC;

SELECT 
    O.Delivery_Status,
    AVG(O.Delivery_Days) AS Avg_Days_To_Deliver,
    COUNT(SF.Order_ID) AS Total_Orders
FROM [dbo].[Sales_Fact (1)] AS SF
JOIN dbo.Operations AS O ON SF.Order_ID = O.Order_ID
GROUP BY O.Delivery_Status;



SELECT TOP 5
    P.Product_Name,
    SUM(SF.Sales_Amount) AS Total_Sales
FROM [dbo].[Sales_Fact (1)] AS SF
JOIN [dbo].[Products(1)] AS P ON SF.Product_ID = P.Product_ID
GROUP BY P.Product_Name
ORDER BY Total_Sales DESC;


SELECT 
    SF.Order_ID,
    SF.Discount,
    SF.Sales_Amount
FROM [dbo].[Sales_Fact (1)] AS SF
WHERE SF.Discount > (SELECT AVG(Discount) FROM [dbo].[Sales_Fact (1)])
ORDER BY SF.Discount DESC;


SELECT 
    C.Customer_Segment,
    AVG(SF.Sales_Amount) AS Avg_Order_Value
FROM dbo.Customers AS C
JOIN [dbo].[Sales_Fact (1)] AS SF ON C.Customer_ID = SF.Customer_ID
GROUP BY C.Customer_Segment
ORDER BY Avg_Order_Value DESC;


SELECT 
    E.Employee_Name,
    SUM(SF.Sales_Amount) AS Total_Sales,
    (SELECT AVG(SubTotal) FROM (SELECT SUM(Sales_Amount) AS SubTotal FROM [dbo].[Sales_Fact (1)] GROUP BY Employee_ID) AS Averages) AS Company_Avg_Sales
FROM [dbo].[Employees(1)] AS E
LEFT JOIN [dbo].[Sales_Fact (1)] AS SF ON E.Employee_ID = SF.Employee_ID
GROUP BY E.Employee_Name;

SELECT TOP 5
    P.Product_Name,
    SUM(SF.Sales_Amount) AS Total_Sales
FROM [dbo].[Sales_Fact (1)] AS SF
JOIN [dbo].[Products(1)] AS P ON SF.Product_ID = P.Product_ID
GROUP BY P.Product_Name
ORDER BY Total_Sales DESC;


SELECT 
    SF.Order_ID,
    SF.Discount,
    SF.Sales_Amount
FROM [dbo].[Sales_Fact (1)] AS SF
WHERE SF.Discount > (SELECT AVG(Discount) FROM [dbo].[Sales_Fact (1)])
ORDER BY SF.Discount DESC;


SELECT 
    C.Customer_Segment,
    AVG(SF.Sales_Amount) AS Avg_Order_Value
FROM dbo.Customers AS C
JOIN [dbo].[Sales_Fact (1)] AS SF ON C.Customer_ID = SF.Customer_ID
GROUP BY C.Customer_Segment
ORDER BY Avg_Order_Value DESC;




SELECT TOP 5
    P.Product_Name,
    SUM(SF.Sales_Amount) AS Total_Sales
FROM [dbo].[Sales_Fact (1)] AS SF
JOIN [dbo].[Products(1)] AS P ON SF.Product_ID = P.Product_ID
GROUP BY P.Product_Name
ORDER BY Total_Sales DESC;


SELECT 
    SF.Order_ID,
    SF.Discount,
    SF.Sales_Amount
FROM [dbo].[Sales_Fact (1)] AS SF
WHERE SF.Discount > (SELECT AVG(Discount) FROM [dbo].[Sales_Fact (1)])
ORDER BY SF.Discount DESC;

SELECT 
    C.Customer_Segment,
    AVG(SF.Sales_Amount) AS Avg_Order_Value
FROM dbo.Customers AS C
JOIN [dbo].[Sales_Fact (1)] AS SF ON C.Customer_ID = SF.Customer_ID
GROUP BY C.Customer_Segment
ORDER BY Avg_Order_Value DESC;



SELECT 
    DATEPART(YEAR, SF.Order_Date) AS Sales_Year,
    'Q' + CAST(DATEPART(QUARTER, SF.Order_Date) AS VARCHAR(1)) AS Sales_Quarter,
    SUM(SF.Sales_Amount) AS Total_Quarterly_Revenue
FROM [dbo].[Sales_Fact (1)] AS SF
GROUP BY DATEPART(YEAR, SF.Order_Date), DATEPART(QUARTER, SF.Order_Date)
ORDER BY Sales_Year, Sales_Quarter;


SELECT 
    C.Customer_Name,
    C.City
FROM dbo.Customers AS C
LEFT JOIN [dbo].[Sales_Fact (1)] AS SF ON C.Customer_ID = SF.Customer_ID
WHERE SF.Order_ID IS NULL;


SELECT 
    SF.Branch_ID,
    P.Category,
    SUM(SF.Profit) AS Total_Category_Profit
FROM [dbo].[Sales_Fact (1)] AS SF
JOIN [dbo].[Products(1)] AS P ON SF.Product_ID = P.Product_ID
GROUP BY SF.Branch_ID, P.Category
ORDER BY SF.Branch_ID, Total_Category_Profit DESC;


SELECT 
    C.Age,
    AVG(SF.Sales_Amount) AS Avg_Spending
FROM dbo.Customers AS C
JOIN [dbo].[Sales_Fact (1)] AS SF ON C.Customer_ID = SF.Customer_ID
GROUP BY C.Age
ORDER BY C.Age;


SELECT 
    P.Category,
    SUM(SF.Sales_Amount) AS Total_Sales,
    SUM(SF.Cost) AS Total_Cost,
    (SUM(SF.Sales_Amount) - SUM(SF.Cost)) AS Total_Profit
FROM [dbo].[Sales_Fact (1)] AS SF
JOIN [dbo].[Products(1)] AS P ON SF.Product_ID = P.Product_ID
GROUP BY P.Category
ORDER BY Total_Profit DESC;


SELECT 
    SF.Branch_ID,
    AVG(CAST(O.Customer_Rating AS FLOAT)) AS Avg_Branch_Rating
FROM [dbo].[Sales_Fact (1)] AS SF
JOIN dbo.Operations AS O ON SF.Order_ID = O.Order_ID
GROUP BY SF.Branch_ID
ORDER BY Avg_Branch_Rating DESC;


SELECT 
    E.Employee_Name,
    SUM(SF.Sales_Amount) AS Total_Sales
FROM [dbo].[Employees(1)] AS E
JOIN [dbo].[Sales_Fact (1)] AS SF ON E.Employee_ID = SF.Employee_ID
GROUP BY E.Employee_Name
HAVING SUM(SF.Sales_Amount) > (SELECT AVG(Total_Sales) FROM (SELECT SUM(Sales_Amount) AS Total_Sales FROM [dbo].[Sales_Fact (1)] GROUP BY Employee_ID) AS SubQuery);

SELECT 
    P.Category,
    CAST(SUM(CASE WHEN O.Return_Flag = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(SF.Order_ID) * 100 AS Return_Rate_Percentage
FROM [dbo].[Sales_Fact (1)] AS SF
JOIN dbo.Operations AS O ON SF.Order_ID = O.Order_ID
JOIN [dbo].[Products(1)] AS P ON SF.Product_ID = P.Product_ID
GROUP BY P.Category
ORDER BY Return_Rate_Percentage DESC;