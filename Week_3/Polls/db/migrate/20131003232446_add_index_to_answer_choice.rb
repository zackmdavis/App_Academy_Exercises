class AddIndexToAnswerChoice < ActiveRecord::Migration
  def change
    add_index :answer_choices, :question_id
  end
end
