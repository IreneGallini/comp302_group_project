-- Intert data into IMDB tables created in IMDBTables.sql

LOAD DATA INFILE 'language.csv'
INTO TABLE languages
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Skips the first line if it contains headers
