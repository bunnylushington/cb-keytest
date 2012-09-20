CREATE TABLE IF NOT EXISTS serialkeys (
  id   SERIAL PRIMARY KEY,
  name VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS uuidkeys (
  id   UUID PRIMARY KEY,
  name VARCHAR(200) NOT NULL
);  

CREATE TABLE IF NOT EXISTS authors (
  id         UUID PRIMARY KEY,
  first_name VARCHAR(64) NOT NULL,
  last_name  VARCHAR(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS books (
  id        UUID PRIMARY KEY,
  title     VARCHAR(200) NOT NULL,
  author_id UUID REFERENCES authors(id)
); 

CREATE TABLE IF NOT EXISTS hackers (
  id       SERIAL PRIMARY KEY, 
  githubid VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS projects (
  id        SERIAL PRIMARY KEY,
  name      VARCHAR(200) NOT NULL,
  hacker_id SERIAL REFERENCES hackers(id)
);
