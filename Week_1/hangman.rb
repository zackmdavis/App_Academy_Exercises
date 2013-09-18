class HangmanGame
  def initialize
    @stickman = Stickman.new
    @rejected_guesses = []
    setup
    play
  end

  def setup
    puts "How many human players?"
    humans = gets.chomp.to_i
    if humans == 1
      puts "Would you like to be the 1) hangman or the 2) condemned?"
      player_role = gets.chomp.to_i
      if player_role == 1
        @hangman = HumanHangman.new
        @condemned = ComputerCondemned.new
      else
        @hangman = ComputerHangman.new
        @condemned = HumanCondemned.new
      end
    elsif humans == 2
      @hangman = HumanHangman.new
      @condemned = HumanCondemned.new
    else
      @hangman = ComputerHangman.new
      @condemned = ComputerCondemned.new
    end
    @hangman.make_secret
    @revealed = '_'*@hangman.secret_length
  end

  def play
    while @stickman.still_alive? and @revealed.include?('_')
      @stickman.display
      puts @revealed
      puts "failed guesses: #{@rejected_guesses.join(' ')}"
      guess = @condemned.guess(@revealed)
      locations = @hangman.check(guess) # list of indices where guess appears
      if locations.empty?
        @stickman.add_part
        @rejected_guesses << guess
      else
        locations.each do |i|
          @revealed[i] = guess
        end
      end
    end
    if @stickman.still_alive?
      puts @revealed
      puts "The word has been guessed; the prisoner shall live another day"
    else
      @stickman.display
      puts "The word was not guessed; the prisoner is dead"
    end
	end

end

class Stickman
  #  |--|
  #  0  |
  # /T\ |
  # / \ |
  # ____|

  def initialize
    @parts = [['O',1,1],['T',2,1], ['/', 2, 0], ["\\", 2, 2], ['/', 3, 0], ["\\", 3, 2]]
    @illustration = [[' ', '|', '-', '-', '|'],
                     [' ', ' ', ' ', ' ', '|'],
                     [' ', ' ', ' ', ' ', '|'],
                     [' ', ' ', ' ', ' ', '|'],
                     ['_', '_', '_', '_', '|']]


  end

  def add_part
    part, i, j = @parts.shift
    @illustration[i][j] = part
  end

  def display
    @illustration.each do |line|
      puts line.join
    end
    puts
  end

  def still_alive?
    !@parts.empty?
  end
end

class HumanHangman
  attr_accessor :secret_length

  def make_secret
    puts "Come up with a secret word!"
    puts "What length is your secret word?"
    @secret_length = gets.chomp.to_i
  end

  def check(guess)
    puts "The guess was the letter #{guess}"
    puts "Input indices at which this letter appears in the secret word, separated by only commas"
    gets.chomp.split(',').map{|c| c.to_i-1}
  end
end

class ComputerHangman
  attr_reader :secret_length

  def make_secret
    @secret = File.readlines('dictionary.txt').sample.chomp.upcase
    make_secret if @secret.include?('-')
    @secret_length = @secret.length
  end

  def check(guess)
    locations = []
    @secret.split('').each_with_index do |letter, i|
      if letter == guess
        locations << i
      end
    end
    locations
  end
end

class HumanCondemned
  def guess(revealed)
    puts "Guess a letter: "
    gets.chomp.upcase
  end
end

class ComputerCondemned
  attr_accessor :previous_guesses
  def initialize
    @previous_guesses =[]
    @words = File.readlines('dictionary.txt').map(&:chomp).map(&:upcase)
  end

  def dumb_guess
    try = ('a'..'z').to_a.sample
    while @previous_guesses.include?(try)
      try = ('a'..'z').to_a.sample
    end

    @previous_guesses << try
    try
  end

  def guess(revealed)
    rejected_letters = infer_rejected_letters(revealed)
    update_words(revealed, rejected_letters)
    all_letters = @words.join.split('').select do |letter|
      !@previous_guesses.include?(letter)
    end
    letter_frequencies = all_letters.reduce(Hash.new(0)) do |hash, chr|
      hash[chr] += 1
      hash
    end
    next_guess = letter_frequencies.sort_by{ |_, v| v}.last[0]
    @previous_guesses << next_guess
    next_guess
  end

  private

  def infer_rejected_letters(revealed)
    @previous_guesses.select do |letter|
      !revealed.include?(letter)
    end
  end

  def pattern_match?(word, matcher)
    matcher =~ word ? true : false
  end

  def update_words(revealed, rejected_letters)
    matcher = Regexp.new('\A'+revealed.gsub('_', '\w')+'\Z')
    @words.select! do |word|
      pattern_match?(word, matcher) and rejected_letters.none?{|l| word.include?(l)}
    end
  end

end

game = HangmanGame.new
