/*
Question: What are the highest paying skills for data engineers?
- Calculate the median salary for each skill required in data engineering job postings
- Focus on Remote positions with specified salaries
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the heighest compensation while also showing
  how common those skills are in the job market, providing a comprehensive view of skill value for data engineers seeking remote opportunities.
*/


SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg),0) AS median_salary,
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
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    median_salary DESC
LIMIT 25; 


/* SOLUTION

┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ rust       │      210000.0 │          232 │
│ golang     │      184000.0 │          912 │
│ terraform  │      184000.0 │         3248 │
│ spring     │      175500.0 │          364 │
│ neo4j      │      170000.0 │          277 │
│ gdpr       │      169616.0 │          582 │
│ zoom       │      168438.0 │          127 │
│ graphql    │      167500.0 │          445 │
│ mongo      │      162250.0 │          265 │
│ fastapi    │      157500.0 │          204 │
│ django     │      155000.0 │          265 │
│ bitbucket  │      155000.0 │          478 │
│ crystal    │      154224.0 │          129 │
│ c          │      151500.0 │          444 │
│ atlassian  │      151500.0 │          249 │
│ typescript │      151000.0 │          388 │
│ kubernetes │      150500.0 │         4202 │
│ ruby       │      150000.0 │          736 │
│ node       │      150000.0 │          179 │
│ css        │      150000.0 │          262 │
│ airflow    │      150000.0 │         9996 │
│ redis      │      149000.0 │          605 │
│ vmware     │      148798.0 │          136 │
│ ansible    │      148798.0 │          475 │
│ jupyter    │      147500.0 │          400 │
└────────────┴───────────────┴──────────────┘
  25 rows                         3 columns

Key findings:

Rust has the highest median salary at $210,000, although its demand count is relatively low at 232 postings.
Golang and Terraform both have a median salary of $184,000. Terraform stands out because it appears in 3,248 postings, compared with 912 for Golang.
Kubernetes has a median salary of $150,500 but appears in 4,202 postings, indicating substantially higher demand.
Airflow has a median salary of $150,000 and the highest demand in your results, appearing in 9,996 postings.
Therefore, salary alone doesn't tell the whole story. 
Some skills command very high salaries but occur less frequently, 
while others have slightly lower median salaries but are much more commonly requested.



Conclusion: 

The analysis shows that the highest-paying data engineering skills are not necessarily the most frequently demanded. 
Rust has the highest median salary at $210,000, while Airflow has the highest demand with 9,996 job postings and a median salary of $150,000. 
Terraform is particularly notable because it combines a relatively high median salary of $184,000 with strong demand across 3,248 postings. Overall, 
the results suggest that data engineers should consider both earning potential and market demand when evaluating which technical skills to develop.
*/