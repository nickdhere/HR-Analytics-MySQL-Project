CREATE SCHEMA HR_SCHEMA;

USE HR_SCHEMA;

-- creating the table
CREATE TABLE project_hr
(
employee_id INT,
department VARCHAR(250),
region VARCHAR(250),
education VARCHAR(250),
gender VARCHAR(250),
recruitment_channel VARCHAR(250),
no_of_trainings INT,
age INT,
previous_year_rating varchar(250),
length_of_service INT,
KPIs_met_more_than_80 INT,
awards_won INT,
avg_training_score INT
);


SELECT * FROM project_hr;
DESC project_hr;


-- Step 1: Removing duplicate rows

SELECT COUNT(employee_id) 
FROM project_hr;

SELECT (COUNT(employee_id) - COUNT(DISTINCT employee_id)) no_of_duplicates
FROM project_hr;

-- checking the duplicate rows
SELECT 
	employee_id, 
    count(employee_id)
FROM 
	project_hr
GROUP BY 1
HAVING 
	count(employee_id) > 1    ;

-- deleting the duplicates
DELETE FROM project_id
WHERE 
	employee_id IN (
	SELECT 
		employee_id
	FROM (
		SELECT 
			employee_id,
			ROW_NUMBER() OVER (
				PARTITION BY employee_id
				ORDER BY employee_id) AS row_num
		FROM 
			project_hr
		
	) t
    WHERE row_num > 1
);
-- dealt with duplicates


-- Step 2: Removing rows for which numeric columns are having irrelevant data type values
DESC project_hr;

SELECT DISTINCT previous_year_rating
FROM project_hr;


SELECT COUNT(previous_year_rating)
FROM project_hr
WHERE previous_year_rating = 'None';



-- finding mean, median, mode for previous_year_rating for imputing
SELECT AVG(previous_year_rating) AS MEAN
FROM project_hr
WHERE previous_year_rating != 'None';
-- mean is approx 3.34


SELECT MAX(previous_year_rating) AS MODE
FROM project_hr
WHERE previous_year_rating = (
							SELECT previous_year_rating
                            FROM project_hr
                            GROUP BY previous_year_rating
                            ORDER BY count(previous_year_rating) DESC
                            LIMIT 1)
                            ;
-- mode is 3
-- MEDIAN
								
SET @rowindex := 0;
SELECT
   AVG(pp.previous_year_rating) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           p.previous_year_rating AS previous_year_rating
    FROM project_hr p
    ORDER BY p.previous_year_rating) AS pp
WHERE
pp.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));
-- median = 3

-- So mean, mode and median values are almost near 3 hence imputing the null values with 3

-- imputing the null values
UPDATE project_hr
SET previous_year_rating = 3
WHERE previous_year_rating = 'None';


-- rechecking the null values of previous_year_rating
SELECT COUNT(previous_year_rating)
FROM project_hr
WHERE previous_year_rating = 'None';

-- Now changing the datatype to int
ALTER TABLE project_hr
MODIFY COLUMN previous_year_rating INT;

-- checking the datatype for each column
SELECT column_name, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE table_schema = 'hr_schema' AND table_name = 'project_hr';

-- we checked all the datatypes and each column is assigned correct datatype

-- checking null_values_count for each column
SELECT 
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS age_null_count,
    SUM(CASE WHEN avg_training_score IS NULL THEN 1 ELSE 0 END) AS avg_training_null_count,
    SUM(CASE WHEN awards_won IS NULL THEN 1 ELSE 0 END) AS awards_won_null_count,
    SUM(CASE WHEN department IS NULL THEN 1 ELSE 0 END) AS deapt_null_count,
    SUM(CASE WHEN education IS NULL THEN 1 ELSE 0 END) AS education_null_count,
    SUM(CASE WHEN employee_id IS NULL THEN 1 ELSE 0 END) AS employeeid_null_count,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender_null_count,
    SUM(CASE WHEN KPIs_met_more_than_80 IS NULL THEN 1 ELSE 0 END) AS KPIs_null_count,
    SUM(CASE WHEN length_of_service IS NULL THEN 1 ELSE 0 END) AS length_of_service_null_count,
    SUM(CASE WHEN no_of_trainings IS NULL THEN 1 ELSE 0 END) AS no_of_trainings_null_count,
    SUM(CASE WHEN previous_year_rating IS NULL THEN 1 ELSE 0 END) AS prev_yr_rating_null_count,
    SUM(CASE WHEN recruitment_channel IS NULL THEN 1 ELSE 0 END) AS recruitment_c_null_count,
    SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) AS region_null_count
FROM
	project_hr;

-- There are no null values for any column.

/*-------------------------------------------------------------------------------------- */
-- ANALYSIS

SELECT * FROM project_hr;


/*
1. Find the average age of employees in each department and gender group.
( Round average  age up to two decimal places if needed)
*/

SELECT department, gender, ROUND(AVG(age),2) Avg_age
FROM project_hr
GROUP BY 1, 2;


/*
2. List the top 3 departments with the highest average training scores.
 ( Round average scores up to two decimal places if needed)
*/
SELECT department, ROUND(AVG(avg_training_score),2) Avg_training_score
FROM
	project_hr
GROUP BY 1
ORDER BY Avg_training_score DESC
LIMIT 3;


/*
3. Find the percentage of employees who have won awards in each region. 
(Round percentages up to two decimal places if needed)
*/

SELECT region, ROUND((SUM(awards_won)/COUNT(region))*100,2) awards_percentage
FROM project_hr
GROUP BY 1
HAVING SUM(awards_won)/COUNT(region) > 0
ORDER BY awards_percentage ;


/* 
4. Show the number of employees who have met more than 80% of
KPIs for each recruitment channel and education level.*/

SELECT recruitment_channel, education, COUNT(employee_id) no_of_employees_having_KPIs_80plus
FROM project_hr
WHERE KPIs_met_more_than_80 >0
GROUP BY 1,2;


/* 5. Find the average length of service for employees in each department,
considering only employees with previous year ratings greater than or equal to 4. 
( Round average length up to two decimal places if needed) */

SELECT department, ROUND(AVG(length_of_service),2) Avg_len_of_service
FROM project_hr
WHERE previous_year_rating >= 4
GROUP BY 1;


/* 6. List the top 5 regions with the highest average previous year ratings. 
( Round average ratings up to two decimal places if needed)*/

SELECT region, ROUND(AVG(previous_year_rating),2) Avg_prev_yr_rating
FROM project_hr
GROUP BY 1
ORDER BY Avg_prev_yr_rating DESC
LIMIT 5;


/* 7. List the departments with more than 100 employees having a length of service greater than 5 years.*/
SELECT department, COUNT(employee_id) as no_of_employee
FROM project_hr
WHERE length_of_service > 5
GROUP BY 1
HAVING COUNT(employee_id) > 100;


/* 8. Show the average length of service for employees who have attended more than 3 trainings, 
grouped by department and gender. 
( Round average length up to two decimal places if needed)*/
SELECT department, gender, ROUND(AVG(length_of_service),2) Avg_len_of_service
FROM project_hr
WHERE no_of_trainings > 3
GROUP BY 1,2;


/* 9. Find the percentage of female employees who have won awards, per department. 
Also show the number of female employees who won awards and total female employees. 
( Round percentage up to two decimal places if needed)*/
SELECT department, 
	ROUND((COUNT(CASE WHEN gender = 'f' AND awards_won > 0 THEN 1 END))/(COUNT(CASE WHEN gender = 'f' THEN 1 END))*100,2) total_F_awards_percent,
	COUNT( CASE WHEN gender = 'f' AND awards_won >0 THEN 1 END) total_F_awards,
    COUNT( CASE WHEN gender = 'f' THEN 1 END) total_F_employees
FROM project_hr
GROUP BY 1;



/* 10. Calculate the percentage of employees per department who have a length of service between 5 and 10 years. 
( Round percentage up to two decimal places if needed)*/
SELECT department, ROUND(COUNT(CASE WHEN length_of_service BETWEEN 5 AND 10 THEN 1 END)/(COUNT(*))*100,2) PERCENT_of_emp
FROM project_hr
GROUP BY 1;


/* 11. Find the top 3 regions with the highest number of employees who have met more than 80% of their KPIs 
and received at least one award, grouped by department and region.*/
SELECT department, region, COUNT(employee_id) no_of_employees
FROM project_hr
WHERE KPIs_met_more_than_80 > 0 AND awards_won > 0
GROUP BY 1,2
ORDER BY no_of_employees DESC
LIMIT 3;


/* 12. Calculate the average length of service for employees per education level and gender, considering only those employees 
who have completed more than 2 trainings and have an average training score greater than 75 
( Round average length up to two decimal places if needed)*/
SELECT education, gender, ROUND(AVG(length_of_service),2) avg_len_of_service
FROM project_hr
WHERE no_of_trainings > 2 AND avg_training_score > 75
GROUP BY 1,2;


/* 13. For each department and recruitment channel, find the total number of employees 
who have met more than 80% of their KPIs, have a previous_year_rating of 5, 
and have a length of service greater than 10 years.*/
SELECT department, recruitment_channel, COUNT(*) no_of_employees
FROM project_hr
WHERE previous_year_rating = 5 AND length_of_service > 10 AND KPIs_met_more_than_80 > 0
GROUP BY 1,2;


/* 14. Calculate the percentage of employees in each department who have received awards, have a previous_year_rating of 4 or 5, 
and an average training score above 70, grouped by department and gender 
( Round percentage up to two decimal places if needed).*/
SELECT department, gender, 
ROUND((COUNT(CASE WHEN awards_won > 0 AND previous_year_rating in (4,5) AND avg_training_score>70 THEN 1 END))/(COUNT(*))*100,2) percentage_of_employees
FROM project_hr
GROUP BY 1,2
ORDER BY percentage_of_employees DESC;


/*
15. List the top 5 recruitment channels with the highest average length of service for employees 
who have met more than 80% of their KPIs, have a previous_year_rating of 5, and an age between 
25 and 45 years, grouped by department and recruitment channel. 
( Round average length up to two decimal places if needed). */
SELECT department, recruitment_channel, ROUND(AVG(length_of_service),2) avg_len_of_service
FROM project_hr
WHERE KPIs_met_more_than_80 > 0 AND previous_year_rating = 5 AND age BETWEEN 25 AND 45
GROUP BY 1,2
ORDER BY avg_len_of_service DESC
LIMIT 5;



/*----------------------------------------------------------------------------------------------*/

-- age wise average  previous_year_rating
SELECT age, AVG(previous_year_rating) avg_prev_yr_rating
FROM project_hr
GROUP BY 1
ORDER BY avg_prev_yr_rating DESC;


-- What is the average training score for male and female employees in each education category?
SELECT education, 
	CASE WHEN MAX(gender = 'f') THEN AVG(avg_training_score) END AS Avg_female_training_score,
    CASE WHEN MAX(gender = 'm') THEN AVG(avg_training_score) END AS Avg_male_training_score
FROM project_hr
WHERE education != 'None'
GROUP BY 1;    
    

-- For employees with more than 5 years of service, what is the distribution of their previous year ratings?
SELECT employee_id, length_of_service, previous_year_rating
FROM project_hr
WHERE length_of_service > 5
ORDER BY 3 DESC, 2 DESC;


/*	Which department has the highest number of employees who met more
 than 80% of their KPIs (Key Performance Indicators)? */
 SELECT department, COUNT(*) no_of_employees
 FROM project_hr
 WHERE KPIs_met_more_than_80 > 0
 GROUP BY 1
 ORDER BY 2 DESC;
 
 
 /*  How many employees were recruited through each recruitment channel, 
 and what is their average length of service?*/
 SELECT recruitment_channel, COUNT(*) no_of_employees, AVG(length_of_service) Avg_len_of_service
 FROM project_hr
 GROUP BY 1;
 

/*  Are there any correlations between the number of trainings taken and the average training 
score for employees in the Technology department?*/
SELECT no_of_trainings, AVG(avg_training_score) Avg_training_score
FROM project_hr
WHERE department = 'Technology'
GROUP BY 1
ORDER BY 1 DESC;



/* What is the percentage of employees in each department who have a 
Bachelor's, Master's, or other education level?*/
SELECT department , 
	ROUND((COUNT(CASE WHEN education = 'bachelors' THEN 1 END)/COUNT(*))*100,2) Percentage_of_bachelor,
    ROUND((COUNT(CASE WHEN education = 'Below Secondary' THEN 1 END)/COUNT(*))*100,2) Percentage_of_belowSecondary,
    ROUND((COUNT(CASE WHEN education = 'Masters & above' THEN 1 END)/COUNT(*))*100,2) Percentage_of_masters_andabove
FROM project_hr
GROUP BY 1;

 
/* Identify the top 5 regions with the highest average training scores for employees with a Bachelor's 
degree, along with the count of employees in each region. */
SELECT region, AVG(avg_training_score) Avg_training_score, Count(*) no_of_employees
FROM project_hr
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;



/* Calculate the retention rate for each department, defined as the percentage of employees 
who have completed more than 5 years of service.*/
SELECT department, 
	(COUNT(CASE WHEN length_of_service > 5 THEN 1 END)/COUNT(*))*100 retention_rate
FROM project_hr
GROUP BY 1;


/* Determine the overall percentage of employees who have received awards and have a 
KPI score of more than 80%, segmented by their education levels.*/
SELECT education, 
	(COUNT(CASE WHEN awards_won > 0 THEN 1 END)/COUNT(*))*100 percent_employee_won
FROM project_hr
WHERE KPIs_met_more_than_80 > 0
GROUP BY 1;


/* Calculate the average length of service for employees who have taken at least 2 trainings,
and further break it down by recruitment channel.*/
SELECT recruitment_channel, AVG(length_of_service) Avg_len_of_service
FROM project_hr
WHERE no_of_trainings >= 0
GROUP BY 1;
 
 
/* For employees with a previous year rating of 3 or higher, what is the average training score they have 
achieved, and what is the percentage of such employees in each region?*/
SELECT 
	region, 
    AVG(CASE WHEN previous_year_rating >= 3 THEN avg_training_score END) Avg_training_score,
	(COUNT(CASE WHEN previous_year_rating >= 3 THEN 1 END)/COUNT(*))*100 percentage_of_employees
FROM project_hr
GROUP BY 1;


/* Identify any correlation between the number of trainings taken and the average training score 
for employees within each department, using the Pearson correlation coefficient.*/
SELECT department, 
	ROUND((avg(no_of_trainings * avg_training_score) - avg(no_of_trainings) * avg(avg_training_score)) / 
        (sqrt(avg(no_of_trainings * no_of_trainings) - avg(no_of_trainings) * avg(no_of_trainings)) * sqrt(avg(avg_training_score * avg_training_score) - avg(avg_training_score) * avg(avg_training_score))) 
        ,2) AS Corr_for_No_of_trainings_with_AvgTrainingScore
FROM project_hr
GROUP BY 1;


/* For employees in the Sales & Marketing department, what is the 
median age of male and female employees separately?*/
SELECT cv.age INTO @median_age_male
FROM
(SELECT age, gender,
ROW_NUMBER() OVER() row_numberr,
COUNT(*) OVER() AS rn
FROM project_hr
WHERE gender = 'm'
AND department = 'Sales & Marketing'
) cv
WHERE cv.row_numberr IN ((rn+1)/2) ;

SELECT cv.age INTO @median_age_female
FROM
(SELECT age, gender,
ROW_NUMBER() OVER() row_numberr,
COUNT(*) OVER() AS rn
FROM project_hr
WHERE gender = 'f'
AND department = 'Sales & Marketing'
) cv
WHERE cv.row_numberr IN ((rn+1)/2);

SELECT @median_age_female, @median_age_male;


/*	For each recruitment channel, determine the average training score for 
employees who have a Master's degree and have won awards.*/
SELECT recruitment_channel, AVG(avg_training_score) Avg_training_score
FROM project_hr
WHERE awards_won > 0 AND education = 'Masters & above'
GROUP BY 1;



/*Find the department-wise distribution of employees based on their age group (e.g., 20-25, 26-30, etc.), 
and include the standard deviation of age for each group.*/
SELECT
    department,
    age_group,
    COUNT(*) AS employee_count,
    ROUND(STDDEV(age), 2) AS age_std_dev
FROM (
    SELECT
        department,
        CASE
            WHEN age BETWEEN 20 AND 25 THEN '20-25'
            WHEN age BETWEEN 26 AND 30 THEN '26-30'
            WHEN age BETWEEN 31 AND 35 THEN '31-35'
            WHEN age BETWEEN 35 AND 40 THEN '35-40'
            WHEN age BETWEEN 40 AND 45 THEN '40-45'-- Add more age groups as needed
            WHEN age BETWEEN 45 AND 50 THEN '45-50'
            WHEN age BETWEEN 50 AND 55 THEN '50-55'
            WHEN age BETWEEN 55 AND 60 THEN '55-60'
            ELSE 'Other'
        END AS age_group,
        age
    FROM
        project_hr
) AS age_grouped_data
GROUP BY
    department, age_group
ORDER BY
    department, age_group;


/*For employees who have a Bachelor's degree, what is the
 average training score based on their age group (e.g., 20-25, 26-30, 31-35, etc.)?*/
 SELECT
    CASE
        WHEN age BETWEEN 20 AND 25 THEN '20-25'
        WHEN age BETWEEN 26 AND 30 THEN '26-30'
        WHEN age BETWEEN 31 AND 35 THEN '31-35'
        WHEN age BETWEEN 35 AND 40 THEN '35-40'
		WHEN age BETWEEN 40 AND 45 THEN '40-45'
		WHEN age BETWEEN 45 AND 50 THEN '45-50'
		WHEN age BETWEEN 50 AND 55 THEN '50-55'
		WHEN age BETWEEN 55 AND 60 THEN '55-60'
		ELSE 'Other'
    END AS age_group,
    AVG(avg_training_score) AS avg_training_score
FROM
    project_hr
WHERE
    education = 'Bachelors'
GROUP BY
    age_group
ORDER BY
    age_group;


---------------------------------------------------------------------------------------------------------

 
 
 
 



 
 





 




