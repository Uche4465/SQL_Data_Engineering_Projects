/*
What are the most optimal skills for data engineers -- balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
Why?
   This approach highlights skills that bbalance market demand and financial reward.
   It weights core skills appropriately, rather than letting rare, outlier skills distort the results.
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg),0) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    COUNT(jpf.salary_year_avg) AS corrected_demand_count
FROM
    job_postings_fact AS jpf
INNER JOIN
    skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_work_from_home = True 
    AND
    jpf.job_title_short = 'Data Engineer'
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    median_salary DESC
LIMIT 25; 



SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg),0) AS median_salary,
    COUNT(jpf.salary_year_avg) AS demand_count
FROM
    job_postings_fact AS jpf
INNER JOIN
    skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_work_from_home = True 
    AND
    jpf.job_title_short = 'Data Engineer'
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    median_salary DESC
LIMIT 25; 




SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg),0) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.salary_year_avg)), 1) AS ln_demand_count, 
    MEDIAN(jpf.salary_year_avg) * COUNT(jpf.salary_year_avg) AS optimal_score   
FROM
    job_postings_fact AS jpf
INNER JOIN
    skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_work_from_home = True 
    AND
    jpf.job_title_short = 'Data Engineer'
    AND
    jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    optimal_score DESC
LIMIT 25; 




SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg),0) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count, 
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)))/1_000_000, 2) AS optimal_score   
FROM
    job_postings_fact AS jpf
INNER JOIN
    skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_work_from_home = True 
    AND
    jpf.job_title_short = 'Data Engineer'
    AND
    jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    optimal_score DESC
LIMIT 25; 


/*
RESULTS:

┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar   │    double     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ terraform  │      184000.0 │          193 │             5.3 │          0.97 │
│ python     │      135000.0 │         1133 │             7.0 │          0.95 │
│ aws        │      137320.0 │          783 │             6.7 │          0.91 │
│ sql        │      130000.0 │         1128 │             7.0 │          0.91 │
│ airflow    │      150000.0 │          386 │             6.0 │          0.89 │
│ spark      │      140000.0 │          503 │             6.2 │          0.87 │
│ kafka      │      145000.0 │          292 │             5.7 │          0.82 │
│ snowflake  │      135500.0 │          438 │             6.1 │          0.82 │
│ azure      │      128000.0 │          475 │             6.2 │          0.79 │
│ java       │      135000.0 │          303 │             5.7 │          0.77 │
│ scala      │      137290.0 │          247 │             5.5 │          0.76 │
│ git        │      140000.0 │          208 │             5.3 │          0.75 │
│ kubernetes │      150500.0 │          147 │             5.0 │          0.75 │
│ databricks │      132750.0 │          266 │             5.6 │          0.74 │
│ redshift   │      130000.0 │          274 │             5.6 │          0.73 │
│ gcp        │      136000.0 │          196 │             5.3 │          0.72 │
│ nosql      │      134415.0 │          193 │             5.3 │          0.71 │
│ hadoop     │      135000.0 │          198 │             5.3 │          0.71 │
│ pyspark    │      140000.0 │          152 │             5.0 │           0.7 │
│ docker     │      135000.0 │          144 │             5.0 │          0.67 │
│ mongodb    │      135750.0 │          136 │             4.9 │          0.67 │
│ go         │      140000.0 │          113 │             4.7 │          0.66 │
│ r          │      134775.0 │          133 │             4.9 │          0.66 │
│ github     │      135000.0 │          127 │             4.8 │          0.65 │
│ bigquery   │      135000.0 │          123 │             4.8 │          0.65 │
└────────────┴───────────────┴──────────────┴─────────────────┴───────────────┘


Conclusion

The analysis shows that the most valuable skills for remote Data Engineer roles are not necessarily the skills with the highest salaries or the highest demand individually, but those that offer the strongest combination of both.
Terraform ranks first with an optimal score of 0.97, supported by the highest median salary in the analysis at $184,000. Although its demand count of 193 is relatively moderate, its strong salary potential makes it highly valuable.
Python follows closely with a score of 0.95, offering the strongest overall balance between demand and compensation. With 1,133 job postings and a median salary of $135,000, Python appears to be one of the safest and most broadly valuable skills for Data Engineers.
AWS and SQL both score 0.91, reinforcing their importance as core Data Engineering skills. SQL has extremely high demand at 1,128 postings, while AWS combines strong demand with a slightly higher median salary of $137,320.

Technologies such as Airflow, Spark, Kafka, and Snowflake also rank highly, showing that employers place significant value on skills related to workflow orchestration, distributed data processing, streaming systems, and cloud data warehousing.

Overall, the results suggest that an effective Data Engineering skill set should combine:
* Core programming and querying: Python and SQL
* Cloud infrastructure: AWS
* Data processing and orchestration: Spark and Airflow
* Infrastructure as Code: Terraform
* Streaming and modern data platforms: Kafka and Snowflake

Rather than pursuing rare technologies purely because they advertise high salaries, Data Engineers can maximize their career opportunities by prioritizing skills that consistently appear across job postings while still commanding strong compensation. 
The ranking therefore provides a more practical measure of market value, balancing both earning potential and employability.