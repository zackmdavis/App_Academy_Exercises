class AddCourses < ActiveRecord::Migration
  def up
    create_table :courses do |t|
      t.string :title
    end
  end

  def down
    drop_table :courses
  end
end
