require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @request = req
    @response = res
    @already_built_response = false
  end

  def session
  end

  def already_rendered?
    @already_built_response
  end

  def redirect_to(url)
    @response.status = 302
    @response["Location"] = url
    @already_built_response = true
  end

  def render_content(content, type)
    @response.content_type = type
    @response.body = content
    @already_built_response = true
  end

  def render(template_name)
  end

  def invoke_action(name)
  end
end
