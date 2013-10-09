class ModifyContacts < ActiveRecord::Migration
  def change
    add_index :contacts, :email
    add_index :contacts, :user_id
    change_column :contacts, :name, :string, :null => false
    change_column :contacts, :email, :string, :null => false
    change_column :contacts, :user_id, :integer, :null => false
  end
end
