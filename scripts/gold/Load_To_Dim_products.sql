CREATE VIEW gold.dim_products AS
SELECT 
ROW_NUMBER() OVER (ORDER BY prd_start_dt, prd_key) AS product_key,
    prd_id AS product_id,
    prd_key as product_number,
    prd_nm as product_name,
    cat_id as category_id,
    pc.cat as category,
    pc.subcat as subcategory,
    pc.maintenance,
    prd_cost as cost,
    prd_line as product_line,
    prd_start_dt as start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
on pn.cat_id= pc.id