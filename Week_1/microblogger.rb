require 'jumpstart_auth'
require 'bitly'

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing"
    @client = JumpstartAuth.twitter
    puts "Welcome to the Twitter client!"
    puts "Here's what your friends have said recently---"
    everyones_last_tweet
    Bitly.use_api_version_3
  end

  def run
    command = ""
    while command != "q"
      puts
      printf "enter command:"
      input = gets.chomp
      parts = input.split
      command = parts[0]
      case command
        when 'q' then puts "Presumably you are done tweeting. Goodbye!"
        when 't' then tweet(parts[1..-1].join(" "))
        when 'turl' then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
        else
          puts "I don't understand that command."
      end
    end
  end

  def tweet(message)
    if message.length <= 140
      @client.update(message)
    else
      puts "The message is too long and cannot be tweeted"
    end
  end

  def everyones_last_tweet
    friends = @client.friends.sort_by!{|f| f.name.downcase}
    friends.each do |friend|
      puts "#{friend.name} said:"
      if friend.status
        puts "#{friend.status.text}"
      else
        puts "{No recent tweets}"
      end
      puts
    end
  end

  def shorten(url)
    bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
    short = bitly.shorten(url).short_url
    puts "shortening #{url}"
    puts short
    short
  end

end

b = MicroBlogger.new
b.run