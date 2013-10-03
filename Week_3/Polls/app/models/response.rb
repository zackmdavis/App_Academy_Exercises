class Response < ActiveRecord::Base
  attr_accessible :user_id, :answer_choice_id

  validates :user_id, :presence => true
  validates :answer_choice_id, :presence => true

  belongs_to :respondent, :primary_key => :id, :foreign_key => :user_id, :class_name => "User"

  belongs_to :answer_choice, :primary_key => :id, :foreign_key => :answer_choice_id, :class_name => "AnswerChoice"
end
