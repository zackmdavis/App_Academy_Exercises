class AddEnrollments < ActiveRecord::Migration
  def up
    create_table :enrollments do |t|
      t.integer :user_id
      t.integer :course_id

      t.timestamps
    end
  end

  def down
    drop_table :enrollments
  end
end
