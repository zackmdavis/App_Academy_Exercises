require 'rspec'
require 'array_tdd.rb'

describe "#my_uniq" do

  subject(:test_array) { [1, 2, 2, 2, 5, 3, 8, 9, 8, 3] }

  it "should not contain more than one of any element" do
    counter = Hash.new(0)
    test_array.my_uniq.each do |el|
      counter[el] += 1
    end
    counter.values.max.should <= 1
  end
end


describe "#two_sum" do

  subject(:test_array) { [1, 0, 3, 0, -1, -3, 8] }
  it "should find all the pairs that sum to zero" do
    test_array.two_sum.should == [[0,4], [1,3], [2,5]]
  end

end

describe "#my_transpose" do

  subject(:test_array) { [[0,1,2], [3,4,5], [6,7,8]] }

  it "returns the transposed array" do
    (0...test_array.length).each do |i|
      (i...test_array.length).each do |j|
        test_array.transpose[i][j].should == test_array[j][i]
      end
    end
  end
end

describe "#stock_picker" do

  subject(:test_array) { [100, 120, 90, 150, 200] }

  it "chooses the best pair of days to buy and sell" do
    test_array.stock_picker.should == [2, 4]
  end

end
