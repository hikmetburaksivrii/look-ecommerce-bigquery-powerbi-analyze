/*First, It Checks Whether Every Inventory Item ID In The Order Items Table 
Has A Matching ID In The Inventory ItemsTable. Then, It Checks Whether 
The Product IDs In The Matched Records Are Consistent. If Both Results 
Are Zero, There Are No Relationship Integrity Problems Between The Two Tables.*/

SELECT COUNTIF(ii.id IS NULL) AS unmatched_inventory_items,
  COUNTIF(ii.id IS NOT NULL AND oi.product_id <> ii.product_id) AS mismatched_product_ids
FROM `look0726-300726-p10.look_ecommerce.look_order_items` AS oi
LEFT JOIN `look0726-300726-p10.look_ecommerce.look_inventory_items` AS ii
  ON oi.inventory_item_id = ii.id;

-- Inventory Items.Created At Is Expected To Be Earlier Than Order Items.Created At
-- To Ensure That The Inventory Item Existed Before The Order Was Created.
-- However, Some Records Show Order Items.Created At Occurring Years Before Inventory Items.Created At!
-- 50,895 Records Do Not Follow This Expected Date Order!
-- These Records Result In Negative Date Differences Of More Than 2,000 Days!

-- Inventory Item Id Is Unique In Inventory Items. 
-- So The Date Mismatch Is Not Caused By Duplicate Inventory Item Records!

-- The Date Ranges Of Both Tables Overlap. 
-- But Some Individual Records Have Significant Differences Between Their Created At Values!

-- Further Investigation Is Needed To Determine The Meaning Of Created At!
-- In Inventory Items And Whether It Represents The Actual Inventory Creation Date.

-- Check Whether Inventory Items Were Created Before They Were Ordered!
SELECT oi.inventory_item_id, 
  ii.created_at AS inventory_created_at,
  oi.created_at AS order_created_at
FROM `look0726-300726-p10.look_ecommerce.look_order_items` AS oi
JOIN `look0726-300726-p10.look_ecommerce.look_inventory_items` AS ii
  ON oi.inventory_item_id = ii.id
WHERE ii.created_at > oi.created_at
GROUP BY oi.inventory_item_id,ii.created_at,oi.created_at;

-- Check The Time Difference Between Inventory Creation And Order Creation!
SELECT oi.inventory_item_id,
  ii.created_at AS inventory_created_at,
  oi.created_at AS order_created_at,
  TIMESTAMP_DIFF(oi.created_at, ii.created_at, DAY) AS difference_in_days
FROM `look0726-300726-p10.look_ecommerce.look_order_items` AS oi
JOIN `look0726-300726-p10.look_ecommerce.look_inventory_items` AS ii
  ON oi.inventory_item_id = ii.id
WHERE ii.created_at > oi.created_at
ORDER BY difference_in_days;

-- Check The Date Ranges in Both Tables!
SELECT MIN(created_at) AS min_created_at,
  MAX(created_at) AS max_created_at
FROM `look0726-300726-p10.look_ecommerce.look_inventory_items`;

SELECT MIN(created_at) AS min_created_at,
  MAX(created_at) AS max_created_at
FROM `look0726-300726-p10.look_ecommerce.look_order_items`;

-- 181,397 Records In Inventory Items Table Have A Sold At Value... 
-- Matching The Total Number Of Records In Order Items Table...
-- But There Are No Matching Inventory Items Between The Two Tables!
-- None Of These Inventory Item Ids Are Found In The Inventory Item Id Column Of Order Items Table!

-- Check Whether Sold At Occurs After Order Items.Created At!
SELECT COUNT(*) AS total_records,
  COUNTIF(ii.sold_at IS NULL) AS sold_at_null,
  COUNTIF(ii.sold_at IS NOT NULL AND oi.created_at <= ii.sold_at) AS valid_date_order,
  COUNTIF(ii.sold_at IS NOT NULL AND oi.created_at > ii.sold_at) AS invalid_date_order
FROM `look0726-300726-p10.look_ecommerce.look_order_items` AS oi
JOIN `look0726-300726-p10.look_ecommerce.look_inventory_items` AS ii
  ON oi.inventory_item_id = ii.id;

-- Check Whether Sold Inventory Items Have A Matching Order Item!
SELECT COUNT(*) AS total_sold_inventory_items,
  COUNT(oi.inventory_item_id) AS matched_order_items,
  COUNTIF(oi.inventory_item_id IS NULL) AS unmatched_order_items
FROM `look0726-300726-p10.look_ecommerce.look_inventory_items` AS ii
LEFT JOIN `look0726-300726-p10.look_ecommerce.look_order_items` AS oi
  ON ii.id = oi.inventory_item_id
WHERE ii.sold_at IS NOT NULL;

-- Count Records With A Sold At Date Is Not NULL!
SELECT COUNT(sold_at) AS sold_at_filled
FROM `look0726-300726-p10.look_ecommerce.look_inventory_items`
WHERE sold_at IS NOT NULL;