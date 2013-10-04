class User < ActiveRecord::Base
  attr_accessible :name

  has_many :authored_polls,
           :primary_key => :id,
           :foreign_key => :author_id,
           :class_name => "Poll"

  has_many :responses,
           :primary_key => :id,
           :foreign_key => :user_id,
           :class_name => "Response"


  # BROKEN
  def completed_poll_ids

    choice_ids = responses.map { |r| r.answer_choice_id }

    polls = Poll.includes(:questions => :answer_choices)
    completed_ids = []
    polls.each do |p|
      completed = true
      p.questions do |q|
        if q.answer_choices.map { |c| c.id } & choice_ids == []
          completed = false
        end
      end
      if completed
        completed_poll_ids.push(p.id)
      end
    end
    completed_ids
  end

end
