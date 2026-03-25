-- TODO: put tables in the right order to avoid FK conflicts
--STEP 1: drop tables


-- STEP 2: create tables
--IRENE
-- LANGUAGE TABLE
CREATE TABLE language (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- GENRE TABLE
CREATE TABLE genre (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- CONTENT WARNING TABLE
CREATE TABLE content_warning (
    id SERIAL PRIMARY KEY,
    type VARCHAR(100) NOT NULL UNIQUE
);

-- USER TABLE
CREATE TABLE "user" (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    join_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- MEDIA TABLE
CREATE TABLE media (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    original_title VARCHAR(255),
    type VARCHAR(50) NOT NULL,
    language_id INT NOT NULL,
    budget NUMERIC(15,2) CHECK (budget >= 0),

    CONSTRAINT fk_media_language
        FOREIGN KEY (language_id)
        REFERENCES language(id)
        ON DELETE RESTRICT
);

-- MEDIA_GENRE (MANY-TO-MANY)
CREATE TABLE media_genre (
    media_id INT,
    genre_id INT,

    PRIMARY KEY (media_id, genre_id),

    CONSTRAINT fk_media_genre_media
        FOREIGN KEY (media_id)
        REFERENCES media(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_media_genre_genre
        FOREIGN KEY (genre_id)
        REFERENCES genre(id)
        ON DELETE CASCADE
);

-- MEDIA_CONTENT_WARNING (MANY-TO-MANY)
CREATE TABLE media_content_warning (
    media_id INT,
    warning_id INT,

    PRIMARY KEY (media_id, warning_id),

    CONSTRAINT fk_mc_media
        FOREIGN KEY (media_id)
        REFERENCES media(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_mc_warning
        FOREIGN KEY (warning_id)
        REFERENCES content_warning(id)
        ON DELETE CASCADE
);

-- REVIEW TABLE
CREATE TABLE review (
    id SERIAL PRIMARY KEY,
    media_id INT NOT NULL,
    user_id INT NOT NULL,
    score INT NOT NULL CHECK (score BETWEEN 1 AND 10),
    text TEXT,
    date_posted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_review_media
        FOREIGN KEY (media_id)
        REFERENCES media(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_review_user
        FOREIGN KEY (user_id)
        REFERENCES "user"(id)
        ON DELETE CASCADE,

    CONSTRAINT unique_user_review
        UNIQUE (media_id, user_id) -- one review per user per media
);

-- SAM
-- LANGUAGE TABLE
CREATE TABLE language (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- GENRE TABLE
CREATE TABLE genre (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- CONTENT WARNING TABLE
CREATE TABLE content_warning (
    id SERIAL PRIMARY KEY,
    type VARCHAR(100) NOT NULL UNIQUE
);

-- USER TABLE
CREATE TABLE "user" (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    join_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- MEDIA TABLE
CREATE TABLE media (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    original_title VARCHAR(255),
    type VARCHAR(50) NOT NULL,
    language_id INT NOT NULL,
    budget NUMERIC(15,2) CHECK (budget >= 0),

    CONSTRAINT fk_media_language
        FOREIGN KEY (language_id)
        REFERENCES language(id)
        ON DELETE RESTRICT
);

-- MEDIA_GENRE (MANY-TO-MANY)
CREATE TABLE media_genre (
    media_id INT,
    genre_id INT,

    PRIMARY KEY (media_id, genre_id),

    CONSTRAINT fk_media_genre_media
        FOREIGN KEY (media_id)
        REFERENCES media(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_media_genre_genre
        FOREIGN KEY (genre_id)
        REFERENCES genre(id)
        ON DELETE CASCADE
);

-- MEDIA_CONTENT_WARNING (MANY-TO-MANY)
CREATE TABLE media_content_warning (
    media_id INT,
    warning_id INT,

    PRIMARY KEY (media_id, warning_id),

    CONSTRAINT fk_mc_media
        FOREIGN KEY (media_id)
        REFERENCES media(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_mc_warning
        FOREIGN KEY (warning_id)
        REFERENCES content_warning(id)
        ON DELETE CASCADE
);

-- REVIEW TABLE
CREATE TABLE review (
    id SERIAL PRIMARY KEY,
    media_id INT NOT NULL,
    user_id INT NOT NULL,
    score INT NOT NULL CHECK (score BETWEEN 1 AND 10),
    text TEXT,
    date_posted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_review_media
        FOREIGN KEY (media_id)
        REFERENCES media(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_review_user
        FOREIGN KEY (user_id)
        REFERENCES "user"(id)
        ON DELETE CASCADE,

    CONSTRAINT unique_user_review
        UNIQUE (media_id, user_id) -- one review per user per media
);
