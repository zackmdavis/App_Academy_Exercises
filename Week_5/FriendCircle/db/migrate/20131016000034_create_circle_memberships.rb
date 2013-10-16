class CreateCircleMemberships < ActiveRecord::Migration
  def change
    create_table :circle_memberships do |t|
      t.integer :circled_id
      t.integer :circle_id

      t.timestamps
    end
  end
end
