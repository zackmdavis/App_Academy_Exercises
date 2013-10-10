module RentalRequestsHelper

  def date_helper(date_hash)
    months = %w(January February March April May June July August September October November December)
    month_as_number = months.index(date_hash[:month]) + 1
    Date.new(date_hash[:year].to_i, month_as_number, date_hash[:day].to_i)
  end

end
