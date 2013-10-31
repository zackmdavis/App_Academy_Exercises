class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :paste_id
      t.integer :user_id

      t.timestamps
    end

    add_index :favorites, :user_id
    add_index :favorites, :paste_id
  end
end
