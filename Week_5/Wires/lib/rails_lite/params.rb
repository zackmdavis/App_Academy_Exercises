require 'uri'
require 'json'

class Params
  def initialize(request, route_params)
    @params = request.query
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_json
  end

  # private
  # def parse_from_url(url)
  #   query_string = url.split('?')[1]
  #   params_array URI.decode_www_form(query_string)
  #   @params = {}
  #   @params = params_array.each do |k, v|
  #     @params[k] = v
  #   end
  #   @params
  # end
  #
  # def parse_key(key)
  # end
end
