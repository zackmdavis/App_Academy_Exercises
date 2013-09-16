def times_two(array)
  array.map{|e| 2*e}
end

class Array
  def my_each
    k = 0
    while k < self.length
      yield self[k]
      k += 1
    end
  end

  def median
    sorted = self.sort
    if sorted.length % 2 == 0
      (sorted[sorted.length/2 - 1]+sorted[sorted.length/2]).to_f/2
    else
      sorted[sorted.length/2]
    end
  end

  def cat
    self.reduce(:+)
  end
end

my_array = [1,3,5,6]
other_array = [4,5,2]

my_array.my_each{|element| puts 3*element}
puts my_array.median
puts other_array.median

puts ["Hello ", "World", "!"].cat