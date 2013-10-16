require 'json'
require 'webrick'

class Session
  def initialize(request)
    previous_cookie = request.cookies.find{ |cookie| cookie.name == "wires_app" }
    if previous_cookie.nil?
      @session_hash = {}
    else
      @session_hash = JSON.parse(previous_cookie.value)
    end
  end

  def [](key)
    @session_hash[key]
  end

  def []=(key, value)
    @session_hash[key] = value
  end

  def store_session(response)
    session_json = @session_hash.to_json
    cookie = WEBrick::Cookie.new("wires_app", session_json)
    response.cookies << cookie
  end
end
