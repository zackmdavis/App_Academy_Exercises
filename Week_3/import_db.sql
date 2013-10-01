CREATE TABLE users(
 user_id INTEGER PRIMARY KEY,
 first VARCHAR(20),
 last VARCHAR(20)
);

CREATE TABLE questions(
  question_id INTEGER PRIMARY KEY,
title VARCHAR(70),
body TEXT,
author_id INTEGER
);

CREATE TABLE question_followers(
  question_id INTEGER,
  follower_id INTEGER
);

CREATE TABLE replies(
  reply_id INTEGER PRIMARY KEY,
  question_id INTEGER,
  parent_id INTEGER,
  body TEXT,
  author_id INTEGER
);

CREATE TABLE question_likes(
  user_id INTEGER,
  question_id INTEGER
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

INSERT INTO questions (question_id, title, body, author_id)
VALUES (3, "I just met you, and this is crazy, but ...?",
"Here's my number, so call me maybe", 1);

-- demo replies
INSERT INTO replies (reply_id, question_id, parent_id, body, author_id)
VALUES (1, 1, NULL,
"Yes, I used to wonder that like all the time, but then you-all shared its magic with me",
3);

INSERT INTO replies (reply_id, question_id, parent_id, body, author_id)
VALUES (2, 1, 1,
"Truly outrageous",
2);

-- demo followers
INSERT INTO question_followers (question_id, follower_id)
VALUES (1, 2);

INSERT INTO question_followers (question_id, follower_id)
VALUES (2, 1);

INSERT INTO question_followers (question_id, follower_id)
VALUES (2, 2);

-- demo likes
INSERT INTO question_likes (user_id, question_id)
VALUES (1, 1);

INSERT INTO question_likes (user_id, question_id)
VALUES (2, 1);

INSERT INTO question_likes (user_id, question_id)
VALUES (3, 1);

INSERT INTO question_likes (user_id, question_id)
VALUES (2, 3);