drop table if exists postgres.lab_01.chess_players cascade; 
drop table if exists postgres.lab_01.tournaments cascade;
drop table if exists postgres.lab_01.games cascade;
drop table if exists postgres.lab_01.participants cascade;


create table postgres.lab_01.chess_players(
	id serial,
	name varchar(20),
	surname varchar(30),
	age integer,
	birth_place varchar(50),
	elo_rating integer,
	title varchar(3)
);

create table postgres.lab_01.tournaments (
	id serial,
	name varchar(50),
	location varchar(50),
	year integer,
	number integer,
	place_1 integer,
	place_2 integer,
	place_3 integer
);

create table postgres.lab_01.games (
	id_1 integer,
	id_2 integer,
	winner integer,
	format text,
	year integer
);

create table postgres.lab_01.participants (
	id_p integer,
	id_t integer,
	place integer,
	adding_rating integer,
	wins integer,
	defeats integer,
	draws integer
);
