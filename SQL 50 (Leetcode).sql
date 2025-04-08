
#---------------------------------------------- SQL 50 Changellenge ------------------------------------------------#

-- Q:1
-- 1757. Recyclable and Low Fat Products : 
-- Write a solution to find the ids of products that are both low fat and recyclable.

Create table If Not Exists Products (product_id int, low_fats ENUM('Y', 'N'), recyclable ENUM('Y','N'));
Truncate table Products;
insert into Products (product_id, low_fats, recyclable) values ('0', 'Y', 'N');
insert into Products (product_id, low_fats, recyclable) values ('1', 'Y', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('2', 'N', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('3', 'Y', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('4', 'N', 'N');

select * from Products;

-- Solution :

select product_id from products where low_fats = 'Y' AND recyclable='Y';

------------------------------------------------------------------------------------------------------------

-- Q:2 
-- 584. Find Customer Referee
-- Find the names of the customer that are not referred by the customer with id = 2.

Create table If Not Exists Customer (id int, name varchar(25), referee_id int);
Truncate table Customer;
insert into Customer (id, name, referee_id) values ('1', 'Will', NULL);
insert into Customer (id, name, referee_id) values ('2', 'Jane', NULL);
insert into Customer (id, name, referee_id) values ('3', 'Alex', '2');
insert into Customer (id, name, referee_id) values ('4', 'Bill', NULL);
insert into Customer (id, name, referee_id) values ('5', 'Zack', '1');
insert into Customer (id, name, referee_id) values ('6', 'Mark', '2');

select * from customer;

-- Solution :

Select name from customer where coalesce(referee_id,0) <> 2;

------------------------------------------------------------------------------------------------------------

-- Q:3 
-- 595. Big Countries
-- it has an area of at least three million (i.e., 3000000 km2), or
-- it has a population of at least twenty-five million (i.e., 25000000).
-- Write a solution to find the name, population, and area of the big countries.

Create table If Not Exists World (name varchar(255), continent varchar(255), area int, population int, gdp bigint);
Truncate table World;
insert into World (name, continent, area, population, gdp) values ('Afghanistan', 'Asia', '652230', '25500100', '20343000000');
insert into World (name, continent, area, population, gdp) values ('Albania', 'Europe', '28748', '2831741', '12960000000');
insert into World (name, continent, area, population, gdp) values ('Algeria', 'Africa', '2381741', '37100000', '188681000000');
insert into World (name, continent, area, population, gdp) values ('Andorra', 'Europe', '468', '78115', '3712000000');
insert into World (name, continent, area, population, gdp) values ('Angola', 'Africa', '1246700', '20609294', '100990000000');

select * from world;

-- Solution : 

select name,area,population from World 
where area >=3000000 OR population >= 25000000;

------------------------------------------------------------------------------------------------------------

-- Q:4 
-- 1148. Article Views I
-- Write a solution to find all the authors that viewed at least one of their own articles.
-- Return the result table sorted by id in ascending order.

Create table If Not Exists Views (article_id int, author_id int, viewer_id int, view_date date);
Truncate table Views;
insert into Views (article_id, author_id, viewer_id, view_date) values ('1', '3', '5', '2019-08-01');
insert into Views (article_id, author_id, viewer_id, view_date) values ('1', '3', '6', '2019-08-02');
insert into Views (article_id, author_id, viewer_id, view_date) values ('2', '7', '7', '2019-08-01');
insert into Views (article_id, author_id, viewer_id, view_date) values ('2', '7', '6', '2019-08-02');
insert into Views (article_id, author_id, viewer_id, view_date) values ('4', '7', '1', '2019-07-22');
insert into Views (article_id, author_id, viewer_id, view_date) values ('3', '4', '4', '2019-07-21');
insert into Views (article_id, author_id, viewer_id, view_date) values ('3', '4', '4', '2019-07-21');

select * from Views;

-- Solutions : 

select distinct author_id as id from Views
where author_id = viewer_id
order by author_id;

------------------------------------------------------------------------------------------------------------

-- Q:5
-- Write a solution to find the IDs of the invalid tweets.
-- The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.

Create table If Not Exists Tweets(tweet_id int, content varchar(50));
Truncate table Tweets;
insert into Tweets (tweet_id, content) values ('1', 'Let us Code');
insert into Tweets (tweet_id, content) values ('2', 'More than fifteen chars are here!');

select * from Tweets;

-- Solutions :

select tweet_id from Tweets 
where length(content) >= 15;

------------------------------------------------------------------------------------------------------------

-- Q:6
-- 1378. Replace Employee ID With The Unique Identifier
-- Write a solution to show the unique ID of each user, 
-- If a user does not have a unique ID replace just show null.

Create table If Not Exists Employees (id int, name varchar(20));
Create table If Not Exists EmployeeUNI (id int, unique_id int);
Truncate table Employees;
insert into Employees (id, name) values ('1', 'Alice');
insert into Employees (id, name) values ('7', 'Bob');
insert into Employees (id, name) values ('11', 'Meir');
insert into Employees (id, name) values ('90', 'Winston');
insert into Employees (id, name) values ('3', 'Jonathan');
Truncate table EmployeeUNI;
insert into EmployeeUNI (id, unique_id) values ('3', '1');
insert into EmployeeUNI (id, unique_id) values ('11', '2');
insert into EmployeeUNI (id, unique_id) values ('90', '3');

select * from Employees;
select * from EmployeeUNI;

-- Solutions : 

select 
eu.unique_id as unique_id, e.name as name
from Employees e left join EmployeeUNI eu on e.id = eu.id;

------------------------------------------------------------------------------------------------------------

-- Q:7
-- 1068. Product Sales Analysis I
-- Write a solution to report the product_name, year, and price for each sale_id in the Sales table

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

select * from sales;
select * from product;

-- Solution : 

Select p.product_name,s.year,s.price
from sales as s
join product as p
using(product_id);

------------------------------------------------------------------------------------------------------------

-- Q:8
-- 1581. Customer Who Visited but Did Not Make Any Transactions
-- Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.

Create table If Not Exists Visits(visit_id int, customer_id int);
Create table If Not Exists Transactions(transaction_id int, visit_id int, amount int);
Truncate table Visits;
insert into Visits (visit_id, customer_id) values ('1', '23');
insert into Visits (visit_id, customer_id) values ('2', '9');
insert into Visits (visit_id, customer_id) values ('4', '30');
insert into Visits (visit_id, customer_id) values ('5', '54');
insert into Visits (visit_id, customer_id) values ('6', '96');
insert into Visits (visit_id, customer_id) values ('7', '54');
insert into Visits (visit_id, customer_id) values ('8', '54');
Truncate table Transactions;
insert into Transactions (transaction_id, visit_id, amount) values ('2', '5', '310');
insert into Transactions (transaction_id, visit_id, amount) values ('3', '5', '300');
insert into Transactions (transaction_id, visit_id, amount) values ('9', '5', '200');
insert into Transactions (transaction_id, visit_id, amount) values ('12', '1', '910');
insert into Transactions (transaction_id, visit_id, amount) values ('13', '2', '970');

select * from Visits;
select * from Transactions;

select customer_id , count(customer_id) as count_no_trans 
from visits 
where visit_id not in (select visit_id from transactions)
group by customer_id;

------------------------------------------------------------------------------------------------------------

-- Q:9
-- 197. Rising Temperature
-- Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday).

Create table If Not Exists Weather (id int, recordDate date, temperature int);
Truncate table Weather;
insert into Weather (id, recordDate, temperature) values ('1', '2015-01-01', '10');
insert into Weather (id, recordDate, temperature) values ('2', '2015-01-02', '25');
insert into Weather (id, recordDate, temperature) values ('3', '2015-01-03', '20');
insert into Weather (id, recordDate, temperature) values ('4', '2015-01-04', '30');

select * from Weather;

-- Solution :

select id
from (
    select id, recordDate, temperature,
           lag(temperature) over (order by recordDate) AS prev_temp,
           lag(recordDate) over (order by recordDate) AS prev_date
    from Weather
) as temp_table
where DATEDIFF(recordDate, prev_date) = 1
  and temperature > prev_temp;

------------------------------------------------------------------------------------------------------------

-- Q:10
-- 1661. Average Time of Process per Machine
/* There is a factory website that has several machines each running the same number of processes. Write a solution to find the average time each machine takes to complete a process.

The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.

The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.*/


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

select a1.machine_id , round(avg(a2.timestamp - a1.timestamp),3)as processing_time
from Activity as a1
JOIN Activity as a2
on a1.machine_id=a2.machine_id AND a1.process_id=a2.process_id
and a1.activity_type='start' and a2.activity_type='END'
group by a1.machine_id;

------------------------------------------------------------------------------------------------------------
-- Q:11
-- 577. Employee Bonus
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

select * from Employee;
select * from bonus;

-- Solution : 

select e.name , s.bonus 
from employee as e
left join bonus as s
using(empid)
where s.bonus < 1000 or s.bonus is null;

------------------------------------------------------------------------------------------------------------

-- Q:12 
-- 1280. Students and Examinations
-- Write a solution to find the number of times each student attended each exam.
drop table Students;
drop table Subjects;
drop table Examinations;
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

select * from Students;
select * from Subjects;
select * from Examinations;

-- Solution : 

select 
    S.student_id
    ,S.student_name
    ,SU.subject_name
    ,COUNT(E.student_id) attended_exams
from Students S
cross join Subjects SU
left join Examinations E
    on S.student_id = E.student_id
    AND SU.subject_name = E.subject_name
group by  S.student_id, S.student_name, SU.subject_name
order by S.student_id, S.student_name, SU.subject_name;

------------------------------------------------------------------------------------------------------------

-- Q:13
-- 570. Managers with at Least 5 Direct Reports
-- Write a solution to find managers with at least five direct reports.

drop table Employee;
Create table If Not Exists Employee (id int, name varchar(255), department varchar(255), managerId int);
Truncate table Employee;
insert into Employee (id, name, department, managerId) values ('101', 'John', 'A', NULL);
insert into Employee (id, name, department, managerId) values ('102', 'Dan', 'A', '101');
insert into Employee (id, name, department, managerId) values ('103', 'James', 'A', '101');
insert into Employee (id, name, department, managerId) values ('104', 'Amy', 'A', '101');
insert into Employee (id, name, department, managerId) values ('105', 'Anne', 'A', '101');
insert into Employee (id, name, department, managerId) values ('106', 'Ron', 'B', '101');

select * from Employee;

-- Solution : 

select E1.name
from Employee E1
join (
    select managerId, COUNT(*) AS directReports
    from Employee
    group by managerId
    having COUNT(*) >= 5
) E2 on E1.id = E2.managerId;

------------------------------------------------------------------------------------------------------------

-- Q:14
-- 1934. Confirmation Rate

/* 
The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages.
The confirmation rate of a user that did not request any confirmation messages is 0. Round the confirmation rate to two decimal places.
Write a solution to find the confirmation rate of each user.*/ 

Create table If Not Exists Signups (user_id int, time_stamp datetime);
Create table If Not Exists Confirmations (user_id int, time_stamp datetime, action ENUM('confirmed','timeout'));
Truncate table Signups;
insert into Signups (user_id, time_stamp) values ('3', '2020-03-21 10:16:13');
insert into Signups (user_id, time_stamp) values ('7', '2020-01-04 13:57:59');
insert into Signups (user_id, time_stamp) values ('2', '2020-07-29 23:09:44');
insert into Signups (user_id, time_stamp) values ('6', '2020-12-09 10:39:37');
Truncate table Confirmations;
insert into Confirmations (user_id, time_stamp, action) values ('3', '2021-01-06 03:30:46', 'timeout');
insert into Confirmations (user_id, time_stamp, action) values ('3', '2021-07-14 14:00:00', 'timeout');
insert into Confirmations (user_id, time_stamp, action) values ('7', '2021-06-12 11:57:29', 'confirmed');
insert into Confirmations (user_id, time_stamp, action) values ('7', '2021-06-13 12:58:28', 'confirmed');
insert into Confirmations (user_id, time_stamp, action) values ('7', '2021-06-14 13:59:27', 'confirmed');
insert into Confirmations (user_id, time_stamp, action) values ('2', '2021-01-22 00:00:00', 'confirmed');
insert into Confirmations (user_id, time_stamp, action) values ('2', '2021-02-28 23:59:59', 'timeout');

select * from Signups;
select * from Confirmations;

-- Solution : 

	select s.user_id , coalesce(round(avg(c.action='confirmed'),2),'0.00')as confirmation_rate 
	from Signups as s
	left join Confirmations as c on s.user_id =c.user_id
	group by user_id ;

------------------------------------------------------------------------------------------------------------

-- Q:15
-- 620. Not Boring Movies
-- Write a solution to report the movies with an odd-numbered ID and a description that is not "boring".

Create table If Not Exists cinema (id int, movie varchar(255), description varchar(255), rating float(2, 1));
Truncate table cinema;
insert into cinema (id, movie, description, rating) values ('1', 'War', 'great 3D', '8.9');
insert into cinema (id, movie, description, rating) values ('2', 'Science', 'fiction', '8.5');
insert into cinema (id, movie, description, rating) values ('3', 'irish', 'boring', '6.2');
insert into cinema (id, movie, description, rating) values ('4', 'Ice song', 'Fantacy', '8.6');
insert into cinema (id, movie, description, rating) values ('5', 'House card', 'Interesting', '9.1');

select * from cinema;

select * from Cinema 
where id %2 = 1 and description <> 'boring'
order by rating desc;

------------------------------------------------------------------------------------------------------------

-- Q:16
-- 1251. Average Selling Price
-- Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places. 
-- If a product does not have any sold units, its average selling price is assumed to be 0.

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

select * from Prices;
select * from UnitsSold;

-- Solution : 

select p.product_id , coalesce(round(sum(price * units)/sum(units),2),0) as average_price  
from prices as p
left join unitssold as s
on p.product_id = s.product_id  
and s.purchase_date between start_date AND end_date
group by product_id;

------------------------------------------------------------------------------------------------------------

-- Q:17
-- 1075. Project Employees I
-- Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.

Create table If Not Exists Project (project_id int, employee_id int);
Create table If Not Exists Employee (employee_id int, name varchar(10), experience_years int);
Truncate table Project;
insert into Project (project_id, employee_id) values ('1', '1');
insert into Project (project_id, employee_id) values ('1', '2');
insert into Project (project_id, employee_id) values ('1', '3');
insert into Project (project_id, employee_id) values ('2', '1');
insert into Project (project_id, employee_id) values ('2', '4');
Truncate table Employee;
insert into Employee (employee_id, name, experience_years) values ('1', 'Khaled', '3');
insert into Employee (employee_id, name, experience_years) values ('2', 'Ali', '2');
insert into Employee (employee_id, name, experience_years) values ('3', 'John', '1');
insert into Employee (employee_id, name, experience_years) values ('4', 'Doe', '2');

select * from Project;
select * from Employee;

-- Solution :

select p.project_id , coalesce(round(avg(e.experience_years),2),0) as average_years 
from project p
join Employee e
using(employee_id)
group by p.project_id;

------------------------------------------------------------------------------------------------------------

-- Q:18
-- 1633. Percentage of Users Attended a Contest
-- Write a solution to find the percentage of the users registered in each contest rounded to two decimals.
-- Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.

Create table If Not Exists Users (user_id int, user_name varchar(20));
Create table If Not Exists Register (contest_id int, user_id int);
Truncate table Users;
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
select * from Register;

with total_users AS (
    select count(user_id) AS total from Users
)
select 
r.contest_id, 
round(count(distinct r.user_id) * 100.0 / t.total, 2) as percentage
from Register r
cross join total_users t
group by r.contest_id, t.total
order by percentage desc, r.contest_id;

------------------------------------------------------------------------------------------------------------

-- Q:19
-- 1211. Queries Quality and Percentage
-- We define query quality as:
-- The average of the ratio between query rating and its position.
-- We also define poor query percentage as:
-- The percentage of all queries with rating less than 3.
-- Write a solution to find each query_name, the quality and poor_query_percentage.
-- Both quality and poor_query_percentage should be rounded to 2 decimal places.

Create table If Not Exists Queries (query_name varchar(30), result varchar(50), position int, rating int);
Truncate table Queries;
insert into Queries (query_name, result, position, rating) values ('Dog', 'Golden Retriever', '1', '5');
insert into Queries (query_name, result, position, rating) values ('Dog', 'German Shepherd', '2', '5');
insert into Queries (query_name, result, position, rating) values ('Dog', 'Mule', '200', '1');
insert into Queries (query_name, result, position, rating) values ('Cat', 'Shirazi', '5', '2');
insert into Queries (query_name, result, position, rating) values ('Cat', 'Siamese', '3', '3');
insert into Queries (query_name, result, position, rating) values ('Cat', 'Sphynx', '7', '4');

select * from Queries;

-- Solution : 

select 
query_name,
round(sum(rating / position) / count(*), 2) AS quality,
round((sum(case when rating <= 2 then 1 else 0 end) / count(*)) * 100, 2) AS poor_query_percentage
from Queries
group by query_name;

------------------------------------------------------------------------------------------------------------

-- Q:20 
-- 1193. Monthly Transactions I
-- Write an SQL query to find for each month and country, the number of transactions and their total amount, 
-- the number of approved transactions and their total amount.

Create table If Not Exists Transactions (id int, country varchar(4), state enum('approved', 'declined'), amount int, trans_date date);
Truncate table Transactions;
insert into Transactions (id, country, state, amount, trans_date) values ('121', 'US', 'approved', '1000', '2018-12-18');
insert into Transactions (id, country, state, amount, trans_date) values ('122', 'US', 'declined', '2000', '2018-12-19');
insert into Transactions (id, country, state, amount, trans_date) values ('123', 'US', 'approved', '2000', '2019-01-01');
insert into Transactions (id, country, state, amount, trans_date) values ('124', 'DE', 'approved', '2000', '2019-01-07');

select * from Transactions;

-- Solution : 

select left(trans_date,7) as month,
country,
count(id) as trans_count,
sum(case when state='approved' then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state='approved' then amount else 0 end) as approved_total_amount
from transactions
group by month,country;

------------------------------------------------------------------------------------------------------------

-- Q:21
-- 1174. Immediate Food Delivery II
-- If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.
-- The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.
-- Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

Create table If Not Exists Delivery (delivery_id int, customer_id int, order_date date, customer_pref_delivery_date date);
Truncate table Delivery;
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('1', '1', '2019-08-01', '2019-08-02');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('2', '2', '2019-08-02', '2019-08-02');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('3', '1', '2019-08-11', '2019-08-12');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('4', '3', '2019-08-24', '2019-08-24');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('5', '3', '2019-08-21', '2019-08-22');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('6', '2', '2019-08-11', '2019-08-13');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('7', '4', '2019-08-09', '2019-08-09');

select * from delivery;

-- Solution : 

Select 
round(avg(order_date = customer_pref_delivery_date)*100, 2) as immediate_percentage
from Delivery
where (customer_id, order_date) in (
Select customer_id, min(order_date) 
from Delivery
group by customer_id
);

------------------------------------------------------------------------------------------------------------

-- Q:21
-- 550. Game Play Analysis IV
-- Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places.
-- In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, 
-- then divide that number by the total number of players

Create table If Not Exists Activity (player_id int, device_id int, event_date date, games_played int);
Truncate table Activity;
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-01', '5');
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-02', '6');
insert into Activity (player_id, device_id, event_date, games_played) values ('2', '3', '2017-06-25', '1');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '1', '2016-03-02', '0');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '4', '2018-07-03', '5');

-- Solution :

SELECT
  ROUND(COUNT(DISTINCT player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) AS fraction
FROM
  Activity
WHERE
  (player_id, DATE_SUB(event_date, INTERVAL 1 DAY))
  IN (
    SELECT player_id, MIN(event_date) AS first_login FROM Activity GROUP BY player_id
  );
  
  ------------------------------------------------------------------------------------------------------------
  
  -- Q:22
  -- 2356. Number of Unique Subjects Taught by Each Teacher
  -- Write a solution to calculate the number of unique subjects each teacher teaches in the university.
  
Create table If Not Exists Teacher (teacher_id int, subject_id int, dept_id int);
Truncate table Teacher;
insert into Teacher (teacher_id, subject_id, dept_id) values ('1', '2', '3');
insert into Teacher (teacher_id, subject_id, dept_id) values ('1', '2', '4');
insert into Teacher (teacher_id, subject_id, dept_id) values ('1', '3', '3');
insert into Teacher (teacher_id, subject_id, dept_id) values ('2', '1', '1');
insert into Teacher (teacher_id, subject_id, dept_id) values ('2', '2', '1');
insert into Teacher (teacher_id, subject_id, dept_id) values ('2', '3', '1');
insert into Teacher (teacher_id, subject_id, dept_id) values ('2', '4', '1');

select * from teacher;

-- Solution : 

select teacher_id ,count(distinct subject_id) as cnt 
from Teacher
group by teacher_id;

------------------------------------------------------------------------------------------------------------

-- Q:23
-- 1141. User Activity for the Past 30 Days I
-- Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. 
-- A user was active on someday if they made at least one activity on that day.

Create table If Not Exists Activity (user_id int, session_id int, activity_date date, activity_type ENUM('open_session', 'end_session', 'scroll_down', 'send_message'));
Truncate table Activity;
insert into Activity (user_id, session_id, activity_date, activity_type) values ('1', '1', '2019-07-20', 'open_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('1', '1', '2019-07-20', 'scroll_down');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('1', '1', '2019-07-20', 'end_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('2', '4', '2019-07-20', 'open_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('2', '4', '2019-07-21', 'send_message');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('2', '4', '2019-07-21', 'end_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('3', '2', '2019-07-21', 'open_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('3', '2', '2019-07-21', 'send_message');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('3', '2', '2019-07-21', 'end_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('4', '3', '2019-06-25', 'open_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('4', '3', '2019-06-25', 'end_session');

select * from Activity;

-- Solution : 

select activity_date as day, count(distinct user_id) as active_users
from Activity
where activity_date > "2019-06-27" and activity_date <= "2019-07-27"
group by activity_date;

------------------------------------------------------------------------------------------------------------

-- Q:24
-- 1070. Product Sales Analysis III
-- Write a solution to select the product id, year, quantity, and price for the first year of every product sold

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

-- Solution :

with CTE as 
(
select product_id, min(year) AS minyear from Sales 
group by product_id 
)
select s.product_id, s.year as first_year, s.quantity, s.price 
from Sales s
inner join CTE on cte.product_id = s.product_id  and s.year = cte.minyear; 

------------------------------------------------------------------------------------------------------------

-- Q:25
-- 596. Classes More Than 5 Students
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

select * from Courses;

-- Solution :

With cte_max as
(
 Select *,row_number()over(partition by class order by student)as rk
 from courses
)
select distinct class
from  cte_max
where rk >=5;

------------------------------------------------------------------------------------------------------------

-- Q:26
-- 1729. Find Followers Count
-- Write a solution that will, for each user, return the number of followers.
-- Return the result table ordered by user_id in ascending order.

Create table If Not Exists Followers(user_id int, follower_id int);
Truncate table Followers;
insert into Followers (user_id, follower_id) values ('0', '1');
insert into Followers (user_id, follower_id) values ('1', '0');
insert into Followers (user_id, follower_id) values ('2', '0');
insert into Followers (user_id, follower_id) values ('2', '1');

select * from followers;

-- Solution : 

select user_id, count(follower_id) followers_count
from Followers
group by user_id
order by user_id;

------------------------------------------------------------------------------------------------------------

-- Q:27
-- 619. Biggest Single Number
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

select * from mynumbers;

-- Solution : 

select max(num) as num from mynumbers
where num in 
(
 select num from mynumbers
 group by num
 having  count(num)=1
);

------------------------------------------------------------------------------------------------------------

-- Q:28 
-- 1045. Customers Who Bought All Products
-- Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.

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

select * from Customer;
select * from product;

-- Solution :

select customer_id 
from Customer 
group by customer_id
having COUNT(distinct product_key) = (select COUNT(product_key) from Product);

------------------------------------------------------------------------------------------------------------

-- Q:29
-- 1731. The Number of Employees Which Report to Each Employee
-- For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.
-- Write a solution to report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.
-- Return the result table ordered by employee_id.

Create table If Not Exists Employees(employee_id int, name varchar(20), reports_to int, age int);
Truncate table Employees;
insert into Employees (employee_id, name, reports_to, age) values ('9', 'Hercy', NULL, '43');
insert into Employees (employee_id, name, reports_to, age) values ('6', 'Alice', '9', '41');
insert into Employees (employee_id, name, reports_to, age) values ('4', 'Bob', '9', '36');
insert into Employees (employee_id, name, reports_to, age) values ('2', 'Winston', NULL, '37');

select * from employees;

-- Solution :

select e1.employee_id, e1.name, COUNT(e2.employee_id) as reports_count, ROUND(avg(e2.age)) as average_age
from Employees e1
inner join Employees e2 on e1.employee_id = e2.reports_to
group by e1.employee_id, e1.name
order by e1.employee_id;

------------------------------------------------------------------------------------------------------------

-- Q:30 
-- 1789. Primary Department for Each Employee
-- Employees can belong to multiple departments. When the employee joins other departments, they need to decide which department is their primary department. Note that when an employee belongs to only one department, 
-- their primary column is 'N'.
-- Write a solution to report all the employees with their primary department. For employees who belong to one department, report their only department.

Drop Table employee;
Create table If Not Exists Employee (employee_id int, department_id int, primary_flag ENUM('Y','N'));
Truncate table Employee;
insert into Employee (employee_id, department_id, primary_flag) values ('1', '1', 'N');
insert into Employee (employee_id, department_id, primary_flag) values ('2', '1', 'Y');
insert into Employee (employee_id, department_id, primary_flag) values ('2', '2', 'N');
insert into Employee (employee_id, department_id, primary_flag) values ('3', '3', 'N');
insert into Employee (employee_id, department_id, primary_flag) values ('4', '2', 'N');
insert into Employee (employee_id, department_id, primary_flag) values ('4', '3', 'Y');
insert into Employee (employee_id, department_id, primary_flag) values ('4', '4', 'N');

select * from employee;

-- Solution : 

select employee_id, department_id
from Employee
where primary_flag = 'Y'
union
select employee_id, department_id
from Employee
group by employee_id
having count(employee_id)=1;

------------------------------------------------------------------------------------------------------------

-- Q:31
-- 610. Triangle Judgement
-- Report for every three line segments whether they can form a triangle.

Create table If Not Exists Triangle (x int, y int, z int);
Truncate table Triangle;
insert into Triangle (x, y, z) values ('13', '15', '30');
insert into Triangle (x, y, z) values ('10', '20', '15');

select * from triangle;

select *,
case
	when (x+y) > z and (x+z) > y and (y+z)>x then "Yes" Else "No"
end as triangle 
from triangle ;

------------------------------------------------------------------------------------------------------------

-- Q:32
-- 180. Consecutive Numbers
-- Find all numbers that appear at least three times consecutively.

Create table If Not Exists Logs (id int, num int);
Truncate table Logs;
insert into Logs (id, num) values ('1', '1');
insert into Logs (id, num) values ('2', '1');
insert into Logs (id, num) values ('3', '1');
insert into Logs (id, num) values ('4', '2');
insert into Logs (id, num) values ('5', '1');
insert into Logs (id, num) values ('6', '2');
insert into Logs (id, num) values ('7', '2');

select * from Logs;

-- Solution : 

with cte as 
	(select *,
	lead(num) over() as num1,
	lead(num,2) over() as num2
	from Logs)
select distinct num as ConsecutiveNums from cte where num=num1 and num1=num2;

------------------------------------------------------------------------------------------------------------

-- Q:33
-- 1164. Product Price at a Given Date
-- Write a solution to find the prices of all products on 2019-08-16.
-- Assume the price of all products before any change is 10.

Create table If Not Exists Products (product_id int, new_price int, change_date date);
Truncate table Products;
insert into Products (product_id, new_price, change_date) values ('1', '20', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('2', '50', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('1', '30', '2019-08-15');
insert into Products (product_id, new_price, change_date) values ('1', '35', '2019-08-16');
insert into Products (product_id, new_price, change_date) values ('2', '65', '2019-08-17');
insert into Products (product_id, new_price, change_date) values ('3', '20', '2019-08-18');

select * from products;

-- Solution :

with latest_price as (
    select distinct product_id
	,first_value(new_price) over (partition by product_id order by change_date desc) as latest_price
    from products 
    where change_date <= '2019-08-16' 
)
select distinct product_id,coalesce(b.latest_price, 10) as price
FROM products a
left join latest_price b using (product_id);

------------------------------------------------------------------------------------------------------------

-- Q:34
-- 1204. Last Person to Fit in the Bus
-- There is a queue of people waiting to board a bus. However, the bus has a weight limit of 1000 kilograms, so there may be some people who cannot board.
-- Write a solution to find the person_name of the last person that can fit on the bus without exceeding the weight limit. 
-- The test cases are generated such that the first person does not exceed the weight limit.

Create table If Not Exists Queue (person_id int, person_name varchar(30), weight int, turn int);
Truncate table Queue;
insert into Queue (person_id, person_name, weight, turn) values ('5', 'Alice', '250', '1');
insert into Queue (person_id, person_name, weight, turn) values ('4', 'Bob', '175', '5');
insert into Queue (person_id, person_name, weight, turn) values ('3', 'Alex', '350', '2');
insert into Queue (person_id, person_name, weight, turn) values ('6', 'John Cena', '400', '3');
insert into Queue (person_id, person_name, weight, turn) values ('1', 'Winston', '500', '6') ;
insert into Queue (person_id, person_name, weight, turn) values ('2', 'Marie', '200', '4');

select * from Queue;

-- Solution : 

with cte as 
(select *,
sum(weight) over(order by turn) as total_weight
from Queue)
select person_name 
from cte
where total_weight<=1000
order by total_weight desc
limit 1;

------------------------------------------------------------------------------------------------------------

-- Q:35
-- 1907. Count Salary Categories
-- Write a solution to calculate the number of bank accounts for each salary category. The salary categories are:
-- "Low Salary": All the salaries strictly less than $20000.
-- "Average Salary": All the salaries in the inclusive range [$20000, $50000].
-- "High Salary": All the salaries strictly greater than $50000.
-- The result table must contain all three categories. If there are no accounts in a category, return 0.

Create table If Not Exists Accounts (account_id int, income int);
Truncate table Accounts;
insert into Accounts (account_id, income) values ('3', '108939');
insert into Accounts (account_id, income) values ('2', '12747');
insert into Accounts (account_id, income) values ('8', '87709');
insert into Accounts (account_id, income) values ('6', '91796');

select * from Accounts;

-- Solution :

select 'Low Salary' as category,
count(if(income < 20000,1,null)) as accounts_count 
from Accounts
Union all
select 'Average  Salary' as category,
count(if(income <=20000 and income>=50000,1,null)) as accounts_count 
from Accounts
Union all
select 'High Salary ' as category,
count(if(income > 50000,1,null)) as accounts_count 
from Accounts;

------------------------------------------------------------------------------------------------------------

-- Q:36
-- 1978. Employees Whose Manager Left the Company
-- Find the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company.
-- When a manager leaves the company, their information is deleted from the Employees table, but the reports still have their manager_id set to the manager that left.

Create table If Not Exists Employees (employee_id int, name varchar(20), manager_id int, salary int);
Truncate table Employees;
insert into Employees (employee_id, name, manager_id, salary) values ('3', 'Mila', '9', '60301');
insert into Employees (employee_id, name, manager_id, salary) values ('12', 'Antonella', NULL, '31000');
insert into Employees (employee_id, name, manager_id, salary) values ('13', 'Emery', NULL, '67084');
insert into Employees (employee_id, name, manager_id, salary) values ('1', 'Kalel', '11', '21241');
insert into Employees (employee_id, name, manager_id, salary) values ('9', 'Mikaela', NULL, '50937');
insert into Employees (employee_id, name, manager_id, salary) values ('11', 'Joziah', '6', '28485');

select * from employees;

-- Solution :

select e1.employee_id
from Employees e1
left join Employees e2
on e1.manager_id = e2.employee_id
where e1.salary < 30000 and e2.employee_id is null and e1.manager_id is not null
ORDER BY employee_id;

------------------------------------------------------------------------------------------------------------

-- Q:37
-- 626. Exchange Seats
-- Write a solution to swap the seat id of every two consecutive students. 
-- If the number of students is odd, the id of the last student is not swapped.

Create table If Not Exists Seat (id int, student varchar(255));
Truncate table Seat;
insert into Seat (id, student) values ('1', 'Abbot');
insert into Seat (id, student) values ('2', 'Doris');
insert into Seat (id, student) values ('3', 'Emerson');
insert into Seat (id, student) values ('4', 'Green');
insert into Seat (id, student) values ('5', 'Jeames');

select * from seat;

-- Solution : 

select 
case 
	when id % 2 = 1 and id + 1 in (select id from Seat) then id + 1
	when id % 2 = 0 then id - 1
	else id
end as id,student
from Seat
order by id;

------------------------------------------------------------------------------------------------------------

-- Q:38
-- 1341. Movie Rating
-- Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
-- Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.

Create table If Not Exists Movies (movie_id int, title varchar(30));
Create table If Not Exists Users (user_id int, name varchar(30));
Create table If Not Exists MovieRating (movie_id int, user_id int, rating int, created_at date);
Truncate table Movies;
insert into Movies (movie_id, title) values ('1', 'Avengers');
insert into Movies (movie_id, title) values ('2', 'Frozen 2');
insert into Movies (movie_id, title) values ('3', 'Joker');
Truncate table Users;
insert into Users (user_id, name) values ('1', 'Daniel');
insert into Users (user_id, name) values ('2', 'Monica');
insert into Users (user_id, name) values ('3', 'Maria');
insert into Users (user_id, name) values ('4', 'James');
Truncate table MovieRating;
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '1', '3', '2020-01-12');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '2', '4', '2020-02-11');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '3', '2', '2020-02-12');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '4', '1', '2020-01-01');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('2', '1', '5', '2020-02-17');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('2', '2', '2', '2020-02-01');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('2', '3', '2', '2020-03-01');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('3', '1', '3', '2020-02-22');
insert into MovieRating (movie_id, user_id, rating, created_at) values ('3', '2', '4', '2020-02-25');

select * from Movies;
select * from Users;
select * from MovieRating;

-- Solution : 

with UserRatings as (
select u.name, COUNT(mr.movie_id) as rating_count
from MovieRating mr
join Users u on mr.user_id = u.user_id
group by u.name
order by rating_count desc, u.name
limit 1
),
MovieRatings as (
select m.title, avg(mr.rating) as avg_rating
from MovieRating mr
join Movies m on mr.movie_id = m.movie_id
where mr.created_at between '2020-02-01' and '2020-02-29'
group by m.title
order by  avg_rating desc, m.title
limit 1
)
select name as results from UserRatings
union all
select title from MovieRatings;

------------------------------------------------------------------------------------------------------------

-- Q:39
-- 1321. Restaurant Growth
-- You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).
-- Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.
-- Return the result table ordered by visited_on in ascending order.

Create table If Not Exists Customer (customer_id int, name varchar(20), visited_on date, amount int);
Truncate table Customer;
insert into Customer (customer_id, name, visited_on, amount) values ('1', 'Jhon', '2019-01-01', '100');
insert into Customer (customer_id, name, visited_on, amount) values ('2', 'Daniel', '2019-01-02', '110');
insert into Customer (customer_id, name, visited_on, amount) values ('3', 'Jade', '2019-01-03', '120');
insert into Customer (customer_id, name, visited_on, amount) values ('4', 'Khaled', '2019-01-04', '130');
insert into Customer (customer_id, name, visited_on, amount) values ('5', 'Winston', '2019-01-05', '110');
insert into Customer (customer_id, name, visited_on, amount) values ('6', 'Elvis', '2019-01-06', '140');
insert into Customer (customer_id, name, visited_on, amount) values ('7', 'Anna', '2019-01-07', '150');
insert into Customer (customer_id, name, visited_on, amount) values ('8', 'Maria', '2019-01-08', '80');
insert into Customer (customer_id, name, visited_on, amount) values ('9', 'Jaze', '2019-01-09', '110');
insert into Customer (customer_id, name, visited_on, amount) values ('1', 'Jhon', '2019-01-10', '130');
insert into Customer (customer_id, name, visited_on, amount) values ('3', 'Jade', '2019-01-10', '150');

select * from customer;

-- Solution :

with inner_query as (
    select distinct visited_on, 
        sum(amount) over(order by visited_on range between interval 6 day preceding and current row) as amount,
        min(visited_on) over() as st_date
    from customer
),
filtered_query as (
    select visited_on, amount, st_date
    from inner_query
    where visited_on >= st_date + interval 6 day
),
base as (
    select visited_on, amount, round(amount / 7, 2) as average_amount 
    from filtered_query
)
select visited_on, amount, average_amount
from base;

------------------------------------------------------------------------------------------------------------

-- Q:40 
-- 602. Friend Requests II: Who Has the Most Friends
-- Write a solution to find the people who have the most friends and the most friends number.
-- The test cases are generated so that only one person has the most friends.

Create table If Not Exists RequestAccepted (requester_id int not null, accepter_id int null, accept_date date null);
Truncate table RequestAccepted;
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '2', '2016/06/03');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('2', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/09');

select * from RequestAccepted;

-- Solution :

with cte as 
	(select requester_id as id 
	from RequestAccepted
	union all
	select accepter_id as id 
	from RequestAccepted)
select id, count(*) as num  from cte group by 1 order by 2 desc limit 1;

------------------------------------------------------------------------------------------------------------

-- Q:41
-- 585. Investments in 2016
-- Write a solution to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:
-- have the same tiv_2015 value as one or more other policyholders, and
-- are not located in the same city as any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).
-- Round tiv_2016 to two decimal places.

Create Table If Not Exists Insurance (pid int, tiv_2015 float, tiv_2016 float, lat float, lon float);
Truncate table Insurance;
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('1', '10', '5', '10', '10');
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('2', '20', '20', '20', '20');
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('3', '10', '30', '20', '20');
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('4', '10', '40', '40', '40');

select * from Insurance;

-- Solution :

with duplicate_tiv_2015 as (
    select tiv_2015
    from insurance
    group by tiv_2015
    having count(*) > 1
),
unique_locations as (
    select lat, lon
    from insurance
    group by lat, lon
    having count(*) = 1
)
select round(sum(tiv_2016), 2) as tiv_2016
from insurance
where tiv_2015 in (select tiv_2015 from duplicate_tiv_2015)
and (lat, lon) in (select lat, lon from unique_locations);

------------------------------------------------------------------------------------------------------------

-- Q:42 
-- 185. Department Top Three Salaries
-- A company's executives are interested in seeing who earns the most money in each of the company's departments. A high earner in a department is an employee who has a salary in the top three unique salaries for that department.
-- Write a solution to find the employees who are high earners in each of the departments.

Create table If Not Exists Employee (id int, name varchar(255), salary int, departmentId int);
Create table If Not Exists Department (id int, name varchar(255));
Truncate table Employee;
insert into Employee (id, name, salary, departmentId) values ('1', 'Joe', '85000', '1');
insert into Employee (id, name, salary, departmentId) values ('2', 'Henry', '80000', '2');
insert into Employee (id, name, salary, departmentId) values ('3', 'Sam', '60000', '2');
insert into Employee (id, name, salary, departmentId) values ('4', 'Max', '90000', '1');
insert into Employee (id, name, salary, departmentId) values ('5', 'Janet', '69000', '1');
insert into Employee (id, name, salary, departmentId) values ('6', 'Randy', '85000', '1');
insert into Employee (id, name, salary, departmentId) values ('7', 'Will', '70000', '1');
Truncate table Department;
insert into Department (id, name) values ('1', 'IT');
insert into Department (id, name) values ('2', 'Sales');

select * from Employee;
select * from Department;

with cte as 
	(select d.name as Department,e.name as Employee,e.salary,
	dense_rank() over(partition by d.name order by e.salary desc ) as rk
	from Employee as e
	join Department d
	on e.departmentId = d.id)
select Department , Employee, salary from cte
where rk < 4;

------------------------------------------------------------------------------------------------------------

-- Q:43
-- 1667. Fix Names in a Table
-- Write a solution to fix the names so that only the first character is uppercase and the rest are lowercase.

Create table If Not Exists Users (user_id int, name varchar(40));
Truncate table Users;
insert into Users (user_id, name) values ('1', 'aLice');
insert into Users (user_id, name) values ('2', 'bOB');

-- Solution :

select user_id , concat(upper(substr(name,1,1)),lower(substr(name,2))) as name 
from Users
order by Users.user_id ; 

------------------------------------------------------------------------------------------------------------

-- Q:44
-- 1527. Patients With a Condition
-- Write a solution to find the patient_id, patient_name, and conditions of the patients who have Type I Diabetes.
--  Type I Diabetes always starts with DIAB1 prefix.

Create table If Not Exists Patient (patient_id int, patient_name varchar(30), conditions varchar(100));
Truncate table Patients;
insert into Patient (patient_id, patient_name, conditions) values ('1', 'Daniel', 'YFEV COUGH');
insert into Patient (patient_id, patient_name, conditions) values ('2', 'Alice', '');
insert into Patient (patient_id, patient_name, conditions) values ('3', 'Bob', 'DIAB100 MYOP');
insert into Patient (patient_id, patient_name, conditions) values ('4', 'George', 'ACNE DIAB100');
insert into Patient (patient_id, patient_name, conditions) values ('5', 'Alain', 'DIAB201');

select * from patient;

-- Solution : 

select *
from Patient
where conditions regexp "^DIAB1.*" or
conditions regexp ".* DIAB1.*";

------------------------------------------------------------------------------------------------------------

-- Q:45
-- 196. Delete Duplicate Emails
-- Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.
-- For SQL users, please note that you are supposed to write a DELETE statement and not a SELECT one.
-- For Pandas users, please note that you are supposed to modify Person in place.
-- After running your script, the answer shown is the Person table. The driver will first compile and run your piece of code and then show the Person table. 
-- The final order of the Person table does not matte

Create table If Not Exists Person (Id int, Email varchar(255));
Truncate table Person;
insert into Person (id, email) values ('1', 'john@example.com');
insert into Person (id, email) values ('2', 'bob@example.com');
insert into Person (id, email) values ('3', 'john@example.com');

select * from person;

-- Solution : 

delete p1 from person p1,person p2 
where p1.email=p2.email and p1.id>p2.id;

------------------------------------------------------------------------------------------------------------

-- Q:46
-- 176. Second Highest Salary
-- Write a solution to find the second highest distinct salary from the Employee table

Create table If Not Exists Employee (id int, salary int);
Truncate table Employee;
insert into Employee (id, salary) values ('1', '100');
insert into Employee (id, salary) values ('2', '200');
insert into Employee (id, salary) values ('3', '300');

select * from employee;

-- Solution : 

select
(select distinct salary as "SecondHighestSalary" from Employee order by salary desc limit 1 offset 1) 
as "SecondHighestSalary";

-- (or)

select salary as 'SecondHighestSalary' 
from Employee
order by salary desc
limit 1
offset 1;

------------------------------------------------------------------------------------------------------------

-- Q:47
-- 1484. Group Sold Products By The Date
-- Write a solution to find for each date the number of different products sold and their names.
-- The sold products names for each date should be sorted lexicographically.
-- Return the result table ordered by sell_date.

Create table If Not Exists Activities (sell_date date, product varchar(20));
Truncate table Activities;
insert into Activities (sell_date, product) values ('2020-05-30', 'Headphone');
insert into Activities (sell_date, product) values ('2020-06-01', 'Pencil');
insert into Activities (sell_date, product) values ('2020-06-02', 'Mask');
insert into Activities (sell_date, product) values ('2020-05-30', 'Basketball');
insert into Activities (sell_date, product) values ('2020-06-01', 'Bible');
insert into Activities (sell_date, product) values ('2020-06-02', 'Mask');
insert into Activities (sell_date, product) values ('2020-05-30', 'T-Shirt');

select * from Activities;

-- Solution :

select sell_date,count(distinct product)as 'num_sold',
GROUP_CONCAT(distinct product ORDER BY product SEPARATOR ',') AS products
from Activities
group by sell_date
order by sell_date;

------------------------------------------------------------------------------------------------------------

-- Q:48
-- 1327. List the Products Ordered in a Period
-- Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.

Create table If Not Exists Products (product_id int, product_name varchar(40), product_category varchar(40));
Create table If Not Exists Orders (product_id int, order_date date, unit int);
Truncate table Products;
insert into Products (product_id, product_name, product_category) values ('1', 'Leetcode Solutions', 'Book');
insert into Products (product_id, product_name, product_category) values ('2', 'Jewels of Stringology', 'Book');
insert into Products (product_id, product_name, product_category) values ('3', 'HP', 'Laptop');
insert into Products (product_id, product_name, product_category) values ('4', 'Lenovo', 'Laptop');
insert into Products (product_id, product_name, product_category) values ('5', 'Leetcode Kit', 'T-shirt');
Truncate table Orders;
insert into Orders (product_id, order_date, unit) values ('1', '2020-02-05', '60');
insert into Orders (product_id, order_date, unit) values ('1', '2020-02-10', '70');
insert into Orders (product_id, order_date, unit) values ('2', '2020-01-18', '30');
insert into Orders (product_id, order_date, unit) values ('2', '2020-02-11', '80');
insert into Orders (product_id, order_date, unit) values ('3', '2020-02-17', '2');
insert into Orders (product_id, order_date, unit) values ('3', '2020-02-24', '3');
insert into Orders (product_id, order_date, unit) values ('4', '2020-03-01', '20');
insert into Orders (product_id, order_date, unit) values ('4', '2020-03-04', '30');
insert into Orders (product_id, order_date, unit) values ('4', '2020-03-04', '60');
insert into Orders (product_id, order_date, unit) values ('5', '2020-02-25', '50');
insert into Orders (product_id, order_date, unit) values ('5', '2020-02-27', '50');
insert into Orders (product_id, order_date, unit) values ('5', '2020-03-01', '50');

select * from Products;
select * from Orders;

-- Solution :

with cte as 
(select product_id, sum(unit) as feb_unit from orders
where year(order_date)=2020 and month(order_date)=02
group by product_id)

select p.product_name, c.feb_unit as unit from cte c
left join products p on
p.product_id=c.product_id
where c.feb_unit>=100;

------------------------------------------------------------------------------------------------------------

-- Q:49
-- 1517. Find Users With Valid E-Mails
-- Write a solution to find the users who have valid emails.
-- A valid e-mail has a prefix name and a domain where:
-- The prefix name is a string that may contain letters (upper or lower case), digits, underscore '_', period '.', and/or dash '-'. The prefix name must start with a letter.
-- The domain is '@leetcode.com'.
-- Return the result table in any order.

Create table If Not Exists Users (user_id int, name varchar(30), mail varchar(50));
Truncate table Users;
insert into Users (user_id, name, mail) values ('1', 'Winston', 'winston@leetcode.com');
insert into Users (user_id, name, mail) values ('2', 'Jonathan', 'jonathanisgreat');
insert into Users (user_id, name, mail) values ('3', 'Annabelle', 'bella-@leetcode.com');
insert into Users (user_id, name, mail) values ('4', 'Sally', 'sally.come@leetcode.com');
insert into Users (user_id, name, mail) values ('5', 'Marwan', 'quarz#2020@leetcode.com');
insert into Users (user_id, name, mail) values ('6', 'David', 'david69@gmail.com');
insert into Users (user_id, name, mail) values ('7', 'Shapiro', '.shapo@leetcode.com');

select * from users;

-- Solution : 

select *
from Users
where mail REGEXP '^[A-Za-z][A-Za-z0-9_\.\-]*@leetcode(\\?com)?\\.com$';

---------------------------------- Done -------------------------------------------------------------