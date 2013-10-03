class AddIndicesToResponse < ActiveRecord::Migration
  def up
    add_index :responses, :user_id
    add_index :responses, :answer_choice_id
  end

  def down
    remove_index :responses, :column => :user_id
    remove_index :responses, :column => :answer_choice_id
  end
end
