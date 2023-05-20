DROP TABLE if EXISTS ProviderShow_1NF;
CREATE TABLE if not EXISTS "ProviderShow_1NF" (
	provider_id			INTEGER NOT NULL,
	provider			NOT NULL,
	show_id				INTEGER,
	title				NOT NULL, 
	show_type			NOT NULL, 
	release_year		INTEGER, 
	age_certification	TEXT, 
	runtime				INTEGER NOT NULL, 
	seasons				INTEGER, 
	tmdb_popularity		REAL, 
	tmdb_score			REAL, 
	genre_id 			INTEGER NOT NULL,
	genre				NOT NULL,
	CONSTRAINT Pk_show_genre PRIMARY KEY (show_id, genre_id, provider_id, title)
);
INSERT INTO ProviderShow_1NF (provider_id, provider, show_id, title, show_type, release_year, age_certification, runtime, seasons, tmdb_popularity, tmdb_score, genre_id, genre)
SELECT * FROM ProviderShow_0NF;


DROP TABLE if EXISTS IMDbRating_1NF;
CREATE table if not EXISTS IMDbRating_1NF(
	"tconst"	TEXT,
	"averageRating"	REAL,
	"numVotes"	INTEGER,
	PRIMARY KEY (tconst)
);
INSERT INTO IMDbRating_1NF (tconst, averageRating, numVotes)
SELECT * FROM IMDbRating_0NF;


DROP TABLE if EXISTS IMDbRating_2NF;
CREATE TABLE if not EXISTS IMDbRating_2NF(
	"tconst"		TEXT,
	"averageRating"	REAL,
	"numVotes"		INTEGER,
	PRIMARY KEY (tconst)
);
INSERT INTO IMDbRating_2NF (tconst, averageRating, numVotes)
SELECT * FROM IMDbRating_1NF;



DROP TABLE if EXISTS ProviderShow_2NF;
DROP TABLE if EXISTS ShowSpecifics_2NF;
DROP TABLE if EXISTS Genres_2NF;
DROP TABLE if EXISTS Providers_2NF;


CREATE TABLE if not EXISTS Providers_2NF(
	"provider_id"	INTEGER PRIMARY KEY,
	"provider"		TEXT
);
INSERT INTO Providers_2NF (provider, provider_id)
SELECT DISTINCT provider, provider_id FROM ProviderShow_1NF;


CREATE TABLE if not EXISTS Genres_2NF(
	"genre_id"	INTEGER PRIMARY KEY,
	"genre"		TEXT
);
INSERT INTO Genres_2NF (genre_id, genre)
SELECT DISTINCT genre_id, genre FROM ProviderShow_1NF;


CREATE TABLE if not EXISTS ShowSpecifics_2NF(
	show_id				INTEGER,
	title				NOT NULL, 
	show_type			NOT NULL, 
	release_year		INTEGER, 
	age_certification	TEXT, 
	runtime				INTEGER NOT NULL, 
	seasons				INTEGER, 
	tmdb_popularity		REAL, 
	tmdb_score			REAL, 
	CONSTRAINT Pk_show_idtype PRIMARY KEY (show_id, show_type)
);
INSERT INTO ShowSpecifics_2NF (show_id, title, show_type, release_year, age_certification, runtime, seasons, tmdb_popularity, tmdb_score)
SELECT DISTINCT show_id, title, show_type, release_year, age_certification, runtime, seasons, tmdb_popularity, tmdb_score
FROM ProviderShow_1NF;


CREATE TABLE if not EXISTS "ProviderShow_2NF" (
	provider_id 		INTEGER NOT NULL,
	show_id				INTEGER,
	show_type			NOT NULL, 
	genre_id 			INTEGER NOT NULL,
	CONSTRAINT Pk_show_title PRIMARY KEY (show_id, show_type, provider_id, genre_id)
	FOREIGN KEY (provider_id) REFERENCES Providers_2NF(provider_id)
	FOREIGN KEY (genre_id) REFERENCES Genres_2NF(genre_id)
	FOREIGN KEY (show_id, show_type) REFERENCES ShowSpecifics_2NF(show_id, show_type)
);
INSERT INTO ProviderShow_2NF (provider_id, show_id, show_type, genre_id)
SELECT provider_id, show_id, show_type, genre_id 
FROM ProviderShow_1NF;


