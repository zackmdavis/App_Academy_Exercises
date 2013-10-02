require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("questions_database.db")

    self.results_as_hash = true
    self.type_translation = true
  end
end

class User

  attr_accessor :id, :first, :last

  def initialize(options = {})
    @id = options["id"]
    @first = options["first"]
    @last = options["last"]
  end

  def self.find_by_id(id_to_find)
    query = %Q[
      SELECT * FROM
        users
      WHERE id = ?;]
    query_result = QuestionsDatabase.instance.execute(query, id_to_find)
    unless query_result.empty?
      return User.new(query_result[0])
    else
      return nil
    end
  end

  def self.find_by_name(first, last)
    query = %Q[
      SELECT * FROM
        users
      WHERE first = ? AND last = ?]
    QuestionsDatabase.instance.execute(query, first, last).map { |options| User.new(options) }
  end

  def create
    query = %Q[
      INSERT INTO
        users (first, last)
      VALUES
        (?, ?);]
    QuestionsDatabase.instance.execute(query, first, last)
    @user_id = QuestionsDatabase.instance.last_insert_row_id
    self
  end

  def save
    query = %Q[
      UPDATE users
      SET first = ?,
          last = ?
      WHERE id = ?]
    QuestionsDatabase.instance.execute(query, @first, @last, @id)
    self
  end

  def authored_questions
    query = %Q[
      SELECT * FROM
        questions
      WHERE
        author_id = ?]
    QuestionsDatabase.instance.execute(query, @id).map { |options| Question.new(options) }
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end

  def authored_replies
    Reply.find_by_author_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

end

class Question

  attr_accessor :id, :title, :body, :author_id

  def initialize(options = {})
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @author_id = options["author_id"]
  end

  def Question.find_by_id(id_to_find)
    query = %Q[
      SELECT * FROM
        questions
      WHERE id = ?;]
    query_result = QuestionsDatabase.instance.execute(query, id_to_find)
    unless query_result.empty?
      return Question.new(query_result[0])
    else
      return nil
    end
  end

  def Question.find_by_author_id(author_id)
    query = %Q[
      SELECT * FROM
        questions
      WHERE author_id = ?;]
    QuestionsDatabase.instance.execute(query, author_id).map { |options| Question.new(options) }
  end

  def create
    query = %Q[
      INSERT INTO
        questions (title, body, author_id)
      VALUES
        (?, ?, ?);]
    QuestionsDatabase.instance.execute(query, title, body, author_id)
    @id = QuestionsDatabase.instance.last_insert_row_id
    return self
  end

  def save
    query = %Q[
      UPDATE questions
      SET title = ?,
          body = ?,
          author_id = ?
      WHERE id = ?]
    QuestionsDatabase.instance.execute(query, @title, @body, @author_id, @id)
    self
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollower.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

end

class Reply

  attr_accessor :id, :question_id, :parent_id, :body, :author_id

  def initialize(options = {})
    @id = options["id"]
    @question_id = options["question_id"]
    @parent_id = options["parent_id"]
    @body = options["body"]
    @author_id = options["author_id"]
  end

  def Reply.find_by_id(id_to_find)
    query = %Q[
      SELECT * FROM
        replies
      WHERE id = ?;]
    query_result = QuestionsDatabase.instance.execute(query, id_to_find)
    unless query_result.empty?
      return Reply.new(query_result[0])
    else
      return nil
    end
  end

  def Reply.find_by_question_id(id_to_find)
    query = %Q[
      SELECT * FROM
        replies
      WHERE question_id = ?;]
    QuestionsDatabase.instance.execute(query, id_to_find).map { |options| Reply.new(options) }
  end

  def Reply.find_by_author_id(id_to_find)
    query = %Q[
      SELECT * FROM
        replies
      WHERE author_id = ?;]
    QuestionsDatabase.instance.execute(query, id_to_find).map { |options| Reply.new(options) }
  end

  def create
    query = %Q[
      INSERT INTO
        replies (question_id, parent_id, body, author_id)
      VALUES
        (?, ?, ?, ?);]
    QuestionsDatabase.instance.execute(query, question_id, parent_id, body, author_id)
    @id = QuestionsDatabase.instance.last_insert_row_id
    return self
  end

  def save
    query = %Q[
      UPDATE replies
      SET question_id = ?,
          parent_id = ?,
          body = ?,
          author_id = ?
      WHERE user_id = ?]
    QuestionsDatabase.instance.execute(query, @question_id, @parent_id, @body, @author_id, @user_id)
    self
  end

  def author
    User.find_by_id(@author_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@parent_id)
  end

  def child_replies
    query = %Q[
      SELECT * FROM
        replies
      WHERE parent_id = ?;]
    QuestionsDatabase.instance.execute(query, @id).map { |options| Reply.new(options) }
  end

  def Question.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

end

class QuestionFollower
  def QuestionFollower.followers_for_question_id(id_to_find)
    query = %Q[
      SELECT id, first, last
      FROM users JOIN question_followers ON users.id = question_followers.user_id
      WHERE question_id = ?; ]
    QuestionsDatabase.instance.execute(query, id_to_find).map { |options| User.new(options) }
  end

  def QuestionFollower.followed_questions_for_user_id(id_to_find)
    query = %Q[
      SELECT questions.id, title, body, author_id
      FROM questions JOIN question_followers ON questions.id = question_followers.question_id
      WHERE user_id = ?; ]
    QuestionsDatabase.instance.execute(query, id_to_find).map { |options| Question.new(options) }
  end

  def QuestionFollower.most_followed_questions(n)
    query = %Q[
      SELECT questions.id, title, body, author_id
         FROM
           questions JOIN question_followers
             ON questions.id = question_followers.question_id
         GROUP BY question_followers.question_id
         ORDER BY COUNT(question_followers.question_id) DESC; ]
    QuestionsDatabase.instance.execute(query)[0...n].map { |options| Question.new(options) }
  end

end

class QuestionLike

  def QuestionLike.likers_for_question_id(question_id)
    query = %Q[
      SELECT users.id, first, last
      FROM users JOIN question_likes ON users.id = question_likes.user_id
      WHERE question_id = ?; ]
    QuestionsDatabase.instance.execute(query, question_id).map { |options| User.new(options) }
  end

  def QuestionLike.num_likes_for_question_id(question_id)
    query = %Q[
      SELECT COUNT(question_likes.question_id)
      FROM questions JOIN question_likes ON questions.id = question_likes.question_id
      WHERE questions.id = ?
      GROUP BY question_likes.question_id;]
    query_result = QuestionsDatabase.instance.execute(query, question_id)
    unless query_result.empty?
      return query_result[0].values[0]
    else
      return 0
    end
  end

  def QuestionLike.liked_questions_for_user_id(user_id)
    query = %Q[
      SELECT questions.id, title, body, author_id
      FROM questions JOIN question_likes ON questions.id = question_likes.question_id
      WHERE user_id = ?; ]
    QuestionsDatabase.instance.execute(query, user_id).map { |options| Question.new(options) }
  end

  def QuestionLike.most_liked_questions(n)
    query = %Q[
      SELECT questions.id, title, body, author_id
         FROM
           questions JOIN question_likes
             ON questions.id = question_likes.question_id
         GROUP BY question_likes.question_id
         ORDER BY COUNT(question_likes.question_id) DESC; ]
    QuestionsDatabase.instance.execute(query)[0...n].map { |options| Question.new(options) }
  end

  def QuestionLike.average_karma_for_user_id(user_id)
    query = %Q[
    SELECT CAST(COUNT(question_likes.user_id) AS FLOAT)/COUNT(DISTINCT q.id)
    FROM (SELECT id FROM questions WHERE author_id = ?) AS q
      JOIN question_likes ON q.id = question_likes.question_id;]
    QuestionsDatabase.instance.execute(query, user_id)[0].values[0]
  end

end