def num_to_s(num,base)
  digits = []
  convert = {}
  remainders = (0..15).to_a
  characters = ('0'..'9').to_a+('A'..'F').to_a
  remainders.zip(characters).each do |pair|
    convert[pair[0]] = pair[1]
  end

  quotient = num
  until quotient == 0
    quotient,remainder = quotient.divmod(base)
    digits << convert[remainder]
  end
  digits.reverse.reduce(:+)
end

p num_to_s(5, 10) #=> "5"
p num_to_s(5, 2)  #=> "101"
p num_to_s(5, 16) #=> "5"

p num_to_s(234, 10) #=> "234"
p num_to_s(234, 2)  #=> "11101010"
p num_to_s(234, 16) #=> "EA"