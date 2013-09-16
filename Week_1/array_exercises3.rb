class Matrix
  def initialize(array_of_arrays)
    @matrix = array_of_arrays
  end

  def column(j)
    @matrix.map{|row| row[j]}
  end

  def display
    @matrix.each do |row|
      print row
    end
    print "\n"
  end

  def transpose
    Matrix.new((0...@matrix.length).map{|j| column(j)})
  end
end

my_matrix = Matrix.new([[1,2,3],[4,5,6],[7,8,9]])
my_other_matrix = my_matrix.transpose
my_other_matrix.display