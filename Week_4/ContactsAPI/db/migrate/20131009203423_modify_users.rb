class ModifyUsers < ActiveRecord::Migration
  def change
    add_index :users, :email
    change_column(:users, :name, :string, :null => false)
    change_column(:users, :email, :string, :null => false)
  end
end
