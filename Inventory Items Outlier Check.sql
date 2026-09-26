SELECT COUNTIF(cost <= 0) AS zero_or_negative_cost,
  COUNTIF(product_retail_price <= 0) AS zero_or_negative_retail_price,
  COUNTIF(cost > product_retail_price) AS cost_higher_than_retail_price,
  COUNTIF(sold_at IS NOT NULL AND sold_at < created_at) AS invalid_sold_date 
FROM `look0726-300726-p10.look_ecommerce.look_inventory_items`;

-- Check Whether Sold At Occurs After Created At For Inventory Items!
SELECT COUNT(*) AS total_records,
  COUNTIF(sold_at IS NULL) AS sold_at_null,
  COUNTIF(sold_at IS NOT NULL AND created_at <= sold_at) AS valid_date_order,
  COUNTIF(sold_at IS NOT NULL AND created_at > sold_at) AS invalid_date_order
FROM `look0726-300726-p10.look_ecommerce.look_inventory_items`;