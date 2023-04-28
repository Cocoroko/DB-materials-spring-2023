CREATE SCHEMA indexes;
SET search_path = indexes;


drop table if exists indexes.airplanes;


create table airplanes (
  aircraft_code char(3) not null,
  model text,
  range int,
  check (range > 0),
  primary key (aircraft_code)
);

INSERT INTO airplanes ( aircraft_code, model, range )VALUES
( 'SU9', 'Sukhoi SuperJet-100', 3000 ),
( '773', 'Boeing 777-300', 11100 ),
( '763', 'Boeing 767-300', 7900 ),
( '733', 'Boeing 737-300', 4200 ),
( '320', 'Airbus A320-200', 5700 ),
( '321', 'Airbus A321-200', 5600 ),
( '319', 'Airbus A319-100', 6700 ),
( 'CN1', 'Cessna 208 Caravan', 1200 ),
( 'CR2', 'Bombardier CRJ-200', 1200 );


select * from airplanes;


explain (analyse, timing)
select count(*) from airplanes
where aircraft_code = 'SU9';
--22,76


create index my_index on airplanes (range, aircraft_code);

--когда индекс создан, его поддержанием занимается база данных
--понятное дело, что индексы требуют допилнительных затрат ресурсов системы


explain (analyse, timing)
select count(*) from airplanes
where aircraft_code = 'SU9';

--здесь виден заметный прогресс по времени выполнения

drop index my_index;

explain
select count(*) from airplanes
where aircraft_code = '319';

create index my_index on airplanes (range) ;


explain
select count(*) from airplanes
where aircraft_code = '319';

-- в этой ситуации индекс никак не помог, потому что он создан на другой столбец
drop index my_index;


--как они помогают при сортировке и всем, что ее затрагиевает?
--надо учитывать селективность. (это о том, насколько много строк будет использоваться в запросе)
--чем выше эта доля, тем ниже  селективность, то может произойти так, что наличие индекса может не дать ожидаемого эффекта
--это значит, что индексы полезнее в том случае, когда мы выбираем из таблицы достаточно мало строк

--проверим это всё на практике)))

create index my_index on airplanes (aircraft_code ASC);

explain (analyze, timing)
select * from airplanes
order by aircraft_code ASC limit 3;

drop index my_index;

explain (analyze, timing)
select * from airplanes
order by aircraft_code ASC limit 3;


--options in create index


create unique index my_index_desc on airplanes(aircraft_code DESC nulls first, model ASC nulls last)
-- разные столбцы могут иметь разный порядок сортировки + разнвые дополнительные опции, более детально тут:
-- https://www.postgresql.org/docs/current/indexes.html


insert into airplanes(aircraft_code, model, range)  values
(20, 'kek', null),
(21, 'kek', null);


select * from airplanes;


create index uniq_ind on airplanes (model);


insert into airplanes(aircraft_code, model, range)  values
(222, 'kek', 2455);



insert into airplanes(aircraft_code, model, range)  values
(224, 'kek', 2455);


select * from airplanes;


drop index uniq_ind;


delete  from airplanes
where aircraft_code = '20';


insert into airplanes(aircraft_code, model, range)  values
(20, 'kek', null);



select * from airplanes;



-- 6    -->  {a[1], b[]
-- 2    -->  a[2], b[]
-- 4    -->  a[0]
-- 8    -->  a[3]


--что такое индекс? подробнее об этой структуре данных как о B-дереве.
-- кластерихованные индексы: хранит реальные строки данных у себя в листьях индекса, может быть только один(строки физически
-- лежат там же, просто они теперь отсортированы и где-то лежит сисетманая информация о том, что они отсортированы потому что
-- есть индекс и далее эту историю надо тоже поддреживать, поэтому при дальнейшиех вставках тоже будет автоматическа автосортировка.)


--некластеризованные индексы: их может быть несколько на одну табличку,


--кроме этого индексы бывают: составные, уникальные, покрывающие.
--составные -- до 16 столбцов внутри, их длина ограничена 900 байтами.
--уникальный -- обеспечивает уникальность каждого значения внутри столбца
--покрывающий -- позволяет получить записи с листьев индекса без обращений к записям самой таблицы.

--первичный ключ лучше использовать как кластеризованный индекс
--(а для некластеризованных??)

--до создания индексов таблица хранится
--для составного индекса надо учитывать порядок столбцов в индексе и в запросе к бд, который обращается к этим столбцам
--в той же последовательности


-- можно указать индекс на вычисляемых столбцах. но эти столбцы должны удовлетворять некоторым требованиям.

-- как оптимизация вставки данных в таблицы, на которые создан индекс есть вставка элементов за один запрос, а не за несколько.

--можно ли создавать кластеризованный индекс на столбце, в котором есть дубликаты (и да, и нет. лушче делать unique clustered index)


--топ вопросов про индексы https://habr.com/ru/articles/247373/#01



create unique index uniq_airports_scalar on airplanes (lower(aircraft_code));


create index test on airplanes (range)
where range > 7000;
