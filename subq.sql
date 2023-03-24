drop schema if exists topic_subq cascade;
create schema topic_subq;
set search_path = topic_subq;

create table table_1(
  a int NOT NULL,
  b int NOT NULL
);

create table table_2(
  a int NOT NULL,
  b int NOT NULL
);

insert into table_1 values
                        (1, 2), (1, 3);

insert into table_2 values
                        (1, 2), (1, 4), (1, 5), (2, 2);

--about subquery:  https://www.postgresql.org/docs/current/functions-subquery.html

-- 1)exists
--The argument of EXISTS is an arbitrary SELECT statement, or subquery.
-- The subquery is evaluated to determine whether it returns any rows.
-- If it returns at least one row, the result of EXISTS is “true”;
-- if the subquery returns no rows, the result of EXISTS is “false”.

SELECT a, b
FROM table_1
WHERE EXISTS (SELECT 1 FROM table_2 WHERE b = table_1.b);
--works like inner join

--for compare:
select table_1.a, table_1.b
from table_1
inner join table_2 using(b);

--2) in





