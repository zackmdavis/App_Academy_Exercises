class AddIndexToPolls < ActiveRecord::Migration
  def up
    add_index :polls, :author_id
  end

  def down
    remove_index :polls, :column => :author_id
  end
end
