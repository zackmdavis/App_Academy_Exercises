class CreateCats < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.string :name
      t.integer :age
      t.string :birth_date
      t.string :color
      t.string :string
      t.string :sex
      t.timestamps
    end
  end
end
