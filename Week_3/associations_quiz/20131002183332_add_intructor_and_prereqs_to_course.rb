class AddIntructorAndPrereqsToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :instructor_id, :integer
    add_column :courses, :prereq_id, :integer
  end
end
