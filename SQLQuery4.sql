
-- tp print all databases
select *
from sys.databases;

-- to print all tables in underling database
select *
from sys.tables;


-- display which user are present login
select user;

-- create a new user
CREATE LOGIN BALAJI with password='Balaji@123';

create login AARTI with password='Aarti@123';

-- display which user are present login
select user;

-- create new database
create database dac23;
-- 1) MDF files to store actual data
-- 2) LDF file for backup purpose 

use dac23;

-- create database
create database mydb;

-- rename database name through alter statment
alter database mydb 
modify name=mydatabase;

-- rename database name through store procedure
sp_renameDB "mydatabase", "mydb";

-- drop database 
drop database mydb;

-- =====================================================================

-- SUB-LANGUAGES OF SQL
-- DDL>> create, alter, drop, truncate, modify
-- DML>> insert, update, delete
-- DQL>> select
-- TCL>> commit, rollback, savpoint
-- DCL>> grant, revoke

create database classwork;
use classwork;

create table courses
(
	c_id int primary key,
	c_name nvarchar(50)
);

create table students
(
	s_id int primary key,
	gender char(1),
	s_name nvarchar(30) not null,
	email varchar(40) unique,
	age int check(age>0),
	c_id int,
	constraint fk_cId foreign key(c_id) references courses(c_id) on delete set null on update cascade
);

-- to see structure of table
-- we have pre defined stored procedure
sp_HELP students;

-- drop table if exists students;
-- drop table course;

insert into courses values
(111, 'DAC'),
(222, 'DBDA');

select * from courses;

insert into courses values
(333, 'M.sc Mathematics'),
(444, null),
(555, 'Mechanical Engg');

select * from courses;

insert into courses(c_id) values
(666),
(777);

select * from courses;
-- ==============================================================

-- DDL>> create, alter, drop, truncate, sp_renameDB, sp_RENAME

drop table if exists temp_emp;

create table temp_emp
(
	emp_id int,
	ename char(40),
	gender char(1),
	sal money,
	deptno int
);

sp_HELP temp_emp;

-- to alter the datatype and size  of existing column
alter table temp_emp
alter column ename varchar(70);

sp_HELP temp_emp;

-- store procedure to change table name and column name
-- changing column name
sp_RENAME 'temp_emp.sal', 'salary';

sp_HELP temp_emp;

-- changing table name
sp_RENAME 'temp_emp', 't_emp';

sp_HELP t_emp;

sp_RENAME 't_emp', 'temp_emp';

sp_HELP temp_emp;

-- add column at the end of existing table
alter table temp_emp
add comm int;
  
sp_HELP temp_emp; 

alter table temp_emp
drop column comm;

sp_HELP temp_emp;


-- rename database name through alter statment
alter database mydb 
modify name=mydatabase;

-- rename database name through store procedure
sp_renameDB "mydatabase", "mydb";

-- drop database 
drop database mydb;

-- ===================================================================

-- TRUNCATE and DELETE

-- TRUNCATE : use to delete all rows from table without any condition
			-- we can not use TRUNCATE in combination WITH WHERE clause
			-- we cannot delete specific rows from table

truncate table temp_emp;

select * from temp_emp;

-- DROP table temp_emp;

-- ============================================================

drop table if exists depts;

create table depts
(
	deptno int identity primary key,
	dname varchar(30),
	dlocation nvarchar(50)
);


drop table if exists emps;

create table emps
(
	empno int primary key identity,
	ename varchar(40) not null,
	email varchar(50),
	sal money check(sal>0),
	comm decimal,
	mgr int,
	deptno int,
	constraint un_email unique(email),
	constraint fk_mgr foreign key(mgr) references emps(empno),
	constraint fk_deptno foreign key(deptno) references depts(deptno) on delete cascade on update cascade
);


-- set auto increment values from 1000
DBCC CHECKIDENT ('depts', RESEED, 10);

insert into depts values
('devloper', 'pune'),
('tester', 'mumbai');

delete from depts
where deptno=9;

insert into depts values
('devloper', 'pune');

select * from depts;

insert into depts(dname, dlocation) values
('HR', 'Sambhajinagar'),
('Sales', 'Dharashiv');

select * from depts;

update depts
set dlocation='kallamb'
where dname='Sales';

-- Cannot update identity column 'deptno'.
update depts
set deptno=10
where dname='Sales';

select * from depts;

sp_HELP emps;

insert into emps values
('virat', 'virat@gmail.com', 5000, 300, null, 10);

select * from emps;

insert into emps values
('rohit', 'rohit@gmail.com', 4000, 200, 1, 12),
('rahul', 'rahul@gmail.com', 7000, 200, 7, 11),
('MS Dhoni', 'msd@gmail.com', 9000, 900, null, 13);

select * from emps;


insert into emps values
('shreysh', 'shreysh@gmail.com', 4000, 200, 8, 12);

select * from emps;

insert into emps values
('pandya', 'pandya@gmail.com', 2300, 10, 8, 12);

sp_HELP EMPS;

insert into emps(ename, sal, deptno) values
('surya', 5500, 12);

select * from emps;

-- Violation of UNIQUE KEY constraint 'un_email'. 
-- Cannot insert duplicate key in object 'dbo.emps'. 
-- The duplicate key value is (<NULL>).
insert into emps(ename, sal, deptno) values
('jadu', 4500, 11);

delete from emps
where empno in (18, 13);

insert into emps(ename, email, sal, deptno) values
('jadu', 'jadu@gmail.com', 4500, 11),
('pandya', null, 4500, 11);

select * from emps;

-- Violation of UNIQUE KEY constraint 'un_email'. 
-- Cannot insert duplicate key in object 'dbo.emps'. 
-- The duplicate key value is (<NULL>).
insert into emps(ename, email, sal, deptno) values
('kuldeep', null, 4500, 11);

insert into emps(ename, email, sal, deptno) values
('bhumra', 'bhumra@gmail.com', 4500, 11);

select * from emps;

update emps
set ename='jasprit', email='jasprit@gmail.com'
where empno=23;

select * from emps;

update emps
set comm=50
where comm is null;


insert into emps values
('afridi', 'afridi@gmail.com', 100, 10, 9, 11); 

select * from emps;  

delete from emps
where ename='pandya';

select * from emps;

delete from emps
where mgr is null;

-- set autoincrements 
DBCC CHECKIDENT ('emps', RESEED, 99);

insert into emps(ename, email) values
('siraj', 'siraj@gmail.com'),
('sami', 'sami@gmail.com');

select * from emps;

-- ========================================
-- DQL: data query language

select * from emps;

select empno, ename, email, sal
from emps;
 
 -- create new database
 create database myclsss;

 drop table if exists students;

 
-- auto increment of values
-- IDENTITY(SEED, INCREMENT);
      -- SEED:>> represent starting value -- seed default value is 1
      -- INCREMENT:>> INCREMENT VALUES -- increment default value is also 1
	  -- ONE TABLE CAN CONTAINS ONLY ONE IDENTITY FUNCTION
 create table students
 (
	roll_no int identity(10, 3) primary key,
	s_name varchar(50),
	age tinyint check(age>6),
	marks decimal
 );

 insert into students values
 ('Madhuri', 60, 56),
 ('Anushka', 60, 56),
 ('Katrina', 60, 56),
 ('Karina', 60, 56),
 ('Aarati', 25, 89);

 select * from students;

 select * 
 from students
 where s_name='Madhuri';

 SET IDENTITY_INSERT students ON;

 -- Error: An explicit value for the identity column in table 'students' 
 -- can only be specified when a column list is used and IDENTITY_INSERT is ON.
insert into students values
(555, 'kajal', 60, 56);

-- allowed when >>  SET IDENTITY_INSERT students ON;
 insert into students(roll_no, s_name, age, marks) values
 (555, 'kajal', 60, 56);

 
 SET IDENTITY_INSERT students OFF;

 -- =====================================
 -- in myclsss i.e myclass
 
-- rename database name through alter statment
alter database myclsss
modify name=myclass;

-- OR by using store procedure
 sp_renameDB 'myclsss', 'myclass';

 
 drop table if exists emp_hyd;

 create table emp_hyd
 (
	emp_id int identity(10, 1) primary key,
	ename varchar(40) not null,
	age tinyint not null check(age>=18),
	sal decimal check(sal>5000),
	mgr int,
	constraint fk_mgr foreign key(mgr) references emp_hyd(emp_id) -- on delete set null on update cascade
 );

 sp_HELP emp_hyd;

 insert into emp_hyd values
 ('virat', 34, 5500, null);

 insert into emp_hyd values
 ('shubhamn', 24, 5500, null),
 ('rohit', 36, 6500, null),
 ('rahul', 29, 7500, null);

 select * from emp_hyd;

 delete from emp_hyd
 where ename in ('dipika', 'anushka', 'radhika', 'Aarti', 'Madhuri', 'tamana');


 drop table if exists emp_pune;

 create table emp_pune
 (
	emp_id int identity(10, 1) primary key,
	ename varchar(40) not null,
	age tinyint not null check(age>=18),
	sal decimal check(sal>5000),
	mgr int,
	constraint fk_mgr1 foreign key(mgr) references emp_pune(emp_id) -- on delete set null on update cascade
 );

 insert into emp_pune values
 ('virat', 34, 5500, null);

 insert into emp_pune values
 ('dipika', 24, 5500, null),
 ('anushka', 36, 6500, null),
 ('radhika', 29, 7500, null);

 select * from emp_pune;

 -- join oprations
 
 -- duplicates are not allowed
 select *
 from emp_hyd
 UNION 
 select * 
 from emp_pune;
 
 
 -- duplicates are  allowed
 select *
 from emp_hyd
 UNION ALl
 select * 
 from emp_pune;

 -- Error: All queries combined using a UNION, INTERSECT or EXCEPT 
 -- operator must have an equal number of expressions in their target lists.
 select emp_id, ename, age
 from emp_hyd
 UNION 
 select * 
 from emp_pune;

-- OK
 select emp_id, ename, age
 from emp_hyd
 UNION 
 select emp_id, ename, age
 from emp_pune;

 -- Conversion failed when converting the 
 -- varchar value 'virat' to data type tinyint.
 select emp_id, ename, age
 from emp_hyd
 UNION 
 select emp_id, age, ename
 from emp_pune;


 -- INTERSECT
 select emp_id, ename, age
 from emp_hyd
 INTERSECT 
 select emp_id, ename, age
 from emp_pune;

-- Except
 select emp_id, ename, age
 from emp_hyd
 EXCEPT 
 select emp_id, ename, age
 from emp_pune;


 select emp_id, ename, age
 from emp_pune
 EXCEPT 
 select emp_id, ename, age
 from emp_hyd;

 -- ======================================================
 -- PRIMARY AND FOREIGN KEY CONSTRAINT

 create database DB_PK_FK;

 drop table if exists students;
 drop table if exists courses;



 create table courses
(
	course_d int primary key,
	c_name nvarchar(50)
);

sp_RENAME 'courses.course_d', 'course_id';

sp_help courses;

sp_help students;

drop table if exists students;

create table students
(
	s_id int primary key,
	gender char(1),
	s_name nvarchar(30) not null,
	email varchar(40) unique,
	age int check(age>0),
	c_id int,
	constraint fk_cId foreign key(c_id) references courses(course_id) on delete set null on update cascade
);

sp_help courses;

sp_help students;


create table dept
(
	deptno int identity(10, 2) primary key,
	dname varchar(40) not null,
	dlocation nvarchar(50) 
); 
-- a table which contains PK is called Parent table

sp_help dept;

insert into dept values
('devlopment', 'pune'),
('testing', 'mumbai'),
('design', 'bainglore'),
('markating', 'chennai'),
('HR', 'kolkata'),
('sales', 'hydrabad');

select *
from dept;



create table emp
(
	empno int identity(100, 3),
	email varchar(60), 
	ename varchar(50) not null,
	age tinyint check(age>0),
	sal money,
	comm decimal,
	dptno int, -- references dept(deptno) on delete set null on update cascade	constraint pk_empno primary key(empno),
	constraint uni_email unique(email),
	constraint chk_sal check(sal>1000),
	-- constraint notNull_ename not null(ename), --not allowed
	constraint fk_dptno foreign key(dptno) references dept(deptno) on delete set null on update cascade
);
-- a table which contains FK is called child table
-- FK is is always present in many side

sp_help emp; 

insert into emp values
('virat', 'virat@gmail.com', 35, 5000, 200, 12);
-- 12 is reference value from dept table

-- FK column can contains multiple null values
insert into emp values
('rohit', 'virat@gmail.com', 35, 5000, 200, null);

-- Fk column can not allows the values that are not in reference table(i.e in prenent table)
-- foreign key ensures referenctial integrity
-- Error:-- 55 is unreference value because because 55 is not present in parent table
insert into emp values
('rahul', 'rahul@gmail.com', 35, 5000, 200, 55);

insert into emp values
('shubhamn', 'shubhamn@gmail.com', 35, 5000, 200, 18),
('surya', 'shubhamn@gmail.com', 35, 5000, 200, 18),
('sheyas', 'sheyas@gmail.com', 35, 5000, 200, 18),
('jasprit', 'jasprit@gmail.com', 35, 5000, null, null);

insert into emp values
('rahul', 'rahul@gmail.com', 35, 5000, 200, 14);


select *
from emp;

-- WE CAN NOT UPDATE auto increment column
--Error: Cannot update identity column 'deptno'.
UPDATE dept
SET DEPTNO=555
where deptno=14;

-- ========================================================

select * from courses;
select * from students;

sp_help courses;

insert into courses values
(11, 'dac'),
(22, 'dbda'),
(33, 'ditts');

insert into courses values
(44, 'M.sc'),
(55, 'B.tech Mechanical');

select * from courses;

sp_help students;
insert into students values
(101, 'M', 'virat', 'virat@gmail.com', 35, 11),
(102, 'M', 'rohit', 'rohit@gmail.com', 35, 22),
(103, 'M', 'rahul', 'rahul@gmail.com', 35, 22),
(104, 'M', 'shubhamn', 'shubhamn@gmail.com', 35, 33);


insert into students values
(105, 'M', 'siraj', 'siraj@gmail.com', 35, null),
(106, 'M', 'kuldeep', 'kuldeep@gmail.com', 35, null),
(107, 'M', 'ravindra', 'ravindra@gmail.com', 35, null);


select * from students;

select * from courses;

-- inner join
select c_name, s.s_name, s.email, s.gender, s.age
from courses c
inner join  students s
on c.course_id=s.c_id;

-- left outer join
select c_name, s.s_name, s.email, s.gender, s.age
from courses c
left outer join  students s
on c.course_id=s.c_id;


-- left outer join
select c_name, s.s_name, s.email, s.gender, s.age
from courses c
right outer join  students s
on c.course_id=s.c_id;

-- left outer join
select  s.s_name, s.email, s.gender, s.age, c_name
from students s
left outer join courses c
on s.c_id=c.course_id;


-- inner join
select c_name, s.s_name, s.email, s.gender, s.age
from courses c
inner join  students s
on c.course_id=s.c_id;

-- ===============================

create database db_for_join;

DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS dept;
DROP TABLE IF EXISTS emp;
DROP TABLE IF EXISTS bonus;
DROP TABLE IF EXISTS salgrade;
DROP TABLE IF EXISTS dummy;

CREATE TABLE books (id INT PRIMARY KEY, name VARCHAR(50), author VARCHAR(50), subject VARCHAR(50), price decimal);

INSERT INTO books VALUES (1001,'Exploring C','Yashwant Kanetkar','C Programming',123.456);
INSERT INTO books VALUES (1002,'Pointers in C','Yashwant Kanetkar','C Programming',371.019);
INSERT INTO books VALUES (1003,'ANSI C Programming','E Balaguruswami','C Programming',334.215);
INSERT INTO books VALUES (1004,'ANSI C Programming','Dennis Ritchie','C Programming',140.121);
INSERT INTO books VALUES (2001,'C++ Complete Reference','Herbert Schildt','C++ Programming',417.764);
INSERT INTO books VALUES (2002,'C++ Primer','Stanley Lippman','C++ Programming',620.665);
INSERT INTO books VALUES (2003,'C++ Programming Language','Bjarne Stroustrup','C++ Programming',987.213);
INSERT INTO books VALUES (3001,'Java Complete Reference','Herbert Schildt','Java Programming',525.121);
INSERT INTO books VALUES (3002,'Core Java Volume I','Cay Horstmann','Java Programming',575.651);
INSERT INTO books VALUES (3003,'Java Programming Language','James Gosling','Java Programming',458.238);
INSERT INTO books VALUES (4001,'Operating System Concepts','Peter Galvin','Operating Systems',567.391);
INSERT INTO books VALUES (4002,'Design of UNIX Operating System','Mauris J Bach','Operating Systems',421.938);
INSERT INTO books VALUES (4003,'UNIX Internals','Uresh Vahalia','Operating Systems',352.822);

CREATE TABLE dept(deptno INT, dname VARCHAR(40), loc VARCHAR(40));

INSERT INTO dept VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO dept VALUES (20,'RESEARCH','DALLAS');
INSERT INTO dept VALUES (30,'SALES','CHICAGO');
INSERT INTO dept VALUES (40,'OPERATIONS','BOSTON');

CREATE TABLE emp(empno INT, ename VARCHAR(40), job VARCHAR(40), mgr INT, hire DATE, sal DECIMAL(8,2), comm DECIMAL(8,2), deptno INT);

INSERT INTO emp VALUES (7369,'SMITH','CLERK',7902,'1980-12-17',800.00,NULL,20);
INSERT INTO emp VALUES (7499,'ALLEN','SALESMAN',7698,'1981-02-20',1600.00,300.00,30);
INSERT INTO emp VALUES (7521,'WARD','SALESMAN',7698,'1981-02-22',1250.00,500.00,30);
INSERT INTO emp VALUES (7566,'JONES','MANAGER',7839,'1981-04-02',2975.00,NULL,20);
INSERT INTO emp VALUES (7654,'MARTIN','SALESMAN',7698,'1981-09-28',1250.00,1400.00,30);
INSERT INTO emp VALUES (7698,'BLAKE','MANAGER',7839,'1981-05-01',2850.00,NULL,30);
INSERT INTO emp VALUES (7782,'CLARK','MANAGER',7839,'1981-06-09',2450.00,NULL,10);
INSERT INTO emp VALUES (7788,'SCOTT','ANALYST',7566,'1982-12-09',3000.00,NULL,20);
INSERT INTO emp VALUES (7839,'KING','PRESIDENT',NULL,'1981-11-17',5000.00,NULL,10);
INSERT INTO emp VALUES (7844,'TURNER','SALESMAN',7698,'1981-09-08',1500.00,0.00,30);
INSERT INTO emp VALUES (7876,'ADAMS','CLERK',7788,'1983-01-12',1100.00,NULL,20);
INSERT INTO emp VALUES (7900,'JAMES','CLERK',7698,'1981-12-03',950.00,NULL,30);
INSERT INTO emp VALUES (7902,'FORD','ANALYST',7566,'1981-12-03',3000.00,NULL,20);
INSERT INTO emp VALUES (7934,'MILLER','CLERK',7782,'1982-01-23',1300.00,NULL,10);


CREATE TABLE bonus(ename VARCHAR(40), job VARCHAR(40), sal INT, comm INT);

CREATE TABLE salgrade(grade INT, losal INT, hisal INT);
INSERT INTO salgrade VALUES (1,  700, 1200);
INSERT INTO salgrade VALUES (2, 1201, 1400);
INSERT INTO salgrade VALUES (3, 1401, 2000);
INSERT INTO salgrade VALUES (4, 2001, 3000);
INSERT INTO salgrade VALUES (5, 3001, 9999);

CREATE TABLE dummy (dummy INT);

INSERT INTO dummy VALUES (0);

-- ======================================================

select *
from emp;

sp_help emp;

select *
from dept;

sp_help dept;

-- inner join
select e.ename, e.sal, e.job, e.hire, d.deptno, e.deptno, d.dname, d.loc
from emp e
inner join dept d
on e.deptno=d.deptno;

-- left outer join
select e.ename, e.sal, e.job, e.hire, d.deptno, e.deptno, d.dname, d.loc
from emp e
left outer join dept d
on e.deptno=d.deptno;

-- right outer join
select e.ename, e.sal, e.job, e.hire, d.deptno, e.deptno, d.dname, d.loc
from emp as e
right outer join dept d
on e.deptno=d.deptno;
-- instead of ON we can not use WHERE clause

-- right outer join
select e.ename, e.sal, e.job, e.hire, d.deptno, e.deptno, d.dname, d.loc
from emp as e
full outer join dept d
on e.deptno=d.deptno;

-- right outer join
select e.ename, e.sal, e.job, e.hire, d.deptno, e.deptno, d.dname, d.loc
from emp as e
cross join dept d;
-- cross join gives all possible combination or every row from one 
-- table to another table
-- for cross join to join two tables no requirments of condition

-- ==========================================================

select * from emp;

-- nested query/inner query
select e.ename, e.sal, e.job, e.hire, e.empno, e.mgr
from emp e
where sal=(select sal
			from emp ee
			where ee.ename='ward');

-- findig manager of each employees
select e.ename, ee.ename
from emp e
inner join emp ee
on e.mgr=ee.empno;


-- findig manager of each employees
select e.ename, ee.ename
from emp e
left outer join emp ee
on e.mgr=ee.empno;

-- using correlated query
select e.ename, (select ee.ename from emp ee where e.mgr=ee.empno) as mgr
from emp e;



-- print all employees those have salary  as 'ward' salary
SELECT ee.ename, ee.sal
FROM emp e
INNER JOIN emp ee 
ON e.sal = ee.sal
WHERE e.ename = 'ward';
  -- join condition  &  additional condition


  -- using nested query
select *
from emp
where sal=(select sal
			from emp
			where ename='ward');


-- ============================================================

-- find how many employees are woring in each depatment
select deptno, count(*)
from emp
group by deptno
order by count(*) desc;


select deptno, count(*) as cnt, sum(sal) as sal_sum, avg(sal) as avg_sal, min(sal) as min_sal, max(sal) as max_sal
from emp
group by deptno
order by count(*) desc;


select deptno, job, count(empno)
from emp
group by deptno, job
order by count(*) desc;


select deptno, job, count(empno)
from emp
where 2<9
group by deptno, job
having count(empno)>1
order by count(*) desc;


select deptno, job, sum(sal) as sal_sum
from emp
group by deptno, job
having sum(empno)>1
order by sal_sum desc;

-- ===============================================

-- TCL:- transactional control language

DROP TABLE IF EXISTS branch;

create table branch
(
	bcode int,
	bname varchar(40),
	blocation varchar(40)
);

insert into branch values
(11, 'SBI', 'ravet pune'),
(12, 'BOM', 'new sangvi pune'),
(13, 'SBI', 'akurdi pune');

select * from branch;

BEGIN TRANSACTION
ROLLBACK;

select * from branch;
-- bydefault all DML(insert, update and delete) oprations are auto commited.
-- AUTO COMMITED - means all changes are permanantly applied on underlining table
-- Once the opration is commited then we can not rollbacked


BEGIN TRANSACTION
	insert into branch values
	(14, 'BOI', 'mumbai'),
	(15, 'BOM', 'chennai'),
	(16, 'MGB', 'para');

select * from branch;

-- Error: The ROLLBACK TRANSACTION request has no corresponding BEGIN TRANSACTION.
ROLLBACK;

BEGIN TRANSACTION
ROLLBACK;

SELECT * FROM BRANCH;

BEGIN TRANSACTION
COMMIT;

BEGIN TRANSACTION
	insert into branch values
	(14, 'BOI', 'mumbai'),
	(15, 'BOM', 'chennai'),
	(16, 'MGB', 'para');

BEGIN TRANSACTION
COMMIT;

SELECT * FROM BRANCH;

BEGIN TRANSACTION
ROLLBACK;

select * from branch;

-- =======================================

BEGIN TRANSACTION
COMMIT;

select * from branch;

BEGIN TRANSACTION
	delete from branch
	where bcode in (14, 15, 16);

select * from branch;

BEGIN TRANSACTION 
ROLLBACK;

select * from branch;

BEGIN TRANSACTION
	delete from branch
	where bcode in (14, 15, 16);

select * from branch;

BEGIN TRANSACTION 
COMMIT;

select * from branch;

BEGIN TRANSACTION 
ROLLBACK;

select * from branch;

-- ==================================

delete from branch;

BEGIN TRANSACTION
COMMIT;

select * from branch;

BEGIN TRANSACTION
	insert into branch values
	(11, 'SBI', 'ravet pune'),
	(12, 'BOM', 'new sangvi pune'),
	(13, 'SBI', 'akurdi pune'),
	(14, 'BOI', 'mumbai'),
	(15, 'BOM', 'chennai'),
	(16, 'MGB', 'para');

BEGIN TRANSACTION
COMMIT;

select * from branch;


BEGIN TRANSACTION
	SAVE TRANSACTION S1;
		delete from branch
		where bcode=15;
	SAVE TRANSACTION S2;
		delete from branch
		where bcode=16;

select * from branch;

BEGIN TRANSACTION
ROLLBACK TRANSACTION S2;

select * from branch;

BEGIN TRANSACTION
COMMIT TRANSACTION S1;

select * from branch;

-- ===================================================
		
select job, count(*) as total_count, sum(sal) as sal_sum, avg(sal) as sal_avg, floor(avg(sal)) sal_avg_floor, round(avg(sal), 2) as sal_avg_round
from emp
-- where 1<4
group by job
-- having 2>1
order by count(*) desc;

select job, deptno, count(*) as total_count, sum(sal) as sal_sum, avg(sal) as sal_avg
from emp
group by job, deptno
order by deptno asc, count(*) desc;

-- ====================================================================

-- ROLLUP clause is finding sub & grand total based on a single column.
select job, count(*) as total_count
from emp
group by ROLLUP(job)
order by count(*) asc;

-- CUBE clause is finding sub & grand total based on multiple columns.
select job, count(*) as total_count
from emp
group by CUBE(job)
order by count(*) asc;

-- OR
select job, count(*) as total_count
from emp
group by job with cube
order by count(*) asc;

-- ==================================================================
 -- without ROLLUP and CUBE functions
select job, deptno, count(*) as total_count
from emp
group by job, deptno;


-- ROLLUP function is finding sub & grand total based on a single column.
-- job wise only
select job, deptno, count(*) as total_count
from emp
group by ROLLUP(job, deptno);

-- deptno wise only
select job, deptno, count(*) as total_count
from emp
group by ROLLUP(deptno, job);


-- CUBE function is finding sub & grand total based on multiple columns.
-- deptno wise followed by job wise
select job, deptno, count(*) as total_count
from emp
group by CUBE(job, deptno);

-- job wise followed by deptno wise
select job, deptno, count(*) as total_count
from emp
group by CUBE(deptno, job);


-- =====================================

use db_for_join;

-- stored functions in T/SQL

-- 1) SCALAR VALUED FUNCTION

-- CREATING SCALAR VALUED FUNCTION to returns the gross salary of employees based on the following conditions.
	-- 1)HRA 10%
	-- 2)DA 20%
	-- 3)PF 10%

create function my_fun(@empno int)
RETURNS decimal
AS
BEGIN
	declare @gross_sal decimal;

	select @gross_sal=sum( sal + sal*10/100 + sal*20/100 + sal*10/100 )
	from emp
	where empno=@empno;

	return @gross_sal;
END;

-- drop function my_fun;

-- call to my_fun
select dbo.my_fun(7499);

CREATE FUNCTION fun_gross_sal(@empno int)
RETURNS MONEY
AS
BEGIN
	declare @basic money;
	declare @hra money;
	declare @da money;
	declare @pf money;
	declare @gross money;

	select @basic=sal 
	from emp
	where empno=@empno;

	set @hra=@basic*10/100;
	set @da=@basic*20/100;
	set @pf=@basic*10/100;
	set @gross=@basic+@hra+@da+@pf;

	return @gross;
END;

-- CALL SCALAR VALUED FUNCTION
select dbo.fun_gross_sal(7499);

-- not allowed
select fun_gross_sal(7499);


-- 2) TABLE VALUED FUNCTION

-- create a table valued function to accept depatment name as a parameter 
-- and return the list of employee who are in the given pepartment name

 create function TVF1(@deptname varchar(40))
 RETURNS TABLE
 AS
 return (select * from emp where deptno=(select deptno from dept where dname=@deptname));

-- call to TVF1
select * from TVF1('accounting');
select * from dbo.TVF1('accounting');


-- =======================================================

-- RANKING FUNCTIONS:
	-- 1) ROW_NUMBER()
	-- 2  RANK()
	-- 3) DENSE_RANK()

-- use de_for_join

select ename, job, sal, 
from emp;


select ename, job, sal, row_number() over(order by sal desc) as sal_rank
from emp;

select ename, job, sal, rank() over(order by sal desc) as sal_rank
from emp;

-- Error: Windowed functions can only appear in the SELECT or ORDER BY clauses.
select ename, job, sal, rank() over(order by sal desc) as sal_rank
from emp
where sal=rank() over(order by sal desc);


select ename, job, sal, dense_rank() over(order by sal desc) as sal_rank
from emp;


-- --------------------------------------------------------

select ename, deptno, sal, row_number() over(partition by deptno order by sal desc) as sal_rank
from emp;

select ename, deptno, sal, rank() over(partition by deptno order by sal desc) as sal_rank
from emp;

select ename, deptno, sal, dense_rank() over(partition by deptno order by sal desc) as sal_rank
from emp;



-- ===================================================

-- finding second higest sal from emp table
select *
from emp
where sal=( select max(sal) 
			from emp
			where sal<( select max(sal)
						from emp ) )

-- second highest sal from emp table.
with CTE_emp as -- CTE: common temporary expression
(
	select *, dense_rank() over(order by sal desc) as sal_rank
	from emp
)
select * 
from CTE_emp
where sal_rank=2;


-- second highest sal from emp table.
SELECT *
FROM emp
WHERE sal = ( SELECT TOP 1 sal
			  FROM (SELECT DISTINCT TOP 2 sal FROM emp ORDER BY sal DESC ) AS Subquery
              ORDER BY sal ASC );


-- display top 10 records according to sal
SELECT  TOP (10) sal
FROM emp
ORDER BY sal desc;


-- display top 10 records according to sal
SELECT distinct TOP (10) sal
FROM emp
ORDER BY sal desc;


-- display top 10 records according to sal
SELECT TOP (10) ename, sal
FROM emp
ORDER BY sal desc;

-- display top 10 records according to sal
SELECT distinct TOP (10) ename, sal
FROM emp
ORDER BY sal desc;


-- 2nd higest with derived table
select *
from (select *, dense_rank() over(order by sal desc) as drs from emp) as temp
where drs=2;

-- ===================================================================
-- use db_for_join
-- stored procedure

-- stored procedure without parametes
create procedure my_pro
AS
BEGIN
	select * 
	from emp
	where deptno=any (select deptno
				      from dept
				      where deptno!=40);
END;

-- call procedure my_pro
execute  my_pro;
exec my_pro;


-- stored procedure with in/input parameter
-- create a stored procedure to insert records in  table

drop table if exists sp_table;

create table sp_table
(
	empno int,
	ename varchar(20),
	sal money
);


drop procedure if exists insert_in_sp_table;

create procedure insert_in_sp_table(@empno int, @ename varchar(40), @sal money)
AS
BEGIN
	insert into sp_table values
	(@empno, @ename, @sal);
END;

execute insert_in_sp_table 111, 'akash', 4000;

select * 
from sp_table;

execute insert_in_sp_table 222, 'saurabh', 6000;

select * 
from sp_table;


-- write a stored procedure that take integer  number as input 
-- and print its square inside stored procedure
create procedure sp_square(@num int)
AS
BEGIN
	select @num*@num;
END;

exec sp_square 5;

-- store procedure with out parameters
-- write a store procedure to input empno and returns that employee 
-- provident fund and professional tax on salary by following condition
	-- 1) PF 10%
	-- 2) PT 20%
create procedure sp_emp(@empno int = 100, @PF int out, @PT int out)
AS
BEGIN
	declare @salary money;

	select @salary=sal 
	from emp
	where empno=@empno;

	set @PF=@salary*10/100;
	set @PT=@salary*20/100;
END;

-- drop procedure sp_emp;

-- declare bind variable.
declare @bPF int;
declare @bPT int;

-- execute stored procedure 
execute sp_emp 7499, @bPF out, @bPT output;

-- print values 
print @bPF;
print @bPT;

print 'provident fund : '+cast(@bPF as varchar);
print 'professional tax : '+cast(@bPT as varchar);





-- ===============================================================

select ename, sal, comm, isnull(comm, 0) as comms
from emp;

-- Error: Column 'emp.ename' is invalid in the select list because it is 
-- not contained in either an aggregate function or the GROUP BY clause.
select ename, sum(sal+isnull(comm, 0)) as total
from emp;


select ename, sal comm, isnull(comm, 0) as comms, sal+comm as gross_total, sal+isnull(comm, 0) as 'total gross salary'
from emp;

select * from dept;
select * from emp;

select e.ename, e.sal, e.deptno, d.deptno, d.dname
from emp e
inner join dept d
on e.deptno=d.deptno;


-- non equi join
select e.ename, e.sal, e.deptno, d.deptno, d.dname
from emp e
inner join dept d
on e.deptno<>d.deptno;

-- non equi join
select e.ename, e.sal, e.deptno, d.deptno, d.dname
from emp e
inner join dept d
on e.deptno>d.deptno;

select *
from emp e 
left join dept d
on e.deptno=d.deptno
where d.deptno is null;
-- ==============================================================

create table temp_student
(
	roll int identity primary key,
	sname varchar(30) not null,
	email varchar(40) unique
);

insert into temp_student values
('akash', 'akash@gmail.com');

insert into temp_student values
('aarti', null);

-- only one null value is allowed in MS SQL server
insert into temp_student values
('akshita', null);


-- we can use UNIQUE KEY column for uniquely identifying a row 
-- from table like primary key.
-- -----------------------------------------


select * from temp_student;

insert into temp_student values
('akshita', 'akshita@gmail.com'),
('ankita', 'ankita@gmail.com'),
('akshara', 'akshara@gmail.com'),
('anushka', 'anushka@gmail.com');

select * from temp_student;

BEGIN TRANSACTION
DELETE FROM temp_student;

select * from temp_student;

BEGIN TRANSACTION
ROLLBACK;

select * from temp_student;

-- after delete we can rollback.
-- ---------------------------------------------

BEGIN TRANSACTION
COMMIT

select * from temp_student;

BEGIN TRANSACTION
TRUNCATE table temp_student;

select * from temp_student;

BEGIN TRANSACTION
ROLLBACK;

select * from temp_student;

-- after truncate we also rollback but it is not true in MySQL

-- ============================================================

-- SUB QUERY AND CORELATED QUERY

-- sub query with in clause
select * 
	from emp
	where deptno in (select deptno
				      from dept
				      where deptno!=40);

-- sub query with any clause
select * 
from emp
where deptno=any(select deptno
				 from dept
				  where deptno!=40);

-- sub query wit all clause
select * 
	from emp
	where deptno=all(select deptno
				      from dept
				      where deptno!=40);

-- ================================================================

-- Find details of person having max sal

-- An aggregate may not appear in the WHERE clause unless it is in a 
-- subquery contained in a HAVING clause or a select list, and the column
-- being aggregated is an outer reference.
select *
from emp
where sal=max(sal);



-- ========================================
DECLARE @max INT;

SELECT @max = MAX(sal) 
FROM emp;

-- Then print the value of @max
PRINT @max;

select @max;

select *
from emp
where sal=@max;
-- =================================================

-- print employee with max salary
select *
from emp
where sal=(select max(sal)
			from emp);


-- print employee details with second highest salary
select *
from emp
where sal=(select top 1 sal
			from ( select distinct top 2  sal
				   from emp
			       order by sal desc) as temp_temp -- giving alias is mandetory
			order by sal asc);
		
-- print details of employee whose salary is at 9th higest
select *
from emp
where sal=(select distinct top 1 sal
			from (select distinct top 9 sal
					from emp
					order by sal desc) as temp_teble
			order by sal asc);

select *
from emp
order by sal desc;

-- print 2nd higest sal employees details using Common Temporary Expression
with CTE_table as
(
	select *, dense_rank() over(order by sal desc) as sal_rank
	from emp
)
select *
from CTE_table
where sal_rank=2;

-- print 9nd higest sal employees details
with CTE_table as
(
	select *, dense_rank() over(order by sal desc) as sal_rank
	from emp
)
select *
from CTE_table
where sal_rank=9;


-- using derived table
select *
from (select *, dense_rank() over(order by sal desc) as dr from emp) as temp
where dr=2;




-- find details of employee whose depatment name is 'sales'
select * 
from emp
where deptno=(  select deptno
				from dept
				where dname='sales' );

-- using joins
select *
from emp e
inner join dept d
on e.deptno=d.deptno
where d.dname='sales';

-- find details of employee whose depatment is same as the department 
-- of the employee smith or miller

-- not recommended
select *
from emp e
where e.deptno=any( select deptno
				    from emp ee
				    where ee.ename='smith' or ee.ename='miller');


select *
from emp e
where e.deptno=any( select deptno
				    from emp ee
				    where ee.ename in ('smith', 'miller' ));

-- OR
select *
from emp e
where e.deptno in ( select deptno
				    from emp ee
				    where ee.ename in ('smith', 'miller' ));

-- using joins


-- ==============================================
use db_for_join;

-- creating duplicate table with all data
select * into temp_emp
from emp;

select * from temp_emp;

sp_help temp_emp;


-- creating table structure only i.e empty table
select * into temp_emp2
from emp
where 2=1;

-- ======================================================
use classwork;

select * from depts;

select * from emps;

sp_help depts;

sp_help emps;

-- creating table structure only from existing table 
-- but constraint are not copied
select * into temp_emps
from emps
where 2=1;

sp_help temp_emps;

-- creating exact copy of emps table with data
select * into temp_emps2
from emps;

select * 
from temp_emps2;


-- creating views
create view v1 as select * from emps;


sp_help emps;

-- all rules(i.e constraints) and default values are not copy 
-- from parent table to views only auto-ncrement values are copied
sp_help v1;
-- ==============================================================

-- ## VIEWS IN MS SQL

use db_for_join;

select * from emp;

-- t2 is a table not a view
select * into t2 from emp;

sp_help t2;

-- 1) SIMPLE VIEWS(updatable views):-

-- t1 is a view not a table
create view t1 as select * from emp;


-- all constraint are not copied in views from base table 
-- only identity(auto increment) properties copies from base to views
create view v2 as select * from temp_student;

sp_help v2;

select * from v2;

select * from temp_student;

-- in simple views changes are reflected in base table aslo
insert into v2 values
('chima', 'chima@gmail.com');

select * from v2;

select * from temp_student;

-- in simple views changes are reflected in base table aslo
delete from v2
where roll=1;

select * from v2;

select * from temp_student;

-- -------------------------------------------------------
-- 2) complex views(non updatable views ):-
			-- created using joins on multiple tables
			-- read only views
			-- does not support to DML oprations

select * from emp;
select * from dept;

create view cv1 as 
select e.empno, e.ename, e.sal, e.job, e.hire, d.dname, d.loc 
from emp e
inner join dept d
on e.deptno=d.deptno;

select * from cv1;

-- complex views are read only 
-- complex views does not support to DML oprations.
-- it means we cannot insert / update / delete data with the help of complex views

-- ===========================================================

select ename, sal, hire, 
CASE
	when sal<=1500 then 'poor'
	when sal between 1500 and 2500 then 'middle'
	else 'ritch'
END as msg
from emp;

select * from emp;

update emp
set sal= CASE
			when sal<1500 then sal+100
			when sal>=1500 and sal<2500 then sal+200 -- between oprator doest not work here
			else sal+300
		END;

update emp
set sal= IIF(sal<1500, sal+100, IIF(sal>1500 and sal<2500, sal+200, sal+300));

-- ===============================================================

-- find employee details having 2nd highest salary

-- with nested query
select * 
from emp
where sal=(select max(sal)
			from emp
			where sal<(select max(sal)
						from emp));

--- with temp table
select *
from emp
where sal=(select top 1 sal
			from (select distinct top 2 sal
					from emp
					order by sal desc) as temp
			order by sal asc);

-- with CTE
with CTE_table as
(
	select *, DENSE_RANK() over(order by sal desc) as rank_sal
	from emp
)
select * 
from CTE_table
where rank_sal=2;

-- with co-related query
select *
from emp e
where (2-1)=(select count(*)
		     from emp ee
		     where e.sal<ee.sal);
-- not recommended

-- =======================================================

-- display all employee whose depatment No, is not in dept table
select *
from emp e
where  not exists ( select deptno
				    from dept d
				    where e.deptno=d.deptno );


-- display all employee whose depatment No, is not in dept table
SELECT *
FROM emp e
left outer join dept d
on e.deptno=d.deptno
where d.deptno is null;

-- =================================================================

select *
from emp
where ename like '%A%A%';

SELECT *
FROM emp
WHERE PATINDEX('%A%A%', ename) > 0;

-- ======================================================

-- String Function

select ASCII('A');  -- 65
select ASCII('AB'); -- 65

select CHAR(65); -- A

select len('  Balaji') as without_ltrim, -- 8
	   len(ltrim('  Balaji')) as with_ltrim; -- 6

select len('Balaji  ') as without_rtrim,  -- 6
	   len(rtrim('Balaji  ')) as with_rtrim; -- 6

select len('  Balaji  ') as without_trim, -- 8
	   len(trim('  Balaji  ')) as with_trim; -- 6

select ename, 
	   lower(ename) as lowercase, 
	   upper(ename) as uppercase, 
	   reverse(ename) as reverse_name, 
	   len(ename) as length
from emp;

-- print ASCII code from 65 to 90

declare @start int=65;

WHILE (@start<=90)
BEGIN
	select CHAR(@start);
	set @start=@start+1;
END;

-- print table of 10
declare @num int =10;

while(90<=@num)
BEGIN
	select @num;
	set @num=@num+10;
END;


-- if else block
IF(15>20)
BEGIN 
	select 'inside IF block';
END
ELSE IF(40>50)
BEGIN 
	select 'inside ELSE IF block';
END
ELSE 
BEGIN
	select 'inside ELSE block';
END;

-- IIF condition
SELECT IIF(10<20, 'FIRST', 'SECOND');








-- ====================================================
-- TRIGGERS

drop table if exists employees;

create table employees
(
	empno int primary key,
	ename varchar(30),
	sal money
);

-- writting trigger on employees table for insert
drop table if exists employees_audit_for_insert;

create table employees_audit_for_insert
(
	id int,
	auditdata nvarchar(500)
);

-- writting trgger
drop trigger if exists tr1;

create trigger tr1
on employees
-- for insert
after insert
AS
BEGIN
	declare @id int;

	-- inserted table is special temporaty table it is available only in 
	-- context of trigger. (it similar to table on which we are creating trigger)
	select @id=empno
	from inserted;
	
	-- select @id=empno
	-- from employees;

	insert into employees_audit_for_insert values
	( @id, 'new employee with id='+cast(@id as varchar(50))+' is added on '+ cast( getdate() as varchar(50) ) );
END;

insert into employees values
(111, 'virat', 4500);

select *
from employees;

select * 
from employees_audit_for_insert;

insert into employees values
(222, 'rohit', 5600);

select *
from employees;

select * 
from employees_audit_for_insert;

insert into employees values
(333, 'shubhamn', 2300);

select *
from employees;

select * 
from employees_audit_for_insert;

insert into employees values
(444, 'surya', 76000);

select *
from employees;

select * 
from employees_audit_for_insert;

-- =================================================

-- writting trigger on employees table for delete
drop table if exists employees_audit_for_delete;

create table employees_audit_for_delete
(
	id int,
	auditdata nvarchar(500)
);

-- writting trigger 
drop trigger if exists tr2;

create trigger tr2
on employees
-- for delete
after delete
AS
BEGIN
	declare @id int;

	-- deleted table is special temporaty table it is available only in 
	-- context of trigger only. (it similar to table on which we are creating trigger)
	select @id=empno
	from deleted;

	-- select @id=empno
	-- from employees;

	insert into employees_audit_for_delete values
	(@id, 'employee with id='+cast( @id as varchar(30) )+'is delete on '+cast( getdate() as varchar(30) ) );

END;

delete from employees
where empno=333;

select *
from employees;

select * 
from employees_audit_for_delete;

-- =======================================================

-- writting trigger on employees table for update
drop trigger if exists tr3;

create trigger tr3
on employees
after update
AS
BEGIN
	select * from deleted;
	select * from inserted;
END;

update employees
set ename='jasprit', sal=9999
where empno=111;

-- ============================================================

-- writting trigger on employees table for update
drop table if exists employees_audit_for_update;

create table employees_audit_for_update
(
	id int,
	dates datetime,
	users varchar(50),
	old_ename varchar(40),
	new_ename varchar(50),
	old_sal money,
	new_sal money,
);


drop trigger if exists tr4;

create trigger tr4
on employees
after update
AS
BEGIN
	declare @id int;
	declare @date datetime;
	declare @user varchar(50);
	declare @old_name varchar(40);
	declare @new_name varchar(40);
	declare @old_sal money;
	declare @new_sal money;

	select @id=empno
	from deleted;

	set @date=getdate();

	select @user=SYSTEM_USER;

	select @old_name=ename
	from deleted;
	
	select @new_name=ename
	from inserted;

	select @old_sal=sal
	from deleted;

	select @new_sal=sal
	from inserted;

	insert into employees_audit_for_update values
	(@id, @date, @user, @old_name, @new_name, @old_sal, @new_sal);

END;

update employees
set ename='kuldeep', sal=7777
where empno=222;

select *
from employees;

select *
from employees_audit_for_update;

--===============================================================
-- ERROR HANDLING IN MS SQL

drop table if exists bank_accounts;

create table bank_accounts
(
	account_no int primary key identity(2023001, 1),
	ifsc_code varchar(45) default 'SBIN0004451',
	bank_name varchar(40),
	customer_name varchar(150),
	mobile bigint,
	balance money,
);

insert into bank_accounts values
(default, 'SBI', 'BALAJI GAPAT', 9096973617, 2575000),
(default, 'SBI', 'SACHIN BHARATE', 9970063817, 2575000),
(default, 'SBI', 'SAMBHAJI KOTHAWALE', 9096973617, 2575000),
(default, 'SBI', 'RAVI SINGNE', 9096973617, 2575000);

SELECT * FROM BANK_ACCOUNTS;

drop table if exists bank_transaction;

create table bank_transaction
(
	tr_id int primary key,
	tran_date datetime default getdate(),
	sender_account_no bigint,
	receiver_account_no bigint,
	transaction_amount int
);

-- write procedure 
drop procedure if exists make_transaction;

create procedure make_transaction(@sender_acc bigint, @receiver_acc bigint, @amount int)
AS
BEGIN
	BEGIN TRANSACTION
		declare @sender bigint = 0;
		declare @receiver bigint = 0;

		select @sender=account_no
		from bank_accounts
		where account_no=@sender_acc;

		select @receiver=account_no
		from bank_accounts
		where account_no=@receiver_acc;

		IF(@sender!=0 and @receiver!=0)
		BEGIN
			update bank_accounts
			set balance=balance-@amount
			where account_no=@sender;

			update bank_accounts
			set balance=balance+@amount
			where account_no=@receiver;

		    declare @tr_id int;
		    
		    select @tr_id= CASE 
		    					when max(tr_id) is null then 0
		    					else max(tr_id)	
		    				END
		    from bank_transaction;
		    
		    -- select @tr_id=isnull(max(tr_id), 0)
		    -- from bank_transaction;
		    
		    set @tr_id=@tr_id+1;
		    
		    insert into bank_transaction values
		    (@tr_id, getdate(), @sender, @receiver, @amount);

	        COMMIT TRANSACTION;
		END;
		ELSE
		BEGIN
			RAISERROR('given account numbers are not valid', 16,1);
			ROLLBACK TRANSACTION;
		END;

END;

-- EXECUTE PROCEDURE
make_transaction 20230012, 2023002, 5000;


select * from bank_accounts;

select * from bank_transaction;

-- =======================================================
-- try catch block to handle error

drop procedure if exists spDivision;

create procedure SpDivision(@num1 int, @num2 int)
AS
BEGIN
	declare @ans int;
	
	BEGIN TRY
		set @ans=@num1/@num2;
		select @ans;
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER(),
			ERROR_MESSAGE(),
			ERROR_PROCEDURE(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE();
	END CATCH;
END;

-- execute store procedure
SPdivision 100, 10;

SPdivision 100, 20;

SPdivision 100, 0;

SPdivision 100, 50;

SPdivision 100, 0;




















-- ===============================================================

-- CURSOR IN T/SQ LANGUAGE
-- 1) DECLARE CURSOR
-- 2) OPEN CURSOR CONNECTION
-- 3) FETCH DATA INTO CURSOR



-- 1) FIRST METHOD
			-- fetch first row from cursor table
-- 2) NEXT METHOD
			-- fetch one by one (next) row from cursor table in forword direction
-- 3) LAST METHOD
			-- fetch first row from table
-- 4) PRIOR METHOD
			-- fetch row from cursor table in backword direction row by row
-- 5) ABSOLUTE n
			-- fetch exact nth row from cursor table
-- 6) RELATIVE n
			-- fetch ow from table in incremental way or in decremental way



-- without cursor variable

declare c1 CURSOR SCROLL for select * from emp;
OPEN c1;
	fetch next from c1;
	fetch prior from c1;
	fetch first from c1;
	fetch last from c1;
	fetch absolute 7 from c1;
	fetch relative -2 from c1;
	fetch relative 5 from c1;
	
CLOSE C1;
DEALLOCATE c1;


-- ==========================================================================================

declare @empno int;
declare @ename varchar(40);

declare cr_emp2 CURSOR SCROLL for select empno, ename from emp; -- 1
OPEN cr_emp2; -- 2
	
	fetch next from cr_emp2 into @empno, @ename; -- 3
	
	WHILE(@@FETCH_STATUS=0)
	BEGIN
		print cast(@empno as varchar(30))+'   and   '+@ename;
		fetch next from cr_emp2 into @empno, @ename;
	END;
CLOSE cr_emp2; -- 4
DEALLOCATE cr_emp2;

-- ==================================================
-- same cursor but in procedure
create procedure spCursor
AS
BEGIN
	declare @empno int;
	declare @ename varchar(40);
	
	declare cr_emp3 CURSOR SCROLL for select empno, ename from emp; -- 1
	OPEN cr_emp3; -- 2
		
		fetch next from cr_emp3 into @empno, @ename; -- 3
		
		WHILE(@@FETCH_STATUS=0)
		BEGIN
			print cast(@empno as varchar(30))+'   and   '+@ename;
			fetch next from cr_emp3 into @empno, @ename;
		END;
	CLOSE cr_emp3; -- 4
	DEALLOCATE cr_emp3;
END;

-- execute procedure
spCursor;


-- =====================================================================

