drop table emp cascade constraints;
drop table dept cascade constraints;
drop table stud cascade constraints;
drop table course cascade constraints;
drop table teaches cascade constraints;
drop table result cascade constraints;


create table emp
(
ename varchar(10),
eid number constraint pke primary key,
sex char,
sal number(8,2),
dob date,
addr varchar(50),
supeid number,
deptno number
);



create table dept
(
dname varchar(10),
dnum number constraint pkd primary key,
hodeid number constraint fkd references emp(eid),
hodstdate date
);
alter table emp add constraint fke foreign key(deptno) references dept(dnum);
alter table emp add constraint fke_eid foreign key(supeid) references emp(eid);


insert all
into dept values('CSE',10,'','12-dec-1997')
into dept values('Mech',20,'','24-apr-2017')
into dept values('Civil',30,'','31-dec-2006')
select * from dual;


insert all
into emp values('Manjunath',1,'m',15987,'08-may-1982','#98 vidyanagar hubballi','',10)
into emp values('Manjunath',2,'m',54765,'16-jul-1980','#100 rajnagar Bangalore',1,10)
into emp values('Aruna',3,'f',43000,'08-may-1975','#34 vidyanagar Bangalore',2,10)
into emp values('Mahesh',4,'m',27000,'08-may-1982','#97 vidyanagar hubballi','',20)
into emp values('Sangeeta',5,'f',27000,'10-jan-1972','#97 Gandhinagar Dharwad',4,20)
into emp values('Sameer',6,'m',55000,'10-jan-1972','#45 Gandhinagar Bangalore',1,30)
select * from dual;


update dept
set hodeid=1 where dnum=10;

update dept
set hodeid=4 where dnum=20;

update dept
set hodeid=6 where dnum=30;


create table stud
(
sname varchar(15),
usn number constraint pks primary key,
sem number check(sem>=1 and sem<=10),
dob date,
address varchar(50),
dno number constraint fks references dept(dnum)
);

insert all
into stud values('Ajay',100,7,'01-aug-1990','#234 vidyagiri Dharwad',10)
into stud values('Ram',200,5,'01-aug-1990','#234 vidyagiri Bagalkot',10)
into stud values('Sonal',300,3,'11-sep-1992','#56 rajeevnagar hubballi',10)
into stud values('Sapna',400,7,'01-jan-1990','#234 vidyagiri Dharwad',20)
into stud values('Ajay',500,1,'15-feb-1995','#3 rajeevnagar hubballi',20)
into stud values('Sita',600,5,'11-jan-1990','#32 gandhinagar bangalore',20)
into stud values('Sangeeta',700,1,'01-aug-1990','#234 gurunagar Dharwad',20)
into stud values('Manju',800,7,'01-mar-1988','#200 rajeevnagar Dharwad',30)
into stud values('Soujanya',900,7,'01-mar-1990','#213 vidyanagar Dharwad',30)
select * from dual;
create table course
(
cname varchar(15),
ccode char(5) constraint pkc primary key,
credit number(3,1),
deptno number constraint fkc references dept(dnum)
);


insert all
into course values('DBMS','cs100',4,10)
into course values('OS','cs200',3,10)
into course values('DS','cs300',1.5,10)
into course values('Cprogram','cs400',3,10)
into course values('Machine','me100',4,20)
into course values('CAD','me200',1.5,20)
into course values('CAM','me300',3,20)
into course values('Structure','cv100',3,30)
into course values('Design','cv200',1.5,30)
select * from dual;


create table teaches
(
empid number constraint fkt1 references emp(eid),
code char(5) constraint fkt2 references course(ccode),
constraint pkt primary key(empid,code)
);

insert all
into teaches values(1,'cs100')
into teaches values(1,'cs200')
into teaches values(2,'cs100')
into teaches values(2,'cs200')
into teaches values(2,'cs300')
into teaches values(4,'me100')
into teaches values(4,'me200')
into teaches values(6,'cv100')
into teaches values(6,'cv200')
select * from dual;


create table result
(
susn number constraint fkr1 references stud(usn),
code char(5) constraint fkr2 references course(ccode),
grade char,
constraint pkr primary key(susn,code)
);

insert all
into result values(100,'cs100','f')
into result values(100,'cs200','s')
into result values(200,'cs300','s')
into result values(200,'cv100','a')
into result values(200,'cs100','a')
into result values(300,'cs100','f')
into result values(500,'me100','b')
into result values(500,'me200','w')
into result values(600,'me100','s')
into result values(600,'cs300','c')
into result values(800,'cv100','e')
into result values(800,'cv200','c')
into result values(900,'cs100','i')
into result values(900,'cv200','s')
into result values(900,'cs200','a')
into result values(900,'me100','a')
select * from dual;


commit;
select *from emp;
select *from dept;
select *from stud;
select *from course;
select *from teaches;
select *from result;
Select Dnum,Dname,Count(*)
From Dept,Emp
Where Dnum=Deptno 
Group By Dnum,Dname
Having Count(*)>1;

Select Sname,Usn,Dob,Count(Code) As Number_Of_Courses_With_S_Grade
From Result,Stud,Course
Where grade='s' and code=ccode and susn=usn
Group By Sname,Usn,Dob
having dob like '______90';


Select Cname,dnum,Dname,Count(Empid)
From Course,Dept,Teaches
Where Deptno=Dnum And Ccode=Code
group by Cname,dnum,Dname;


--Retrieve details  all emp who has salary more than avg salary
select * 
from emp 
where sal>(select avg(sal) from emp);

--Retrieve details  all emp who has salary more than avg salary of cse depatrment
select *
from emp
where sal>(select avg(sal) from emp,dept where dnum=deptno and dname='CSE');

--Retrieve details  all emp who has working for either cse or mechanical
select * from emp
where deptno in( select dnum from dept where dname='CSE' or dname='Mech');

select * from emp
where deptno not in( 40,20);

select * from emp
where deptno=10 and exists(select * from dept where dnum=40) ;

--Retrieve details of supervisor
select * from emp
where eid in ( select supeid from emp );

--Retrieve details of Head of deparment
select * from emp
where eid in ( select hodeid from dept );

select * from emp
where eid not in ( select hodeid from dept );

--Retrieve details  all emp who not teaching any course
select * from emp
where eid not in ( select empid from teaches );

--Retrieve name of emp who teaches atleast on course offered by mech  
select ename from emp
where eid in ( select empid from teaches where code in(select ccode from course where deptno= (select dnum from dept where dname='Mech') ) );

select * from emp
where eid in ( select empid
              from teaches 
              where code in(
                            select ccode from course , dept where deptno =dnum and  dname='Mech') ) ;
                            
--For each emp Retrieve id ,name of emp and total emp
select ename , eid ,deptno,(select count(*)from emp)"Total"
from emp;

select * from (select * from dept),emp
where deptno=dnum;

----For each emp Retrieve id ,name of emp and total emp who is same depart as emp dept
select ename , eid ,deptno,(select count(*)from emp e2 where e1.deptno=e2.deptno)"Total"
from emp e1
order by e1.eid desc;

--Retrieve details  all emp who has salary more than avg salary of his own department
select *
from emp e1
where sal>(select avg(e2.sal) 
          from emp e2 
          where e1.deptno=e2.deptno );

----Retrieve details  all student who has not got any s grade
select * 
from stud 
where usn not in (select susn from result where grade='s') ;

select * 
from stud 
where   exists (select * from result where usn=susn and grade='s') 
order by usn;