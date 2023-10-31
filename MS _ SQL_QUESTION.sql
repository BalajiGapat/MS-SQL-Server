use db_for_join;
-- =========================================================================
-- 1) find nth highest salary from table
-- using temp table
select *
from emp
where sal=(select distinct top 1 sal
			from (select distinct top 2 sal
					from emp
					order by sal desc) as temp -- giving alias for table is mandetory
			order by sal asc);

-- using CTE
with CTE_table as
(
	select *, DENSE_RANK() over(order by sal desc) as sal_rank
	from emp
)
select * 
from CTE_table
where sal_rank=2;

-- using nested query
select *
from emp
where sal=(select max(sal)
			from emp
			where sal<(select max(sal)
						from emp));

-- using corelated query
select *
from emp e
where (2-1)=(select count(*)
			from emp ee
			where e.sal<ee.sal);

--using derived tables
select *
from (select *, dense_rank() over(order by sal desc) as dr from emp) as tt
where dr=2;
-- =======================================================================
-- 2) find max salary from each department

-- using group by clause
select deptno, max(sal) as max_sal
from emp
group by deptno;

-- using windowsuns
select distinct deptno, maxs
from (select *, max(sal) over(partition by deptno) as maxs from emp) as tt;


-- 2nd highest sal in each depatment
select deptno, sal
from (select *, DENSE_RANK() over(partition by deptno order by sal desc) as dr from emp) as tt
where dr=1;


select deptno, min(sal), max(sal), avg(sal), count(*), sum(sal)
from emp
group by deptno;

-- =======================================================================
-- 3) write sql query to get the complete orgnization 
-- hierarchy based on an Empno

-- in this King is missing
select e.ename as employee, ee.ename as manager
from emp e
inner join emp ee
on e.mgr=ee.empno;

select e.empno, e.ename as employee, ee.ename as manager
from emp e
left outer join emp ee
on e.mgr=ee.empno
order by e.empno;

select e.empno, e.ename as employee, ee.ename as manager
from emp e
left outer join emp ee
on e.mgr=ee.empno
order by e.empno;

-- ======================================================================
-- 4) delete duplicate records from table

select * from emp;

insert into emp select * from emp;

alter table emp
add  sr_no int identity(1, 1);

delete e from emp e
inner join emp ee
on e.sr_no<ee.sr_no and e.empno=ee.empno and e.ename=ee.ename and e.job=ee.job and isnull(e.mgr, 0)=isnull(ee.mgr, 0)
and e.hire=ee.hire and e.sal=ee.sal and isnull(e.comm, 0)=isnull(ee.comm, 0) and e.deptno=ee.deptno;

alter table emp
drop column sr_no;


-- -----------------------------------------
-- OLD

sp_helpindex emp;
drop index index_emp2 on emp;

select * from emp;

BEGIN TRANSACTION
	insert into emp select * from emp;

BEGIN TRANSACTION 
ROLLBACK


-- by using row_number() fun
with CTE_table as
(
	select *, row_number() over(partition by empno, ename, job, mgr, hire, sal, comm, deptno order by empno, ename, job, mgr, hire, sal, comm, deptno) as rn_fun
	from emp
)
select *
from CTE_table;


with CTE_table as
(
	select *, row_number() over(partition by empno, ename, job, mgr, hire, sal, comm, deptno order by empno, ename, job, mgr, hire, sal, comm, deptno) as rn_fun
	from emp
)
delete from CTE_table
where rn_fun>=2;

select * 
from emp;


-- ===============================================
-- 5) write sql query to find employees hire in last month

select *
from emp
where hire>='1981-05-01' and hire<='1981-05-31';


select *
from emp
where hire between '1981-05-01' and '1981-05-31';

select *
from emp
where month(hire)=4;

-- emp hire in 5th month
select *, datediff( month, hire, getdate() )%12 as months
from emp
where datediff(month, hire, getdate())%12=5;

select *, datediff(month, hire, getdate())%12 as months
from emp
order by months;


-- emp hire in 6th month
select *
from emp
where month(hire)=6;

-- =================================================================
-- 6) generate email id of employees

select ename, sal, CONCAT(ename, empno, '@gmail.com')
from emp;

select ename, SUBSTRING(ename, 1, 3)
from emp;

-- ===================================================================
-- 7) print todyas date 

select getdate();

select CONVERT(date, getdate());

select convert(time, getdate());

select month(getdate());

select year(getdate());

select day(getdate()); 

select SYSDATETIME();

select cast(sysdatetime() as date);

select cast(sysdatetime() as time);

-- =================================================================
-- 8) print employees experiance

select ename, hire, datediff(year, hire, getdate()) as experiance
from emp;

select ename, hire, datediff(day, hire, convert(date, getdate()) )/365 as experiance
from emp;

select abs(datediff(year, getdate(), '1996-01-29'));

-- ================================================================
-- 9) write a sql query to retrive commission does not contains null that contains only numeric date
select * 
from emp
where isnumeric(comm)=1;

SELECT *
FROM emp
WHERE comm LIKE '%[0-9]%'

-- ================================================================
-- find department that contains highest no. of employees

select deptno, count(*)
from emp 
group by deptno;

select deptno, count(*) as counts
from emp 
group by deptno
order by counts desc;

select top 1 deptno, count(*) as counts
from emp 
group by deptno
order by counts desc;

-- Error: Column 'dept.dname' is invalid in the select list because it is 
-- not contained in either an aggregate function or the GROUP BY clause.
select distinct e.deptno, d.dname , count(e.deptno) as counts
from emp e
inner join dept d
on e.deptno=d.deptno
group by e.deptno;


select distinct e.deptno, d.dname , count(e.empno) as counts
from emp e
inner join dept d
on e.deptno=d.deptno
group by e.deptno, d.dname
order by counts desc;


select distinct e.deptno, d.dname , count(e.empno) as counts
from emp e
left outer join dept d
on e.deptno=d.deptno
group by e.deptno, d.dname
order by counts desc;


select distinct top 1 e.deptno, d.dname , count(e.deptno) as counts
from emp e
left outer join dept d
on e.deptno=d.deptno
group by e.deptno, d.dname
order by counts desc;

-- ======================================
-- join three columns

select e.ename as employee, e.job,  ee.ename as manager, d.dname, d.loc
from emp e
left outer join emp ee
on e.mgr=ee.empno
left outer join dept d
on e.deptno=d.deptno;

-- ===========================================================
-- blocing in ms sql

-- Transaction 1
BEGIN TRANSACTION
	update emp
	set sal=700
	where ename='sachin';

COMMIT transaction;
select * from emp;
-- -------------------------------------------
-- Transaction 2
BEGIN TRANSACTION
	update emp
	set sal=600
	where ename='sachin';
-- ======================================================================
-- write a sql query to retrive all student names that start with 
-- letter "M" without using like oprator

select *
from emp
where ename like 'M%';

select *
from emp
where patindex('M%', ename)>0;

select *
from emp
where substring(ename, 1, 1)='M';

select *
from emp
where left(ename, 1)='M';

-- find all emploees whose name  start with 'M' ends with 'R' 
-- and in between contains "L" latter in ms sql
SELECT *
FROM emp
WHERE ename LIKE 'M%L%R';

select *
from emp
where patindex('M%L%R', ename)>0;

-- =================================================
-- Many to Many relations
-- 1 student can enroll for many courses
-- 1 course can have many student

drop table if exists students;

create table students
(
	s_id int primary key,
	s_name varchar(40)
);

drop table if exists courses;

create table courses
(
	c_id int primary key,
	c_name varchar(50)
);


drop table if exists students_courses;

create table students_courses
(
	s_id int foreign key references students(s_id),
	c_id int foreign key references courses(c_id),
	constraint pk_sis_cid primary key(s_id, c_id)
);


insert into students values
(11, 'virat'),
(12, 'rohit'),
(13, 'rahul'),
(14, 'shubhamn'),
(15, 'surya');

insert into courses values
(51, 'dac'),
(52, 'dbda'),
(53, 'ditts');

insert into students_courses values
(11, 51);

insert into students_courses values
(12, 52),
(13, 51),
(14, 51),
(15, 53);

select * from courses;

select * from students;

select * from students_courses;

-- ==================================================================
-- write a sql query to find all employee who born 
-- between '1981-12-03' and '1983-1-12' 
-- Note:- between oprator includes both the end points
select *
from emp
where hire between '1981-12-03' and '1983-1-12'
order by hire;

-- emp hire on 17th novmber
select *
from emp
where month(hire)=11 and day(hire)=17;

-- emp bort in between march and september month
select *
from emp
where month(hire) between 4 and 9;

-- emp bort in between 9th march and 22th september month
select *
from emp
where month(hire)=3 and day(hire)>=9 
      OR month(hire) between 4 and 8 
      OR month(hire)=9 and day(hire)<=22;

-- print yesterday date
select getdate()-1, getdate();

select dateadd(day, -1, convert(date, getdate()));

select dateadd(day, -1, cast(getdate() as date));

-- =============================================================

/*

ALTER emp
ADD CONSTRAINT fk_deptno foreign key references dept(deptno) on delete cascade on update cascade;

 ALTER emp
 DROP CONSTRAINT fk_deptno;

 */
-- ===========================================================
-- 1) write a function to get sum of numbers
-- scalar valued v]function

 drop function if exists get_sum;

 create function get_sum(@num1 int, @num2 int)
 RETURNS int
 AS
 BEGIN
	declare @ans int;
	set @ans=@num1+@num2;
	return @ans;
 END;

 -- call to function
select dbo.get_sum(10,20);

print dbo.get_sum(20, 30);
print 'result : '+cast(dbo.get_sum(20,30) as varchar(20));


-- =============================================================

-- CREATING SCALAR VALUED FUNCTION to returns the gross salary of employees based on the following conditions.
	-- 1)HRA 10%
	-- 2)DA 20%
	-- 3)PF 10%

create function get_gross_sal22(@v_empno int)
RETURNS decimal
AS
BEGIN
	declare @HRA decimal;
	declare @DA decimal;
	declare @PF decimal;
	declare @GROSS decimal;
	declare @BASIC decimal;

	select @BASIC=sal 
	from emp
	where empno=@v_empno;

	set @HRA=@BASIC*10/100;
	set @DA=@BASIC*20/100;
	set @PF=@BASIC*10/100;

	set @GROSS=@BASIC+@HRA+@DA+@PF;

	return @GROSS;

END;

-- CALL TO FUNCTION
SELECT dbo.get_gross_sal22(7499);

print dbo.get_gross_sal22(7499);

print 'total gross salary of employee : '+cast(dbo.get_gross_sal22(7499) as varchar(30));

-- =================================================================
-- 2) table valued function

drop function if exists TVF2;

create function TVF2(@v_dname varchar(30))
RETURNS table
AS
return select * from emp where deptno=(select deptno from dept where dname=@v_dname);

-- call to table valued function
select * from dbo.TVF2('accounting');

select * from TVF2('accounting');

-- ================================================================
-- 1) write a procedure without parameters

drop procedure if exists sp_emp2;

create procedure sp_emp2
AS
BEGIN
	select *
	from emp
	where deptno=any(select deptno
						from dept
						where deptno!=20);
END;

-- execute stored procedure
execute sp_emp2;

exec sp_emp2;

-- ============================================================
-- 2) write a procedure with in parameter

drop procedure if exists sp_emp3;

create procedure sp_emp3(@dname varchar(40))
AS
BEGIN
	select *
	from emp
	where deptno=(select deptno
					from dept
					where dname=@dname);
END;

-- execute stored procedure
execute sp_emp3 'accounting';

-- ======================================================
-- 3) write a stored procedure which takes num as input and 
-- returns square and cube of that number

create procedure sp_square_cube(@num int, @sqr int out, @cube int out)
AS
BEGIN
	set @sqr=@num*@num;
	set @cube=@num*@num*@num;
END;

-- declare bind variabe
declare @ans1 int;
declare @ans2 int;

-- execute stored procedure
execute sp_square_cube 6, @ans1 output, @ans2 out;

-- print ans
print @ans1;
print @ans2;

print 'square : '+cast(@ans1 as varchar(30));
print 'cube : '+cast(@ans2 as varchar(30));

-- ===========================================================
-- 4) create a stored procedure to insert records in  table

drop table if exists table22;

create table table22
(
	empno int,
	ename varchar(20),
	sal money
);


drop procedure if exists sp_insert_in_table22;

create procedure sp_insert_in_table22(@empno int, @ename varchar(40), @sal money)
AS
BEGIN
	insert into table22 values
	(@empno,@ename, @sal);
END;

-- execute stored procedure
execute sp_insert_in_table22 11, 'balaji',45000;

execute sp_insert_in_table22 22, 'sachin',30000;

execute sp_insert_in_table22 33, 'sambhaji',25000;

select * from table22;

-- ===============================================================
-- 5) write a store procedure to input empno and returns that employee 
-- provident fund and professional tax on salary by following condition
		-- 1) PF 10%
		-- 2) PT 20%

drop procedure if exists sp_emp4;

create procedure sp_emp4(@empno int, @PF int out, @PT int out)
AS
BEGIN
	declare @BASIC int;

	select @BASIC=sal
	from emp
	where empno=@empno;

	set @PF=@BASIC*10/100;
	set @PT=@BASIC*20/100;
END;

-- declare bind variable
declare @bPF int;
declare @bPT int;

-- ececute procedure
execute sp_emp4 7499, @bPF output, @bPT out;

print 'PF of employee : '+cast(@bPF as varchar(30));
print 'PT of employee : '+cast(@bPT as varchar(30));

print @bPF;
print @bPT;

select @bPF, @bPT;



-- to view the defination of stored prodecure
sp_helptext sp_emp4;

-- to views how many paramets there datatypes
sp_help sp_emp4;


-- ============================================================
-- index

sp_help emp;

drop index if exists index_emp
on emp;

create index index_emp 
on emp(empno);

drop index if exists index_emp2
on emp;

create unique index index_emp2
on emp(ename);

drop index if exists index_emp3
on emp;

create clustered index index_emp3
on emp(empno);


-- to view all indexes on table emp
SP_helpindex emp;


-- ==========================================================

select *
from emp
where ename in ('sachin', 'king', 'miller');

declare @names varchar(220)='sachin,king,miller';

-- Empty set
select *
from emp
where ename=@names;

-- string_split function
select *
from string_split('balaji,sachin,sambhaji', ',');

-- string_split function
select value
from string_split('balaji,sachin,sambhaji', ',');


declare @emp_names varchar(220)='sachin,miller,king';

select *
from emp
where ename in (select value from string_split(@emp_names, ','));


-- select all employee whose name contains 'A' 2times  at any posositon
select * 
from emp
where ename like '%A%A%';

select *
from emp
where patindex('%A%A%', ename)>0;


-- select all employee whose name start with 'S' or 'A' 
-- and ends with 'N'
select *
from emp 
where ename like 'S%N' or ename like 'A%N';

select *
from emp 
where ename like '[AS]%N';

select *
from emp
where patindex('[SA]%N', ename)>0;

-- select all employee whose name contains 2nd latter 'A' 
-- and 2nd last latter 'I'

select *
from emp
where ename like '_A%I_';

select *
from emp
where patindex('_A%I_', ename)>0;


-- first occurance of 'A' in ename column

select ename, charindex('A', ename)
from emp;

-- print email of employee in following format
-- format:- ename_empno_@NIYO.com

select empno, ename, concat(ename, empno, '@NIYO.com') as emap
from emp;

select ename, empno, ename+cast(empno as varchar(40))+'@NIYO@.com'
from emp;

-- print 1st 3 latter of employees name
select ename, substring(ename, 1, 3)
from emp;

select ename, left(ename, 3)
from emp;

-- print  3 latter of employees name starting from 2nd latter
select ename, substring(ename, 2, 3)
from emp;
 
-- replicate fun
select ename, REPLICATE(ename+' ', 3)
from emp;

-- replace 'S' with '*' in ename
select ename, REPLACE(ename, 'S', '*') 
from emp;


-- replace 'S' with '*' and 'L' with '#' in emane
select ename, REPLACE(REPLACE(ename, 'S', '*'), 'L', '#')
from emp;

--  
select ename, stuff(ename, 2, 3, '######')
from emp;


-- dealing with null values
select sal, comm, isnull(comm, 55), COALESCE(comm, 0)
from emp;

-- COALESCE FUNCTION RETUREN FIRST NON NULL VALUE

-- ===========================================================
-- MATHEMATIC FUNCTIONS:

-- ABS
-- SQUARE
-- SQRT
-- POWER
-- RAND

-- FLOOR
-- ROUND
-- CEILING

SELECT ABS(-12), SQUARE(4), SQRT(49), POWER(3, 4), RAND(), RAND(4);

SELECT ROUND(12.0123, 1),ROUND(12.5467, 3), ROUND(12.8965, 2), ROUND(12,93);

SELECT FLOOR(12.0123), FLOOR(12.5467), FLOOR(12.8965);

SELECT CEILING(12.0123),CEILING(12.5467), CEILING(12.8965);


SELECT RAND(8);











-- ======================================================
-- write a sql query to select most repeted deptno
select *
from emp
where deptno=(select top 1 deptno
              from emp
              group by deptno
              order by count(*) desc);

-- write a sql query to select most repeted job
select *
from emp
where job=(select top 1 job
              from emp
              group by job
              order by count(*) desc);


-- write a sql query to select exactly 3 times repeted job
select *
from emp
where job=(select top 1 job
              from emp
              group by job
              having count(*)=3);
-- ===============================================================
-- Rollup and Cube functions

select deptno, sum(sal)
from emp
group by deptno;


-- rollup is used to find grand total on single column
select deptno, sum(sal)
from emp
group by deptno with rollup;


select deptno, job, sum(sal)
from emp
group by deptno, job;


select deptno, job, sum(sal)
from emp
group by deptno, job with rollup;


select deptno, job, sum(sal) as sum_sal, count(*) as total_count
from emp
group by deptno, job with cube;

-- ============================================================
-- row_number() >> use case for duplicating records from table
-- rank()
-- dense_rank()

select deptno, ename, sal,
	   ROW_NUMBER() over(order by sal desc) as row_num_fun,
	   RANK() over(order by sal desc) as rank_fun,
	   DENSE_RANK() over(order by sal desc) as dense_rank_fun
from emp;

-- print rank to employee on sal in its own department 
-- only dense_rank() function is required other no need
select deptno, ename, sal,
	   ROW_NUMBER() over(partition by deptno order by sal desc) as row_num_fun,
	   RANK() over(partition by deptno order by sal desc) as rank_fun,
	   DENSE_RANK() over(partition by deptno order by sal desc) as dense_rank_fun
from emp;


-- finding max(sal) from each depatment
select deptno, ename, sal 
from ( select deptno, ename, sal,
			ROW_NUMBER() over(partition by deptno order by sal desc) as row_num_fun,
			RANK() over(partition by deptno order by sal desc) as rank_fun,
			DENSE_RANK() over(partition by deptno order by sal desc) as dense_rank_fun
		from emp ) as dt -- derived table
where dense_rank_fun=1;

-- finding 2nd max(sal) from each depatment
select deptno, ename, sal 
from ( select deptno, ename, sal,
			ROW_NUMBER() over(partition by deptno order by sal desc) as row_num_fun,
			RANK() over(partition by deptno order by sal desc) as rank_fun,
			DENSE_RANK() over(partition by deptno order by sal desc) as dense_rank_fun
		from emp ) as dt
where dense_rank_fun=1;

-- by CTE
with CTE_table as
(
	select *, dense_rank() over(partition by deptno order by sal desc) as dr
	from emp
) 
select *
from CTE_table
where dr=2;


-- =================================================================

select deptno, max(sal)
from emp
group by deptno;

-- Column "emp.sal" is invalid in the ORDER BY clause because 
-- it is not contained in either an aggregate function or 
-- the GROUP BY clause.
select deptno, max(sal)
from emp
group by deptno
order by sal;

-- correct query
select deptno, max(sal)
from emp
group by deptno
order by max(sal);




-- ===================================================================
-- NO NEED ADDITIONAL WORK

-- Error: Column 'emp.ename' is invalid in the select list because it is not 
-- contained in either an aggregate function or the GROUP BY clause.
select deptno, ename, sal, hire, count(*) as counts, avg(sal) as avgs , max(sal) as maxs
from emp
group by deptno;

-- correct query using joins
select e.ename, e.sal, e.hire, e.deptno, dt.deptno, dt.counts, dt.avgs, dt.sums, dt.maxs
from emp e
inner join (select deptno, count(*) as counts, avg(sal) as avgs , sum(sal) as sums, max(sal) as maxs
            from emp
            group by deptno) as dt
on e.deptno=dt.deptno;
           
-- correct query using over clause
select ename, sal, hire, deptno,
		count(*) over(partition by deptno order by deptno asc ) as counts,
		avg(sal) over(partition by deptno order by deptno asc) as avgs,
		sum(sal) over(partition by deptno order by deptno asc) as sums,
		max(sal) over(partition by deptno order by deptno asc) as maxs,
		DENSE_RANK() over(partition by deptno order by sal desc) as ranks
from emp;

  
-- correct query using over clause
select ename, sal, hire, deptno,
		count(*) over(partition by deptno order by deptno asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as counts,
		avg(sal) over(partition by deptno order by deptno asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as avgs,
		sum(sal) over(partition by deptno order by deptno asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as sums,
		max(sal) over(partition by deptno order by deptno asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as maxs,
		DENSE_RANK() over(partition by deptno order by sal desc) as ranks
from emp;

-- ==========================================================

-- BY DEFAULT RANGE :>> RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  select ename, sal, 
		avg(sal) over(order by sal desc) avgs, 
        sum(sal) over(order by sal desc) as sums
  from emp;

  
-- RANGE BETWEEN UNBOUNDED PRECEDING AND CORRUNT ROW
  select ename, sal, 
		avg(sal) over(order by sal desc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) avgs, 
        sum(sal) over(order by sal desc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as sums
  from emp;


-- ==============================================================

select charindex('A', 'balaji', 3);

select patindex('A', 'balaji');