class Response < ActiveRecord::Base
  attr_accessible :user_id, :answer_choice_id

  validates :user_id, :presence => true
  validates :answer_choice_id, :presence => true
  validate :respondent_has_not_already_answered_question
  validate :poll_author_cannot_answer_own_poll

  belongs_to :respondent,
             :primary_key => :id,
             :foreign_key => :user_id,
             :class_name => "User"

  belongs_to :answer_choice,
             :primary_key => :id,
             :foreign_key => :answer_choice_id,
             :class_name => "AnswerChoice"

  def poll_author_cannot_answer_own_poll
    poll_author_id = User.joins(:authored_polls =>
            {:questions => :answer_choices}).where('answer_choices.id = ?', self.answer_choice_id)[0].id
    if self.user_id == poll_author_id
      errors[:base] << "You can't respond to your own poll!!"
    end
  end

  def respondent_has_not_already_answered_question
    unless existing_responses.empty? or (existing_responses.length == 1 and existing_responses[0] == self.id)
      errors[:base] << "You can't answer the same question more than once!!"
    end
  end

  def existing_responses
    query  = %Q[
      SELECT responses.id
      FROM responses JOIN answer_choices ON responses.answer_choice_id = answer_choices.id
      WHERE answer_choices.question_id IN (SELECT questions.id
                                           FROM questions JOIN answer_choices
                                                        ON questions.id = answer_choices.question_id
                                           WHERE answer_choices.id = ?)
        AND responses.user_id = ?]
    Response.find_by_sql([query, self.answer_choice_id, self.user_id]).map { |obj| obj.id }
  end

end
