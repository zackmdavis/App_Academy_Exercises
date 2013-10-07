require_relative './associatable'
require_relative './db_connection'
require_relative './mass_object'
require_relative './searchable'

class SQLObject < MassObject

  extend Searchable
  extend Associatable

  def self.set_table_name(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name
  end

  def self.all
    query = "SELECT * FROM #{self.table_name};"
    results = DBConnection.execute(query)
    self.parse_all(results)
  end

  def self.find(id)
    query = "SELECT * FROM #{self.table_name} WHERE id = ?;"
    results = DBConnection.execute(query, id)
    new(results[0])
  end

  def self.question_marks(n)
    if n == 1
      return '?'
    else
      return '('+(['?']*n).join(', ')+')'
    end
  end

  def create
    attributes_string = '('+self.class.attributes.join(', ')+')'
    query = %Q[INSERT INTO #{self.class.table_name attributes_string}
      VALUES #{self.question_marks(atrribute_names.length)};]
    attribute_values = attribute_names.map { |name| self.send(name) }
    DBConnection.execute(query, *attribute_values)
    self.id = DBConnection.last_insert_row_id
  end

  def update
    set_string = self.class.attributes.map { |name| "#{name} = ?" }.join(', ')
    query = "UPDATE #{self.class.table_name} SET #{set_string} WHERE id = #{self.id}"
    DBConnection.execute(query, *attribute_values)
  end

  def save
    unless self.id.nil?
      update
    else
      create
    end
  end

  def attribute_values
    self.class.attributes.map { |name| self.send(name) }
  end
end
