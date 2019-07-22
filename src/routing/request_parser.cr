require "./response.cr"
require "./route_handler.cr"


module RequestParser
    extend self
    def parse(context : HTTP::Server::Context)
        handler = RouteHandler.new
        route = context.request.path
        response = Response.new
        if (handler.findRoute route) == true
            processedRoute = handler.processRoute route, context
            routeResponseType = handler.getRouteResponseType route
            response = Response.new routeResponseType, processedRoute
        else
            puts "Did not find route"
        end
        return response
    end

end
