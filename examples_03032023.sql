insert into my_first_table values (2, 3);
insert into my_first_table values (3, 4);
insert into my_first_table values (5, 6);


insert into my_first_table values (6, 7);
insert into my_first_table values (7, 8);
insert into my_first_table values (8, 9);

insert into my_first_table values (9, 10);
insert into my_first_table values (10, 11);

/*numeric(точность, масштаб) = numeric(6, 2)*/

create table my_table (
    a numeric(6, 2),
    b numeric(6, 3)
);

INSERT INTO my_table
  VALUES
         (1.1 + 3.56555);



create table airplanes (
  aircraft_code char(3) not null,
  model text not null,
  range int  not null,
  check (range > 0),
  primary key (aircraft_code)
);

INSERT INTO airplanes ( aircraft_code, model, range )
  VALUES ( 'SU9', 'Sukhoi SuperJet-100', 3000 );


select * from airplanes;

INSERT INTO airplanes( aircraft_code, model, range ) VALUES
( '773', 'Boeing 777-300', 11100 ),
( '763', 'Boeing 767-300', 7900 ),
( '733', 'Boeing 737-300', 4200 ),
( '320', 'Airbus A320-200', 5700 ),
( '321', 'Airbus A321-200', 5600 ),
( '319', 'Airbus A319-100', 6700 ),
( 'CN1', 'Cessna 208 Caravan', 1200 ),
( 'CR2', 'Bombardier CRJ-200', 2700 );


select model, aircraft_code, range from airplanes
    order by model;



select model, aircraft_code, range
    from airplanes
    where range >= 4000 AND range <= 6000;


update airplanes
    set range = 3500
    where aircraft_code = 'SU9';


delete from airplanes
       where aircraft_code = 'CN1';

/* DELETE FROM aircrafts; удалить все строки из отношения */


create table seats (
  aircraft_code char(3) not null,
  seat_no varchar(4) not null,
  fare_conditions varchar(10) not null,

  PRIMARY KEY ( aircraft_code, seat_no ),
  FOREIGN KEY ( aircraft_code )
    REFERENCES airplanes (aircraft_code )
    ON DELETE CASCADE
);


select * from seats;


INSERT INTO seats VALUES
   ( 'SU9', '1A', 'Business' ),
   ( 'SU9', '1B', 'Business' ),
   ( 'SU9', '10A', 'Economy' ),
   ( 'SU9', '10B', 'Economy' ),
   ( 'SU9', '10F', 'Economy' ),
   ( '319', '10F', 'Economy' ),
   ( 'CR2', '10F', 'Economy' ),
   ( 'SU9', '20F', 'Economy' );


SELECT count( * ) FROM seats WHERE aircraft_code = 'SU9';

SELECT count( * ) FROM seats WHERE aircraft_code = 'CN1';



SELECT  aircraft_code FROM seats
  GROUP BY aircraft_code;


SELECT aircraft_code, count( * ) FROM seats
  GROUP BY aircraft_code
  ORDER BY count; /*DESC*/


SELECT aircraft_code, fare_conditions, count( * )
  FROM seats
  GROUP BY aircraft_code, fare_conditions
  ORDER BY aircraft_code, fare_conditions;



CREATE TABLE pilots (
  pilot_name text,
  schedule integer[]
);

/*массив представлен в виде строкового литерала с указанием типа данных и квадратных скобок*/
INSERT INTO pilots
  VALUES ( 'Ivan',  '{ 1, 5, 5, 5, 7 }'::integer[] ),
         ( 'Petr',  '{ 1, 2, 5, 7 }'   ::integer[] ),
         ( 'Pavel', '{ 2, 5}'          ::integer[] ),
         ('Nikola', ARRAY[1,1,1,1,1]),
         ( 'Boris', '{ 3, 5, 6 }'      ::integer[] );

INSERT INTO pilots
  VALUES  ('Nikola', ARRAY[1,1,1,1,1]);

UPDATE pilots
  SET schedule = schedule || 7
  WHERE pilot_name = 'Boris';

/*предположим, что все они должны летать по 4 дня в неделю теперь */
UPDATE pilots
  SET schedule = array_append( schedule, 6 )
  WHERE pilot_name = 'Pavel';

UPDATE pilots
  SET schedule = array_prepend( 1, schedule )
  WHERE pilot_name = 'Pavel';


/*второй параметр array_remove -- это значение параметра, а не индекс*/
UPDATE pilots
  SET schedule = array_remove( schedule, 5 )
  WHERE pilot_name = 'Ivan';


UPDATE pilots
  SET schedule[ 8 ] = 2, schedule[ 9 ] = 3
  WHERE pilot_name = 'Petr';


UPDATE pilots
  SET schedule[ 1:2 ] = ARRAY[ 2, 2 ]
  WHERE pilot_name = 'Petr';


SELECT * FROM pilots
  WHERE schedule && ARRAY[ 2, 5 ];


SELECT * FROM pilots
  WHERE NOT  (schedule && ARRAY[ 2, 5 ]) ;



/*array_partition*/
SELECT * FROM pilots
  WHERE schedule @> '{ 1, 7 }'::integer[];



CREATE TABLE airports (
  airport_code char( 3 ) NOT NULL, -- Код аэропорта
  airport_name text NOT NULL, -- Название аэропорта
  city text NOT NULL, -- Город
  longitude float NOT NULL, -- Координаты аэропорта: долгота
  latitude float NOT NULL, -- Координаты аэропорта: долгота
  timezone text NOT NULL, -- Часовой пояс аэропорта
  PRIMARY KEY ( airport_code )
);



/*запросы продолжение */

SELECT * FROM airplanes WHERE model LIKE 'Airbus%';

SELECT * FROM airplanes
  WHERE model NOT LIKE 'Airbus%'
    OR model NOT LIKE 'Boeing%';


SELECT * FROM airplanes WHERE range BETWEEN 3000 AND 6000;


SELECT model, range, range / 1.609 AS miles FROM airplanes;


SELECT model, range, round( range / 1.609, 2 ) AS miles
  FROM airplanes
  limit 3
  offset 3;


SELECT model, range,
  CASE WHEN range < 2000 THEN 'Ближнемагистральный'
       WHEN range < 5000 THEN 'Среднемагистральный'
       ELSE 'Дальнемагистральный'
  END AS type
  FROM airplanes
  ORDER BY model DESC;


SELECT model, range,
  CASE WHEN range < 2000 THEN 'Ближнемагистральный'
       WHEN range < 5000 THEN 'Среднемагистральный'
       ELSE 'Дальнемагистральный'
  END AS type
  FROM airplanes
  ORDER BY model;
