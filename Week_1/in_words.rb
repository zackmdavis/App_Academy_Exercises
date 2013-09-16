class Fixnum

  def in_words

    def convert_triple(triple)
      i_digits = (1..9).to_a
      s_digits = ["one", "two", "three", "four",
        "five", "six", "seven", "eight", "nine"]
      digit_pairs = i_digits.zip(s_digits)
      digit_translate = {}
      digit_pairs.each do |num, word|
        digit_translate[num] = word
      end
      words = []
       hundreds_digit, tens_and_ones = triple.divmod(100)
       unless hundreds_digit == 0
         words << digit_translate[hundreds_digit] + " hundred"
       end
       teens = {10 => "ten", 11 => "eleven", 12 => "twelve", 13 => "thirteen",
         14 => "fourteen", 15 => "fifteen", 16 => "sixteen", 17 => "seventeen",
         18 => "eighteen", 19 => "nineteen"}
         tens_place = {20 => "twenty", 30 => "thirty", 40 => "forty",
           50 => "fifty", 60 => "sixty", 70 => "seventy", 80 => "eighty",
           90 => "ninety"}
      unless tens_and_ones == 0
        if tens_and_ones < 10
         words << digit_translate[tens_and_ones]
        elsif tens_and_ones < 20
           words << teens[tens_and_ones]
        else
           tens, ones = tens_and_ones.divmod(10)
           words << tens_place[tens*10]
           words << digit_translate[ones] unless ones == 0
        end
      end
      words.join(' ')
    end

    return "zero" if self == 0

    triples = []
    quotient = self
    until quotient == 0 do
      quotient, remainder = quotient.divmod(1000)
      triples << remainder
    end
    triples_words = triples.map{|t| convert_triple(t)}
    endings = ['', " thousand", " million", " billion", " trillion", " quadrillion"]
    result = []
    triples_words.each_with_index do |t,index|
      unless t.empty?
        result << t + endings[index]
      end
    end
    return result.reverse.join(" ")
  end
end
