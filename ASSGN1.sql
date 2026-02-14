--QUESTION 1
CREATE TABLE address(
address_id INT PRIMARY KEY,
street_address VARCHAR(50),
city VARCHAR(20),
state_name VARCHAR(20),
postal_code INT
);
CREATE TABLE department(
department_id INT PRIMARY KEY,
department_name VARCHAR(20)
);
CREATE TABLE student (
   student_id INT PRIMARY KEY,
   first_name VARCHAR(30),
   last_name varchar(30),
   birthdate DATE,
   department_id INT,
   address_id INT,
   FOREIGN KEY (department_id) REFERENCES department(department_id),
   FOREIGN KEY (address_id) REFERENCES address(address_id)
);

--QUESTION 2
INSERT INTO department VALUEs(1,'CS');
INSERT INTO department VALUES(2,'ME');
INSERT INTO department VALUES(3,'EE');
INSERT INTO department VALUES(4,'CE');
INSERT INTO department VALUES(5,'MATH');
INSERT INTO department VALUES(6,'BIO');

INSERT INTO address VALUES
(1, '123 Elm St', 'Springfield', 'IL',62701),
(2, '456 Oak St', 'Decatur', 'IL',62521),
(3, '789 Pine St', 'Champaign', 'IL',61820),
(4, '102 Birch Rd', 'Peoria', 'IL',61602),
(5, '205 Cedar Ave', 'Chicago', 'IL',60601),
(6, '310 Maple Dr', 'Urbana', 'IL',61801),
(7, '415 Oak Blvd', 'Champaign', 'IL',61821),
(8, '520 Pine Rd', 'Carbondale', 'IL',62901);

INSERT INTO student VALUES
(1, 'John', 'Doe', '1995-04-15', 1, 1),
(2, 'Jane', 'Smith', '1996-07-22', 2, 2),
(3, 'Alice', 'Johnson', '1994-11-30', 3, 3),
(4, 'Michael', 'Brown', '1997-02-19', 4, 4),
(5, 'Sophia', 'Davis', '1998-01-05', 5, 5),
(6, 'Daniel', 'Wilson', '1995-06-10', 6, 6),
(7, 'Olivia', 'Martinez', '1997-11-25', 1, 7),
(8, 'Ethan', 'Miller', '1996-03-30', 2, 8);

--QUESTION 3
SELECT COUNT(*) AS total_student from student;

--QUESTION 4
SELECT department_name FROM department WHERE department_id=(SELECT department_id FROM 
student WHERE first_name='John');

--Question 5
SELECT d.department_id , COUNT(*) AS number_student from department d 
LEFT JOIN 
student s ON d.department_id=s.department_id 
GROUP BY d.department_id;

--QUESTION 6
SELECT d.department_name,a.street_address,a.city,a.state_name,a.postal_code
FROM student s JOIN department d ON s.department_id=d.department_id
JOIN address a ON s.address_id=a.address_id;

--QUESTION 7
SELECT * FROM student WHERE department_id=(SELECT department_id from department where 
department_name='CS');

--QUESTION 8
UPDATE address set city='New York' where address_id=(SELECT address_id FROM student where
nam)

--QUESTION 11
SELECT d.department_id,COUNT(*) FROM department d LEFT JOIN student s ON
d.department_id=s.department_id
GROUP BY d.department_id;

--QUESTION 12
SELECT first_name,last_name from student s JOIN address a ON 
s.address_id=a.address_id WHERE a.city='Springfield';

--QUESTION 13
SELECT * FROM student WHERE EXTRACT(MONTH FROM birthdate)=2;

--QUESTION 14
SELECT d.department_name,a.city,a.state_name
FROM student s JOIN department d ON s.department_id=d.department_id
JOIN address a ON s.address_id=a.address_id
WHERE s.first_name='John'; 

--QUESTION 15
SELECT * FROM student WHERE birthdate>='1995-01-01' AND birthdate<'1999-01-01';

--QUESTION 16
SELECT d.department_name,s.first_name,s.last_name,d.department_id
FROM student s JOIN department d ON s.department_id=d.department_id
ORDER BY d.department_id;

--QUESTION 17
SELECT d.department_name,SUM(CASE WHEN a.city='Champaign' THEN 1 ELSE 0 END) FROM 
student s JOIN department d ON s.department_id=d.department_id
JOIN address a ON s.address_id=a.address_id
GROUP BY d.department_id;

--QUESTION 18
SELECT s.first_name FROM 
student s JOIN address a ON s.address_id=a.address_id
WHERE street_address ILIKE '%pine';

--QUESTION 19
UPDATE department SET department_name='ME' WHERE department_id=(SELECT department_id FROM student WHERE
student_id=6);

--QUESTION 20
SELECT s.first_name,s.last_name FROM student s LEFT JOIN department d ON 
s.department_id=d.department_id 
LEFT JOIN address a ON s.address_id=a.address_id WHERE 
a.city='Chicago' AND d.department_name='MATH';

--QUESTION 21
SELECT s.first_name,s.last_name FROM student s LEFT JOIN
address a ON s.address_id=a.address_id WHERE 
a.city IN('Urbana','Peoria');

--QUESTION 22
SELECT first_name,last_name FROM
student ORDER BY student_id DESC
LIMIT 1;

--QUESTION 23
SELECT s.first_name,s.last_name ,d.department_name FROM student s LEFT JOIN department d ON 
s.department_id=d.department_id 
WHERE d.department_name!='CS';

--QUESTION 24
SELECT COUNT(*) AS total_number FROM 
address GROUP BY city 
HAVING city='Champaign';

--QUESTION 25
SELECT s.first_name,s.last_name FROM student s LEFT JOIN
address a ON s.address_id=a.address_id WHERE 
a.street_address='520 Pine Rd';

--QUESTION 26
SELECT AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE,s.birthdate))) FROM
student s  JOIN department d ON 
s.department_id=s.department_id 
GROUP BY d.department_id HAVING department_name='EE';

--QUESTION 27
SELECT s.first_name,s.last_name,a.city ,d.department_name FROM student s LEFT JOIN department d ON 
s.department_id=d.department_id 
LEFT JOIN address a ON s.address_id=a.address_id WHERE
d.department_name ILIKE 'M%';

--QUESTION 28
DELETE FROM student 
WHERE department_id=(SELECT department_id FROM department WHERE department_name='ME' LIMIT 1);
