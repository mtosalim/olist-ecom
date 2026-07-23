
USE OlistEcom;
GO

SELECT *
FROM bronze.olist_customers_dataset;

DROP TABLE IF EXISTS silver.olist_customers_dataset;
CREATE TABLE silver.olist_customers_dataset (
	customer_id VARCHAR(50) PRIMARY KEY,
	customer_unique_id VARCHAR(50),
	customer_zip_code_prefix INT,
	customer_city VARCHAR(50),
	customer_state VARCHAR(5)
)
INSERT INTO silver.olist_customers_dataset 
	(
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
	)
SELECT
	REPLACE(customer_id, '"', ''),
	REPLACE(customer_unique_id, '"', ''),
	TRY_CAST(REPLACE(customer_zip_code_prefix, '"', '') AS INT),
	COALESCE(customer_city, 'Sem dados'),
	COALESCE(customer_state, 'Sem dados')
FROM bronze.olist_customers_dataset;

SELECT *
FROM silver.olist_customers_dataset

SELECT *
FROM bronze.olist_order_items_dataset;
DROP TABLE IF EXISTS silver.olist_order_items_dataset;
CREATE TABLE silver.olist_order_items_dataset (
	order_id VARCHAR(40),
	order_item_id INT,
	product_id VARCHAR(40),
	seller_id VARCHAR(40),
	shipping_limit_date DATETIME,
	price DECIMAL(10,2),
	freight_value DECIMAL(10,2)
)
INSERT INTO silver.olist_order_items_dataset (
	order_id,
	order_item_id,
	product_id,
	seller_id,
	shipping_limit_date,
	price,
	freight_value
)
SELECT 
	TRY_CAST(REPLACE(order_id, '"', '') AS VARCHAR),
	TRY_CAST(order_item_id AS INT),
	TRY_CAST(REPLACE(product_id, '"', '') AS VARCHAR),
	TRY_CAST(REPLACE(seller_id, '"', '') AS VARCHAR),
	--TRY_CONVERT(DATETIME, shipping_limit_date),
	TRY_CONVERT(DATETIME, shipping_limit_date, 103),
	TRY_CAST(price AS DECIMAL(10,2)),
	TRY_CAST(freight_value AS DECIMAL(10,2))
FROM bronze.olist_order_items_dataset

select *
from silver.olist_order_items_dataset



SELECT *
FROM bronze.olist_geolocation_dataset;
DROP TABLE IF EXISTS silver.olist_geolocation_dataset;
CREATE TABLE silver.olist_geolocation_dataset (
	geolocation_zip_code_prefix INT,
	geolocation_lat VARCHAR(30),
	geolocation_lng VARCHAR(30),
	geolocation_city VARCHAR(50),
	geolocation_state VARCHAR(50)
	)
INSERT INTO silver.olist_geolocation_dataset (
	geolocation_zip_code_prefix,
	geolocation_lat,
	geolocation_lng,
	geolocation_city,
	geolocation_state
	)
SELECT 
	REPLACE(geolocation_zip_code_prefix, '"', ''),
	TRY_CAST(geolocation_lat AS VARCHAR),
	TRY_CAST(geolocation_lng AS VARCHAR),
	LOWER(TRIM(geolocation_city)),
	--TRY_CAST(LOWER(TRIM(geolocation_state)) AS VARCHAR),
	COALESCE(
		CASE WHEN TRY_CAST(TRIM(geolocation_state) AS VARCHAR) = 'bahia, brasil",ba'
		THEN 'ba'
		WHEN TRY_CAST(TRIM(geolocation_state) AS VARCHAR) = 'rio de janeiro, brasil",rj'
		THEN 'rj'
		ELSE geolocation_state
		END, 'sem dados') AS geolocation_state
FROM bronze.olist_geolocation_dataset;

SELECT *
FROM silver.olist_geolocation_dataset;


SELECT TOP 20 *
FROM bronze.olist_order_payments_dataset
DROP TABLE IF EXISTS silver.olist_order_payments_dataset;
CREATE TABLE silver.olist_order_payments_dataset (
	order_id VARCHAR(50),
	payment_sequential INT,
	payment_type VARCHAR(20),
	payment_installments INT,
	payment_value DECIMAL(10,2)
)
INSERT INTO silver.olist_order_payments_dataset (
	order_id,
	payment_sequential,
	payment_type,
	payment_installments,
	payment_value
)
SELECT 
	TRY_CAST(REPLACE(order_id, '"', '') AS VARCHAR),
	TRY_CAST(payment_sequential AS INT),
	TRY_CAST(
	CASE WHEN payment_type = 'credit_card' THEN 'Cartão de crédito'
	WHEN payment_type = 'debit_card' THEN 'Cartão de débito'
	WHEN payment_type = 'not_defined' THEN 'Outros'
	WHEN payment_type = 'voucher' THEN 'Voucher'
	WHEN payment_type = 'boleto' THEN 'Boleto bancário'
	END AS VARCHAR),
	TRY_CAST(payment_installments AS INT),
	TRY_CAST(payment_value AS DECIMAL(10,2))
FROM bronze.olist_order_payments_dataset

SELECT TOP 50 *
FROM silver.olist_order_payments_dataset

SELECT COUNT(payment_type) as qtd, payment_type
FROM silver.olist_order_payments_dataset
GROUP BY payment_type
ORDER BY payment_type ASC

SELECT TOP 20 *
FROM bronze.olist_orders_dataset;
DROP TABLE IF EXISTS silver.olist_orders_dataset;
CREATE TABLE silver.olist_orders_dataset (
	order_id VARCHAR(50),
	customer_id VARCHAR(50),
	order_status VARCHAR(20),
	order_purchase_timestamp DATETIME2(0)
	--order_approved_at DATETIME,
	--order_delivered_carrier_date DATETIME,
	--order_delivered_customer_date DATETIME,
	--order_estimated_delivery_date DATE
)
INSERT INTO silver.olist_orders_dataset (
	order_id,
	customer_id,
	order_status,
	order_purchase_timestamp
	--order_approved_at,
	--order_delivered_carrier_date,
	--order_delivered_customer_date,
	--order_estimated_delivery_date
)
SELECT 
	TRY_CAST(REPLACE(order_id, '"', '') AS VARCHAR),
	TRY_CAST(REPLACE(customer_id, '"', '') AS VARCHAR),
	TRY_CAST(order_status AS VARCHAR),
	TRY_CONVERT(DATETIME2(0), order_purchase_timestamp)
	--COALESCE(TRY_CAST(order_purchase_timestamp AS DATETIME), 'Undefined'),
	--COALESCE(TRY_CAST(order_approved_at AS DATETIME), 'Undefined'),
	--COALESCE(TRY_CAST(order_delivered_carrier_date AS DATETIME), 'Undefined'),
	--COALESCE(TRY_CAST(order_delivered_customer_date AS DATETIME), 'Undefined'),
	--COALESCE(TRY_CAST(order_estimated_delivery_date AS DATE), 'Undefined')
FROM bronze.olist_orders_dataset;

select * from silver.olist_orders_dataset