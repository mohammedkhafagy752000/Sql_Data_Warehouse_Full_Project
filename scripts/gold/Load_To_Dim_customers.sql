CREATE VIEW gold.dim_customers AS
SELECT 
ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
cst_id as customer_id,
cst_key as customer_number,
cst_firstname as first_name,
cst_lastname as last_name,
LA.cntry as country,
cst_marital_status as marital_status,
CASE WHEN CI.cst_gndr != 'N/A' THEN CI.cst_gndr  -- CRM IS THE MASTER
ELSE COALESCE( CA.gen,'N/A')
END AS gender,
CA.bdate as birthdate,
cst_create_date as create_date
FROM silver.crm_cust_info CI
LEFT JOIN silver.erp_cust_az12 CA 
ON        CI.cst_key= CA.cid
LEFT JOIN silver.erp_loc_a101 LA
ON        CI.cst_key= LA.cid