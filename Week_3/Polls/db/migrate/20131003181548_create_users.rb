class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :limit => 40

      t.timestamps
    end
  end
end
