require "../../routes.cr"

class RouteHandler
    property routes

    def initialize()
        @routes = Hash(String, Route).new
        #Routes
        @routes["/"] = LoginRoute.new "GET", "/", "text/html", false

        #API Routes (TODO: find some way to version the path)
        @routes["/generateSession"] = GenerateSessionRoute.new "POST", "/generateSession", "application/json", false
        @routes["/file"] = FilePostRoute.new "POST", "/file", "application/json", true
        #@routes[""] = Route.new "GET", "/v1/file", "../api/api.cr@updateClient"
        @routes["/authenticate"] = AuthenticateRoute.new "POST", "/authenticate", "application/json", false
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
