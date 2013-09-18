class GuessingGame
  def self.play
    secret_number = rand(1..100)
    guess = -1
    number_guesses = 0
    while guess != secret_number
      puts "Enter a number which you think is the secret number"
      guess = gets.chomp.to_i
      number_guesses += 1
      if guess > secret_number
        puts "Too high!"
      elsif guess < secret_number
        puts "Too low!"
      else
        puts "That's correct! You are a good guesser!!!"
      end
    end
  end
end
