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
    @first = options[:first]
    @last = options[:last]
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

# class Question
#
#   QuestionsDatabase.instance.execute(<<-SQL, title, body, author_id)
#     INSERT INTO
#       questions (title, body, author_id)
#     VALUES
#
#   SQL
# end