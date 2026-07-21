------------ CHECK QUALITY OF crm_cust_info TABLE-----------

-- CHECK FOR NULLS OR DUPLICATES IN PK
SELECT cst_id, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 OR cst_id IS NULL;

-- CHECK UNWANTED DATA : FIRST NAME 
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- CHECK UNWANTED SPACE : LAST NAME 
SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

-- CHECK NULLS IN cst_gndr
SELECT DISTINCT cst_gndr 
FROM bronze.crm_cust_info


------------ CHECK QUALITY OF crm_prd_info TABLE-----------
-- CHECK UNWANTED SPACE : prd_nm 
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- CHECK NULLS OR NEGATIVE VALUES: prd_cost
SELECT *
FROM bronze.crm_prd_info
WHERE prd_cost <0 OR prd_cost IS NULL

-- CHECK NULLS IN prd_line
SELECT DISTINCT prd_line 
FROM bronze.crm_prd_info

-- CHECK FOR INVALID DATE ORDERS
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt< prd_start_dt;

------------ CHECK QUALITY OF crm_sales_details TABLE-----------
-- CHECK UNWANTED SPACE : sls_ord_num 
SELECT *
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)

--CHECK SLS_OEDER_DT QUALITY
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt<=0 
OR  LEN(sls_order_dt) !=8 
OR sls_order_dt<19000101 
OR sls_order_dt>20500101

--CHECK sls_ship_dt QUALITY
SELECT *
FROM bronze.crm_sales_details
WHERE sls_ship_dt<=0 
OR  LEN(sls_ship_dt) !=8 
OR sls_ship_dt<19000101 
OR sls_ship_dt>20500101

-- CHECK LOGIC: ORDER DATE SHOUD BE BEFORE SHIP DATE
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- CHECK QUALITY OF SALES S, QUANTITY Q, AND PRICE P
   --> S= Q*P
   --> VALUES MUST NOT BE NULLS, NEGATIVE, ZEROS
SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR  sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <=0 OR  sls_quantity <=0 OR sls_price <=0
ORDER BY sls_sales,sls_quantity,sls_price

-- CHECK QUALITY erp_cust_az12 TABLE
SELECT cid,
       bdate,
       gen
FROM bronze.erp_cust_az12
where bdate > GETDATE();

SELECT DISTINCT GEN 
FROM bronze.erp_cust_az12
 

 -- CHECK QUALITY erp_loc_a101 TABLE
SELECT REPLACE( cid,'-','') FROM bronze.erp_loc_a101
where  REPLACE( cid,'-','') NOT IN (SELECT cst_key FROM silver.crm_cust_info);

 -->  CHECK cntry consistency
  SELECT DISTINCT cntry
  FROM bronze.erp_loc_a101
  ORDER BY cntry

   -- CHECK QUALITY erp_px_cat_g1v2 TABLE
    --> CHECK UNWANTED SPACE
   SELECT *
   FROM bronze.erp_px_cat_g1v2
   WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)
