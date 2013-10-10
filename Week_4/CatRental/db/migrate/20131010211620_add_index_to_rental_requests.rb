class AddIndexToRentalRequests < ActiveRecord::Migration
  def change
    add_index :rental_requests, :cat_id
  end
end
