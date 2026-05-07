SELECT DB_NAME();
USE [HperMarket];
GO

select * 
from [dbo].[supermarket_sales_branch_randomized]


----------------
-- Are there missing values in critical fields (Price, Quantity, Product)?

select *
from [dbo].[supermarket_sales_branch_randomized]
where Product  is null or Price is null or Quantity is null

--Are there duplicate transactions that could inflate revenue?

select count(*) as duplicated_orders , OrderID
from [dbo].[supermarket_sales_branch_randomized]
group by OrderID
having count(*) > 1

--Are product names or categories inconsistent (e.g., spelling variations)?

select Category , count(*) as categories_count  
from [dbo].[supermarket_sales_branch_randomized]
group by Category


select product , count(*) as products_Count 
from [dbo].[supermarket_sales_branch_randomized]
group by product


SELECT * , UPPER(TRIM(Product)) AS Clean_Product , upper(trim(category)) as Clean_Category
FROM [dbo].[supermarket_sales_branch_randomized]

--Which products generate the highest number of orders?

select  count(*) as number_of_orders , Product
from [dbo].[supermarket_sales_branch_randomized]
group by product
order by count(*) desc

--Which branches are the most active?

select count(*) as branches_orders , branchid
from [dbo].[supermarket_sales_branch_randomized]
group by BranchID
order by count(*) desc

--Which product categories appear most frequently in transactions?

select count(*) as product_category , category
from [dbo].[supermarket_sales_branch_randomized]
group by Category
order by count(*) desc

--How do orders change over time (monthly)?

select count(*) as Orders , month(date) as Orders_Month
from [dbo].[supermarket_sales_branch_randomized]
group by month(date)
order by month(date) asc

--Are there peak sales periods?

SELECT 
    M.OrderID , M.Date ,             
    M.ProductID, M.Product , 
    M.Category , M.Price ,
    M.Quantity , M.Customer , 
    M.BranchID
FROM 
   dbo.supermarket_sales_branch_randomized AS M
INNER JOIN 
    Products AS P ON M.ProductID = P.ProductID
INNER JOIN 
    Branches AS B ON M.BranchID = B.BranchID
    WHERE 
    ISNULL(TRIM(M.Customer), '') = ''
    OR TRY_CAST(M.Price AS decimal(18,2)) = 0 
    OR TRY_CAST(M.Quantity AS int) = 0
    OR TRY_CAST(M.Price AS decimal(18,2)) IS NULL;




