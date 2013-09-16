def correct_hash(wrong_hash)
  fixed_hash = {}
  wrong_hash.each{|key,value| fixed_hash[(key.to_s.ord+1).chr.to_sym] = value }
  fixed_hash
end

p correct_hash({ :a => "banana", :b => "cabbage", :c => "dental_floss", :d => "eel_sushi" })