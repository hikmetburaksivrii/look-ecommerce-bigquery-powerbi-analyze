SELECT COUNTIF(sale_price <= 0) AS zero_or_negative_price,
  ROUND(MIN(sale_price), 2) AS minimum_price,
  ROUND(MAX(sale_price), 2) AS maximum_price,
  ROUND(AVG(sale_price), 2) AS average_price,
  APPROX_QUANTILES(sale_price, 4) AS price_quartiles
FROM `look0726-300726-p10.look_ecommerce.look_order_items`;

-- Comparison: Check Of Actual Sale Price Against Product Retail Price And Cost!
-- All Rows Return Equal To Retail Price Result!
-- Every Item Was Sold At Its Full Retail Price!
SELECT COUNTIF(oi.sale_price > ii.product_retail_price) AS above_retail_price,
  COUNTIF(oi.sale_price < ii.cost) AS below_cost,
  COUNTIF(oi.sale_price = ii.product_retail_price) AS equal_to_retail_price
FROM `look0726-300726-p10.look_ecommerce.look_order_items` AS oi
JOIN `look0726-300726-p10.look_ecommerce.look_inventory_items` AS ii
  ON oi.inventory_item_id = ii.id;