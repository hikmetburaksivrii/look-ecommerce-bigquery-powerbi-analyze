--Same Product Id Can Cause Data Duplication Within The Same Order Id!
SELECT * FROM `look0726-300726-p10.look_ecommerce.look_order_items` WHERE order_id=90466;
SELECT order_id, COUNT(*) FROM `look0726-300726-p10.look_ecommerce.look_order_items`
GROUP BY order_id HAVING COUNT(*)>2;