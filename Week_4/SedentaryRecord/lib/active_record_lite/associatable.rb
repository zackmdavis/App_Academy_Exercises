require 'active_support/core_ext/object/try'
require 'active_support/inflector'
require_relative './db_connection.rb'

class AssocParams

  attr_accessor :other_class_name, :primary_key, :foreign_key

  def other_class
    ActiveSupport::Inflector.constantize(@other_class_name)
  end

  def other_table_name
    other_class.table_name
  end

end

class BelongsToAssocParams < AssocParams

  def initialize(name, params)
    @other_class_name = params[:class_name] ? params[:class_name] : ActiveSupport::Inflector.camelize(name)
    @primary_key = params[:primary_key] ? params[:primary_key] : :id
    @foreign_key = params[:foreign_key] ? params[:foreign_key] : (name.to_s+"_id").to_sym
  end

end

class HasManyAssocParams < AssocParams

  def initialize(name, params, self_class)
    if params[:class_name]
      @other_class_name = params[:class_name]
    else
      @other_class_name = ActiveSupport::Inflector.camelize(ActiveSupport::Inflector.singularize(name))
    end

    @primary_key = params[:primary_key] ? params[:primary_key] : :id

    if params[:foreign_key]
      @foreign_key = params[:foreign_key]
    else
      @foreign_key = (ActiveSupport::Inflector.snake_case(self_class)+"_id").to_sym
    end

  end

end

module Associatable

  def belongs_to(name, params = {})

    assoc_params = BelongsToAssocParams.new(name, params)

    self.define_method(name) do
      primary_key_query = %Q[SELECT #{assoc_params.foreign_key.to_s} FROM #{self.class.table_name}
                 WHERE id = ?;]
      primary_key_value = DBConnection.execute(primary_key_query, @id)[0].values[0]
      main_query = %Q[SELECT * FROM #{assoc_params.other_table_name}
                 WHERE #{assoc_params.primary_key.to_s} = ?;]
      results = DBConnection.execute(main_query, primary_key_value)
      assoc_params.other_class.new(results[0])
    end

  end

  def has_many(name, params = {})

    assoc_params = HasManyAssocParams.new(name, params, self.class.to_s)

    self.define_method(name) do
      primary_key_value = self.id
      query = %Q[SELECT * FROM #{assoc_params.other_table_name}
                WHERE #{assoc_params.foreign_key.to_s} = ?]
      results = DBConnection.execute(query, primary_key_value)
      assoc_params.other_class.parse_all(results)
    end

  end

  def has_one_through(name, assoc1, assoc2)
  end
end
