def encodeword(word, shift)
  encoded = ""
  word.each_byte do |char|
    encoded += (((char-97+shift) % 26) + 97).chr
  end
  encoded
end

def cipher(text,shift)
  words = text.split(" ")
  encoded_words = words.map{|word| encodeword(word,shift)}
  encoded_text = encoded_words.join(" ")
end

p cipher("hello",3)
p cipher("this is a test",0)
p cipher("i used to wonder what friendship could be", -4)

