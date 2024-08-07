# ETL_AWS
For this architecture I have decided to use AWS to load the data and process it.
For the data warehouse, I have used Snowflake and Tableu to visualize the data.

### Challenge #1
You are a data engineer at Globant and you are about to start an important project. This project
is big data migration to a new database system. You need to create a PoC to solve the next
requirements:
1. Move historic data from files in CSV format to the new database.__
2. Create a Rest API service to receive new data. This service must have:<br>
&emsp;2.1. Each new transaction must fit the data dictionary rules.<br>
&emsp;2.2. Be able to insert batch transactions (1 up to 1000 rows) with one request.<br>
&emsp;2.3. Receive the data for each table in the same service.<br>
&emsp;2.4. Keep in mind the data rules for each table.
3. Create a feature to backup for each table and save it in the file system in AVRO format.
4. Create a feature to restore a certain table with its backup.

In order to achive the solution desired, I will work in AWS, where we will store our data in a `Landing` bucket. Then as soon as a `.xlsx` file is uploaded, a `lambda` will be trigger, and will convert `.xlsx` file into `.csv`, then save it into a `Tranformed` bucket.
After that, a `crawler` will explore the `.csv` data, and will get the schema to save the tables in `Glue`.
Then a `Glue ETL` will run a `spark` script to store the data in Snowflake, and will store a `.avro` in `Backup` Bucket.
`Glue ETL` can get the snowflake credentials and basic details from `Secrets Manager`.

![Diagram](Images/ETL.png)

### For Challenge #2
1. Number of employees hired for each job and department in 2021 divided by quarter. The table must be ordered alphabetically by department and job.

In order to achive this challenge, I connected `Snowflake` with `Tableau` to be able to visualize the data.

We can access to the graphic here: [Employees Hired per Quarter 2021](https://us-west-2b.online.tableau.com/#/site/globant/views/Globant/Sheet1?:iid=1 "Employees Hired per Quarter 2021")

This is the query used to extract the data, it was needed to pivot it in Tableau:
```sql
SELECT 
    d.department AS department, 
    j.job AS job,
    CASE 
        WHEN e.DATETIME LIKE '%T%' THEN QUARTER(DATE(DATETIME))
        ELSE 0
    END AS time_quarter,
    count(*) AS TOTAL
FROM GLOBANT.PUBLIC.JOBS j
LEFT JOIN GLOBANT.PUBLIC.EMPLOYEES e
ON j.id = e.job_id
LEFT JOIN GLOBANT.PUBLIC.DEPARTMENTS d
ON d.id = e.department_id
WHERE 
    e.DATETIME IS NOT NULL
    OR YEAR(DATE(e.DATETIME)) = 2021
    AND time_quarter > 0
GROUP BY 1, 2, 3;
```

2. List of ids, name and number of employees hired of each department that hired more employees than the mean of employees hired in 2021 for all the departments, ordered by the number of employees hired (descending).

We can access to the graphic here: [Hired Bigger Than Average](https://us-west-2b.online.tableau.com/#/site/globant/views/Globant/Sheet2?:iid=2 "Hired Bigger Than Average")

This is the query used to extract the data:

```sql
SELECT
    d.id,
    d.department,
    COUNT(*) AS HIRED
FROM GLOBANT.PUBLIC.DEPARTMENTS d
LEFT JOIN GLOBANT.PUBLIC.EMPLOYEES e
ON e.department_id = d.id
GROUP BY d.id, d.department
HAVING COUNT(*) > (
    WITH total_hired AS (
        SELECT
            d.id,
            d.department,
            COUNT(*) AS HIRED
        FROM GLOBANT.PUBLIC.DEPARTMENTS d
        LEFT JOIN GLOBANT.PUBLIC.EMPLOYEES e
        ON e.department_id = d.id
        GROUP BY d.id, d.department
    )
    SELECT AVG(HIRED)
    FROM total_hired
)
ORDER BY HIRED DESC;
```

Please note that in order to get the results, they have been extracted to Excel, and they can be found in the folder called `Requierements`

### What can be improved?
1. The `Lambda` can be changed to read `.xlsx` from `spark` directly
2. Clean the data before upload it to `Snowflake`. There is a step in `spark` to `dropna` data, but it is not enough.
3. Protect `PII` data, by protect it, with `SHA`, or by delete it.
4. Add an `Schema` to the dataframes in `spark`.
5. The queries to visualize the data can be stored as `Fact Tables`.
6. It is possible to create a [stage](https://docs.snowflake.com/en/user-guide/data-load-s3-create-stage, "Stage data in Snowflake") in `Snowflake` to load data directly from the `bucket` and create an `ELT` job, instead of an `ETL`.
7. In order to backup `Snowflake` tables, it is possible to use [Unload data](https://docs.snowflake.com/en/user-guide/data-unload-s3, "Unload Snowflake Data")
