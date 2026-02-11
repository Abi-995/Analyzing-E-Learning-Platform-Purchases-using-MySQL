-- Database Creation --
CREATE DATABASE E_Learning_Platform; 

USE E_Learning_Platform;

-- Table Creation --
CREATE TABLE Learners ( 
 learner_id INT Primary Key ,
 full_name VARCHAR(60) ,
 Country VARCHAR(50) );


CREATE TABLE Courses (
course_id INT Primary Key , 
course_name VARCHAR(50),
category VARCHAR(50),
unit_price DECIMAL(10,2) ) ;

CREATE TABLE Purchases (
 purchase_id  INT Primary Key ,
 learner_id INT , 
 course_id INT , 
 Quantity INT , 
 purchase_date DATE ,
 Foreign Key (learner_id) REFERENCES Learners (learner_id) ,
 Foreign Key (course_id) REFERENCES Courses (course_id) 
 );

-- Insert datas --
INSERT INTO learners (learner_id ,full_name , Country) VALUES 
('1001' , 'AnanyaSharma' , 'India' ),
('1002' , 'Rahul Verma' , 'India'),
('1003' , 'Meena Krishnan' , 'Singapore'),
('1004' , 'Arjun Patel' , 'Canada'),
('1005' , 'Kavya Reddy' , 'Australia');

INSERT INTO Courses (course_id , course_name , category , unit_price ) VALUES 
(301 , 'Data Visualization with Power BI' , 'Business Intelligence' , 18000),
(302 , 'Python for Data Analysis' , 'Programming' , 15000),
(303 , 'Introduction to Cloud Services' , 'Cloud Computing' , 20000),
(304 , 'Cybersecurity Basics' , 'Information Security' , 22000),
(305 , 'Digital Marketing Strategy' , 'Marketing' , 12000);

INSERT INTO Purchases (purchase_id , learner_id, course_id , Quantity , purchase_date  ) VALUES
(101 , 1001 , 302 , 1 , '2024-01-08'),
(102 , 1003 , 305 , 2 , '2024-01-22'),
(103 , 1002 , 301 , 1 , '2024-02-10'),
(104 , 1004 , 304 , 1 , '2024-02-25'),
(105 , 1005 , 303 , 3 , '2024-03-12'),
(106 , 1001 , 301 , 2 , '2024-03-28'),
(107 , 1003 , 302 , 1 , '2024-04-05'),
(108 , 1002 , 305 , 1 , '2024-04-18');


-- Data Exploration -
SELECT p.learner_id,
ROUND(SUM(p.quantity * c.unit_price), 2) AS total_spent
FROM purchases p
JOIN courses c 
ON p.course_id = c.course_id
GROUP BY p.learner_id
ORDER BY total_spent DESC;

-- INNER JOIN, LEFT JOIN, and RIGHT JOIN -
SELECT l.full_name AS learner_name,
c.course_name , c.category , p.quantity , 
ROUND(p.quantity * c.unit_price, 2) AS total_amount,
p.purchase_date FROM purchases p
INNER JOIN learners l ON p.learner_id = l.learner_id 
INNER JOIN courses C ON p.course_id = c.course_id 
ORDER BY total_amount ASC;

SELECT l.full_name AS learner_name , c.course_name , c.category , p.quantity ,
    ROUND(p.quantity * c.unit_price, 2) AS total_amount,
    p.purchase_date FROM Learners l
LEFT JOIN Purchases p ON l.learner_id = p.learner_id
LEFT JOIN Courses c ON p.course_id = c.course_id
ORDER BY learner_name;

SELECT l.full_name AS learner_name, c.course_name , c.category , p.quantity ,
    ROUND(p.quantity * c.unit_price, 2) AS total_amount, 
    p.purchase_date FROM Purchases p
RIGHT JOIN Courses c ON p.course_id = c.course_id
LEFT JOIN Learners l ON p.learner_id = l.learner_id
ORDER BY course_name;

-- Analytical Queries -
-- Display each learner’s total spending (quantity × unit_price) along with their country -

SELECT l.learner_id , l.full_name , l.country,
ROUND(SUM(p.quantity * c.unit_price), 2) AS total_spent
FROM learners l
INNER JOIN purchases p 
    ON l.learner_id = p.learner_id
INNER JOIN courses c 
    ON p.course_id = c.course_id
GROUP BY 
    l.learner_id, 
    l.full_name, 
    l.country
ORDER BY total_spent;
 
 -- Find the top 3 most purchased courses based on total quantity sold -
 SELECT c.course_id , c.course_name , c.category,
    SUM(p.quantity) AS total_quantity_sold
FROM courses c
INNER JOIN  purchases p
    ON p.course_id = c.course_id
GROUP BY c.course_id, c.course_name, c.category
ORDER BY total_quantity_sold DESC
LIMIT 3;

--  Show each course category’s total revenue and the number of unique learners who purchased from that category -

SELECT 
    c.category,
    ROUND(SUM(p.quantity * c.unit_price), 2) AS total_revenue,
    COUNT(DISTINCT p.learner_id) AS unique_learners
FROM courses c
INNER JOIN purchases p
    ON p.course_id = c.course_id
GROUP BY c.category
ORDER BY total_revenue ;

-- List all learners who have purchased courses from more than one category -
 
SELECT 
    l.learner_id,
    l.full_name AS learner_name,
    COUNT(DISTINCT c.category) AS category_count
FROM learners l
INNER JOIN purchases p
    ON p.learner_id = l.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name
HAVING COUNT(DISTINCT c.category) > 1; 

--  Identify courses that have not been purchased at all --

SELECT 
    c.course_id,
    c.course_name,
    c.category
FROM courses c
LEFT JOIN purchases p
    ON c.course_id = p.course_id
WHERE p.course_id IS NULL;




