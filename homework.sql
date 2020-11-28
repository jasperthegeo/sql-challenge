--Create the tables
--ERD Diagram https://dbdiagram.io/d/5fbf06323a78976d7b7d7397
--
CREATE TABLE departments(
	dept_no varchar(100) PRIMARY KEY,
	dept_name varchar(100)
);

CREATE TABLE titles(
	title_id varchar(100) PRIMARY KEY,
	title varchar(100)
);

CREATE TABLE employees(
	emp_no int PRIMARY KEY, 
	emp_title_id varchar (100),
	birth_date varchar, 
	first_name varchar(100),
	last_name varchar(100),
	sex char,
	hire_date varchar,
	FOREIGN KEY (emp_title_id) REFERENCES titles (title_id)
);

CREATE TABLE salaries(
	emp_no int PRIMARY KEY,
	salary int,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE dept_emp (
	emp_no INTEGER NOT null,
	dept_no varchar(100) NOT null,
	constraint dept_map_pk primary key (emp_no, dept_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE dept_manager(
	dept_no varchar(100),
	emp_no int,
	PRIMARY KEY (dept_no, emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

--SINCE employees.birth_date and employees.hire_date had to be imported as varchar
--the following code changes that to date
--CREATE A PERSISTENT TO_DATE ARGUMENT for birth_date

ALTER TABLE employees ADD birth_dt date;
UPDATE employees SET birth_dt = TO_DATE(birth_date, 'MM/DD/YYYY');
ALTER TABLE employees DROP column birth_date;

ALTER TABLE employees ADD hire_dt date;
UPDATE employees SET hire_dt = TO_DATE(hire_date, 'MM/DD/YYYY');
ALTER TABLE employees DROP column hire_date;

--Q1 List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT  employees.first_name,
		employees.last_name,
		employees.sex,
		salaries.salary
		
FROM employees
	LEFT JOIN salaries on salaries.emp_no = employees.emp_no

--Q2 List first name, last name, and hire date for employees who were hired in 1986.
SELECT  employees.first_name,
		employees.last_name,
		employees.hire_dt
FROM employees 

WHERE date_part('year', hire_dt)=1986;

--Q3. List the manager of each department with the following information:
--department number, department name, the manager's employee number, last name, first name.

SELECT dept_manager.dept_no,
		dept_manager.emp_no,
		departments.dept_name,
		employees.first_name,
		employees.last_name

FROM employees
	INNER JOIN dept_manager ON employees.emp_no = dept_manager.emp_no
	INNER JOIN departments ON dept_manager.dept_no = departments.dept_no;
		
--Q4 List the department of each employee with the following information:
--employee number, last name, first name, and department name.
SELECT employees.emp_no,
		employees.last_name,
		employees.first_name,
		departments.dept_name
		
FROM employees 
	LEFT JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
	LEFT JOIN departments ON dept_emp.dept_no = departments.dept_no;

--Q5 List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT  first_name,
		last_name,
		sex
		
FROM employees
WHERE first_name ='Hercules' AND last_name LIKE 'B%';

--Q6 List all employees in the Sales department, including their employee number, 
--last name, first name, and department name.
SELECT employees.emp_no,
		employees.last_name,
		employees.first_name,
		departments.dept_name
FROM employees 
	LEFT JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
	LEFT JOIN departments ON dept_emp.dept_no = departments.dept_no

WHERE departments.dept_name ='Sales';


--Q7 List all employees in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.
SELECT employees.emp_no,
	employees.first_name,
	employees.last_name,
	departments.dept_name
	
FROM employees 
	LEFT JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
	LEFT JOIN departments ON dept_emp.dept_no = departments.dept_no;
	
--Q8 In descending order, list the frequency count of employee last names, i.e.,
--how many employees share each last name.
SELECT last_name,
COUNT(*) AS empl_cnt
FROM employees
GROUP BY last_name
ORDER BY 2 DESC;