SELECT 'department' as dptmt, 'value' as depdiff, coalesce(t1.Service,
         t2.Service) AS service,
         round((t2.week2-t1.week1)/1000,1) AS diff
FROM ( 
    (SELECT sum(line_item_unblended_cost)*discount AS week1,
         line_item_product_code AS Service
    FROM customer_all
    WHERE date_format(line_item_usage_start_date,'%Y-%m-%d')
        BETWEEN 'date1'
            AND 'date2'
            AND UPPER(departmentTag)='department'
            AND line_item_line_item_type = 'Usage'
            AND line_item_product_code != 'AmazonCloudFront'
    GROUP BY  line_item_product_code)
    UNION
        (SELECT sum(line_item_unblended_cost) AS week1,
         line_item_product_code AS Service
        FROM customer_all
        WHERE date_format(line_item_usage_start_date,'%Y-%m-%d')
            BETWEEN 'date1'
                AND 'date2'
                AND UPPER(departmentTag)='department'
                AND line_item_line_item_type = 'Usage'
                AND line_item_product_code = 'AmazonCloudFront'
        GROUP BY  line_item_product_code)) t1 full
    JOIN ( 
        (SELECT sum(line_item_unblended_cost)*discount AS week2,
         line_item_product_code AS Service
        FROM customer_all
        WHERE date_format(line_item_usage_start_date,'%Y-%m-%d')
            BETWEEN 'date3'
                AND 'date4'
                AND UPPER(departmentTag)='department'
                AND line_item_line_item_type = 'Usage'
                AND line_item_product_code != 'AmazonCloudFront'
        GROUP BY  line_item_product_code)
        UNION
            (SELECT sum(line_item_unblended_cost) AS week2,
         line_item_product_code AS Service
            FROM customer_all
            WHERE date_format(line_item_usage_start_date,'%Y-%m-%d')
                BETWEEN 'date3'
                    AND 'date4'
                    AND UPPER(departmentTag)='department'
                    AND line_item_line_item_type = 'Usage'
                    AND line_item_product_code = 'AmazonCloudFront'
            GROUP BY  line_item_product_code)) t2
            ON t1.Service=t2.Service
