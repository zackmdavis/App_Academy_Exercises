def bubble_sort(array)
  (array.length-1).times do
    (0...array.length-1).each do |i|
      if array[i] > array[i+1]
        array[i], array[i+1] = array[i+1], array[i]
      end
    end
  end
  array
end