SELECT 'date1到date2用量',round((t1.cost+t2.cost)/1000,1) AS week1,
        'K，date3到date4用量', round((t3.cost+t4.cost)/1000,1) AS week2,
         'K，变化',round((t3.cost+t4.cost-t1.cost-t2.cost)/1000,1) AS diff,
         'K，',round(100*(t3.cost+t4.cost-t1.cost-t2.cost)/(t1.cost+t2.cost),1) AS rate,
	'%。'
FROM 
    (SELECT sum(line_item_unblended_cost)*0.66 AS cost,
         'name' AS name
    FROM customer_all
    WHERE date_format(line_item_usage_start_date,'%Y-%m-%d')
        BETWEEN 'date1'
            AND 'date2'
            AND line_item_line_item_type = 'Usage'
            AND line_item_product_code != 'AmazonCloudFront') t1
JOIN 
    (SELECT sum(line_item_unblended_cost) AS cost,
         'name' AS name
    FROM customer_all
    WHERE date_format(line_item_usage_start_date,'%Y-%m-%d')
        BETWEEN 'date1'
            AND 'date2'
            AND line_item_line_item_type = 'Usage'
            AND line_item_product_code = 'AmazonCloudFront') t2
    ON (t1.name=t2.name)
JOIN 
    (SELECT sum(line_item_unblended_cost)*0.66 AS cost,
         'name' AS name
    FROM customer_all
    WHERE date_format(line_item_usage_start_date,'%Y-%m-%d')
        BETWEEN 'date3'
            AND 'date4'
            AND line_item_line_item_type = 'Usage'
            AND line_item_product_code != 'AmazonCloudFront') t3
    ON (t2.name=t3.name)
JOIN 
    (SELECT sum(line_item_unblended_cost) AS cost,
         'name' AS name
    FROM customer_all
    WHERE date_format(line_item_usage_start_date,'%Y-%m-%d')
        BETWEEN 'date3'
            AND 'date4'
            AND line_item_line_item_type = 'Usage'
            AND line_item_product_code = 'AmazonCloudFront') t4
    ON (t4.name=t3.name)
