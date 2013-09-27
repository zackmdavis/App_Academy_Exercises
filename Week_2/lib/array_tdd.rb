class Array
  def my_uniq
    uniques = []
    self.each do |el|
      unless uniques.include?(el)
        uniques.push(el)
      end
    end
    uniques
  end

  def two_sum
    zero_pairs = []
    (0...self.length-1).each do |i|
      (i+1...self.length).each do |j|
       if self[i] + self[j] == 0
         zero_pairs << [i, j]
       end
      end
    end
    zero_pairs
  end

  def my_transpose
    (0...self.length).map { |index| col(self, index)}
  end

  def col(matrix, j)
    matrix.map {|row| row[j]}
  end

  def stock_picker
    best_profit = 0
    best_days = [nil, nil]
    (0...self.length-1).each do |i|
      (i+1...self.length).each do |j|
        if self[j] - self[i] > best_profit
          best_profit = self[j] - self[i]
          best_days = [i, j]
        end
      end
    end
    best_days
  end

end
