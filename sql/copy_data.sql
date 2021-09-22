delete from postgres.lab_01.chess_players;
copy postgres.lab_01.chess_players (name, surname, age, birth_place, elo_rating, title) 
from '/chess_players.csv' delimiter '|' csv;

delete from postgres.lab_01.tournaments;
copy postgres.lab_01.tournaments (name, location, year, number, place_1, place_2, place_3) 
from '/tournaments.csv' delimiter '|' csv;

delete from postgres.lab_01.games;
copy postgres.lab_01.games (id_1, id_2, winner, format, year) 
from '/games.csv' delimiter '|' csv;

delete from postgres.lab_01.participants;
copy postgres.lab_01.participants (id_p, id_t, place, adding_rating, wins, defeats, draws) 
from '/participants.csv' delimiter '|' csv;