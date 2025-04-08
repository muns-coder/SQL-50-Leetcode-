 use leetcode;

#---------------------------------DAY : 1 -------------------------------------------------------------------#

CREATE TABLE employee_attendance (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    check_in_time TIME,
    check_in_date DATE
);

INSERT INTO employee_attendance (employee_id, check_in_time, check_in_date) VALUES
(401, '08:45:00', '2024-02-01'),
(401, '09:15:00', '2024-02-02'),
(401, '09:30:00', '2024-02-05'),
(401, '09:10:00', '2024-02-08'),
(401, '08:50:00', '2024-02-10'),
(402, '08:55:00', '2024-02-03'),
(402, '09:20:00', '2024-02-06'),
(402, '09:05:00', '2024-02-10'),
(402, '09:30:00', '2024-02-15'),
(403, '08:40:00', '2024-02-01'),
(403, '08:55:00', '2024-02-04'),
(403, '09:10:00', '2024-02-07'),
(403, '09:15:00', '2024-02-12'),
(403, '09:25:00', '2024-02-18')
,(403, '09:25:00', '2024-02-18');

select * from employee_attendance;

WITH ete_count AS (
    SELECT employee_id, 
           COUNT(*) OVER(PARTITION BY employee_id) AS late_time
    FROM employee_attendance
    WHERE check_in_time >= '09:00:00'
)
SELECT DISTINCT employee_id, late_time 
FROM ete_count
WHERE late_time = 3;


#----------------------------------------------------------------------------------------------#

CREATE TABLE product_sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    sale_date DATE
);

INSERT INTO product_sales (category, product_name, quantity_sold, sale_date) VALUES
('Electronics', 'Laptop', 50, '2024-01-10'),
('Electronics', 'Smartphone', 80, '2024-01-12'),
('Electronics', 'Tablet', 40, '2024-01-15'),
('Electronics', 'Headphones', 90, '2024-01-20'),
('Furniture', 'Sofa', 30, '2024-02-01'),
('Furniture', 'Table', 50, '2024-02-05'),
('Furniture', 'Chair', 70, '2024-02-08'),
('Furniture', 'Bookshelf', 20, '2024-02-10'),
('Electronics', 'Smartwatch', 35, '2024-01-25');

-- problem 2 : 

# You are given a table product_sales that tracks the sales of different products. 
# Your task is to find the top 2 most sold products for each category based on the total quantity sold.

Select * from product_sales;

With cte_sale as 
(
 SELECT category , product_name , quantity_sold as total_quantity_sold,
 row_number() over(partition by category order by quantity_sold desc)as RK
 from product_sales
)
select category , product_name , total_quantity_sold from cte_sale
where RK <=2;

-- 3 problem : 

CREATE TABLE employee_salaries (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

INSERT INTO employee_salaries (emp_name, department, salary) VALUES
('Alice', 'IT', 70000),
('Bob', 'HR', 50000),
('Charlie', 'IT', 90000),
('David', 'HR', 55000),
('Eve', 'IT', 85000),
('Frank', 'Finance', 95000),
('Grace', 'Finance', 80000);


select * from employee_salaries;

with cte_average as 
(
select *, 
avg(salary) over(partition by department) as avg_department_salary
from employee_salaries
)
select * from cte_average
where salary > avg_department_salary;


-- 3 : Problem 

CREATE TABLE employee_attendances(
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    emp_name VARCHAR(50),
    attendance_date DATE,
    status VARCHAR(10) CHECK (status IN ('Present', 'Absent'))
);

INSERT INTO employee_attendances (emp_id, emp_name, attendance_date, status) VALUES
(101, 'Alice', '2024-02-01', 'Present'),
(101, 'Alice', '2024-02-02', 'Absent'),
(101, 'Alice', '2024-02-03', 'Absent'),
(101, 'Alice', '2024-02-04', 'Absent'),
(101, 'Alice', '2024-02-05', 'Present'),
(102, 'Bob', '2024-02-01', 'Present'),
(102, 'Bob', '2024-02-02', 'Absent'),
(102, 'Bob', '2024-02-03', 'Present'),
(103, 'Charlie', '2024-02-01', 'Absent'),
(103, 'Charlie', '2024-02-02', 'Absent'),
(103, 'Charlie', '2024-02-03', 'Absent'),
(103, 'Charlie', '2024-02-04', 'Present');


select * from employee_attendances;

WITH cte_absent AS (
    SELECT emp_id, 
           emp_name, 
           attendance_date, 
           status, 
           LAG(attendance_date) OVER(PARTITION BY emp_id ORDER BY attendance_date) AS prev_date,
           DENSE_RANK() OVER(PARTITION BY emp_id ORDER BY attendance_date) AS grp
    FROM employee_attendances
    WHERE status = 'Absent'
),
cte_grouped AS (
    SELECT emp_id, 
           emp_name, 
           MIN(attendance_date) AS start_date, 
           MAX(attendance_date) AS end_date, 
           COUNT(*) AS absent_days
    FROM cte_absent
    GROUP BY emp_id, emp_name
)
SELECT * FROM cte_grouped WHERE absent_days >= 3;

-- 4 : problem : 

CREATE TABLE customer_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(50),
    order_date DATE,
    total_amount DECIMAL(10,2)
);

INSERT INTO customer_orders (customer_id, customer_name, order_date, total_amount) VALUES
(201, 'Alice', '2024-01-05', 250),
(201, 'Alice', '2024-01-20', 300),
(202, 'Bob', '2024-01-10', 400),
(202, 'Bob', '2024-02-15', 350),
(203, 'Charlie', '2024-02-05', 150),
(203, 'Charlie', '2024-02-25', 200),
(204, 'David', '2024-03-10', 500);

select * from customer_orders;

WITH cte_orders AS (
    SELECT customer_id, 
           customer_name, 
           DATE_FORMAT(order_date, '%Y-%m') AS order_month,
           COUNT(order_id) OVER(PARTITION BY customer_id, DATE_FORMAT(order_date, '%Y-%m')) AS total_orders
    FROM customer_orders
)
SELECT DISTINCT customer_id, customer_name, order_month, total_orders
FROM cte_orders
WHERE total_orders >= 2;

-- 5 problem : 
# You are given a table employee_salaries that stores salary details of employees. 
#Your task is to find the highest-paid employee in each department.


drop table employee_salaries; 

CREATE TABLE employee_salaries (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

INSERT INTO employee_salaries (emp_name, department, salary) VALUES
('Alice', 'IT', 70000),
('Bob', 'HR', 50000),
('Charlie', 'IT', 90000),
('David', 'HR', 55000),
('Eve', 'IT', 85000),
('Frank', 'Finance', 95000),
('Grace', 'Finance', 80000);


select * from employee_salaries;

with etc_salary as 
(
 select distinct department , emp_name , salary,
 rank() over(partition by department order by salary desc) as rk
 from employee_salaries
)
select department , emp_name , salary 
from etc_salary
where rk=1; 


-- SQL Problem: Find the First and Last Purchase Date of Each Customer
-- You are given a table customer_orders that stores purchase records of customers. 
-- Your task is to find the first and last order date for each customer.


CREATE TABLE customer_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(50),
    order_date DATE,
    total_amount DECIMAL(10,2)
);

INSERT INTO customer_order (customer_id, customer_name, order_date, total_amount) VALUES
(101, 'Alice', '2024-01-05', 250),
(101, 'Alice', '2024-03-15', 400),
(102, 'Bob', '2024-02-10', 350),
(102, 'Bob', '2024-05-20', 500),
(103, 'Charlie', '2024-03-08', 150),
(103, 'Charlie', '2024-04-12', 300);

select * from customer_order;

select max(order_date) from customer_order;


WITH cte_orders AS (
    SELECT customer_id, 
           customer_name, 
           MIN(order_date) OVER(PARTITION BY customer_id) AS first_order_date,
           MAX(order_date) OVER(PARTITION BY customer_id) AS last_order_date
    FROM customer_orders
)	
SELECT DISTINCT customer_id, customer_name, first_order_date, last_order_date
FROM cte_orders;

-- 7 Problem : 

with etc_salary as 
(
 select distinct department , emp_name , salary,
 row_number() over(partition by department order by salary desc) as rk
 from employee_salaries
)
select department , emp_name , salary 
from etc_salary
where rk=2; 


-- Next Questoin :

-- Your task is to find employees who have been absent for 3 or more consecutive days.

CREATE TABLE employee_attendance (
    emp_id INT,
    emp_name VARCHAR(50),
    attendance_date DATE,
    status VARCHAR(10) CHECK (status IN ('Present', 'Absent'))
);

INSERT INTO employee_attendance (emp_id, emp_name, attendance_date, status) VALUES
(101, 'Alice', '2024-02-01', 'Present'),
(101, 'Alice', '2024-02-02', 'Absent'),
(101, 'Alice', '2024-02-03', 'Absent'),
(101, 'Alice', '2024-02-04', 'Absent'),
(101, 'Alice', '2024-02-05', 'Present'),
(102, 'Bob', '2024-02-01', 'Absent'),
(102, 'Bob', '2024-02-02', 'Present'),
(102, 'Bob', '2024-02-03', 'Absent'),
(102, 'Bob', '2024-02-04', 'Absent'),
(102, 'Bob', '2024-02-05', 'Present');


select * from employee_attendance;


WITH cte AS (
    SELECT 
        emp_id, 
        emp_name, 
        attendance_date,
        status,
        LAG(attendance_date, 1) OVER (PARTITION BY emp_id ORDER BY attendance_date) AS prev_day,
        LAG(attendance_date, 2) OVER (PARTITION BY emp_id ORDER BY attendance_date) AS prev_two_days
    FROM employee_attendance
)
SELECT 
    emp_id, 
    emp_name, 
    MIN(attendance_date) AS start_date, 
    MAX(attendance_date) AS end_date,
    COUNT(*) AS absent_days
FROM cte
WHERE status = 'Absent'
AND DATE_SUB(attendance_date, INTERVAL 1 DAY) = prev_day
AND DATE_SUB(attendance_date, INTERVAL 2 DAY) = prev_two_days
GROUP BY emp_id, emp_name;

#---------------------------------DAY : 2 -------------------------------------------------------------------#

use leetcode;

Create table If Not Exists Accounts (account_id int, income int);
Truncate table Accounts;
insert into Accounts (account_id, income) values ('3', '108939');
insert into Accounts (account_id, income) values ('2', '12747');
insert into Accounts (account_id, income) values ('8', '87709');
insert into Accounts (account_id, income) values ('6', '91796');

select * from accounts;

SELECT 
    CASE 
        WHEN income < 20000 THEN 'Low Salary'
        WHEN if(income >=20000 AND income<= 50000,1,null) THEN 'Average Salary'
        WHEN income >= 50000 THEN 'High Salary'
    END AS category,
    COUNT(*) AS counted_account
FROM accounts
GROUP BY category
ORDER BY category;

SELECT 'Low Salary' as category,
count(if(income <= 20000,1,null)) as counted_account
 from accounts
 union all
 SELECT 'Average Salary' as category,
 count(if(income >= 20000 AND income <=50000,1,null))
 from accounts
 union all
 SELECT 'hight Salary' as category,
 count(if(income >= 50000,1,null))
 from accounts;

-- Q2 : Write a solution to find the prices of all products on 2019-08-16. 
-- Assume the price of all products before any change is 10.

Create table If Not Exists Products (product_id int, new_price int, change_date date);
Truncate table Products;
insert into Products (product_id, new_price, change_date) values ('1', '20', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('2', '50', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('1', '30', '2019-08-15');
insert into Products (product_id, new_price, change_date) values ('1', '35', '2019-08-16');
insert into Products (product_id, new_price, change_date) values ('2', '65', '2019-08-17');
insert into Products (product_id, new_price, change_date) values ('3', '20', '2019-08-18');

SELECT * FROM Products;

# Write your MySQL query statement below

WITH latest_price AS (
    SELECT DISTINCT product_id
        , FIRST_VALUE(new_price) OVER (PARTITION BY product_id ORDER BY change_date DESC) as latest_price
    FROM products 
    WHERE change_date <= '2019-08-16' 
)
SELECT DISTINCT product_id
    , IFNULL(b.latest_price, 10) as price
FROM products a
    LEFT JOIN latest_price b USING (product_id);

-- Q3 :  Classes More Than 5 Students
-- Write a solution to find all the classes that have at least five students.

Create table If Not Exists Courses (student varchar(255), class varchar(255));
Truncate table Courses;
insert into Courses (student, class) values ('A', 'Math');
insert into Courses (student, class) values ('B', 'English');
insert into Courses (student, class) values ('C', 'Math');
insert into Courses (student, class) values ('D', 'Biology');
insert into Courses (student, class) values ('E', 'Math');
insert into Courses (student, class) values ('F', 'Computer');
insert into Courses (student, class) values ('G', 'Math');
insert into Courses (student, class) values ('H', 'Math');
insert into Courses (student, class) values ('I', 'Math');

select * from courses;

With cte_max as
(
 Select *,row_number()over(partition by class order by student)as rk
 from courses
)
select distinct class
from  cte_max
where rk >=5;

-- Q5 : 
-- Find Followers Count
-- Write a solution that will, for each user, return the number of followers.
-- Return the result table ordered by user_id in ascending order.

Create table If Not Exists Followers(user_id int, follower_id int);
Truncate table Followers;
insert into Followers (user_id, follower_id) values ('0', '1');
insert into Followers (user_id, follower_id) values ('1', '0');
insert into Followers (user_id, follower_id) values ('2', '0');
insert into Followers (user_id, follower_id) values ('2', '1');

SELECT * FROM Followers;

select user_id, count(follower_id) followers_count
from Followers
group by user_id
order by user_id;

-- Q6 : Biggest Single Number
-- A single number is a number that appeared only once in the MyNumbers table.
-- Find the largest single number. If there is no single number, report null.

Create table If Not Exists MyNumbers (num int);
Truncate table MyNumbers;
insert into MyNumbers (num) values ('8');
insert into MyNumbers (num) values ('8');
insert into MyNumbers (num) values ('3');
insert into MyNumbers (num) values ('3');
insert into MyNumbers (num) values ('1');
insert into MyNumbers (num) values ('4');
insert into MyNumbers (num) values ('5');
insert into MyNumbers (num) values ('6');

SELECT * from Mynumbers;

select max(num) from mynumbers
where num in
(
 select num from mynumbers
 group by num
 having  count(num)=1
 order by num desc
);

-- Q7 : Customers Who Bought All Products 
-- Write a solution to report the customer ids from the Customer table 
-- that bought all the products in the Product table.

Create table If Not Exists Customer (customer_id int, product_key int);
Create table Product (product_key int);
Truncate table Customer;
insert into Customer (customer_id, product_key) values ('1', '5');
insert into Customer (customer_id, product_key) values ('2', '6');
insert into Customer (customer_id, product_key) values ('3', '5');
insert into Customer (customer_id, product_key) values ('3', '6');
insert into Customer (customer_id, product_key) values ('1', '6');
Truncate table Product;
insert into Product (product_key) values ('5');
insert into Product (product_key) values ('6');

select * from customer;
select * from product;

with cte_join as 
(select c.customer_id , p.product_key 
from customer as c
join product as p
on c.product_key=p.product_key
),
cte_max as 
(select customer_id,group_concat(product_key)as products,count(product_key)as counted
from cte_join
group by customer_id
)
select customer_id from cte_max
where counted=
(select max(counted) from cte_max);

# Write your MySQL query statement below

SELECT  customer_id FROM Customer GROUP BY customer_id
HAVING COUNT(distinct product_key) = (SELECT COUNT(product_key) FROM Product);

-- Q:8
-- Reformat Department Table
-- Reformat the table such that there is a department id column and a revenue column for each month.

Create table If Not Exists Department (id int, revenue int, month varchar(5));
Truncate table Department;
insert into Department (id, revenue, month) values ('1', '8000', 'Jan');
insert into Department (id, revenue, month) values ('2', '9000', 'Jan');
insert into Department (id, revenue, month) values ('3', '10000', 'Feb');
insert into Department (id, revenue, month) values ('1', '7000', 'Feb');
insert into Department (id, revenue, month) values ('1', '6000', 'Mar');

select * from department;

select id,
sum(case when month='Jan' then revenue else null end)as Jan_Revenue,
sum(case when month='Feb' then revenue else null end)as Feb_Revenue,
sum(case when month='Mar' then revenue else null end)as Mar_Revenue,
sum(case when month='Apr' then revenue else null end)as Apr_Revenue,
sum(case when month='May' then revenue else null end)as May_Revenue,
sum(case when month='Jun' then revenue else null end)as Jun_Revenue,
sum(case when month='Jul' then revenue else null end)as Jul_Revenue,
sum(case when month='Aug' then revenue else null end)as Aug_Revenue,
sum(case when month='Sep' then revenue else null end)as Sep_Revenue,
sum(case when month='Oct' then revenue else null end)as Oct_Revenue,
sum(case when month='Nov' then revenue else null end)as Nov_Revenue,
sum(case when month='dec' then revenue else null end)as Dec_Revenue
from department
group by id;

-- Q:9
-- The Number of Employees Which Report to Each Employee
# For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.
# Write a solution to report the ids and the names of all managers, the number of employees who report directly to them, 
-- and the average age of the reports rounded to the nearest integer.

Create table If Not Exists Employees(employee_id int, name varchar(20), reports_to int, age int);
Truncate table Employees;
insert into Employees (employee_id, name, reports_to, age) values ('9', 'Hercy', NULL, '43');
insert into Employees (employee_id, name, reports_to, age) values ('6', 'Alice', '9', '41');
insert into Employees (employee_id, name, reports_to, age) values ('4', 'Bob', '9', '36');
insert into Employees (employee_id, name, reports_to, age) values ('2', 'Winston', NULL, '37');

select * from employees;

select e1.employee_id , e1.`name` , count(e2.reports_to)as reports_to , avg(e2.age) as average_sale
from employees e1
join employees e2 using (employee_id)
group by  e1.`name`, e1.employee_id
having reports_to is not null
order by average_sale;

#--------------------Day 5 ---------------------------------------#

Create table If Not Exists Activity (machine_id int, process_id int, activity_type ENUM('start', 'end'), timestamp float);
Truncate table Activity;
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('0', '0', 'start', '0.712');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('0', '0', 'end', '1.52');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('0', '1', 'start', '3.14');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('0', '1', 'end', '4.12');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('1', '0', 'start', '0.55');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('1', '0', 'end', '1.55');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('1', '1', 'start', '0.43');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('1', '1', 'end', '1.42');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('2', '0', 'start', '4.1');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('2', '0', 'end', '4.512');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('2', '1', 'start', '2.5');
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('2', '1', 'end', '5');

select * from Activity;

select a1.machine_id , round(avg(a2.timestamp - a1.timestamp),3)as processing
from Activity as a1
JOIN Activity as a2
on a1.machine_id=a2.machine_id AND a1.process_id=a2.process_id
and a1.activity_type='start' and a2.activity_type='END'
group by a1.machine_id;

-- Q : 2 
-- Employee Bonus
-- Write a solution to report the name and bonus amount of each employee with a bonus less than 1000.

Create table If Not Exists Employee (empId int, name varchar(255), supervisor int, salary int);
Create table If Not Exists Bonus (empId int, bonus int);
Truncate table Employee;
insert into Employee (empId, name, supervisor, salary) values ('3', 'Brad', NULL, '4000');
insert into Employee (empId, name, supervisor, salary) values ('1', 'John', '3', '1000');
insert into Employee (empId, name, supervisor, salary) values ('2', 'Dan', '3', '2000');
insert into Employee (empId, name, supervisor, salary) values ('4', 'Thomas', '3', '4000');
Truncate table Bonus;
insert into Bonus (empId, bonus) values ('2', '500');
insert into Bonus (empId, bonus) values ('4', '2000');

select * from employee;
select * from bonus;

select e.name , s.bonus 
from employee as e
left join bonus as s
using(empid)
where s.bonus <= 1000 or s.bonus is null;

-- Q : 3 
-- Average Selling Price
-- Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places. 
-- If a product does not have any sold units, 
-- its average selling price is assumed to be 0.

Create table If Not Exists Prices (product_id int, start_date date, end_date date, price int);
Create table If Not Exists UnitsSold (product_id int, purchase_date date, units int);
Truncate table Prices;
insert into Prices (product_id, start_date, end_date, price) values ('1', '2019-02-17', '2019-02-28', '5');
insert into Prices (product_id, start_date, end_date, price) values ('1', '2019-03-01', '2019-03-22', '20');
insert into Prices (product_id, start_date, end_date, price) values ('2', '2019-02-01', '2019-02-20', '15');
insert into Prices (product_id, start_date, end_date, price) values ('2', '2019-02-21', '2019-03-31', '30');
Truncate table UnitsSold;
insert into UnitsSold (product_id, purchase_date, units) values ('1', '2019-02-25', '100');
insert into UnitsSold (product_id, purchase_date, units) values ('1', '2019-03-01', '15');
insert into UnitsSold (product_id, purchase_date, units) values ('2', '2019-02-10', '200');
insert into UnitsSold (product_id, purchase_date, units) values ('2', '2019-03-22', '30');

select * from prices;
select * from UnitsSold;

select p.product_id , coalesce(round(sum(price * units)/sum(units),2),0) as average_price  
from prices as p
left join unitssold as s
on p.product_id = s.product_id  
and s.purchase_date between start_date AND end_date
group by product_id;

Create table If Not Exists cinema (id int, movie varchar(255), description varchar(255), rating float(2, 1));
Truncate table cinema;
insert into cinema (id, movie, description, rating) values ('1', 'War', 'great 3D', '8.9');
insert into cinema (id, movie, description, rating) values ('2', 'Science', 'fiction', '8.5');
insert into cinema (id, movie, description, rating) values ('3', 'irish', 'boring', '6.2');
insert into cinema (id, movie, description, rating) values ('4', 'Ice song', 'Fantacy', '8.6');
insert into cinema (id, movie, description, rating) values ('5', 'House card', 'Interesting', '9.1');

select * from cinema;

# Write your MySQL query statement below
SELECT * FROM Cinema 
WHERE id % 2 = 1 AND description != 'boring' 
ORDER BY rating DESC;

select * from Cinema 
where id %2 = 1 and description <> 'boring';

 select * from cinema where MOD(id, 2) = 1 or description <> 'boring' ;
 
 #---------------- Day : 4 -----------------------------------------------------#
 
 -- Q : 1 
 -- Students and Examinations
 -- Write a solution to find the number of times each student attended each exam.
 
Create table If Not Exists Students (student_id int, student_name varchar(20));
Create table If Not Exists Subjects (subject_name varchar(20));
Create table If Not Exists Examinations (student_id int, subject_name varchar(20));
Truncate table Students;
insert into Students (student_id, student_name) values ('1', 'Alice');
insert into Students (student_id, student_name) values ('2', 'Bob');
insert into Students (student_id, student_name) values ('13', 'John');
insert into Students (student_id, student_name) values ('6', 'Alex');
Truncate table Subjects;
insert into Subjects (subject_name) values ('Math');
insert into Subjects (subject_name) values ('Physics');
insert into Subjects (subject_name) values ('Programming');
Truncate table Examinations;
insert into Examinations (student_id, subject_name) values ('1', 'Math');
insert into Examinations (student_id, subject_name) values ('1', 'Physics');
insert into Examinations (student_id, subject_name) values ('1', 'Programming');
insert into Examinations (student_id, subject_name) values ('2', 'Programming');
insert into Examinations (student_id, subject_name) values ('1', 'Physics');
insert into Examinations (student_id, subject_name) values ('1', 'Math');
insert into Examinations (student_id, subject_name) values ('13', 'Math');
insert into Examinations (student_id, subject_name) values ('13', 'Programming');
insert into Examinations (student_id, subject_name) values ('13', 'Physics');
insert into Examinations (student_id, subject_name) values ('2', 'Math');
insert into Examinations (student_id, subject_name) values ('1', 'Math');

select * from students;
select * from subjects;
select * from Examinations;
 
 -- student_id | student_name | subject_name | attended_exams 
 
 select s.student_id , s.student_name , e.subject_name,count(e.subject_name)
 from students as s
 join Examinations as e
 using (student_id)
 group by s.student_id , s.student_name , e.subject_name;
 
 #-----------------Day 4 --------------------------------------------#
-- Q : 1 
-- Project Employees I

Create table If Not Exists Project (project_id int, employee_id int);
Create table If Not Exists Employee (employee_id int, name varchar(10), experience_years int);
Truncate table Project;
insert into Project (project_id, employee_id) values ('1', '1');
insert into Project (project_id, employee_id) values ('1', '2');
insert into Project (project_id, employee_id) values ('1', '3');
insert into Project (project_id, employee_id) values ('2', '1');
insert into Project (project_id, employee_id) values ('2', '4');
drop table Employee;
insert into Employee (employee_id, name, experience_years) values ('1', 'Khaled', '3');
insert into Employee (employee_id, name, experience_years) values ('2', 'Ali', '2');
insert into Employee (employee_id, name, experience_years) values ('3', 'John', '1');
insert into Employee (employee_id, name, experience_years) values ('4', 'Doe', '2');

select * from project;
select * from employee;

select p.project_id , round(avg(e.experience_years),2) as average_sale
from project as p
join employee as e
using (employee_id)
group by p.project_id;

-- Q : 2 
-- Percentage of Users Attended a Contest

Create table If Not Exists Users (user_id int, user_name varchar(20));
Create table If Not Exists Register (contest_id int, user_id int);
drop table Users;
insert into Users (user_id, user_name) values ('6', 'Alice');
insert into Users (user_id, user_name) values ('2', 'Bob');
insert into Users (user_id, user_name) values ('7', 'Alex');
Truncate table Register;
insert into Register (contest_id, user_id) values ('215', '6');
insert into Register (contest_id, user_id) values ('209', '2');
insert into Register (contest_id, user_id) values ('208', '2');
insert into Register (contest_id, user_id) values ('210', '6');
insert into Register (contest_id, user_id) values ('208', '6');
insert into Register (contest_id, user_id) values ('209', '7');
insert into Register (contest_id, user_id) values ('209', '6');
insert into Register (contest_id, user_id) values ('215', '7');
insert into Register (contest_id, user_id) values ('208', '7');
insert into Register (contest_id, user_id) values ('210', '2');
insert into Register (contest_id, user_id) values ('207', '2');
insert into Register (contest_id, user_id) values ('210', '7');

select * from users;
select * from register;

SELECT r.contest_id , ROUND(AVG(count(u.user_id)) * 100,2) as percentage 
FROM users as u
JOIN register as r
using (user_id)
group by r.contest_id;

#-------------Day : Monday 10/03-----------------#

-- Nth Highest Salary
-- Write a solution to find the nth highest salary from the Employee table
-- If there is no nth highest salary, return null.

Create table If Not Exists Employee (Id int, Salary int);
drop table Employee;
insert into Employee (id, salary) values ('1', '100');
insert into Employee (id, salary) values ('2', '200');
insert into Employee (id, salary) values ('3', '300');

Select * from Employee;

DELIMITER @@

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE nth_highest_salary INT;
  
  SET nth_highest_salary = (
    SELECT DISTINCT salary 
    FROM Employee 
    ORDER BY salary DESC 
    LIMIT N-1, 1
  );

  RETURN nth_highest_salary;
END @@

DELIMITER ;

-- Q : 2 

-- Department Highest Salary
-- Write a solution to find employees who have the highest salary in each of the departments.
drop table department;
Create table If Not Exists Employee (id int, name varchar(255), salary int, departmentId int);
Create table If Not Exists Department (id int, name varchar(255));
Truncate table Employee;
insert into Employee (id, name, salary, departmentId) values ('1', 'Joe', '70000', '1');
insert into Employee (id, name, salary, departmentId) values ('2', 'Jim', '90000', '1');
insert into Employee (id, name, salary, departmentId) values ('3', 'Henry', '80000', '2');
insert into Employee (id, name, salary, departmentId) values ('4', 'Sam', '60000', '2');
insert into Employee (id, name, salary, departmentId) values ('5', 'Max', '90000', '1');
Truncate table Department;
insert into Department (id, name) values ('1', 'IT');
insert into Department (id, name) values ('2', 'Sales');

select * from employee;
select * from department;

Select d.name as Department , e.name as employee , max(e.salary) as Salary
from department as d
join employee as e
on  e.departmentid = d.id
group by d.name , e.name ;

With CTE_max_salary as
(
	Select d.name as Department , e.name as employee , e.salary as Salary,
	dense_rank() over (partition by d.name order by e.salary desc) as rk
	from department as d
	join employee as e
	on  e.departmentid = d.id
)
select Department , employee , Salary
from CTE_max_salary
where rk=1;

#----------Thursday 11/03 ---------------------#

-- Q : 1
-- Employees Earning More Than Their Managers
-- Write a solution to find the employees who earn more than their managers.

DROP table Employee;
Create table If Not Exists Employee (id int, name varchar(255), salary int, managerId int);
Truncate table Employee;
insert into Employee (id, name, salary, managerId) values ('1', 'Joe', '70000', '3');
insert into Employee (id, name, salary, managerId) values ('2', 'Henry', '80000', '4');
insert into Employee (id, name, salary, managerId) values ('3', 'Sam', '60000', NULL);
insert into Employee (id, name, salary, managerId) values ('4', 'Max', '90000', NULL);

select * from employee;

WITH cte_manager as
(
	select 
	e1.id,e1.name,e1.salary,e2.managerId
	from employee e1
	join employee e2
	on e2.id = e1.managerId
	where e1.salary > e2.salary
    
)
select name from cte_manager;

-- Q:2 
-- Customers Who Never Order
-- Write a solution to find all customers who never order anything.

Create table If Not Exists Customers (id int, name varchar(255));
Create table If Not Exists Orders (id int, customerId int);
Truncate table Customers;
insert into Customers (id, name) values ('1', 'Joe');
insert into Customers (id, name) values ('2', 'Henry');
insert into Customers (id, name) values ('3', 'Sam');
insert into Customers (id, name) values ('4', 'Max');
Truncate table Orders;
insert into Orders (id, customerId) values ('1', '3');
insert into Orders (id, customerId) values ('2', '1');

select * from orders;
select * from customers;
select * from orders;

# Write your MySQL query statement below

WITH cte_customer
as
(
    select c.name as Customers 
    from Customers as c
    left join Orders as o
    on c.id = o.CustomerId
    where o.CustomerId is null
)
select * from cte_customer;

-- Q:2

-- Top Travellers
-- Return the result table ordered by travelled_distance in descending order, 
-- if two or more users traveled the same distance, order them by their name in ascending order.

drop table Users;
Create Table If Not Exists Users (id int, name varchar(30));
Create Table If Not Exists Rides (id int, user_id int, distance int);
Truncate table Users;
insert into Users (id, name) values ('1', 'Alice');
insert into Users (id, name) values ('2', 'Bob');
insert into Users (id, name) values ('3', 'Alex');
insert into Users (id, name) values ('4', 'Donald');
insert into Users (id, name) values ('7', 'Lee');
insert into Users (id, name) values ('13', 'Jonathan');
insert into Users (id, name) values ('19', 'Elvis');
Truncate table Rides;
insert into Rides (id, user_id, distance) values ('1', '1', '120');
insert into Rides (id, user_id, distance) values ('2', '2', '317');
insert into Rides (id, user_id, distance) values ('3', '3', '222');
insert into Rides (id, user_id, distance) values ('4', '7', '100');
insert into Rides (id, user_id, distance) values ('5', '13', '312');
insert into Rides (id, user_id, distance) values ('6', '19', '50');
insert into Rides (id, user_id, distance) values ('7', '7', '120');
insert into Rides (id, user_id, distance) values ('8', '19', '400');
insert into Rides (id, user_id, distance) values ('9', '7', '230');


select * from users;
select * from rides;

With Ctc_toptraveller
as 
(
	Select u.name , SUM(r.distance)as travelled_distance
    from users as u
    join rides as r
    on u.id=r.user_id
    group by u.name
)
select * from Ctc_toptraveller
order by travelled_distance desc , name ;

-- Q : 4
-- Rank Scores

Create table If Not Exists Scores (id int, score DECIMAL(3,2));
Truncate table Scores;
insert into Scores (id, score) values ('1', '3.5');
insert into Scores (id, score) values ('2', '3.65');
insert into Scores (id, score) values ('3', '4.0');
insert into Scores (id, score) values ('4', '3.85');
insert into Scores (id, score) values ('5', '4.0');
insert into Scores (id, score) values ('6', '3.65');

select * from Scores;

select * from 
(	SELECT score ,
	rank() over(partition by score) as `rank`
	from scores
)n
order by score desc;

-- Q:5
-- Swap Salary

Create table If Not Exists Salary (id int, name varchar(100), sex char(1), salary int);
Truncate table Salary;
insert into Salary (id, name, sex, salary) values ('1', 'A', 'm', '2500');
insert into Salary (id, name, sex, salary) values ('2', 'B', 'f', '1500');
insert into Salary (id, name, sex, salary) values ('3', 'C', 'm', '5500');
insert into Salary (id, name, sex, salary) values ('4', 'D', 'f', '500');

select * from salary;

SELECT id , name ,
CASE
	when sex = 'm' Then replace('m',sex,'f')
    when sex='f' Then replace('f',sex,'m')
END as sex ,
salary
from salary;

-- Q:6
-- Bank Account Summary II


drop table users;
Create table If Not Exists Users (account int, name varchar(20));
Create table If Not Exists Transactions (trans_id int, account int, amount int, transacted_on date);
Truncate table Users;
insert into Users (account, name) values ('900001', 'Alice');
insert into Users (account, name) values ('900002', 'Bob');
insert into Users (account, name) values ('900003', 'Charlie');
Truncate table Transactions;
insert into Transactions (trans_id, account, amount, transacted_on) values ('1', '900001', '7000', '2020-08-01');
insert into Transactions (trans_id, account, amount, transacted_on) values ('2', '900001', '7000', '2020-09-01');
insert into Transactions (trans_id, account, amount, transacted_on) values ('3', '900001', '-3000', '2020-09-02');
insert into Transactions (trans_id, account, amount, transacted_on) values ('4', '900002', '1000', '2020-09-12');
insert into Transactions (trans_id, account, amount, transacted_on) values ('5', '900003', '6000', '2020-08-07');
insert into Transactions (trans_id, account, amount, transacted_on) values ('6', '900003', '6000', '2020-09-07');
insert into Transactions (trans_id, account, amount, transacted_on) values ('7', '900003', '-4000', '2020-09-11');

Select * from users;
select * from Transactions;

With ctc_translation
as
(
	Select u.name as name ,sum(t.amount) as balance
    from users as u
    Join Transactions as t
    on u.account=t.account
    group by u.name

) 
select * from ctc_translation
where balance > 10000;

-- Q:7 :
-- Odd and Even Transactions

Drop table Transactions;

Create table if not exists transactions ( transaction_id int, amount int, transaction_date date);
Truncate table transactions;
insert into transactions (transaction_id, amount, transaction_date) values ('1', '150', '2024-07-01');
insert into transactions (transaction_id, amount, transaction_date) values ('2', '200', '2024-07-01');
insert into transactions (transaction_id, amount, transaction_date) values ('3', '75', '2024-07-01');
insert into transactions (transaction_id, amount, transaction_date) values ('4', '300', '2024-07-02');
insert into transactions (transaction_id, amount, transaction_date) values ('5', '50', '2024-07-02');
insert into transactions (transaction_id, amount, transaction_date) values ('6', '120', '2024-07-03');

Select * from Transactions;

With cte_Transactions
as
(
	select transaction_date ,
	sum(case when amount%2=1 Then amount end)as odd_sum ,
	sum(case when amount%2=0 Then amount end)as even_sum
	from Transactions
	group by transaction_date
)
select transaction_date , coalesce(odd_sum,0) as odd_sum , coalesce(even_sum,0)as even_sum
from cte_Transactions
order by transaction_date;

-- Q:8 
-- Calculate Special Bonus

drop table employees;
Create table If Not Exists Employees (employee_id int, name varchar(30), salary int);
Truncate table Employees;
insert into Employees (employee_id, name, salary) values ('2', 'Meir', '3000');
insert into Employees (employee_id, name, salary) values ('3', 'Michael', '3800');
insert into Employees (employee_id, name, salary) values ('7', 'Addilyn', '7400');
insert into Employees (employee_id, name, salary) values ('8', 'Juan', '6100');
insert into Employees (employee_id, name, salary) values ('9', 'Kannon', '7700');

select * from employees;

Select employee_id,
case
	when employee_id%2=0 then salary=0 
    when name like 'M%' then salary=0
    else salary
end as bonus
from employees
order by employee_id;

-- Q:9
-- The Latest Login in 2020

Create table If Not Exists Logins (user_id int, time_stamp datetime);
Truncate table Logins;
insert into Logins (user_id, time_stamp) values ('6', '2020-06-30 15:06:07');
insert into Logins (user_id, time_stamp) values ('6', '2021-04-21 14:06:06');
insert into Logins (user_id, time_stamp) values ('6', '2019-03-07 00:18:15');
insert into Logins (user_id, time_stamp) values ('8', '2020-02-01 05:10:53');
insert into Logins (user_id, time_stamp) values ('8', '2020-12-30 00:46:50');
insert into Logins (user_id, time_stamp) values ('2', '2020-01-16 02:49:50');
insert into Logins (user_id, time_stamp) values ('2', '2019-08-25 07:59:08');
insert into Logins (user_id, time_stamp) values ('14', '2019-07-14 09:00:00');
insert into Logins (user_id, time_stamp) values ('14', '2021-01-06 11:59:59');

select * from logins;

select user_id ,
case
	when time_stamp like '2020%' then time_stamp
end as time_stamp
from logins;

with cte_time
as
(
	select user_id , time_stamp  from logins 
	where time_stamp like '2020%'
)
select user_id , min(time_stamp)as time_stamp
from cte_time
group by user_id;

-- Q : 9 
-- Find Total Time Spent by Each Employee

drop table employees;
Create table If Not Exists Employees(emp_id int, event_day date, in_time int, out_time int);
Truncate table Employees;
insert into Employees (emp_id, event_day, in_time, out_time) values ('1', '2020-11-28', '4', '32');
insert into Employees (emp_id, event_day, in_time, out_time) values ('1', '2020-11-28', '55', '200');
insert into Employees (emp_id, event_day, in_time, out_time) values ('1', '2020-12-3', '1', '42');
insert into Employees (emp_id, event_day, in_time, out_time) values ('2', '2020-11-28', '3', '33');
insert into Employees (emp_id, event_day, in_time, out_time) values ('2', '2020-12-9', '47', '74');

select * from employees;

select 
e1.event_day , e1.emp_id ,
sum(e1.out_time - e1.in_time)+(e2.out_time - e2.in_time) as total_time 
from employees as e1
join employees as e2
on e1.emp_id = e2.emp_id
group by e1.event_day , e1.emp_id;

select event_day , emp_id ,
sum(out_time - in_time)as total_time
from employees
group by event_day , emp_id
order by event_day;

#-------- Wednesday 12/03 ------------------#

-- Q:1
-- Duplicate Emails

Create table If Not Exists Person (id int, email varchar(255));
Truncate table Person;
insert into Person (id, email) values ('1', 'a@b.com');
insert into Person (id, email) values ('2', 'c@d.com');
insert into Person (id, email) values ('3', 'a@b.com');

select * from Person;

SELECT email from Person
group by email
having count(email) > 1;

-- Q:2
-- Actors and Directors Who Cooperated At Least Three Times

Create table If Not Exists ActorDirector (actor_id int, director_id int, timestamp int);
Truncate table ActorDirector;
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '0');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '1');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '2');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '2', '3');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '2', '4');
insert into ActorDirector (actor_id, director_id, timestamp) values ('2', '1', '5');
insert into ActorDirector (actor_id, director_id, timestamp) values ('2', '1', '6');

select * from ActorDirector;

with cte
as 
(
    Select actor_id , director_id,
    row_number() over(partition by actor_id , director_id) as rk
    from ActorDirector 
)
select actor_id , director_id from cte
where rk =1 and actor_id=director_id;

-- Q:4
-- Product Sales Analysis III

drop table product;
Create table If Not Exists Sales (sale_id int, product_id int, year int, quantity int, price int);
Create table If Not Exists Product (product_id int, product_name varchar(10));
Truncate table Sales;
insert into Sales (sale_id, product_id, year, quantity, price) values ('1', '100', '2008', '10', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('2', '100', '2009', '12', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('7', '200', '2011', '15', '9000');
Truncate table Product;
insert into Product (product_id, product_name) values ('100', 'Nokia');
insert into Product (product_id, product_name) values ('200', 'Apple');
insert into Product (product_id, product_name) values ('300', 'Samsung');

select * from Sales;
select * from Product;

WITH CTE AS (
    SELECT product_id, MIN(year) AS minyear FROM Sales 
    GROUP BY product_id 
)

SELECT s.product_id, s.year AS first_year, s.quantity, s.price 
FROM Sales s
INNER JOIN CTE ON cte.product_id = s.product_id  AND s.year = cte.minyear; 

-- Q:5 

CREATE TABLE repair_records (
    client VARCHAR(10),
    auto VARCHAR(10),
    repair_date YEAR,
    indicator VARCHAR(20),
    value VARCHAR(20)
);

INSERT INTO repair_records (client, auto, repair_date, indicator, value) VALUES
('c1', 'a1', 2022, 'level', 'good'),
('c1', 'a1', 2022, 'velocity', '90'),
('c1', 'a1', 2023, 'level', 'regular'),
('c1', 'a1', 2023, 'velocity', '80'),
('c1', 'a1', 2024, 'level', 'wrong'),
('c1', 'a1', 2024, 'velocity', '70'),
('c2', 'a1', 2022, 'level', 'good'),
('c2', 'a1', 2022, 'velocity', '90'),
('c2', 'a1', 2023, 'level', 'wrong'),
('c2', 'a1', 2023, 'velocity', '50'),
('c2', 'a2', 2024, 'level', 'good'),
('c2', 'a2', 2024, 'velocity', '80');

select * from repair_records;
select distinct indicator from repair_records;

With velocity as (select row_number() over() as rn,value as velocity  from repair_records
where indicator='velocity'),
level as 
(select  row_number() over() as rn,value as level from repair_records
where indicator='level') 
select v.velocity,
count(case when level='good' then velocity end) as good,
count(case when level='wrong' then velocity end) as wrong,
count(case when level='regular' then velocity end) as regular
from velocity v 
join 
level l 
on v.rn=l.rn
group by 1
order by velocity;

#---------- thursday 13/03 ---------------------------------#

-- Q:1
-- Monthly Transactions I
drop table Transactions;
Create table If Not Exists Transactions (id int, country varchar(4), state enum('approved', 'declined'), amount int, trans_date date);
Truncate table Transactions;
insert into Transactions (id, country, state, amount, trans_date) values ('121', 'US', 'approved', '1000', '2018-12-18');
insert into Transactions (id, country, state, amount, trans_date) values ('122', 'US', 'declined', '2000', '2018-12-19');
insert into Transactions (id, country, state, amount, trans_date) values ('123', 'US', 'approved', '2000', '2019-01-01');
insert into Transactions (id, country, state, amount, trans_date) values ('124', 'DE', 'approved', '2000', '2019-01-07');

select * from Transactions;

select left(trans_date,7) as month, # or dateformat(trans_date,'%Y-%m')
country,
count(id) as trans_count,
sum(case when state='approved' then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state='approved' then amount else 0 end) as approved_total_amount
from transactions
group by month,country;

-- Q:2
-- Consecutive Numbers

Create table If Not Exists Logs (id int, num int);
Truncate table Logs;
insert into Logs (id, num) values ('1', '1');
insert into Logs (id, num) values ('2', '1');
insert into Logs (id, num) values ('3', '1');
insert into Logs (id, num) values ('4', '2');
insert into Logs (id, num) values ('5', '1');
insert into Logs (id, num) values ('6', '2');
insert into Logs (id, num) values ('7', '2');

select * from logs;

with cte
as
(
	select *,
	row_number() over(partition by num) as rk
	from logs
)
select distinct num from cte
where  rk <=3;

with cte as
(
	select l1.id ,l1.num,
	rank() over(partition by l1.num)as rk
	from logs as l1
    join logs as l2
    on l1.id=l2.id and l1.num=l2.num 
)
select 
distinct
case
	when num = rk then num 
end as num
from cte;

-- TQF Problem

CREATE TABLE VACATION_PLANS (
    ID INT PRIMARY KEY,
    EMP_ID INT,
    FROM_DT DATE,
    TO_DT DATE
);
INSERT INTO VACATION_PLANS (ID, EMP_ID, FROM_DT, TO_DT) VALUES
(1, 1, '2024-02-12', '2024-02-16'),
(2, 2, '2024-02-20', '2024-02-29'),
(3, 3, '2024-03-01', '2024-03-31'),
(4, 1, '2024-04-11', '2024-04-23'),
(5, 4, '2024-06-01', '2024-06-30'),
(6, 3, '2024-07-05', '2024-07-15'),
(7, 3, '2024-08-28', '2024-09-15');

select * from VACATION_PLANS;

CREATE TABLE LEAVE_BALANCE (
    EMP_ID INT PRIMARY KEY,
    BALANCE INT
);

INSERT INTO LEAVE_BALANCE (EMP_ID, BALANCE) VALUES
(1, 12),
(2, 10),
(3, 26),
(4, 20),
(5, 14);

select  * from VACATION_PLANS;
select * from LEAVE_BALANCE;

-- Q:4 :
-- Human Traffic of Stadium

Create table If Not Exists Stadium (id int, visit_date DATE NULL, people int);
Truncate table Stadium;
insert into Stadium (id, visit_date, people) values ('1', '2017-01-01', '10');
insert into Stadium (id, visit_date, people) values ('2', '2017-01-02', '109');
insert into Stadium (id, visit_date, people) values ('3', '2017-01-03', '150');
insert into Stadium (id, visit_date, people) values ('4', '2017-01-04', '99');
insert into Stadium (id, visit_date, people) values ('5', '2017-01-05', '145');
insert into Stadium (id, visit_date, people) values ('6', '2017-01-06', '1455');
insert into Stadium (id, visit_date, people) values ('7', '2017-01-07', '199');
insert into Stadium (id, visit_date, people) values ('8', '2017-01-09', '188');


select * from Stadium;

with recursive cte as
(
	Select id,visit_date,people,
	row_number() over(order by people desc) as rk
	from Stadium
)
select visit_date,people,rk
from cte
where people >=100 and rk>=1;

#--------------- Friday 14-03 ----------------------------#

-- TQF Problem solving 
-- Bussiness analtyst interview Question :

create table candidates
(
    id int,
    gender varchar(1),
    age int,
    party varchar(20)
);

create table results
(
    constituency_id     int,
    candidate_id        int,
    votes               int
);

insert into candidates values(1,'M',55,'Democratic');
insert into candidates values(2,'M',51,'Democratic');
insert into candidates values(3,'F',62,'Democratic');
insert into candidates values(4,'M',60,'Republic');
insert into candidates values(5,'F',61,'Republic');
insert into candidates values(6,'F',58,'Republic');

insert into results values(1,1,847529);
insert into results values(1,4,283409);
insert into results values(2,2,293841);
insert into results values(2,5,394385);
insert into results values(3,3,429084);
insert into results values(3,6,303890);
-- Expected o/p

-- Democratic 2
-- Republic 1

select * from candidates;
select * from results;

with cte_election
as 
(
	Select *,
	rank() over(partition by constituency_id order by votes desc) as rk
	from candidates as c
	join results as r
	on r.candidate_id = c.id 
	order by constituency_id ,votes desc
)
select concat(party, ' ',count(party)) as candidates from cte_election
where rk=1
group by party;

-- TQF Problem 2
-- Advertising System Deviations report

create table customers
(
    id          int,
    first_name  varchar(50),
    last_name   varchar(50)
);
insert into customers values(1, 'Carolyn', 'O''Lunny');
insert into customers values(2, 'Matteo', 'Husthwaite');
insert into customers values(3, 'Melessa', 'Rowesby');

create table campaigns
(
    id          int,
    customer_id int,
    name        varchar(50)
);
insert into campaigns values(2, 1, 'Overcoming Challenges');
insert into campaigns values(4, 1, 'Business Rules');
insert into campaigns values(3, 2, 'YUI');
insert into campaigns values(1, 3, 'Quantitative Finance');
insert into campaigns values(5, 3, 'MMC');

create table events
(
    campaign_id int,
    status      varchar(50)
);
insert into events values(1, 'success');
insert into events values(1, 'success');
insert into events values(2, 'success');
insert into events values(2, 'success');
insert into events values(2, 'success');
insert into events values(2, 'success');
insert into events values(2, 'success');
insert into events values(3, 'success');
insert into events values(3, 'success');
insert into events values(3, 'success');
insert into events values(4, 'success');
insert into events values(4, 'success');
insert into events values(4, 'failure');
insert into events values(4, 'failure');
insert into events values(5, 'failure');
insert into events values(5, 'failure');
insert into events values(5, 'failure');
insert into events values(5, 'failure');
insert into events values(5, 'failure');
insert into events values(5, 'failure');

insert into events values(4, 'success');
insert into events values(5, 'success');
insert into events values(5, 'success');
insert into events values(1, 'failure');
insert into events values(1, 'failure');
insert into events values(1, 'failure');
insert into events values(2, 'failure');
insert into events values(3, 'failure');

select * from customers;
select * from campaigns;
select * from events;

    SELECT * 
    FROM customers AS cs
    JOIN campaigns AS cm ON cs.id = cm.customer_id
    JOIN events AS e ON cm.id = e.campaign_id;


with cte as 
    (select (cst.first_name||' '||cst.last_name) as customer
    , ev.status as event_type
    , group_concat(distinct cmp.name, ', ') as campaign 
    , count(1) as total
    , rank() over (partition by status order by count(1) desc) as rnk
    from customers cst
    join campaigns cmp on cmp.customer_id = cst.id
    join events ev on ev.campaign_id = cmp.id
    group by customer, status)
select event_type, customer, campaign, total
from cte 
where rnk = 1
order by event_type desc;
 
 -- TQF Problem :
 
 drop table if exists candidates_tab;
create table candidates_tab
(
    id          int,
    first_name  varchar(50),
    last_name   varchar(50)
);
insert into candidates_tab values(1, 'Davide', 'Kentish');
insert into candidates_tab values(2, 'Thorstein', 'Bridge');

drop table if exists results_tab;
create table results_tab
(
    candidate_id    int,
    state           varchar(50)
);
insert into results_tab values(1, 'Alabama');
insert into results_tab values(1, 'Alabama');
insert into results_tab values(1, 'California');
insert into results_tab values(1, 'California');
insert into results_tab values(1, 'California');
insert into results_tab values(1, 'California');
insert into results_tab values(1, 'California');
insert into results_tab values(2, 'California');
insert into results_tab values(2, 'California');
insert into results_tab values(2, 'New York');
insert into results_tab values(2, 'New York');
insert into results_tab values(2, 'Texas');
insert into results_tab values(2, 'Texas');
insert into results_tab values(2, 'Texas');

insert into results_tab values(1, 'New York');
insert into results_tab values(1, 'Texas');
insert into results_tab values(1, 'Texas');
insert into results_tab values(1, 'Texas');
insert into results_tab values(2, 'California');
insert into results_tab values(2, 'Alabama');

select * from candidates_tab;
select * from results_tab;

with cte as
    (select concat(first_name,' ',last_name) as candidate_name
    , state
    , count(1) as total
    , dense_rank() over(partition by concat(first_name,' ',last_name) order by count(1) desc) as rnk
    from candidates_tab c
    join results_tab r on r.candidate_id = c.id
    group by candidate_name, state)
select candidate_name
, group_concat(case when rnk = 1 then state||' ('||total||')' end, ', ' order by state) as "1st_place"
, group_concat(case when rnk = 2 then state||' ('||total||')' end, ', ') as "2nd_place"
, group_concat(case when rnk = 3 then state||' ('||total||')' end, ', ') as "3rd_place"
from cte 
where rnk <= 3
group by candidate_name;

#---------- 17/03 Monday --------------------------------------#

create table job_positions
(
	id			int,
	title 		varchar(100),
	`groups` 		varchar(10),
	levels		varchar(10),
	payscale	int,
	totalpost	int
);
insert into job_positions values (1, 'General manager', 'A', 'l-15', 10000, 1);
insert into job_positions values (2, 'Manager', 'B', 'l-14', 9000, 5);
insert into job_positions values (3, 'Asst. Manager', 'C', 'l-13', 8000, 10);

drop table if exists job_employees;
create table job_employees
(
	id				int,
	name 			varchar(100),
	position_id 	int
);
insert into job_employees values (1, 'John Smith', 1);
insert into job_employees values (2, 'Jane Doe', 2);
insert into job_employees values (3, 'Michael Brown', 2);
insert into job_employees values (4, 'Emily Johnson', 2);
insert into job_employees values (5, 'William Lee', 3);
insert into job_employees values (6, 'Jessica Clark', 3);
insert into job_employees values (7, 'Christopher Harris', 3);
insert into job_employees values (8, 'Olivia Wilson', 3);
insert into job_employees values (9, 'Daniel Martinez', 3);
insert into job_employees values (10, 'Sophia Miller', 3);

select * from job_positions;
select * from job_employees;

WITH RECURSIVE series AS (
    SELECT 1 AS rn
    UNION ALL
    SELECT rn + 1 FROM series WHERE rn < (SELECT MAX(totalpost) FROM job_positions)
)
SELECT 
    p.title, 
    p.groups, 
    p.levels, 
    p.payscale, 
    COALESCE(e.name, 'Vacant') AS employee_name
FROM job_positions p
JOIN series ON series.rn <= p.totalpost
LEFT JOIN (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY position_id ORDER BY id) AS rn
    FROM job_employees
) e 
ON e.position_id = p.id AND e.rn = series.rn
order by  p.title;

-- TQF Problem :
-- Ungroup Data 

CREATE TABLE items (
    id INT PRIMARY KEY,
    item_name VARCHAR(255),
    total_count INT
);
INSERT INTO items (id, item_name, total_count) VALUES
(1, 'Water Bottle', 2),
(2, 'Tent', 1),
(3, 'Apple', 4);

select * from items;

WITH RECURSIVE item_expansion AS (
    -- Base case: Start with 1 for each item
    SELECT id, item_name, total_count, 1 AS rn 
    FROM items 
    UNION ALL
    -- Recursive case: Increment rn until it reaches total_count
    SELECT id, item_name, total_count, rn + 1 
    FROM item_expansion 
    WHERE rn < total_count
)
SELECT id, item_name 
FROM item_expansion
ORDER BY id, rn;

select * from items;

-- TQF Problem 2 
-- Continous increase based on year 

CREATE TABLE sales (
    year INT,
    brand VARCHAR(50),
    amount INT
);

INSERT INTO sales (year, brand, amount) VALUES
(2018, 'Apple', 45000),
(2019, 'Apple', 35000),
(2020, 'Apple', 75000),
(2018, 'Samsung', 15000),
(2019, 'Samsung', 20000),
(2020, 'Samsung', 25000),
(2018, 'Nokia', 21000),
(2019, 'Nokia', 17000),
(2020, 'Nokia', 14000);

select * from sales;

with red as    (
			select *,
			RANK() over(partition by brand order by amount asc) as 'rnk'
			,rank() over(partition by brand order by year asc)  as 'yrnk'from sales
			) 
select * from sales where brand not in (
select distinct brand from red where rnk<>yrnk);

-- TQF Problem 3
-- Find the scound highest travel 

CREATE TABLE activities (
    username VARCHAR(50),
    activity VARCHAR(50),
    startDate DATE,
    endDate DATE
);

INSERT INTO activities (username, activity, startDate, endDate) VALUES
('Amy', 'Travel', '2020-02-12', '2020-02-20'),
('Amy', 'Dancing', '2020-02-21', '2020-02-23'),
('Amy', 'Travel', '2020-02-24', '2020-02-28'),
('Joe', 'Travel', '2020-02-11', '2020-02-18');

select *,
row_number() over(partition by username,activity) as rk
from activities;

#--------------- Thuesday 18/03 -----------------------------------#

-- Q:1
-- Game First Login 

Create table If Not Exists Activity (player_id int, device_id int, event_date date, games_played int);
Truncate table Activity;
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-01', '5');
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-05-02', '6');
insert into Activity (player_id, device_id, event_date, games_played) values ('2', '3', '2017-06-25', '1');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '1', '2016-03-02', '0');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '4', '2018-07-03', '5');

select player_id,min(event_date) as first_login
from activity 
group by player_id;

-- Q:2 
-- profit Gain / loss

Create Table If Not Exists Stocks (stock_name varchar(15), operation ENUM('Sell', 'Buy'), operation_day int, price int);
Truncate table Stocks;
insert into Stocks (stock_name, operation, operation_day, price) values ('Leetcode', 'Buy', '1', '1000');
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Buy', '2', '10');
insert into Stocks (stock_name, operation, operation_day, price) values ('Leetcode', 'Sell', '5', '9000');
insert into Stocks (stock_name, operation, operation_day, price) values ('Handbags', 'Buy', '17', '30000');
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Sell', '3', '1010');
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Buy', '4', '1000');
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Sell', '5', '500');
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Buy', '6', '1000');
insert into Stocks (stock_name, operation, operation_day, price) values ('Handbags', 'Sell', '29', '7000');
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Sell', '10', '10000');

select * from stocks;

select stock_name ,
sum(
	case
		when operation='Buy' then -price else price
    end
) as capital_gain_loss 
from stocks
group by stock_name;

-- Q:3
-- Market analyze

Create table If Not Exists Users (user_id int, join_date date, favorite_brand varchar(10));
Create table If Not Exists Orders (order_id int, order_date date, item_id int, buyer_id int, seller_id int);
Create table If Not Exists Items (item_id int, item_brand varchar(10));
Truncate table Users;
insert into Users (user_id, join_date, favorite_brand) values ('1', '2018-01-01', 'Lenovo');
insert into Users (user_id, join_date, favorite_brand) values ('2', '2018-02-09', 'Samsung');
insert into Users (user_id, join_date, favorite_brand) values ('3', '2018-01-19', 'LG');
insert into Users (user_id, join_date, favorite_brand) values ('4', '2018-05-21', 'HP');
Truncate table Orders;
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('1', '2019-08-01', '4', '1', '2');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('2', '2018-08-02', '2', '1', '3');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('3', '2019-08-03', '3', '2', '3');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('4', '2018-08-04', '1', '4', '2');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('5', '2018-08-04', '1', '3', '4');
insert into Orders (order_id, order_date, item_id, buyer_id, seller_id) values ('6', '2019-08-05', '2', '2', '4');
Truncate table Items;
insert into Items (item_id, item_brand) values ('1', 'Samsung');
insert into Items (item_id, item_brand) values ('2', 'Lenovo');
insert into Items (item_id, item_brand) values ('3', 'LG');
insert into Items (item_id, item_brand) values ('4', 'HP');

select * from users;
select * from orders;
select * from items;

SELECT u.user_id as buyer_id, u.join_date, count(o.order_id) as 'orders_in_2019'
FROM users u
LEFT JOIN Orders o
ON o.buyer_id=u.user_id AND YEAR(order_date)='2019'
GROUP BY u.user_id,u.join_date;

-- Q:4
-- Find The Who Improved

CREATE TABLE Scores (
    student_id INT,
    subject VARCHAR(50),
    score INT,
    exam_date VARCHAR(10)
);
Truncate table Scores;
insert into Scores (student_id, subject, score, exam_date) values ('101', 'Math', '70', '2023-01-15');
insert into Scores (student_id, subject, score, exam_date) values ('101', 'Math', '85', '2023-02-15');
insert into Scores (student_id, subject, score, exam_date) values ('101', 'Physics', '65', '2023-01-15');
insert into Scores (student_id, subject, score, exam_date) values ('101', 'Physics', '60', '2023-02-15');
insert into Scores (student_id, subject, score, exam_date) values ('102', 'Math', '80', '2023-01-15');
insert into Scores (student_id, subject, score, exam_date) values ('102', 'Math', '85', '2023-02-15');
insert into Scores (student_id, subject, score, exam_date) values ('103', 'Math', '90', '2023-01-15');
insert into Scores (student_id, subject, score, exam_date) values ('104', 'Physics', '75', '2023-01-15');
insert into Scores (student_id, subject, score, exam_date) values ('104', 'Physics', '85', '2023-02-15');

select * from scores;

WITH Ranked 
AS (
    SELECT
    student_id,
    subject,
    FIRST_VALUE(score) OVER(PARTITION BY student_id,subject ORDER BY exam_date) AS first_score,
    FIRST_VALUE(score) OVER(PARTITION BY student_id,subject ORDER BY exam_date DESC) AS latest_score
    FROM Scores
)
SELECT DISTINCT * FROM Ranked
WHERE first_score<latest_score
ORDER BY student_id,subject;

#----------------Thuresday 20/03 ---------------------#

-- Q:1
-- Calculate sum for per day

CREATE TABLE sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sale_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO sales (sale_date, amount) VALUES 
('2024-03-01', 100),
('2024-03-02', 150),
('2024-03-03', 200),
('2024-03-04', 250),
('2024-03-05', 300);

select * from sales;

Select id , sale_date ,amount,
amount - lag(amount,1,0) over(order by sale_date)as Sales_per_day
from sales;

-- Q:2
-- group aggregation

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO employees (id, name) VALUES 
(1, 'Emp1'),
(2, 'Emp2'),
(3, 'Emp3'),
(4, 'Emp4'),
(5, 'Emp5'),
(6, 'Emp6'),
(7, 'Emp7'),
(8, 'Emp8');

select * from employees;

with cte_agg
as
(
	select id,concat(id, ' ' ,name) as emp,
	ntile(4) over(order by name)as nt
	from employees
)
select nt ,group_concat(emp) as result
from cte_agg
group by nt;

-- Q:3
-- Find the Duplicate record

create table users
(
user_id int primary key,
user_name varchar(30) not null,
email varchar(50));

insert into users values
(1, 'Sumit', 'sumit@gmail.com'),
(2, 'Reshma', 'reshma@gmail.com'),
(3, 'Farhana', 'farhana@gmail.com'),
(4, 'Robin', 'robin@gmail.com'),
(5, 'Robin', 'robin@gmail.com');

Select * from users;

With cte_duplicate
as
(
	select * ,
	row_number() Over(partition by user_name,email) as rk
	from users
)
select * from cte_duplicate
where rk > 1;

-- Q:4
--

create table employee
( emp_ID int primary key
, emp_NAME varchar(50) not null
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);


select * from employee;

with cte as
(	select *,
	row_number() over(order by emp_id desc) as rk
	from employee
)
select * from cte
where rk =2;

-- Q:5
-- Find the Min & Max Salary

create table employee
( emp_ID int primary key
, emp_NAME varchar(50) not null
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);

select * from employee;

select x.*
from employee e
join (select *,
max(salary) over (partition by dept_name) as max_salary,
min(salary) over (partition by dept_name) as min_salary
from employee) x
on e.emp_id = x.emp_id
and (e.salary = x.max_salary or e.salary = x.min_salary)
order by x.dept_name, x.salary;


-- Q:6
-- Same Hospital but different speaclity 

CREATE TABLE doctors (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    speciality VARCHAR(100),
    hospital VARCHAR(50),
    city VARCHAR(50),
    consultation_fee INT
);

INSERT INTO doctors (id, name, speciality, hospital, city, consultation_fee) VALUES 
(1, 'Dr. Shashank', 'Ayurveda', 'Apollo Hospital', 'Bangalore', 2500),
(2, 'Dr. Abdul', 'Homeopathy', 'Fortis Hospital', 'Bangalore', 2000),
(3, 'Dr. Shwetha', 'Homeopathy', 'KMC Hospital', 'Manipal', 1000),
(4, 'Dr. Murphy', 'Dermatology', 'KMC Hospital', 'Manipal', 1500),
(5, 'Dr. Farhana', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1700),
(6, 'Dr. Maryam', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1500);

select * from doctors;

Select d1.id,d1.speciality,d1.hospital 
from doctors d1
join doctors d2
on d1.id<>d2.id And d1.hospital=d2.hospital and d1.speciality<>d2.speciality

-- Q:7
-- More then 3 logins

create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

insert into login_details values
(101, 'Michael', current_date),
(102, 'James', current_date),
(103, 'Stewart', current_date+1),
(104, 'Stewart', current_date+1),
(105, 'Stewart', current_date+1),
(106, 'Michael', current_date+2),
(107, 'Michael', current_date+2),
(108, 'Stewart', current_date+3),
(109, 'Stewart', current_date+3),
(110, 'James', current_date+4),
(111, 'James', current_date+4),
(112, 'James', current_date+5),
(113, 'James', current_date+6);

select * from login_details;

select distinct repeated_names
from (
select *,
case when user_name = lead(user_name) over(order by login_id)
and  user_name = lead(user_name,2) over(order by login_id)
then user_name else null end as repeated_names
from login_details) x
where x.repeated_names is not null;

-- Q:7
-- 

create table students
(
id int primary key,
student_name varchar(50) not null
);
insert into students values
(1, 'James'),
(2, 'Michael'),
(3, 'George'),
(4, 'Stewart'),
(5, 'Robin');

select * from students;

select id,student_name,
case when id%2 <> 0 then lead(student_name,1,student_name) over(order by id)
when id%2 = 0 then lag(student_name) over(order by id) end as new_student_name
from students;

#---------- Apr 1 ------------------------#

CREATE TABLE status (
    parent_id INT,
    child_id INT,
    status VARCHAR(10),
    PRIMARY KEY (parent_id, child_id)
);

INSERT INTO status (parent_id, child_id, status) VALUES
(1, 3, 'Active'),
(1, 4, 'InActive'),
(1, 5, 'Active'),
(1, 6, 'InActive'),
(2, 7, 'Active'),
(2, 8, 'InActive'),
(3, 9, 'Inactive'),
(4, 10, 'Inactive'),
(4, 11, 'Active'),
(5, 12, 'InActive'),
(5, 13, 'InActive');

select * from status;

with active as
(	select distinct parent_id,status from 
	status where status='Active'
),
inactice as 
(
	select distinct parent_id,status from 
	status where parent_id not in (select parent_id from active)
)
select * from inactice
union
select * from active
order by 1;

-- Solution 2 (Using Windows Function)

select parent_id,status from
(Select parent_id,status,
row_number() over(partition by parent_id order by status) as rk
from status
)c
where rk=1 ;

select parent_id,min(status)
from status
group by parent_id
order by parent_id;

-----------------------------------------------------

# ----------- Apr 2 ----------------#

-- Find the Second Highest Salary

CREATE TABLE Employees (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary INT
);

INSERT INTO Employees (ID, Name, Salary) VALUES
(1, 'Alice', 5000),
(2, 'Bob', 7000),
(3, 'Carol', 6000),
(4, 'Dave', 8000);


select * from employees;

with second_salary as
(
Select *,
dense_rank() over(order by salary desc) as rk
from employees
)
select ID,Name,Salary
from second_salary
where rk=2;

-- 2. Find the Highest Salary Employee in Each Department

CREATE TABLE Employee (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary INT,
    Dept VARCHAR(50)
);

INSERT INTO Employee (ID, Name, Salary, Dept) VALUES
(1, 'Alice', 5000, 'IT'),
(2, 'Bob', 7000, 'IT'),
(3, 'Carol', 6000, 'HR'),
(4, 'Dave', 8000, 'HR');

Select * from employee;

Select *,
MAX(salary) over(partition by Dept order by salary desc) as max_salary
from employee;

-- 3. Count the Number of Orders for Each Customer

CREATE TABLE Orders1 (
    OrderID INT PRIMARY KEY,
    CustomerID VARCHAR(10),
    Amount INT
);

INSERT INTO Orders1 (OrderID, CustomerID, Amount) VALUES
(101, 'C001', 500),
(102, 'C002', 1000),
(103, 'C001', 700),
(104, 'C003', 400);

select * from orders1;

SELECT CustomerID, COUNT(*) AS OrderCount 
FROM Orders1 
GROUP BY CustomerID;

-- If two rows are brand-swapped duplicates (like apple/samsung and samsung/apple in the same year) AND CUSTOM1 = CUSTOM3 & CUSTOM2 = CUSTOM4 → Keep only one.
-- If the CUSTOM values do not match, keep both pairs.
-- If a brand does not have a pair, kee
 
CREATE TABLE BrandPairs (
    BRAND1 VARCHAR(50),
    BRAND2 VARCHAR(50),
    YEAR INT,
    CUSTOM1 INT,
    CUSTOM2 INT,
    CUSTOM3 INT,
    CUSTOM4 INT
);

INSERT INTO BrandPairs (BRAND1, BRAND2, YEAR, CUSTOM1, CUSTOM2, CUSTOM3, CUSTOM4) VALUES
('apple', 'samsung', 2020, 1, 2, 1, 2),
('samsung', 'apple', 2020, 1, 2, 1, 2),
('apple', 'samsung', 2021, 1, 2, 5, 3),
('samsung', 'apple', 2021, 5, 3, 1, 2),
('google', 'google', 2020, 5, 9, NULL, NULL),
('oneplus', 'nothing', 2020, 5, 9, 6, 3);

select * from brandpairs;

With cte_concate as
(Select *,
case
	when BRAND1>BRAND2 Then concat(BRAND1,BRAND2,YEAR) ELSE concat(BRAND2,BRAND1,YEAR)
end as pair
from brandpairs)
,cte_rn as 
(
	select *,
    row_number() over(partition by pair order by pair) as rk
    from cte_concate
)
select BRAND1,BRAND2,YEAR,CUSTOM1,CUSTOM2,CUSTOM3,CUSTOM4 from cte_rn
where rk=1 or (CUSTOM1 = CUSTOM3 and CUSTOM2 = CUSTOM4);

-- Footer values : 

CREATE TABLE Cars (
    ID INT PRIMARY KEY,
    CAR VARCHAR(50),
    LENGTH INT,
    WIDTH INT,
    HEIGHT INT
);

INSERT INTO Cars (ID, CAR, LENGTH, WIDTH, HEIGHT) VALUES
(1, 'Hyundai Tucson', 15, 6, NULL),
(2, NULL, NULL, NULL, 20),
(3, NULL, 12, 8, 15),
(4, 'Toyota Rav4', 15, NULL, NULL),
(5, 'Kia Sportage', NULL, NULL, 18);

select * from cars;

select CAR from cars where CAR is not null order by ID desc limit 1;
select LENGTH from cars where LENGTH is not null order by ID desc limit 1;
select WIDTH from cars where WIDTH is not null order by ID desc limit 1;
select HEIGHT from cars where HEIGHT is not null order by ID desc limit 1;

SELECT 
    (SELECT CAR FROM Cars WHERE CAR IS NOT NULL ORDER BY ID DESC LIMIT 1) AS CAR,
    (SELECT LENGTH FROM Cars WHERE LENGTH IS NOT NULL ORDER BY ID DESC LIMIT 1) AS LENGTH,
    (SELECT WIDTH FROM Cars WHERE WIDTH IS NOT NULL ORDER BY ID DESC LIMIT 1) AS WIDTH,
    (SELECT HEIGHT FROM Cars WHERE HEIGHT IS NOT NULL ORDER BY ID DESC LIMIT 1) AS HEIGHT;

-- find the first order date and total amount spent for each customer in the same row.

CREATE TABLE Order1 (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate TIMESTAMP,
    Amount DECIMAL(10,2)
);

INSERT INTO Order1 (OrderID, CustomerID, OrderDate, Amount) VALUES
(1, 101, '2024-03-01 10:30:00', 250.00),
(2, 102, '2024-03-02 11:00:00', 150.00),
(3, 101, '2024-03-05 14:45:00', 300.00),
(4, 103, '2024-03-07 16:20:00', 500.00),
(5, 102, '2024-03-10 18:10:00', 200.00),
(6, 101, '2024-03-15 09:25:00', 100.00),
(7, 103, '2024-03-18 12:50:00', 400.00),
(8, 104, '2024-03-20 15:30:00', 600.00);

select * from order1;

SELECT 
    CustomerID,
    MIN(OrderDate) AS FirstOrderDate,
    SUM(Amount) AS TotalSpent
FROM Order1
GROUP BY CustomerID;

-- Write a query to find the top 3 highest-spending customers along with their total spending amount.

CREATE TABLE Transaction (
    TransactionID INT PRIMARY KEY,
    CustomerID INT,
    Amount DECIMAL(10,2),
    TransactionDate TIMESTAMP
);

INSERT INTO Transaction (TransactionID, CustomerID, Amount, TransactionDate) VALUES
(1, 101, 500.00, '2024-03-01 10:30:00'),
(2, 102, 300.00, '2024-03-02 11:00:00'),
(3, 101, 700.00, '2024-03-05 14:45:00'),
(4, 103, 1200.00, '2024-03-07 16:20:00'),
(5, 102, 500.00, '2024-03-10 18:10:00'),
(6, 101, 600.00, '2024-03-15 09:25:00'),
(7, 104, 1300.00, '2024-03-18 12:50:00'),
(8, 105, 900.00, '2024-03-20 15:30:00');

select * from transaction;

with sum_salary
as
(select CustomerID ,sum(Amount) as total
from transaction
group by CustomerID)
select * from sum_salary order by total desc limit 3;

-- Write a query to find the second highest sale amount from the table without using LIMIT.

CREATE TABLE Sale (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    SaleAmount DECIMAL(10,2),
    SaleDate TIMESTAMP
);

INSERT INTO Sale (SaleID, ProductID, CustomerID, SaleAmount, SaleDate) VALUES
(1, 101, 201, 500.00, '2024-03-01 10:30:00'),
(2, 102, 202, 1200.00, '2024-03-02 11:00:00'),
(3, 103, 203, 900.00, '2024-03-05 14:45:00'),
(4, 104, 204, 1500.00, '2024-03-07 16:20:00'),
(5, 105, 205, 700.00, '2024-03-10 18:10:00'),
(6, 106, 206, 1300.00, '2024-03-15 09:25:00'),
(7, 107, 207, 800.00, '2024-03-18 12:50:00'),
(8, 108, 208, 1600.00, '2024-03-20 15:30:00');

select * from sale;

with cte as 
(select SaleAmount,
row_number() over(order by SaleAmount desc) as rk
from sale)
select SaleAmount from cte
where rk=2;

-- Write a query to find the highest-paid employee in each department along with their salary.

CREATE TABLE Employees1 (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);

INSERT INTO Employees1 (EmployeeID, Name, Department, Salary, HireDate) VALUES
(1, 'Alice', 'IT', 90000, '2020-05-10'),
(2, 'Bob', 'HR', 70000, '2018-06-15'),
(3, 'Charlie', 'Finance', 120000, '2019-07-20'),
(4, 'David', 'IT', 95000, '2021-08-25'),
(5, 'Eve', 'HR', 75000, '2017-09-30'),
(6, 'Frank', 'Finance', 110000, '2016-10-05'),
(7, 'Grace', 'IT', 98000, '2022-11-10'),
(8, 'Hank', 'HR', 72000, '2023-01-12');


select * from employees1;

SELECT e.Department, e.Name, e.Salary 
FROM Employees1 e
JOIN (
    SELECT Department, MAX(Salary) AS MaxSalary
    FROM Employees1
    GROUP BY Department
) m ON e.Department = m.Department AND e.Salary = m.MaxSalary;

-- TQF Problem : 

select * from cars;

select min(id) as id,min(car) as car,min(LENGTH)as LENGTH,min(WIDTH)as WIDTH,min(HEIGHT)as HEIGHT
from cars
UNION ALL
select MAX(id) as id,max(car) as car,max(LENGTH)as LENGTH,max(WIDTH)as WIDTH,max(HEIGHT)as HEIGHT
from cars;

with recursive cte as
(
 select 1 as n
 union all
 select n+1 from cte where n<13
)
select * from cte;

#--------------- Apr 4 -----------------------------#

-- Find the Top 3 salesPerson : 

CREATE TABLE Sale1 (
    SaleID INT PRIMARY KEY,
    Salesperson VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT,
    PricePerUnit DECIMAL(10,2),
    SaleDate DATE
);

INSERT INTO Sale1 (SaleID, Salesperson, Product, Quantity, PricePerUnit, SaleDate) VALUES
(1, 'Alice', 'Laptop', 5, 800.00, '2024-03-01'),
(2, 'Bob', 'Mobile', 10, 500.00, '2024-03-02'),
(3, 'Alice', 'Tablet', 7, 300.00, '2024-03-03'),
(4, 'Charlie', 'Laptop', 3, 900.00, '2024-03-04'),
(5, 'Bob', 'Laptop', 2, 850.00, '2024-03-05'),
(6, 'Alice', 'Mobile', 6, 600.00, '2024-03-06'),
(7, 'Charlie', 'Tablet', 4, 350.00, '2024-03-07'),
(8, 'Bob', 'Tablet', 8, 400.00, '2024-03-08'),
(9, 'Charlie', 'Mobile', 5, 550.00, '2024-03-09'),
(10, 'Alice', 'Laptop', 4, 750.00, '2024-03-10');

select * from sale1;

select * from sale1 order by PricePerUnit desc limit 3;			-- one solution 

SELECT Salesperson, SUM(Quantity * PricePerUnit) AS TotalRevenue
FROM Sale1
GROUP BY Salesperson
ORDER BY TotalRevenue DESC
LIMIT 3;

-- Who earn more than their manager : 

CREATE TABLE Employee1 (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Salary DECIMAL(10,2),
    ManagerID INT
);

INSERT INTO Employee1 (EmpID, EmpName, Salary, ManagerID) VALUES
(1, 'Alice', 90000, NULL),    -- Alice is the CEO (no manager)
(2, 'Bob', 75000, 1),         -- Bob reports to Alice
(3, 'Charlie', 50000, 1),     -- Charlie reports to Alice
(4, 'David', 80000, 2),       -- David reports to Bob
(5, 'Eve', 72000, 2),         -- Eve reports to Bob
(6, 'Frank', 60000, 3),       -- Frank reports to Charlie
(7, 'Grace', 95000, 4);       -- Grace reports to David
															
select * from employee1;

SELECT e.EmpName AS Employee, e.Salary AS EmployeeSalary, 
       m.EmpName AS Manager, m.Salary AS ManagerSalary
FROM Employee1 e
JOIN Employee1 m ON e.ManagerID = m.EmpID
WHERE e.Salary > m.Salary;

-- Q: 2 
-- Add Missing Values  : 

CREATE TABLE JobSkills (
    ROW_ID INT PRIMARY KEY,
    JOB_ROLE VARCHAR(50),
    SKILLS VARCHAR(50)
);

INSERT INTO JobSkills (ROW_ID, JOB_ROLE, SKILLS) VALUES
(1, 'Data Engineer', 'SQL'),
(2, null, 'Python'),
(3, null, 'AWS'),
(4, null, 'Snowflake'),
(5, null, 'Apache Spark'),
(6, 'Web Developer', 'Java'),
(7, null, 'HTML'),
(8, null, 'CSS'),
(9, 'Data Scientist', 'Python'),
(10, null, 'Machine Learning'),
(11, null, 'Deep Learning'),
(12, null, 'Tableau');

select * from JobSkills;

WITH Skill as 
(SELECT ROW_ID,JOB_ROLE,SKILLS,
SUM(CASE
	WHEN JOB_ROLE is NULL THEN 0 ELSE 1 
END) Over(order by ROW_ID) as Flag
FROM JobSkills)
Select Row_ID,
first_value(JOB_ROLE) over(partition  by flag) as Jobs,
SKILLS
from skill;

-- Q : 3 
-- Merging Columns : 

CREATE TABLE CustomerPurchases (
    CUSTOMER_ID INT,
    DATES DATE,
    PRODUCT_ID INT
);

INSERT INTO CustomerPurchases (CUSTOMER_ID, DATES, PRODUCT_ID) VALUES
(1, '2024-02-18', 101),
(1, '2024-02-18', 102),
(1, '2024-02-19', 101),
(1, '2024-02-19', 103),
(2, '2024-02-18', 104),
(2, '2024-02-18', 105),
(2, '2024-02-19', 101),
(2, '2024-02-19', 106);

select * from CustomerPurchases;

Select DATES , PRODUCT_ID from CustomerPurchases
UNION
SELECT DATES , group_concat(PRODUCT_ID) as PRODUCT_ID
from CustomerPurchases
group by DATES;

-- 

With velocity as (select row_number() over() as rn,value as velocity  from repair_records
where indicator='velocity'),
level as 
(select  row_number() over() as rn,value as level from repair_records
where indicator='level') 
select v.velocity,
count(case when level='good' then velocity end) as good,
count(case when level='wrong' then velocity end) as wrong,
count(case when level='regular' then velocity end) as regular
from velocity v 
join 
level l 
on v.rn=l.rn
group by 1
order by velocity;

-- Count the Employee Under the Manager : 

CREATE TABLE Employees2 (
    ID INT PRIMARY KEY,
    NAME VARCHAR(50),
    MANAGER INT
);

INSERT INTO Employees2 (ID, NAME, MANAGER) VALUES
(1, 'Sundar', NULL),
(2, 'Kent', 1),
(3, 'Ruth', 1),
(4, 'Alison', 1),
(5, 'Clay', 2),
(6, 'Ana', 2),
(7, 'Philipp', 3),
(8, 'Prabhakar', 4),
(9, 'Hiroshi', 4),
(10, 'Jeff', 4),
(11, 'Thomas', 1),
(12, 'John', 15),
(13, 'Susan', 15),
(14, 'Lorraine', 15),
(15, 'Larry', 1);

select * from employees2;

SELECT mng.name , COUNT(emp.name) as counted_employee
FROM 
employees2 as emp
JOIN employees2 as mng
on emp.manager=mng.id
GROUP BY mng.name
ORDER BY counted_employee DESC;

-- Covid Test : 

create table covid_cases
(
	cases_reported	int,
	dates			date	
);

INSERT INTO covid_cases (cases_reported, dates) VALUES
(20124, STR_TO_DATE('10/01/2020','%d/%m/%Y')),
(40133, STR_TO_DATE('15/01/2020','%d/%m/%Y')),
(65005, STR_TO_DATE('20/01/2020','%d/%m/%Y')),
(30005, STR_TO_DATE('08/02/2020','%d/%m/%Y')),
(35015, STR_TO_DATE('19/02/2020','%d/%m/%Y')),
(15015, STR_TO_DATE('03/03/2020','%d/%m/%Y')),
(35035, STR_TO_DATE('10/03/2020','%d/%m/%Y')),
(49099, STR_TO_DATE('14/03/2020','%d/%m/%Y')),
(84045, STR_TO_DATE('20/03/2020','%d/%m/%Y')),
(100106, STR_TO_DATE('31/03/2020','%d/%m/%Y')),
(17015, STR_TO_DATE('04/04/2020','%d/%m/%Y')),
(36035, STR_TO_DATE('11/04/2020','%d/%m/%Y')),
(50099, STR_TO_DATE('13/04/2020','%d/%m/%Y')),
(87045, STR_TO_DATE('22/04/2020','%d/%m/%Y')),
(101101, STR_TO_DATE('30/04/2020','%d/%m/%Y')),
(40015, STR_TO_DATE('01/05/2020','%d/%m/%Y')),
(54035, STR_TO_DATE('09/05/2020','%d/%m/%Y')),
(71099, STR_TO_DATE('14/05/2020','%d/%m/%Y')),
(82045, STR_TO_DATE('21/05/2020','%d/%m/%Y')),
(90103, STR_TO_DATE('25/05/2020','%d/%m/%Y')),
(99103, STR_TO_DATE('31/05/2020','%d/%m/%Y')),
(11015, STR_TO_DATE('03/06/2020','%d/%m/%Y')),
(28035, STR_TO_DATE('10/06/2020','%d/%m/%Y')),
(38099, STR_TO_DATE('14/06/2020','%d/%m/%Y')),
(45045, STR_TO_DATE('20/06/2020','%d/%m/%Y')),
(36033, STR_TO_DATE('09/07/2020','%d/%m/%Y')),
(40011, STR_TO_DATE('23/07/2020','%d/%m/%Y')),
(25001, STR_TO_DATE('12/08/2020','%d/%m/%Y')),
(29990, STR_TO_DATE('26/08/2020','%d/%m/%Y')),
(20112, STR_TO_DATE('04/09/2020','%d/%m/%Y')),
(43991, STR_TO_DATE('18/09/2020','%d/%m/%Y')),
(51002, STR_TO_DATE('29/09/2020','%d/%m/%Y')),
(26587, STR_TO_DATE('25/10/2020','%d/%m/%Y')),
(11000, STR_TO_DATE('07/11/2020','%d/%m/%Y')),
(35002, STR_TO_DATE('16/11/2020','%d/%m/%Y')),
(56010, STR_TO_DATE('28/11/2020','%d/%m/%Y')),
(15099, STR_TO_DATE('02/12/2020','%d/%m/%Y')),
(38042, STR_TO_DATE('11/12/2020','%d/%m/%Y')),
(73030, STR_TO_DATE('26/12/2020','%d/%m/%Y'));

select * from covid_cases;

with cte as
	(SELECT MONTH(dates) AS month_number,sum(cases_reported)as total
	 from covid_cases
	 group by MONTH(dates)),
cte_running as 
	(select *,
	sum(total) over(order by month_number) as running_total
	from cte)
select month_number as Month,
case
	WHEN month_number > 1 THEN round((total/LAG(running_total) over(order by month_number)) * 100,1) ELSE '-'
end as average
from cte_running;



