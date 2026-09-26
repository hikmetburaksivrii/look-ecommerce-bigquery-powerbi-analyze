--Inventroty Items Tablosunda Her Satır Bir Inventory Item Id Değeri Tarafından Temsil Ediliyor!
--Inventory Item ID ve Product ID Kombinasyonu Da Eşsiz!
SELECT ID, COUNT(*) 
FROM `look0726-300726-p10.look_ecommerce.look_inventory_items`
GROUP BY ID
HAVING COUNT(*)>1;

SELECT ID,product_id, COUNT(*) 
FROM `look0726-300726-p10.look_ecommerce.look_inventory_items`
GROUP BY ID,product_id
HAVING COUNT(*)>1;

--Order Item Tablosunun Eşsiz Anahtarı ID Değeri Olabilirdi!
--Ancak Inventory Items İle İlişkilendirilemiyor!
SELECT ID, COUNT(*) 
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
GROUP BY ID
HAVING COUNT(*)>1;

--Order ID Tek Başına Eşsiz Değil!
SELECT order_id, COUNT(*) 
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
GROUP BY order_id
HAVING COUNT(*)>1;

--Her Order ID Kapsamında Product ID Tekil Olarak Bulunabiliyor!
--Siparişin İçeriğinde Aynı Üründen Birden Fazla Olabilir!
--Bu Kombinasyonun Unique Olması Beklenemez!
SELECT order_id,product_id, COUNT(*) 
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
GROUP BY order_id,product_id
HAVING COUNT(*)>1;

SELECT order_id,user_id, COUNT(*) 
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
GROUP BY order_id,user_id
HAVING COUNT(*)>1;

--Order Items Tablosundaki Inventory Item ID Değeri Eşsiz!
--2 Tablo Arasındaki Join İşlemi Buradan Yapılabilir! 
SELECT inventory_item_id, COUNT(*) 
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
GROUP BY inventory_item_id
HAVING COUNT(*)>1;