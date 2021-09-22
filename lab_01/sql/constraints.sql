alter table postgres.lab_01.chess_players add primary key (id);

alter table postgres.lab_01.tournaments add primary key (id);
alter table postgres.lab_01.tournaments add foreign key (place_1) references postgres.lab_01.chess_players;
alter table postgres.lab_01.tournaments add foreign key (place_2) references postgres.lab_01.chess_players;
alter table postgres.lab_01.tournaments add foreign key (place_3) references postgres.lab_01.chess_players;

alter table postgres.lab_01.games add foreign key (id_1) references postgres.lab_01.chess_players;
alter table postgres.lab_01.games add foreign key (id_2) references postgres.lab_01.chess_players;

alter table postgres.lab_01.participants add foreign key (id_p) references postgres.lab_01.chess_players;
alter table postgres.lab_01.participants add foreign key (id_t) references postgres.lab_01.tournaments;

alter table postgres.lab_01.chess_players add check (name is not null);
alter table postgres.lab_01.chess_players add check (surname is not null);
alter table postgres.lab_01.chess_players add check (age > 2 and age < 120);
alter table postgres.lab_01.chess_players add check (birth_place is not null);
alter table postgres.lab_01.chess_players add check (elo_rating > 0 and elo_rating < 3000);
alter table postgres.lab_01.chess_players add check (title in ('IV', 'III', 'II', 'I', 'CM', 'FM', 'IM', 'GM'));

alter table postgres.lab_01.tournaments add check (name is not null);
alter table postgres.lab_01.tournaments add check (location is not null);
alter table postgres.lab_01.tournaments add check (year > 0 and year < 2022);
alter table postgres.lab_01.tournaments add check (number > 0);

alter table postgres.lab_01.games add check (winner = id_1 or winner = id_2);
alter table postgres.lab_01.games add check (format in ('online', 'offline'));
alter table postgres.lab_01.games add check (year > 0 and year < 2022);

alter table postgres.lab_01.participants add check (place > 0);
alter table postgres.lab_01.participants add check (adding_rating is not null);
alter table postgres.lab_01.participants add check (wins >= 0);
alter table postgres.lab_01.participants add check (defeats >= 0);
alter table postgres.lab_01.participants add check (draws >= 0);
