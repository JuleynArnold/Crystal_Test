require "./route.cr"

class RouteHandler
    property routes

    def initialize()
        @routes = Hash(String, Route).new
        #Routes
        @routes["/"] = LoginRoute.new "GET", "/", "text/html"

        #API Routes (TODO: find some way to version the path)
        @routes["/api/v1/file"] = FilePostRoute.new "POST", "/api/v1/file", "application/json"
        #@routes[""] = Route.new "GET", "/api/v1/file", "../api/api.cr@updateClient"
        #@routes[""] = Route.new "POST", "/authenticate", "../api/api.cr@authenticate"
    end

    def addRoute(name, controller, controllermethod, httpmethod, uri)

    end

    def findRoute(route : String)
        if @routes[route].is_a?(Route)
            return true
        else
            #Exception message
            return false
        end
    end

    def getRouteResponseType(route : String)
        return @routes[route].content_type
    end

    def processRoute(route : String, context : HTTP::Server::Context)
        #TODO: Ensure that the context request is the content type the route is expecting.
        return @routes[route].processRoute(context)
    end
end
