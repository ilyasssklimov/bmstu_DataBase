from faker import Faker
from random import randint, choice


N = 5000
T = 1500
G = 10000
P = 15000


def create_chess_players():
    """
    id serial,
    name varchar(20),
    surname varchar(30),
    age integer,
    birth_place varchar(50),
    elo_rating integer,
    title varchar(3)
    """
    fake = Faker('en_US')
    with open('data/chess_players.csv', 'w') as f:
        for _ in range(N):
            name = fake.name().split()
            age = randint(20, 60)
            birth = fake.city()
            rating = randint(1500, 2500)
            titles = ['IV', 'III', 'II', 'I', 'CM', 'FM', 'IM', 'GM']
            s = f'{name[0]}|{name[1]}|{age}|{birth}|{rating}|{choice(titles)}'
            f.write(s + '\n')


def create_tournaments():
    """
    id serial,
    name varchar(50),
    location varchar(50),
    year integer,
    number integer,
    place_1 integer,
    place_2 integer,
    place_3 integer
    """
    fake = Faker()
    with open('data/tournaments.csv', 'w') as f:
        for _ in range(T):
            name = f'{fake.word().upper()} - {fake.word().upper()}'
            location = fake.city()
            year = randint(2000, 2021)
            number = randint(1, 500)
            place_1 = randint(1, N)
            place_2 = randint(1, N)
            place_3 = randint(1, N)
            s = f'{name}|{location}|{year}|{number}|{place_1}|{place_2}|{place_3}'
            f.write(s + '\n')


def create_games():
    """
    id_1 integer,
    id_2 integer,
    winner integer,
    format text,
    year integer
    """
    with open('data/games.csv', 'w') as f:
        for _ in range(G):
            id_1 = randint(1, N)
            id_2 = randint(1, N)
            winner = choice([id_1, id_2])
            game_format = choice(['online', 'offline'])
            year = randint(1970, 2021)
            s = f'{id_1}|{id_2}|{winner}|{game_format}|{year}'
            f.write(s + '\n')


def create_participants():
    """
    id_p integer,
    id_t integer,
    place integer,
    adding_rating integer,
    wins integer,
    defeats integer,
    draws integer
    """
    with open('data/participants.csv', 'w') as f:
        for _ in range(P):
            id_p = randint(1, N)
            id_t = randint(1, T)
            place = randint(1, 20)
            adding_rating = randint(-30, 40)
            wins = randint(0, 10)
            defeats = randint(0, 10)
            draws = randint(0, 10)
            s = f'{id_p}|{id_t}|{place}|{adding_rating}|{wins}|{defeats}|{draws}'
            f.write(s + '\n')


if __name__ == '__main__':
    create_chess_players()
    create_tournaments()
    create_games()
    create_participants()
