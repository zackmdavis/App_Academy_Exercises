require 'webrick'
require 'uri'
require 'json'

class Params
  def initialize(request, route_params)
    body_string = request.body
    query_string = request.query_string
    param_string = [body_string, query_string].join('&')
    @params = Params.parse_www_encoded_form(param_string)
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_json
  end

  def self.parse_www_encoded_form(query_style_string)
    raw_hash = WEBrick::HTTPUtils.parse_query(query_style_string)
    nesting_regexp = /\]\[|\[|\]/
    simple_hash = raw_hash.reject { |k, _| nesting_regexp =~ k }
    compound_hash =  raw_hash.select { |k, _| nesting_regexp =~ k }
    leveled_hash = {}
    compound_hash.each do |k, v|
      keys = k.split(nesting_regexp)
      level_hash = leveled_hash
      keys[0..-2].each do |key|
        level_hash[key] ||= {}
        level_hash = level_hash[key]
      end
      level_hash[keys[-1]] = v
    end
    simple_hash.merge(leveled_hash)
  end

end
