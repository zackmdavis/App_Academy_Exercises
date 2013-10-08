class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.integer :twitter_status_id, :null  => false
      t.integer :twitter_user_id, :null  => false
      t.string :body, :null  => false

      t.timestamps
    end

    add_index :statuses, :twitter_status_id, :uniqueness => true
    add_index :statuses, :twitter_user_id
  end
end
