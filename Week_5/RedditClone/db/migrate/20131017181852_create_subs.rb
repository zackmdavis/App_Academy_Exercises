class CreateSubs < ActiveRecord::Migration
  def change
    create_table :subs do |t|
      t.string :name
      t.integer :mod_id

      t.timestamps
    end
    add_index :subs, :mod_id
  end
end
