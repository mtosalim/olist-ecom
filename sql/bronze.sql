

DROP TABLE IF EXISTS bronze.olist_customers_dataset;
CREATE TABLE bronze.olist_customers_dataset (
	customer_id VARCHAR(50),
	customer_unique_id VARCHAR(50),
	customer_zip_code_prefix VARCHAR(50),
	customer_city VARCHAR(50),
	customer_state VARCHAR(50)
);
BULK INSERT bronze.olist_customers_dataset
FROM 'C:\Users\mathe\Desktop\olist_ecom\orders\olist_customers_dataset.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	CODEPAGE = '65001',
	TABLOCK
);
SELECT *
FROM bronze.olist_customers_dataset;

DROP TABLE IF EXISTS bronze.olist_geolocation_dataset;
CREATE TABLE bronze.olist_geolocation_dataset (
	geolocation_zip_code_prefix VARCHAR(50),
	geolocation_lat VARCHAR(50),
	geolocation_lng VARCHAR(50),
	geolocation_city VARCHAR(50),
	geolocation_state VARCHAR(50),
);
BULK INSERT bronze.olist_geolocation_dataset
FROM 'C:\Users\mathe\Desktop\olist_ecom\orders\olist_geolocation_dataset_clean.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	CODEPAGE = '65001',
	TABLOCK
);
SELECT *
FROM bronze.olist_geolocation_dataset;

DROP TABLE IF EXISTS bronze.olist_order_items_dataset;
CREATE TABLE bronze.olist_order_items_dataset (
	order_id VARCHAR(50),
	order_item_id VARCHAR(50),
	product_id VARCHAR(50),
	seller_id VARCHAR(50),
	shipping_limit_date VARCHAR(50),
	price VARCHAR(50),
	freight_value VARCHAR(50)
);
BULK INSERT bronze.olist_order_items_dataset
FROM 'C:\Users\mathe\Desktop\olist_ecom\orders\olist_order_items_dataset.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	CODEPAGE = '65001',
	TABLOCK
);
SELECT *
FROM bronze.olist_order_items_dataset;

DROP TABLE IF EXISTS bronze.olist_order_payments_dataset;
CREATE TABLE bronze.olist_order_payments_dataset (
	order_id VARCHAR(50),
	payment_sequential VARCHAR(50),
	payment_type VARCHAR(50),
	payment_installments VARCHAR(50),
	payment_value VARCHAR(50)
);
BULK INSERT bronze.olist_order_payments_dataset
FROM 'C:\Users\mathe\Desktop\olist_ecom\orders\olist_order_payments_dataset.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	CODEPAGE = '65001',
	TABLOCK
);
SELECT *
FROM bronze.olist_order_payments_dataset;

DROP TABLE IF EXISTS bronze.olist_order_reviews_dataset;
CREATE TABLE bronze.olist_order_reviews_dataset (
	review_id VARCHAR(50),
	order_id VARCHAR(50),
	review_score VARCHAR(50),
	review_comment_title VARCHAR(50),
	review_comment_message VARCHAR(255),
	review_creation_date VARCHAR(50),
	review_answer_timestamp VARCHAR(50)
);
BULK INSERT bronze.olist_order_reviews_dataset
FROM 'C:\Users\mathe\Desktop\olist_ecom\orders\olist_order_reviews_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK
);
SELECT *
FROM bronze.olist_order_reviews_dataset;

DROP TABLE IF EXISTS bronze.olist_orders_dataset;
CREATE TABLE bronze.olist_orders_dataset (
	order_id VARCHAR(50),
	customer_id VARCHAR(50),
	order_status VARCHAR(50),
	order_purchase_timestamp VARCHAR(50),
	order_approved_at VARCHAR(50),
	order_delivered_carrier_date VARCHAR(50),
	order_delivered_customer_date VARCHAR(50),
	order_estimated_delivery_date VARCHAR(50)
);
BULK INSERT bronze.olist_orders_dataset
FROM 'C:\Users\mathe\Desktop\olist_ecom\orders\olist_orders_dataset.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	CODEPAGE = '65001',
	TABLOCK
);
SELECT *
FROM bronze.olist_orders_dataset;

DROP TABLE IF EXISTS bronze.olist_products_dataset;
CREATE TABLE bronze.olist_products_dataset (
	product_id VARCHAR(50),
	product_category_name VARCHAR(50),
	product_name_lenght VARCHAR(50),
	product_description_lenght VARCHAR(50),
	product_photos_qty VARCHAR(50),
	product_weight_g VARCHAR(50),
	product_length_cm VARCHAR(50),
	product_height_cm VARCHAR(50),
	product_width_cm VARCHAR(50)
);
BULK INSERT bronze.olist_products_dataset
FROM 'C:\Users\mathe\Desktop\olist_ecom\orders\olist_products_dataset.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	CODEPAGE = '65001',
	TABLOCK
);
SELECT *
FROM bronze.olist_products_dataset;

DROP TABLE IF EXISTS bronze.olist_sellers_dataset;
CREATE TABLE bronze.olist_sellers_dataset (
	seller_id VARCHAR(50),
	seller_zip_code_prefix VARCHAR(50),
	seller_city VARCHAR(50),
	seller_state VARCHAR(50)
);
BULK INSERT bronze.olist_sellers_dataset
FROM 'C:\Users\mathe\Desktop\olist_ecom\orders\olist_sellers_dataset.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	CODEPAGE = '65001',
	TABLOCK
);
SELECT *
FROM bronze.olist_sellers_dataset;

DROP TABLE IF EXISTS bronze.product_category_name_translation;
CREATE TABLE bronze.product_category_name_translation (
	product_category_name VARCHAR(50),
	product_category_name_english VARCHAR(50)
);
BULK INSERT bronze.product_category_name_translation
FROM 'C:\Users\mathe\Desktop\olist_ecom\orders\product_category_name_translation.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	CODEPAGE = '65001',
	TABLOCK
);
SELECT *
FROM bronze.product_category_name_translation;

