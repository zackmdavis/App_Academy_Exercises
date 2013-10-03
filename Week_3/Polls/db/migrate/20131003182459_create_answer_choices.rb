class CreateAnswerChoices < ActiveRecord::Migration
  def change
    create_table :answer_choices do |t|
      t.string :text, :limit => 200
      t.integer :question_id

      t.timestamps
    end
  end
end
