require 'active_support/inflector'

class Route
  attr_reader :pattern, :http_method, :controller_name, :action_name

  def initialize(http_method, pattern, controller_name, action_name)
    @http_method = http_method
    @pattern = pattern
    @controller_name = controller_name
    @action_name = action_name
  end

  def matches?(request)
    @pattern =~ request.path and @http_method == request.request_method.downcase.to_sym
  end

  def run(request, response)
    match = @pattern.match(request.path)
    route_params = {}
    match.names.each do |name|
      route_params[name] = match[name]
    end
    controller_name.constantize.new(request, response, route_params).invoke_action(action_name)
  end
end

class Router
  attr_reader :routes
  alias_method :draw, :instance_eval

  def initialize
    @routes = []
  end

  def add_route(route)
    @routes << route
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_name, action_name|
      add_route(Route.new(http_method, pattern, controller_name, action_name))
    end
  end

  def match(request)
    @routes.each.find { |route| route.matches?(request) }
  end

  def run(request, response)
    route = match(request)
    if route
      route.run(request, response)
    else
      response.status = 404
    end
  end

end
