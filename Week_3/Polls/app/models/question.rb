class Question < ActiveRecord::Base
  attr_accessible :text, :poll_id

  validates :poll_id, :presence => true

  belongs_to :poll,
             :primary_key => :id,
             :foreign_key => :poll_id,
             :class_name => "Poll"

  has_many :answer_choices,
           :primary_key => :id,
           :foreign_key => :question_id,
           :class_name => "AnswerChoice"

  def results
    choices = answer_choices.includes(:responses)
    choices_counts = {}
    choices.each do |choice|
      choices_counts[choice.text] = choice.responses.length
    end
    choices_counts
  end
end
