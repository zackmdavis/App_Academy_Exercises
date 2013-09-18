class MastermindGame

  NUMBER_OF_PEGS = 4
  MAXIMUM_GUESSES = 12

  def initialize
    @previous_results = []
    @last_guess = nil
    @last_result = nil
    @guesser = GuessingPlayer.new
    @master = MasterPlayer.new(NUMBER_OF_PEGS)
    @game_over = false
  end

  def play
    until @game_over
      display_previous_guesses
      @last_guess = @guesser.make_guess
      @last_result = @master.check(@last_guess)
      @previous_results << [@last_guess, @last_result]
      win_message if guesser_win?
      lose_message if out_of_guesses?
    end
  end

  private

  def display_previous_guesses
    @previous_results.each do |result|
      puts result[0].join(' ') + " | #{result[1][:exact]} #{result[1][:color_only]}"
    end
    puts ''
  end


  def win_message
    puts "You guessed my secret!! You win."
    @game_over = true
  end

  def lose_message
    puts "You've taken too long.  The secret is mine forever!!!!!!!!!"
    sleep 1
    puts "..."
    sleep 1
    puts "No, I guess you deserve to know, after all"
    secret = @master.secret.join
    puts "The secret is #{secret}"
    @game_over = true
  end

  def guesser_win?
    @last_result[:exact] == NUMBER_OF_PEGS
  end

  def out_of_guesses?
    @previous_results.length == MAXIMUM_GUESSES
  end
end


class GuessingPlayer
  def initialize
  end

  def make_guess
    puts  "Enter your guess!"
    guess = gets.chomp
    guess.upcase.split('')
  end

end

class MasterPlayer

  attr_reader :secret

  PEG_COLORS = 'ROYGBIV'

  def initialize(num_pegs)
    @number_of_pegs = num_pegs
    @secret = invent_secret
  end

  def invent_secret
    secret = []
    @number_of_pegs.times do
      secret << PEG_COLORS[rand(0...PEG_COLORS.length)]
    end
    secret
  end

  def check(guess)
    exact_indices = check_exact(guess)
    color_only = check_color_only(guess, exact_indices)
    result = { :exact => exact_indices.length, :color_only => color_only }
  end


  private

  def check_exact(guess)
    exact_indices = []
    guess.each_with_index do |guess_el, i|
      if guess_el == @secret[i]
        exact_indices << i
      end
    end
    exact_indices
  end

  def check_color_only(guess, exact_indices)
    nonexact_indices = (0...@number_of_pegs).to_a - exact_indices
    unmatched_secret = nonexact_indices.map { |i| @secret[i] }
    unmatched_guess = nonexact_indices.map{ |i| guess[i] }

    color_matches = 0
    unmatched_guess.each do |guess_peg|
      if unmatched_secret.include?(guess_peg)
        color_matches += 1
        unmatched_secret.delete_at(unmatched_secret.index(guess_peg))
      end
    end
    color_matches
  end

end

if __FILE__ == $PROGRAM_NAME
  game = MastermindGame.new
  game.play
end