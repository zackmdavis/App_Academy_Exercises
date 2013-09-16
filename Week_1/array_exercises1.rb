class Array
  # filter for uniqueness
	def my_uniq
		uniques = []
		self.each do |i|
			unless uniques.include?(i)
				uniques.push(i)
			end
		end
		uniques
	end
end

# testing my_uniq
#my_array = [7,1,2,3,7,3,4,3,2]
#print my_array.my_uniq


class Array
  # return positions of pairs of elements that sum to zero
	def two_sum
		positions = []
		(0...self.length).each do |i|
			(i+1...self.length).each do |j|
				if self[i] + self[j] == 0
					positions.push([i,j])
				end
			end
		end
		positions
	end
end

# testing two_sum
#p [-1, 0, 2, -2, 1].two_sum

