class Array

  def my_each
    k = 0
    while k < self.length
      yield(self[k])
      k += 1
    end
  end

  def my_map
    [].tap do |arr|
      self.my_each do |el|
        arr << yield(el)
      end
    end
  end

  def my_map2(&prc)
    [].tap do |arr|
      self.my_each do |el|
        arr << prc.call(el)
      end
    end
  end

  def my_select
    [].tap do |arr|
      self.my_each do |el|
        arr << el if yield(el)
      end
    end
  end

  def my_reduce
    total = self[0]
    self[1..self.length].my_each do |el|
      total = yield(total, el)
    end
    total
  end

  def my_bubblesort!
    sorted = false
    until sorted
      sorted = true
      (0...self.length-1).to_a.my_each do |i|
        # function expects to take a block that returns 1
        # iff its arguments are out of order
        if yield(self[i], self[i+1]) == 1
          self[i], self[i+1] = self[i+1], self[i]
          sorted = false
        end
      end
    end
    self
  end

end

def args_to_block(*args, &prc)
  raise "no block given" if prc.nil?
  prc.call(args)
end

# my_array = [2,3,9,4,2,6,1]
# p my_array.my_bubblesort!{|n1, n2| n2 <=> n1}
# p my_array

