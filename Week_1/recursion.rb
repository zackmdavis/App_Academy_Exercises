def range(first, last)
  if (first == last)
    return [first]
  else
    return [first] + range(first + 1, last)
  end

end

class Array

  def sum_recursive
    if self.length == 0
      return 0
    elsif self.length == 1
      return self[0]
    else
      return self[0] + self[1...self.length].sum_recursive
    end
  end

  def sum_iterative
    sum = 0
    self.each do |n|
      sum += n
    end
    sum
  end

end

def expt_dumb(base, exp)
  if exp == 0
    return 1
  else
    return base*expt_dumb(base, exp-1)
  end
end

def expt_smart(base, exp)
  # O(lg "exp") multiplications --- more efficient!
  if exp == 0
    return 1
  elsif exp % 2 == 0
    n = expt_smart(base, exp/2)
    return n * n
  else
    n = expt_smart(base, (exp-1)/2)
    return base * n * n
  end
end

class Array

  def deep_dup
    arr = []
    self.each do |el|
      if el.is_a?(Array)
        arr << el.deep_dup
      else
        arr << el
      end
    end
    arr
  end

end

# 0 1 1 2 3 5 8

# def fib_recursive(n)
#   if n == 0
#     return 0
#   elsif
#     return 1
#   else
#     return fib(n-1) + fib(n-2)
# end
#
# def fibs_array(m)
#   (0..m).map{|i| fib_recursive(i)}
# end

def fibs_recursive(n)
  if n == 0
    return []
  elsif n == 1
    return [0]
  elsif n == 2
    return [0, 1]
  else
    prev = fibs_recursive(n-1)
    return prev + [prev[-1]+prev[-2]]
  end
end

def fibs_iterative(n)
  if n == 0
    return []
  elsif n == 1
    return [0]
  else
    fibs = [0, 1]
    (n-2).times do
      fibs << fibs[-1] + fibs[-2]
    end
    return fibs
  end
end

def binary_search(array, first, last, target)
  middle = (last - first)/2 + first
  middle_val = array[middle]
  if middle_val == target
    return middle
  elsif middle_val < target
    return binary_search(array, middle + 1, array.length-1, target)
  else
    return binary_search(array, 0, middle, target)
  end
end

def binary_search2(array, target)
  middle = array.length/2
  middle_val = array[middle]
  if middle_val == target
    return middle
  elsif middle_val < target
    return middle + 1 + binary_search2(array[middle + 1..array.length-1], target)
  else
    return binary_search2(array[0...middle], target)
  end
end


def make_change(amount, denominations = [25, 10, 5, 1])
  # take the largest element of denominations less or equal to than amount
  # appended with recursive call to same
  # this "greedy" algorithm gives correct change, but not optimal change
  if amount == 0
    return []
  else
    next_coin = denominations.select{|n| n <= amount}[0]
    [next_coin] + make_change(amount-next_coin)
  end
end

class Array
  def self.my_merge(left, right)
    merged = []
    until left.empty? && right.empty?
      if left.empty? || right.empty?
        merged += left + right
        return merged
      elsif (left[0] < right[0])
        merged << left.shift
      else
        merged << right.shift
      end
    end
    merged
  end

  def my_mergesort
    if self.length <= 1
      return self
    else
      middle = self.length/2
      left = self[0...middle].my_mergesort
      right = self[middle...self.length].my_mergesort
      return Array.my_merge(left, right)
    end
  end

end

def subsets(set)
  # P{S U {t}} = P{S} U {s U {t} | s >= P(S)}
  # id est, the powerset of the union of the set S and the singleton set {t} ...
  # equals the union of the powerset of S with
  # the sets s U {t} for all s in the the powerset of S
  if set.count == 0
    return [[]]
  else
    small = set.last
    return subsets(set[0...set.length-1]) +
     subsets(set[0...set.length-1]).map{|s| s + [small]}
  end
end

