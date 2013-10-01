CREATE TABLE users(
 user_id INT PRIMARY KEY,
 first VARCHAR(20),
 last VARCHAR(20)
);

CREATE TABLE questions(
  question_id INT PRIMARY KEY,
title VARCHAR(70),
body TEXT,
author_id INT
);

CREATE TABLE question_followers(
  question_id INT,
  follower_id INT
);

CREATE TABLE replies(
  reply_id INT  PRIMARY KEY,
  question_id INT,
  parent_id INT,
  author_id INT
);

CREATE TABLE question_likes(
  user_id INT,
  question_id INT
);


-- demo users
INSERT INTO users (user_id, first, last)
VALUES (1, "Jennifer Q.", "User-Smith");

INSERT INTO users (user_id, first, last)
VALUES (2, "Carl P.", "Userton");

INSERT INTO users (user_id, first, last)
VALUES (3, "Voltairine", "de Cleyre");

-- demo questions
INSERT INTO questions (question_id, title, body, author_id)
VALUES (1, "Did you used to wonder what friendship could be?",
"It's totally a question that you would imagine someone like you wondering about", 1);

INSERT INTO questions (question_id, title, body, author_id)
VALUES (2, "Is John Brown's body a-mouldering in the grave?",
"It's been a while", 2);


