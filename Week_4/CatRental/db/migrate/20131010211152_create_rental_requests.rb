class CreateRentalRequests < ActiveRecord::Migration
  def change
    create_table :rental_requests do |t|
      t.integer :cat_id
      t.date :start_date
      t.date :end_date
      t.string :status, {default: "PENDING"}
      t.timestamps
    end
  end
end
