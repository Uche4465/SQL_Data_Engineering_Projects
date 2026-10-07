/*
Question: What are the most in-demand skills for data engineers?
-- Identify the top 10 in-demand skills for data engineers
-- Focus on Remote Job postings
-- Why? Retrieves the top 10 skills with the highest demand in the remote job market,
providing insights into the most valuable skills for data engineers seeking remote opportunities. 
*/


-- for displaying the list of tables
SHOW TABLES;   

SELECT table_name
FROM information_schema.tables;

-- for displaying the columns of a table
DESCRIBE job_postings_fact;
DESCRIBE skills_job_dim;
DESCRIBE skills_dim;

-- exploring the job_postings_fact table
SELECT
    *
FROM
    job_postings_fact AS jpf
LIMIT 10;


SELECT
    job_location,  
    job_via,
    job_schedule_type,
    job_work_from_home, 
    search_location,
    job_posted_date 
FROM
    job_postings_fact AS jpf
LIMIT 10;


SELECT
    job_no_degree_mention,
    job_health_insurance,
    job_country  
FROM
    job_postings_fact AS jpf
LIMIT 10; 


-- exploring the skills_dim table
SELECT
    *
FROM
    skills_dim  AS sd
LIMIT 10;


-- exploring the skills_dim table
SELECT
    *
FROM
    skills_job_dim  AS sjd
LIMIT 10;


-- Combining the job_postings_fact, skills_job_dim, 
-- and skills_dim tables to identify the most in-demand skills 
-- for data engineers in remote job postings.
SELECT
    *
FROM
    job_postings_fact AS jpf
INNER JOIN
    skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
LIMIT 10; 


-- This query retrieves the top 10 
-- that appears in the greatest number of job postings. 
SELECT
    sd.skills,
    COUNT(jpf.*) AS demand_count
FROM
    job_postings_fact AS jpf
INNER JOIN
    skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
GROUP BY
    sd.skills
ORDER BY
    demand_count DESC
LIMIT 10; 



-- This query retrieves the top 10 skills that appear 
-- in the greatest number of remote job postings for 
-- data engineers. 
SELECT
    sd.skills,
    COUNT(jpf.*) AS demand_count
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
ORDER BY
    demand_count DESC
LIMIT 10; 

/*

RESULT:::::
┌────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │        29221 │
│ python     │        28776 │
│ aws        │        17823 │
│ azure      │        14143 │
│ spark      │        12799 │
│ airflow    │         9996 │
│ snowflake  │         8639 │
│ databricks │         8183 │
│ java       │         7267 │
│ gcp        │         6446 │
└────────────┴──────────────┘

*/