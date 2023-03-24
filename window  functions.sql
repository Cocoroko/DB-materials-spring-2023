DROP SCHEMA IF EXISTS topic_6 CASCADE;
CREATE SCHEMA topic_6;
SET search_path = topic_6;

DROP TABLE IF EXISTS topic_6.participant;
CREATE TABLE topic_6.participant
(
    participant_id         INT PRIMARY KEY,
    participant_nm         VARCHAR(200),
    participant_birth_dt   DATE,
    participant_country_nm VARCHAR(200)
);

insert into topic_6.participant values (1, 'Diego Gallaher', '2008-08-10', 'China');
insert into topic_6.participant values (2, 'Ofella Palmby', '1979-05-05', 'Philippines');
insert into topic_6.participant values (3, 'Micheline Curmi', '1965-10-29', 'Syria');
insert into topic_6.participant values (4, 'Dynah Andisie', '1970-02-12', 'Russia');
insert into topic_6.participant values (5, 'Dal Lots', '1957-03-19', 'Portugal');
insert into topic_6.participant values (6, 'Ethelda Camacke', '1957-08-29', 'Indonesia');
insert into topic_6.participant values (7, 'Cyril Ehrat', '1974-09-27', 'France');
insert into topic_6.participant values (8, 'Roger Stelfax', '1980-02-11', 'Portugal');
insert into topic_6.participant values (9, 'Jabez McMaster', '1988-08-18', 'Ireland');
insert into topic_6.participant values (10, 'Adrianna Tremberth', '1978-02-11', 'Russia');
insert into topic_6.participant values (11, 'Judie Rammell', '1964-12-20', 'Indonesia');
insert into topic_6.participant values (12, 'Brooke Gaw', '1995-07-16', 'Czech Republic');
insert into topic_6.participant values (13, 'Allsun Scimone', '1994-07-27', 'Philippines');
insert into topic_6.participant values (14, 'Pamela Laye', '1986-05-29', 'Philippines');
insert into topic_6.participant values (15, 'Ranee Trott', '1974-08-18', 'Argentina');
insert into topic_6.participant values (16, 'Lisle Abramski', '1993-03-28', 'Iraq');
insert into topic_6.participant values (17, 'Cheryl Bick', '1993-05-11', 'Indonesia');
insert into topic_6.participant values (18, 'Noby Spriggs', '1985-09-17', 'Macedonia');
insert into topic_6.participant values (19, 'Schuyler Weston', '1966-09-04', 'Tanzania');
insert into topic_6.participant values (20, 'Horton Ongin', '1961-08-11', 'China');
insert into topic_6.participant values (21, 'Carolyn Goodliff', '2002-01-17', 'Pakistan');
insert into topic_6.participant values (22, 'Geri Barnfather', '1985-02-24', 'Serbia');
insert into topic_6.participant values (23, 'Gearard Mote', '1990-06-01', 'Chile');
insert into topic_6.participant values (24, 'Sheffield Murrigans', '1970-03-26', 'Sweden');
insert into topic_6.participant values (25, 'Saunder Olivo', '1961-12-31', 'El Salvador');
insert into topic_6.participant values (26, 'Willamina Lequeux', '1993-12-10', 'Canada');
insert into topic_6.participant values (27, 'Eduard Fessier', '1957-04-22', 'Portugal');
insert into topic_6.participant values (28, 'Clywd Follacaro', '1995-12-18', 'Japan');
insert into topic_6.participant values (29, 'Arnuad Tran', '1999-11-27', 'France');
insert into topic_6.participant values (30, 'Bartlett Freiberg', '1987-06-26', 'Poland');


--Window func

--where we can use them?  (in select / order by)

--The syntax of a window function call is one of the following:
--function_name ([expression [, expression ... ]]) [ FILTER ( WHERE filter_clause ) ] OVER window_name
--function_name ([expression [, expression ... ]]) [ FILTER ( WHERE filter_clause ) ] OVER ( window_definition )
--function_name ( * ) [ FILTER ( WHERE filter_clause ) ] OVER window_name
--function_name ( * ) [ FILTER ( WHERE filter_clause ) ] OVER ( window_definition )
--https://www.postgresql.org/docs/current/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS

--here, u can find which functions we can use
--as window https://www.postgresql.org/docs/current/functions-window.html#FUNCTIONS-WINDOW-TABLE


--classes of window functions:
-- aggregate (агрегирующие)
-- ranking (ранжирующие)
-- value (функции смещения)


--window functions (aggregate type)

--using the group by reduces the granularity of the table
select participant_country_nm, count(participant_id) from participant
group by participant_country_nm;


--in prev we cannot include participant_nm because it wasn't in the group by
select participant_nm, participant_country_nm,
       count(participant_id) over (partition by participant_country_nm) as count_people_over_country
from participant;


--the role of window will play all table
select participant_nm, participant_country_nm,
       count(participant_id) over () as count_people_over_country
from participant;


--introduction in window frames
select participant_nm, participant_country_nm,
       sum(participant_id)
from participant
group by participant_country_nm, participant_nm
order by participant_country_nm;


select participant_nm, participant_country_nm,
       sum(participant_id) over (partition by participant_country_nm, participant_nm)
from participant;
--the second option is better: We can add to select more columns that were not partition by.


--example with duplicates in window frames
select participant_nm, participant_country_nm,
       sum(participant_id) over (partition by participant_country_nm) as count_people_over_country
from participant
order by participant_country_nm;


-- but if we want to do something with the information, and it is important in what order we process it
select participant_country_nm, participant_id,
       sum(participant_id) over (order by participant_country_nm ASC) as count_people_over_country
from participant;
--here, we can order by (participant_country_nm, participant_id) to avoid duplicates while sum counting.

-- frames with row/range/groups
-- { RANGE | ROWS | GROUPS } frame_start [ frame_exclusion ]
-- { RANGE | ROWS | GROUPS } BETWEEN frame_start AND frame_end [ frame_exclusion ]
-- details: https://www.postgresql.org/docs/current/sql-expressions.html

select participant_country_nm, participant_id,
       sum(participant_id) over
           (order by participant_country_nm rows between unbounded preceding and current row)
           as count_people_over_country
from participant;

select participant_country_nm, participant_id,
       sum(participant_id) over
           (order by participant_country_nm rows current row )
           as count_people_over_country
from participant;

select participant_country_nm, participant_id,
       sum(participant_id) over
           (partition by participant_country_nm order by participant_country_nm rows between unbounded preceding and current row )
           as count_people_over_country
from participant;

select participant_country_nm, participant_id,
       sum(participant_id) over
           (order by participant_country_nm range current row )
           as count_people_over_country
from participant;

select participant_country_nm, participant_id,
       sum(participant_id) over
           (order by participant_country_nm range between current row  and unbounded following )
           as count_people_over_country
from participant;



select participant_country_nm, participant_id, participant_birth_dt,
       sum(participant_id) over
           (partition by participant_country_nm order by participant_birth_dt range between current row  and '100 days' following)
           as count_people_over_country
from participant;



select participant_country_nm, participant_id,
       sum(participant_id) over
           (partition by participant_country_nm range between current row and unbounded following)
           as people_over_country
from participant;


select participant_country_nm, participant_id,
       sum(participant_id) over
           (partition by participant_country_nm order by participant_id groups between current row and 1 following)
           as people_over_country
from participant;




--window functions (ranking type)
select participant_id, participant_country_nm,
       dense_rank() over (order by participant_country_nm) as country_id
from participant;
--count without duplicates (ignore them in each "group" in ordering)

select participant_id, participant_country_nm,
       rank() over (order by participant_country_nm) as country_id
from participant;
--count with duplicates

select participant_id, participant_country_nm,
       row_number() over (order by participant_country_nm) as country_id
from participant;
--primitive counting of line numbers, does not know any information about duplicates

select participant_id, participant_country_nm,
       dense_rank() over () as country_id
from participant;
-- we should use order by with ranging functions

select participant_id, participant_country_nm,
       row_number() over (partition by participant_country_nm order by participant_country_nm) as country_id
from participant;
--use partitions


--window functions (value type)
select participant_country_nm, participant_id,
       lag(participant_id) over (order by participant_id) as prev_id
from participant
order by participant_id;
--prev value

select participant_country_nm, participant_id,
       lag(participant_id, 2, 0) over (order by participant_id) as prev_id
from participant
order by participant_id;
--prev value with users offset

select participant_country_nm, participant_id,
       lead(participant_id, 2, 0) over (order by participant_id) as prev_id
from participant
order by participant_id;
--next value with users offset

select participant_country_nm, participant_id,
       first_value(participant_id) over (partition by participant_country_nm) as prev_id
from participant;


select participant_country_nm, participant_id,
       first_value(participant_id) over (partition by participant_country_nm order by participant_id) as first_id
from participant;
--we need sort to avoid UB
