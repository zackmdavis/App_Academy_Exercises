require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'

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
    controller_name = self.class.to_s.underscore.gsub('_controller', '')
    p controller_name
    template = File.read("views/#{controller_name}/#{template_name}.html.erb")
    content = ERB.new(template).result(binding)
    render_content(content, 'html')
  end

  def invoke_action(name)
  end
end
