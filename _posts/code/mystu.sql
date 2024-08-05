##如果已经存在mystu数据库，则先删除；
DROP DATABASE IF EXISTS mystu;

##创建数据库的命令：
create database mystu;

##选中新创建的mystu数据库；
use mystu;

##数据库中创建数据表；
create table scorename(name char(20) not null, score int not null);

##往数据表中插入学生成绩；
insert into scorename(name, score) values('zhang3', 78),('li4', 80), ('wang5', 82);

##查询数据表中的内容；
select * from scorename;

##创建新用户;
create user "temp1" identified by "12345";

##root用户将数据库授权给temp1用户;
grant all privileges on mystu.* to temp1 identified by "12345"