class Question < ActiveRecord::Base
  attr_accessible :text, :poll_id

  validates :poll_id, :presence => true

  belongs_to :poll, :primary_key => :id, :foreign_key => :poll_id, :class_name => "Poll"

  has_many :answer_choices, :primary_key => :id, :foreign_key => :question_id, :class_name => "AnswerChoice"
end
