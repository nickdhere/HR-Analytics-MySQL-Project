# MySQL COVID Project README

## Project Overview
This MySQL project, titled "COVID Project," is designed to demonstrate database management and analysis skills. The project involves creating a MySQL schema, defining tables, importing data, performing data cleaning, and executing various SQL queries to derive meaningful insights from the dataset.

The dataset used in this project pertains to employee data and is structured into several columns, including employee ID, department, region, education level, gender, recruitment channel, and various performance-related metrics like KPIs, awards, and training scores.

## Project Structure
The project is divided into several sections, each addressing specific tasks and questions related to the dataset. Here is a brief overview of the sections included in the code:

### Schema and Table Creation
- Creation of a MySQL schema named "HR_SCHEMA."
- Creation of a table named "project_hr" to store employee data.

### Data Cleaning
- Removal of duplicate rows from the dataset.
- Checking the datatypes and fixing them.
- Identification and handling of null values in the dataset.

### Data Analysis
The project involves answering a series of questions using SQL queries to analyze the employee dataset. These questions are as follows:

1. Find the average age of employees in each department and gender group.
2. List the top 3 departments with the highest average training scores.
3. Find the percentage of employees who have won awards in each region.
4. Show the number of employees who have met more than 80% of KPIs for each recruitment channel and education level.
5. Find the average length of service for employees in each department, considering only employees with previous year ratings greater than or equal to 4.
6. List the top 5 regions with the highest average previous year ratings.
7. List the departments with more than 100 employees having a length of service greater than 5 years.
8. Show the average length of service for employees who have attended more than 3 trainings, grouped by department and gender.
9. Find the percentage of female employees who have won awards, per department.
10. Calculate the percentage of employees per department who have a length of service between 5 and 10 years.
11. Find the top 3 regions with the highest number of employees who have met more than 80% of their KPIs and received at least one award, grouped by department and region.
12. Calculate the average length of service for employees per education level and gender, considering only those employees who have completed more than 2 trainings and have an average training score greater than 75.
13. For each department and recruitment channel, find the total number of employees who have met more than 80% of their KPIs, have a previous_year_rating of 5, and have a length of service greater than 10 years.
14. Calculate the percentage of employees in each department who have received awards, have a previous_year_rating of 4 or 5, and an average training score above 70.
15. List the top 5 recruitment channels with the highest average length of service for employees who have met more than 80% of their KPIs, have a previous_year_rating of 5, and an age between 25 and 45 years, grouped by department and recruitment channel.
16. What is the average training score for male and female employees in each education category?
17. For employees with more than 5 years of service, what is the distribution of their previous year ratings?
18. Which department has the highest number of employees who met more than 80% of their KPIs (Key Performance Indicators)?
19. How many employees were recruited through each recruitment channel, and what is their average length of service?
20. Are there any correlations between the number of trainings taken and the average training score for employees in the Technology department?
21. What is the percentage of employees in each department who have a Bachelor's, Master's, or other education level?
22. Identify the top 5 regions with the highest average training scores for employees with a Bachelor's degree, along with the count of employees in each region.
23. Calculate the retention rate for each department, defined as the percentage of employees who have completed more than 5 years of service.
24. Determine the overall percentage of employees who have received awards and have a KPI score of more than 80%, segmented by their education levels.
25. Calculate the average length of service for employees who have taken at least 2 trainings,and further break it down by recruitment channel.
26. For employees with a previous year rating of 3 or higher, what is the average training score they have achieved, and what is the percentage of such employees in each region?
27. Identify any correlation between the number of trainings taken and the average training score for employees within each department, using the Pearson correlation coefficient.
28. For employees in the Sales & Marketing department, what is the median age of male and female employees separately?
29. For each recruitment channel, determine the average training score for employees who have a Master's degree and have won awards.
30. Find the department-wise distribution of employees based on their age group (e.g., 20-25, 26-30, etc.), and include the standard deviation of age for each group.
31. For employees who have a Bachelor's degree, what is the average training score based on their age group (e.g., 20-25, 26-30, 31-35, etc.)?


### Additional Analysis
- Age-wise average previous_year_rating.
- Average training score for male and female employees in each education category.
- Distribution of previous year ratings for employees with more than 5 years of service.
- Department with the highest number of employees who met more than 80% of their KPIs.
- Number of employees recruited through each recruitment channel and their average length of service.
- Correlation analysis between the number of trainings taken and the average training score for Technology department employees.
- Percentage of employees in each department with specific education levels.
- Top regions with the highest average training scores for employees with a Bachelor's degree.
- Retention rate for each department.
- Percentage of employees with awards and high KPI scores, segmented by education levels.
- Average length of service for employees who have taken at least 2 trainings, segmented by recruitment channel.
- Distribution of employees with specific criteria, including previous year rating, age, and education level.
- Correlation analysis between the number of trainings taken and the average training score for each department.
- Median age of male and female employees in the Sales & Marketing department.
- Average training score for employees with a Master's degree and awards, grouped by recruitment channel.
- Department-wise distribution of employees based on their age group.
- Average training score for employees with a Bachelor's degree, based on age groups.

## How to Use the Code
1. Ensure you have a MySQL database set up and running.
2. Copy and paste the code from the provided file into your MySQL query editor or client.
3. Execute the code sequentially, following the comments and section headers.
4. Review the results of each query to obtain the desired insights.

Please feel free to modify or adapt this code for your own projects as needed. If you have any questions or encounter any issues, do not hesitate to reach out for assistance.

## Author Information
- Author: Nikhil
- Email: dahiyanick44@gmail.com

Thank you for using this MySQL COVID Project code. We hope you find it useful for your data analysis needs.
