create database tops_project;
use tops_project;

create table dept (
    deptno int(2) primary key,
    dname varchar(14),
    loc varchar(13)
);

create table emp (
    empno int(4) primary key,
    ename varchar(10),
    job varchar(9),
    mgr int(4),
    hiredate date,
    sal decimal(7,2),
    comm decimal(7,2),
    deptno int(2),
    foreign key (deptno) references dept(deptno)
);

create table student (
    rno int(2) primary key,
    sname varchar(14),
    city varchar(20),
    state varchar(20)
);

create table emp_log (
    emp_id int(5),
    log_date date,
    new_salary int(10),
    action varchar(20)
);


insert into dept values (10, 'accounting', 'new york');
insert into dept values (20, 'research', 'dallas');
insert into dept values (30, 'sales', 'chicago');
insert into dept values (40, 'operations', 'boston');

insert into emp values (7369,'smith','clerk',7902,'1980-12-17',800.00,null,20);
insert into emp values (7499,'allen','salesman',7698,'1981-02-20',1600.00,300.00,30);
insert into emp values (7521,'ward','salesman',7698,'1981-02-22',1250.00,500.00,30);
insert into emp values (7566,'jones','manager',7839,'1981-04-02',2975.00,null,20);
insert into emp values (7654,'martin','salesman',7698,'1981-09-28',1250.00,1400.00,30);
insert into emp values (7698,'blake','manager',7839,'1981-05-01',2850.00,null,30);
insert into emp values (7782,'clark','manager',7839,'1981-06-09',2450.00,null,10);
insert into emp values (7788,'scott','analyst',7566,'1987-06-11',3000.00,null,20);
insert into emp values (7839,'king','president',null,'1981-11-17',5000.00,null,10);
insert into emp values (7844,'turner','salesman',7698,'1981-08-09',1500.00,0.00,30);
insert into emp values (7876,'adams','clerk',7788,'1987-07-13',1100.00,null,20);
insert into emp values (7900,'james','clerk',7698,'1981-03-12',950.00,null,30);
insert into emp values (7902,'ford','analyst',7566,'1981-03-12',3000.00,null,20);
insert into emp values (7934,'miller','clerk',7782,'1982-01-23',1300.00,null,10);


select distinct job from emp;

select * from emp 
order by deptno asc, job desc;

select distinct job from emp 
order by job desc;

select * from emp 
where hiredate < '1981-01-01';

select empno, ename, sal, (sal/30) as daily_sal from emp 
order by (sal*12) asc;

select empno, ename, sal, timestampdiff(year, hiredate, curdate()) as exp from emp 
where mgr = 7369;

select * from emp where comm > sal;

select * from emp 
where job in ('clerk', 'analyst') 
order by job desc;

select * from emp 
where (sal * 12) between 22000 and 45000;

select ename from emp 
where ename like 's____';

select * from emp 
where empno not like '78%';

select * from emp 
where job = 'clerk' and deptno = 20;

select e.* from emp e join emp m on e.mgr = m.empno 
where e.hiredate < m.hiredate;

select * from emp 
where deptno = 20 and 
job in (select job from emp where deptno = 10);

select * from emp 
where sal in (select sal from emp 
where ename in ('ford', 'smith')) 
order by sal desc;

select * from emp 
where job in (select job from emp where ename in ('smith', 'allen'));

select distinct job from emp 
where deptno = 10 and 
job not in (select job from emp where deptno = 20);

select max(sal) from emp;

select * from emp 
where sal = (select max(sal) from emp);

select sum(sal) from emp 
where job = 'manager';

select * from emp 
where ename like '%a%';

select job, min(sal) from 
emp group by job 
order by min(sal) asc;

select * from emp 
where sal > (select sal from emp where ename = 'blake');

create view v1 as select e.ename, e.job, d.dname, d.loc from emp e join dept d on e.deptno = d.deptno;

delimiter //
create procedure get_emp_dept(in dno int)
begin
    select e.ename, d.dname from emp e join dept d on e.deptno = d.deptno where e.deptno = dno;
end //
delimiter ;

alter table student add pin bigint;
alter table student modify sname varchar(40);

delimiter //
create trigger sal_log_trg
after update on emp
for each row
begin
    if old.sal <> new.sal then
        insert into emp_log (emp_id, log_date, new_salary, action)
        values (new.empno, curdate(), new.sal, 'new salary');
    end if;
end //
delimiter ;