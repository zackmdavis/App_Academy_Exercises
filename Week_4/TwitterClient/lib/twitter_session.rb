require 'singleton'
require 'oauth'
require 'launchy'
require 'yaml'
require './consumer_constants'

class TwitterSession

  attr_reader :access_token

  include Singleton
  include ConsumerConstants
  CONSUMER = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, :site => "https://twitter.com")
  TOKEN_SAVE_FILE = "saved_token.yaml"
  REQUEST_TOKEN = false

  def initialize
    @access_token = read_or_request_access_token
    p @access_token
    p @access_token.methods
  end

  def self.get(*args)
    self.instance.access_token.get(*args).body
  end

  def self.post(*args)
    self.instance.access_token.post(*args).body
  end

  def read_or_request_access_token
    if REQUEST_TOKEN
      request_token = CONSUMER.get_request_token
      authorize_url = request_token.authorize_url
      puts "Go to this URL: #{authorize_url}"
      Launchy.open(authorize_url)
      puts "Login, and type your verification code in"
      oauth_verifier = gets.chomp
      access_token = request_token.get_access_token(:oauth_verifier => oauth_verifier)
      File.open(TOKEN_SAVE_FILE, 'w').write(YAML::dump(access_token))
      return access_token
    else
      access_token = YAML::load(File.open(TOKEN_SAVE_FILE, 'r'))
      return access_token
    end
  end
end

ts = TwitterSession.instance

