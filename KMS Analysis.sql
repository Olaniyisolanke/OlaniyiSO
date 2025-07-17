 -- 1. What product category has the highest sales?--

SELECT `Product Category`, SUM(Sales) AS Total_Sales
FROM orders
GROUP BY `Product Category`
ORDER BY Total_Sales DESC
LIMIT 1;
-- “Technology” category generated the highest revenue, contributing over 40% of total sales. Consider expanding this category or bundling it with underperforming categories to boost overall profit. --

-- 2. What are the top 3 and bottom 3 regions based on sales? --

SELECT Region, SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Region
ORDER BY Total_Sales DESC;
-- West, Ontanrio, and Prarie regions lead in sales. --
-- Nunout, Northwest and Yukon underperform—investigate demand drivers or marketing gaps in these regions.

-- 3. What’s the total sales of Appliances in Ontario? --

SELECT SUM(Sales) AS Appliance_Sales_Ontario
FROM orders
WHERE `Product Sub-Category` = 'Appliances' AND Region = 'Ontario';
-- Ontario generated 202,346.8400 in sales for Appliances products, showing that this sub-category has a consistent demand in the region. Management may consider bundling appliance promotions in this location or investigating what drives appliance sales there. --

-- 4. Bottom 10 customers by sales (to advise management) --

SELECT `Customer Name`, SUM(Sales) AS Total_Sales
FROM orders
GROUP BY `Customer Name`
ORDER BY Total_Sales ASC
LIMIT 10;
-- These customers have consistently low engagement. Recommend initiating targeted loyalty or feedback campaigns to revive interest or understand disengagement. --

-- 5. KMS incurred the most shipping cost using which shipping method? --
SELECT `Ship Mode`, SUM(`Shipping Cost`) AS Total_Shipping_Cost
FROM orders
GROUP BY `Ship Mode`
ORDER BY Total_Shipping_Cost desc
LIMIT 1;
-- KMS incurred the highest shipping cost using Delivery Truck with a total of 51144.539 --
-- This suggests that the company relies heavily on this mode,not necessarily because it’s the most expensive mode per shipment, but likely due to the high frequency or bulkiness of goods requiring that mode such as furniture or appliances..
-- It is worth reviewing whether this method is being used appropriately for low-priority or low-margin orders. --

-- 6. Who are the most valuable customers, and what products or services do they typically purchase? --
SELECT `Customer Name`, ROUND(SUM(Sales), 2) AS Total_Sales
FROM orders
GROUP BY `Customer Name`
ORDER BY Total_Sales DESC
LIMIT 10;

SELECT 
  `Customer Name`,
  `Product Category`,
  COUNT(*) AS Purchase_Count,
  ROUND(SUM(Sales), 2) AS Total_Spent
FROM orders
WHERE `Customer Name` IN (
'Emily Phan',
'Roy Skaria',
'Deborah Brumfield',
'Sylvia Foulston',
'Alejandro Grove',
'Grant Carroll',
'Darren Budd',
'John Lucas',
'Liz MacKendrick'
'Dennis Kane'
)
GROUP BY `Customer Name`, `Product Category`
ORDER BY `Customer Name`, Total_Spent DESC;
/* KMS’s most valuable customers demonstrate diversified purchasing behavior across all three main product categories: Technology, Furniture, and Office Supplies.
Notably:
Deborah Brumfield, Emily Phan, and Grant Carroll made purchases across all three categories, indicating broad product engagement.
Others, like Alejandro Grove and Darren Budd, focused more on Furniture and Office Supplies, which may reflect operational or office setup needs.
Strategic Recommendation:
These customers represent high-value multi-category buyers. KMS should:
Prioritize them for cross-category promotions (e.g., "Buy tech, get discount on furniture")
Build personalized campaigns targeting their purchase patterns
Offer early access to new products in their favorite categories to deepen loyalty.
*/

-- 7. Which small business customer had the highest sales? --
SELECT `Customer Name`, SUM(Sales) AS Total_Sales
FROM orders
WHERE `Customer Segment` = 'Small Business'
GROUP BY `Customer Name`
ORDER BY Total_Sales DESC
LIMIT 1;
-- Dennis Kane with sales of 74298.54. This Small Business segment shows strong individual contribution. Focused advertising could scale more like them. --

-- 8. Which Corporate Customer placed the most number of orders in 2009 – 2012? --
SELECT `Customer Name`, COUNT(`Order ID`) AS Total_Orders
FROM orders
WHERE `Customer Segment` = 'Corporate'
  AND YEAR(STR_TO_DATE(`Order Date`, '%m/%d/%Y')) BETWEEN 2009 AND 2012
GROUP BY `Customer Name`
ORDER BY Total_Orders DESC
LIMIT 1;
/* Between 2009 and 2012, the Corporate customer with the highest number of orders was Roy Skaria, placing a total of 25 orders.
This indicates a strong, recurring relationship with KMS over several years.
Recommendation: KMS should explore upselling and long-term contracts with this customer to secure consistent revenue and deepen engagement.
*/

-- 9. Which consumer customer was the most profitable one? --
SELECT `Customer Name`, SUM(Profit) AS Total_Profit
FROM orders
WHERE `Customer Segment` = 'Consumer'
GROUP BY `Customer Name`
ORDER BY Total_Profit DESC
LIMIT 1;
/*Emily Phan is the most profitable customer in the Consumer segment, generating a total profit of 34,005.44 over the analysis period
 Recommendation:
KMS should prioritize Emily for exclusive offers, early access to premium products, or even a personalized loyalty plan.
Understanding the types of products Emily regularly buys can help shape marketing efforts to attract similar high-value customers.
*/

-- 10. Which customer returned items, and what segment do they belong to? --

SELECT 
  DISTINCT o.`Customer Name`, 
  o.`Customer Segment`
FROM orders o
JOIN order_status os 
  ON o.`Order ID` = os.`Order ID`
WHERE os.`Status` = 'Returned'
ORDER BY o.`Customer Name`;

SELECT COUNT(DISTINCT o.`Customer Name`) AS Total_Customers_With_Returns
FROM orders o
JOIN order_status os ON o.`Order ID` = os.`Order ID`
WHERE os.`Status` = 'Returned';

SELECT 
  o.`Customer Segment`, 
  COUNT(*) AS Return_Count
FROM orders o
JOIN order_status os 
  ON o.`Order ID` = os.`Order ID`
WHERE os.`Status` = 'Returned'
GROUP BY o.`Customer Segment`
ORDER BY Return_Count DESC
LIMIT 5;

/*A total of 376 customers returned products, spanning all segments: Consumer, Corporate, and Home Office.
The highest number of returns came from the Corporate segment, suggesting potential dissatisfaction or mismatch in expectations within that group.
Recommendation: KMS should conduct a focused review on return behavior within each segment to improve customer experience and reduce churn.
*/

/* 11. If the delivery truck is the most economical but the slowest shipping method and 
Express Air is the fastest but the most expensive one, do you think the company 
appropriately spent shipping costs based on the Order Priority? Explain your answer */

SELECT `Ship Mode`, `Order Priority`, COUNT(*) AS Orders, ROUND(SUM(`Shipping Cost`), 1) AS Total_Shipping_Cost
FROM orders
GROUP BY `Ship Mode`, `Order Priority`
ORDER BY `Order Priority`, Total_Shipping_Cost DESC;
/* The company did not consistently align shipping methods with order priority:
Over 460 high/critical orders were shipped using Delivery Truck, the slowest method — potentially delaying time-sensitive deliveries.
~370 medium/low-priority orders used Express Air, the most expensive method leading to likely overspending.
This mismatch between priority and shipping method suggests operational inefficiencies that could impact customer satisfaction and profit margins.
*/

/* Business Recommendations
Double down on Technology category for promotions and bundling
Optimize Express Air shipping usage for truly high-priority items only
Launch customer segmentation campaigns targeting:
Low spenders with tailored offers
High-value customers with loyalty perks
Investigate Nunout and Northwest region marketing gaps
Explore return reasons for Customer Service training or product quality checks*/




