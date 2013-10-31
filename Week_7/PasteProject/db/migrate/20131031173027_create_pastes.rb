class CreatePastes < ActiveRecord::Migration
  def change
    create_table :pastes do |t|
      t.string :title
      t.integer :owner_id
      t.text :body

      t.timestamps
    end
    add_index :pastes, :owner_id
  end
end
