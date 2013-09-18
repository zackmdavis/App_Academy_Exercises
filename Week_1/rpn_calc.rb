class RpnCalc

  def initialize
    @stack = []
    @operations = { "+" => :add, "-" => :subtract, "*" => :multiply, "/" => :divide }
  end

  def input(chars)
    if @operations.include? chars
      self.send(@operations[chars])
    else
      @stack.push(chars.to_i)
    end
  end

  def push_number(n)
    @stack.push(n)
  end

  def show_stack
    print @stack, "\n"
  end

  def add
    if check_stack
      summand1 = @stack.pop
      summand2 = @stack.pop
      @stack.push(summand1 + summand2)
    end
  end

  def subtract
    if check_stack
      subtrahend = @stack.pop
      minuhend = @stack.pop
      @stack.push(minuhend - subtrahend)
    end
  end

  def multiply
    if check_stack
      factor1 = @stack.pop
      factor2 = @stack.pop
      @stack.push(factor1*factor2)
    end
  end

  def divide
    if check_stack
      divisor = @stack.pop
      dividend = @stack.pop
      @stack.push(dividend/divisor)
    end
  end

  def check_stack
    if @stack.length < 2
      puts "Not enough values on the stack"
      false
    else
      true
    end
  end

end

class RpnLive
  def self.run
    calc = RpnCalc.new
    while true
      user_input = gets.chomp
      calc.input(user_input)
      calc.show_stack
    end
  end
end

class RpnFile
  def self.run(file)
    commands = File.read(file)
    commands = commands.split(' ')
    calc = RpnCalc.new
    commands.each do |command|
      calc.input(command)
      calc.show_stack
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  unless ARGV.empty?
    RpnFile.run(ARGV[0])
  else
    RpnLive.run
  end
end