class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :user_id
      t.integer :answer_choice_id

      t.timestamps
    end
  end
end
