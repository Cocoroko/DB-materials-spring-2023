create schema it;

CREATE TABLE it.Laptop (
 code int NOT NULL ,
 model varchar (50) NOT NULL ,
 speed smallint NOT NULL ,
 ram smallint NOT NULL ,
 hd real NOT NULL ,
 price decimal(12,2) NULL ,
 screen smallint NOT NULL
);

CREATE TABLE it.PC (
 code int NOT NULL ,
 model varchar (50) NOT NULL ,
 speed smallint NOT NULL ,
 ram smallint NOT NULL ,
 hd real NOT NULL ,
 cd varchar (10) NOT NULL ,
 price decimal(12,2) NULL
);

----PC------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into it.PC values(1,'1232',500,64,5,'12x','600');
insert into it.PC values(2,'1121',750,128,14,'40x','850');
insert into it.PC values(3,'1233',500,64,5,'12x','600');
insert into it.PC values(4,'1121',600,128,14,'40x','850');
insert into it.PC values(5,'1121',600,128,8,'40x','850');
insert into it.PC values(6,'1233',750,128,20,'50x','950');
insert into it.PC values(7,'1232',500,32,10,'12x','400');
insert into it.PC values(8,'1232',450,64,8,'24x','350');
insert into it.PC values(9,'1232',450,32,10,'24x','350');
insert into it.PC values(10,'1260',500,32,10,'12x','350');
insert into it.PC values(11,'1233',900,128,40,'40x','980');
insert into it.PC values(12,'1233',800,128,20,'50x','970');


----Laptop------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into it.Laptop values(1,'1298',350,32,4,'700',11);
insert into it.Laptop values(2,'1321',500,64,8,'970',12);
insert into it.Laptop values(3,'1750',750,128,12,'1200',14);
insert into it.Laptop values(4,'1298',600,64,10,'1050',15);
insert into it.Laptop values(5,'1752',750,128,10,'1150',14);
insert into it.Laptop values(6,'1298',450,64,10,'950',12);

-- { [cross] | [inner] | left/right/full + [outer] } join

select * from it.Laptop cross join it.PC;
--select * it.Laptop, it.PC;


select * from it.Laptop inner join it.PC
on it.Laptop.hd = it.PC.hd;
--соединение по условию

select * from it.Laptop inner join it.PC
using(hd, ram);
--соединение по условию

select * from it.Laptop full join it.PC
on it.Laptop.hd = it.PC.hd;
--соединение по условию

select * from it.Laptop left outer join it.PC
on it.Laptop.hd = it.PC.hd;
--соединение по условию, но точно попадают все элементы левой таблицы

select * from it.Laptop left  join it.PC
on it.Laptop.hd = it.PC.hd
where it.PC.hd is null;
--соединение по условию, но точно попадают все элементы левой таблицы

select * from it.Laptop left outer join it.PC
on it.Laptop.hd = it.PC.hd;

insert into it.PC values(6,'1298',450,64,10,'950',12);

-- select * from it.Laptop natural join it.PC;

select * from it.Laptop full outer join it.PC
on it.Laptop.hd = it.PC.hd;


select * from it.Laptop full outer join it.PC
on it.Laptop.hd = it.PC.hd
where it.PC.hd is null or it.Laptop.hd is null;
