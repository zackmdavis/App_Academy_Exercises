class CreateFavorites < ActiveRecord::Migration
  def change
    add_column :contacts, :favorite, :boolean
  end
end
