# Assumptions:
- [CUR enabled](https://docs.aws.amazon.com/cur/latest/userguide/cur-create.html) and [Athena intergrated](https://docs.aws.amazon.com/cur/latest/userguide/cur-query-athena.html)
- The data is for the past 2 weeks starting from Sunday
- The unit of the amoun is k$ and keep 1 digit after the decimal point

# Usage
- run ./wow.sh without any paramater
- you will get 2 SQLs which can be run in Athena.
1. The SQl under "==Company Total==" can get the cost information of the account or company in the past 2 weeks
2. The SQl under "==Department Total==" can get the total cost change of each department in the past 2 weeks
- Download the query result of "==Department Total==".  We will use the result as the parameter for the next run. There are 2 columns in the table, department name and the cost change. Copy all the data and add ":" between the 2 columns, keep the string in multiple lines or insert a space between them.
- Run ./wow.sh with the string get in the last step as parameter
- You get a new SQL can be used to analyse the service cost change of each department
