require_relative './db_connection'

module Searchable
  def where(params)
    where_string = params.keys.map { |name| "#{name} = ?" }.join(' AND ')
    query = "SELECT * FROM #{self.table_name} WHERE #{where_string};"
    results = DBConnection.execute(query, *params.values)
    self.parse_all(results)
  end
end