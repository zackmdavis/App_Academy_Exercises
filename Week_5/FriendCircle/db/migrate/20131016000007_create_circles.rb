class CreateCircles < ActiveRecord::Migration
  def change
    create_table :circles do |t|
      t.integer :user_id
      t.string :name

      t.timestamps
    end
  end
end
