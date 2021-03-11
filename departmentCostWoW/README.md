# Assumptions:
- [CUR enabled](https://docs.aws.amazon.com/cur/latest/userguide/cur-create.html) and [Athena intergrated](https://docs.aws.amazon.com/cur/latest/userguide/cur-query-athena.html)
- The week start from Sunday
- All the amount keep 1 digit after the decimal point and less than 0.1K will be ignored

# Usage
- run ./wow.sh without any paramater
- you will get 2 SQLs which can be run in Athena 
