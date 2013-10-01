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

  attr_accessor :user_id, :first, :last

  def initialize(options = {})
    @user_id = options["user_id"]
    @first = options["first"]
    @last = options["last"]
  end

  def User.find_by_id(id_to_find)
    query = %Q[
      SELECT * FROM
        users
      WHERE user_id = #{id_to_find};]
    User.new(QuestionsDatabase.instance.execute(query)[0])
  end

  def User.find_by_name(first, last)
    query = %Q[
      SELECT * FROM
        users
      WHERE first = '#{first}' AND last = '#{last}']
    QuestionsDatabase.instance.execute(query).map { |options| User.new(options) }
  end

  def authored_questions
    query = %Q[
      SELECT * FROM
        questions
      WHERE
        author_id = #{@user_id}]
    QuestionsDatabase.instance.execute(query).map { |options| Question.new(options) }
  end

  def authored_replies
    query = %Q[
      SELECT * FROM
        replies
      WHERE
        author_id = #{@user_id}]
    QuestionsDatabase.instance.execute(query).map { |options| Reply.new(options) }
  end

  def create
    query = %Q[
      INSERT INTO
        users (first, last)
      VALUES
        (?, ?);]
    QuestionsDatabase.instance.execute(query, first, last)
    @user_id = QuestionsDatabase.instance.last_insert_row_id
    return self
  end
end

class Question

  attr_accessor :question_id, :title, :body, :author_id

  def initialize(options = {})
    @question_id = options["question_id"]
    @title = options["title"]
    @body = options["body"]
    @author_id = options["author_id"]
  end

  def Question.find_by_id(id_to_find)
    query = %Q[
      SELECT * FROM
        questions
      WHERE question_id = #{id_to_find};]
    Question.new(QuestionsDatabase.instance.execute(query)[0])
  end

  def Question.find_by_author_id(author_id)
    query = %Q[
      SELECT * FROM
        questions
      WHERE author_id = '#{author_id}';]
    QuestionsDatabase.instance.execute(query).map { |options| Question.new(options) }
  end

  def author
    User.find_by_id(author_id)
  end

  def replies

  end

  def create
    QuestionsDatabase.instance.execute(<<-SQL, title, body, author_id)
      INSERT INTO
        questions (title, body, author_id)
      VALUES
        (?, ?, ?);
        SQL
    @question_id = QuestionsDatabase.instance.last_insert_row_id
    return self
  end
end

class Reply

  attr_accessor :reply_id, :question_id, :parent_id, :body, :author_id

  def initialize(options = {})
    @reply_id = options["reply_id"]
    @question_id = options["question_id"]
    @parent_id = options["parent_id"]
    @body = options["body"]
    @author_id = options["author_id"]
  end

  def Reply.find_by_id(id_to_find)
    query = %Q[
      SELECT * FROM
        replies
      WHERE reply_id = #{id_to_find};]
    Reply.new(QuestionsDatabase.instance.execute(query)[0])
  end

  def Reply.find_by_question_id
  end

  def create
    query = %Q[
      INSERT INTO
        replies (question_id, parent_id, body, author_id)
      VALUES
        (?, ?, ?, ?);]
    QuestionsDatabase.instance.execute(query, question_id, parent_id, body, author_id)
    @user_id = QuestionsDatabase.instance.last_insert_row_id
    return self
  end

end

