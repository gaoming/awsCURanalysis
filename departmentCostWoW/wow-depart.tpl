SELECT coalesce(t1.tag,t2.tag,t3.tag,t4.tag) AS dptmt,
         round((COALESCE(t3.cost,0)+COALESCE(t4.cost,0) - COALESCE(t1.cost,0)-COALESCE(t2.cost,0))/1000,1) as diff
FROM 
    (SELECT sum(line_item_unblended_cost)*discount AS cost,
         UPPER(departmentTag) AS tag
    FROM customer_all
    WHERE date_format(line_item_usage_start_date,'%Y-%m-%d')
        BETWEEN 'date1'
            AND 'date2'
            AND line_item_line_item_type = 'Usage'
            AND line_item_product_code != 'AmazonCloudFront'
    GROUP BY  UPPER(departmentTag)) t1 FULL
JOIN 
    (SELECT sum(line_item_unblended_cost) AS cost,
         UPPER(departmentTag) AS tag
    FROM customer_all
    WHERE date_format(line_item_usage_start_date,'%Y-%m-%d')
        BETWEEN 'date1'
            AND 'date2'
            AND line_item_line_item_type = 'Usage'
            AND line_item_product_code = 'AmazonCloudFront'
    GROUP BY  UPPER(departmentTag)) t2 ON(t2.tag=t1.tag) FULL
JOIN 
    (SELECT sum(line_item_unblended_cost)*discount AS cost,
         UPPER(departmentTag) AS tag
    FROM customer_all
    WHERE date_format(line_item_usage_start_date,'%Y-%m-%d')
        BETWEEN 'date3'
            AND 'date4'
            AND line_item_line_item_type = 'Usage'
            AND line_item_product_code != 'AmazonCloudFront'
    GROUP BY  UPPER(departmentTag)) t3 ON(t3.tag=t1.tag) FULL
JOIN 
    (SELECT sum(line_item_unblended_cost) AS cost,
         UPPER(departmentTag) AS tag
    FROM customer_all
    WHERE date_format(line_item_usage_start_date,'%Y-%m-%d')
        BETWEEN 'date3'
            AND 'date4'
            AND line_item_line_item_type = 'Usage'
            AND line_item_product_code = 'AmazonCloudFront'
    GROUP BY  UPPER(departmentTag)) t4 ON(t4.tag=t2.tag) 
order by abs(diff) desc
