def factors(num)
  factor_array = []
  (1..Math.sqrt(num).floor).each do |x|
    if num%x == 0
      factor_array << x
      factor_array << num/x
    end
  end
  factor_array.sort
end