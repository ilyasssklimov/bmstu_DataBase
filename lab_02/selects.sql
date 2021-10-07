-- 1) Имя, фамилия, рейтинг шахматистов, у которых рейтинг больше 2400 пунктов 
-- (сравнение)
select name, surname, elo_rating
from lab_01.chess_players
where elo_rating > 2400
order by elo_rating; 

-- 2) Турниры, на которых рейтинг хотя бы одного участника меджу 2300 и 2500 пунктами 
-- (between)
select distinct tournaments.name, tournaments.year, players.elo_rating as rating
from lab_01.tournaments as tournaments 
join (lab_01.participants as participants join lab_01.chess_players as players on players.id = participants.id_p)
on tournaments.id = participants.id_t 
where players.elo_rating between 2300 and 2500;

-- 3) Партии, в которых играли спортсмены званием выше 1го разряда 
-- (like)
select players_1.surname ||' '||players_1.name as player_1, players_2.surname ||' '||players_2. name as player_2, games.year as year
from lab_01.games as games
join lab_01.chess_players as players_1 on games.id_1 = players_1.id 
join lab_01.chess_players as players_2 on games.id_2 = players_2.id
where players_1.title like '_M' and players_2.title like '_M'

-- 4) Шахматисты, занимавшие призовые места в турнирах, проходивших в городе Charlesfort
-- (in с вложенным подзапросом)
select players.id as player_id, players.name||' '||players.surname as player
from lab_01.chess_players as players
where players.id in (select tournaments.place_1 from lab_01.tournaments as tournaments where location = 'Charlesfort')
or players.id in (select tournaments.place_2 from lab_01.tournaments as tournaments where location = 'Charlesfort')
or players.id in (select tournaments.place_3 from lab_01.tournaments as tournaments where location = 'Charlesfort');

-- 5) Id, возраст и рейтинг шахматистов, занимавших первые места в турнирах с 2016 по 2021 год 
-- (exists с вложенным подзапросом)
select id as player_id, age, elo_rating
from lab_01.chess_players
where exists (select 1 from lab_01.tournaments as tournaments
where lab_01.chess_players.id = tournaments.place_1 and tournaments.year between 2016 and 2021);

-- 6) Шахматисты, у которых рейтинг больше, чем у гроссмейстеров
-- (сравнение с квантором)
select name||' '||surname as player, elo_rating, title
from lab_01.chess_players
where elo_rating > all (select elo_rating from lab_01.chess_players where title = 'GM');

-- 7) Среднее количество набранных очков и средняя прибавка рейтинга шахматистов на турнирах
-- (агрегатные функции)
select id_p as player_id, points, avg_rating
from (select id_p, (sum(wins - defeats + draws * 0.5) / count(id_p)) as points, avg(adding_rating) as avg_rating
from lab_01.participants as p1 group by id_p) as results order by player_id;

-- 8) Количество призовых мест и средняя прибавка рейтинга у игроков в турнирах
-- (скалярные подзапросы)
select name||' '||surname as player,
(select count(place) from lab_01.participants as participants 
where participants.id_p = players.id and place between 1 and 3) as count_top,
(select avg(adding_rating) from lab_01.participants as participants
where participants.id_p = players.id) as avg_adding
from lab_01.chess_players as players;

-- 9) Звания шахматистов на русском
-- (простой case)
select id, name||' '||surname as player, 
case title 
when 'GM' then 'Гроссмейстер'
when 'IM' then 'Международный мастер'
when 'FM' then 'Мастер ФИДЕ'
when 'CM' then 'Кандидат в мастера'
else 'Разряд'
end as text_title
from lab_01.chess_players as players;

-- 10) Сколько участников сыграло на каждом турнире
-- (поисковый case)
select id, name,
case
when number between 251 and 500 then 'Больше 250'
when number between 101 and 250 then 'Больше 100'
when number between 26 and 100 then 'Больше 25'
when number between 11 and 25 then 'Больше 10'
else 'Меньше 10'
end as participants_number
from lab_01.tournaments as torunaments;

-- 11) Создание временной таблицы с игроками с рейтингом выше 2200 и младше 30 лет
-- (новая временная локальная таблица)
drop table if exists lab_02.best_players cascade; 
select id, name, surname, age, elo_rating
into lab_02.best_players
from lab_01.chess_players as players 
where elo_rating > 2200 and age < 30
order by elo_rating;
select * from lab_02.best_players; 

-- 12) Количество призовых мест у каждого гроссмейстера
-- (коррелированные подзапросы)
select name||' '||surname as player, elo_rating, top_places
from lab_01.chess_players as players join
(select id_p, count(place) as top_places from lab_01.participants as participants
where participants.place < 4 group by id_p)
as places on players.id = places.id_p where players.title = 'GM';

-- 13) Шахматисты, имеющие максимальную прибавку рейтинга за турнир 'SPACE - POLICE'
-- (уровень вложенности 3)
select distinct id, name, surname
from lab_01.participants join lab_01.chess_players on id_p = id
where id_p in (
	select id_p from lab_01.participants join lab_01.tournaments on id_t = id
	where name = 'SPACE - POLICE' group by id_p having max(adding_rating) = (
		select max(adding_rating) from (
			select adding_rating from lab_01.participants p join lab_01.tournaments t on id_t = id 
			where t.name = 'SPACE - POLICE'
			) as adding
		)
	);

-- 14) Средний и максимальный рейтинг шахматистов, занимавших призовые места с 2012 по 2016 года
-- (group by без having)
(select year, round(avg(elo_rating)) as avg_rating, max(elo_rating) as max_rating, 'First' as place
from lab_01.tournaments t join lab_01.chess_players cp on cp.id = place_1
where year between 2012 and 2016
group by year
union
select year, round(avg(elo_rating)) as avg_rating, max(elo_rating) as max_rating, 'Second' as place
from lab_01.tournaments t join lab_01.chess_players cp on cp.id = place_2
where year between 2012 and 2016
group by year
union 
select year, round(avg(elo_rating)) as avg_rating, max(elo_rating) as max_rating, 'Third' as place
from lab_01.tournaments t join lab_01.chess_players cp on cp.id = place_3
where year between 2012 and 2016
group by year)
order by place, year;

-- 15) Имена и рейтинг шахматистов, у которых максимальное количество побед на турнирах больше общего среднего
-- (group by с having)
select id, name, surname, elo_rating, max(wins) as max_wins
from lab_01.participants p join lab_01.chess_players cp on id_p = id
group by id 
having max(wins) > (select avg(wins) from lab_01.participants)
order by max_wins;

-- 16) Добавление нового игрока в таблицу шахматистов
-- (insert одной строки)
insert into lab_01.chess_players (name, surname, age, birth_place, elo_rating, title)
values ('Ilya', 'Klimov', 20, 'Yakutsk', 1600, 'I');

-- 17) Добавление новых партий
-- (insert множества строк)
insert into lab_01.games (id_1, id_2, winner, format, year)
(
select id, (select id from lab_01.chess_players where name = 'Ilya' and surname = 'Klimov'), id, 'online', 2021
from lab_01.chess_players where elo_rating > 1600
union 
select id, (select id from lab_01.chess_players where name = 'Ilya' and surname = 'Klimov'),
(select id from lab_01.chess_players where name = 'Ilya' and surname = 'Klimov'), 'online', 2021
from lab_01.chess_players where elo_rating < 1600
);

-- 18) Обновить рейтнг шахматиста
-- (update простой)
update lab_01.chess_players 
set elo_rating = elo_rating + 28
where name = 'Ilya' and surname = 'Klimov';

-- 19) Заменить рейтинг шахматиста на средний
-- (update со скалярным подзапросом)
update lab_01.chess_players 
set elo_rating = (select round(avg(elo_rating)) from lab_01.chess_players)
where name = 'Ilya' and surname = 'Klimov';

-- 20) Удалить партии, сыгранные в онлайне и раньше 2005 года
-- (delete простой)
delete from lab_01.games 
where format = 'online' and year < 2005;

-- 21) Удалить участников, участвоваших в турнирах в 2010 году и старше 50 лет
-- (delete с коррелированным подзапросом)
delete from lab_01.participants
where id_p in (
select cp.id from (lab_01.participants p join lab_01.chess_players cp on cp.id = id_p)
join lab_01.tournaments t on t.id = id_t 
where t.year = 2010 and cp.age > 50
)

-- 22) Среднее количество участников и максимальный рейтинг игроков в турнирах с 2000 по 2020 года
-- (CTE)
with data_tournaments (year, number, rating) as (
select t.year, round(avg(t.number)), max(cp.elo_rating)
from lab_01.participants p join lab_01.tournaments t on id_t = t.id 
join lab_01.chess_players cp on id_p = cp.id 
where t.year between 2000 and 2020
group by t.year
order by t.year
)
select year, number as avg_number, rating as max_rating
from data_tournaments;

-- 23) Распределение участников по количеству побед в турнире ATTENTION - STAND (id = 2)
-- (рекурсивное CTE)
with recursive winners (player_id, wins, place) as (
	select id_p, wins, 1 as place
	from lab_01.participants
	where id_t = 2 and wins = (select max(wins) from lab_01.participants where id_t = 2 group by id_t)
	union
	select p.id_p, p.wins, winners.place + 1 as place
	from lab_01.participants p join winners on p.wins = winners.wins - 1 where id_t = 2
)
select * from winners;


-- 24) Максимальный, минимальный, средний рейтинг шахматистов от 25 до 50 лет
-- (оконные функции)
select distinct cp.age,
max(cp.elo_rating) over (partition by cp.age) as max_rating,
min(cp.elo_rating) over (partition by cp.age) as min_rating,
round(avg(cp.elo_rating) over (partition by cp.age)) as avg_rating
from lab_01.chess_players cp
where age between 25 and 50
order by cp.age;

-- 25) Удаление дублириющихся строк
-- (оконные функции для устранения дублей)
delete from lab_01.chess_players cp
where id in (
select id from (
select * from (
select id, row_number() over (partition by name, surname, age, birth_place) as cnt
from lab_01.chess_players
) count_players
where cnt > 1
) count_duplicates
);
-- Создание строки для последующего дублирования
insert into lab_01.chess_players (name, surname, age, birth_place, elo_rating, title)
values ('Magnus', 'Carlsen', 30, 'Norway', 2850, 'GM');


-- Дополнительное задание
select cp.id as player_id, cp.name||' '||cp.surname as player_name, cp.age, cp.birth_place, p.place, 
t.name as tournament_name, t.year
from lab_01.chess_players cp join lab_01.participants p on cp.id = p.id_p
join lab_01.tournaments t on p.id_t = t.id 
where cp.age > 50 and cp.birth_place like 'An%'and p.place < 4
order by cp.id;

