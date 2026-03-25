-- TODO: put tables in the right order to avoid FK conflicts
-- DROP TABLES
DROP TABLE IF EXISTS award_nomination;
DROP TABLE IF EXISTS domestic_box_office;
DROP TABLE IF EXISTS episode;
DROP TABLE IF EXISTS movie;

DROP TABLE IF EXISTS participation;
DROP TABLE IF EXISTS person_profession;
DROP TABLE IF EXISTS media_production;
DROP TABLE IF EXISTS country_of_production;
DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS media_content_warning;
DROP TABLE IF EXISTS media_genre;

DROP TABLE IF EXISTS series;
DROP TABLE IF EXISTS production_company;
DROP TABLE IF EXISTS character;
DROP TABLE IF EXISTS person;

DROP TABLE IF EXISTS profession;
DROP TABLE IF EXISTS award;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS content_warning;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS media;
DROP TABLE IF EXISTS language;
DROP TABLE IF EXISTS country;

-- CREATE TABLES

-- LOOKUP TABLES
CREATE TABLE language (
    id AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE genre (
    id AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE content_warning (
    id AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    join_date DATE NOT NULL DEFAULT CURRENT_DATE
) ENGINE=InnoDB;

CREATE TABLE country
(
id INT PRIMARY KEY,
name VARCHAR(64)
) ENGINE = InnoDB;

CREATE TABLE profession
(
id INT PRIMARY KEY,
name VARCHAR(64)
) ENGINE = InnoDB;

CREATE TABLE award (
id INT PRIMARY KEY,
name VARCHAR(64)
) engine=InnoDB;

CREATE TABLE character (
id INT PRIMARY KEY,
name VARCHAR (64)
) engine=InnoDB;

-- MEDIA TABLE (depends on LANGUAGE)
CREATE TABLE media (
    id AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    original_title VARCHAR(255),
    type VARCHAR(50) NOT NULL,
    language_id INT NOT NULL,
    budget NUMERIC(15,2) CHECK (budget >= 0),

    FOREIGN KEY (language_id) REFERENCES language(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- PERSON (depends on COUNTRY)
CREATE TABLE person
(
id INT PRIMARY KEY,
name VARCHAR(64),
birth_year YEAR,
death_year YEAR,
nationality_id INT,
FOREIGN KEY nationality_id REFERENCES country (id)
) ENGINE = InnoDB;

-- PRODUCTION_COMPANY (depends on COUNTRY)
CREATE TABLE production_company
(
id INT PRIMARY KEY,
name VARCHAR(64),
hq_country_id INT,
FOREIGN KEY hq_country_id REFERENCES country (id)
) ENGINE = InnoDB;

-- MOVIE (depends on MEDIA)
CREATE TABLE movie (
media_id INT PRIMARY KEY, 
Release_year YEAR,
Duration_minutes INT,
FOREIGN KEY (media_id) REFERENCES media(id)
) engine=InnoDB;

-- SERIES (depends on MEDIA)
CREATE TABLE series (
media_id INT PRIMARY KEY,
intended_season_count INT,
content_format VARCHAR(64),
start_year YEAR,
end_year YEAR,
FOREIGN KEY (media_id) REFERENCES media(id)
) engine=InnoDB;


CREATE TABLE media_genre (
    media_id INT NOT NULL,
    genre_id INT NOT NULL,

    PRIMARY KEY (media_id, genre_id),

    FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genre(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- MEDIA_CONTENT_WARNING (MANY-TO-MANY)
CREATE TABLE media_content_warning (
    media_id INT NOT NULL,
    warning_id INT NOT NULL,

    PRIMARY KEY (media_id, warning_id),

    FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE CASCADE,
    FOREIGN KEY (warning_id) REFERENCES content_warning(id) ON DELETE CASCADE
) ENGINE=InnoDB; 

-- REVIEW TABLE
CREATE TABLE review (
    id AUTO_INCREMENT PRIMARY KEY,
    media_id INT NOT NULL,
    user_id INT NOT NULL,
    score INT NOT NULL CHECK (score BETWEEN 1 AND 10),
    text TEXT,
    date_posted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE (media_id, user_id) -- one review per user per media
) ENGINE=InnoDB;


CREATE TABLE participation
(
participation_id INT PRIMARY KEY,
media_id INT,
person_id INT,
profession_id INT,
character_id INT,
FOREIGN KEY person_id REFERENCES person (id),
FOREIGN KEY media_id REFERENCES media (id),
FOREIGN KEY profession_id REFERENCES profession (id),
FOREIGN KEY character_id REFERENCES character (id)
) ENGINE = InnoDB;


CREATE TABLE person_profession
(
person_id INT,
profession_id INT,
PRIMARY KEY(person_id, profession_id),
FOREIGN KEY person_id REFERENCES person (id),
FOREIGN KEY profession_id REFERENCES profession (id)
) ENGINE = InnoDB;



CREATE TABLE country_of_production
(
country_id INT,
media_id INT,
PRIMARY KEY (media_id, country_id),
FOREIGN KEY media_id REFERENCES media (id),
FOREIGN KEY country_id REFERENCES country (id)
) ENGINE = InnoDB;


CREATE TABLE media_production
(
media_id INT,
company_id INT,
role VARCHAR(64),
PRIMARY KEY(media_id, company_id),
FOREIGN KEY media_id REFERENCES media (id),
FOREIGN KEY company_id REFERENCES production_company (id)
) ENGINE = InnoDB;


CREATE TABLE award_nomination (
id INT PRIMARY KEY,
award_id INT,
media_id INT,
person_id INT,
year YEAR,
category VARCHAR(64),
is_winner VARCHAR(64),
FOREIGN KEY (award_id) REFERENCES award(id),
FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (person_id) REFERENCES person(id)
) engine=InnoDB;



CREATE TABLE domestic_box_office (
media_id INT,
record_date DATE,
day_amount INT,
theatre_count INT,
FOREIGN KEY (media_id) REFERENCES media(id),
PRIMARY KEY (media_id, record_date)
) engine=InnoDB;

CREATE TABLE episode (
media_id INT PRIMARY KEY,
series_media_id INT,
season_number INT,
episode_number INT,
duration_minutes INT,
release_date DATE,
FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (series_media_id) REFERENCES series(media_id)
) engine=InnoDB;


