require "../../routes.cr"

class RouteHandler
    property routes

    def initialize()
        @routes = Hash(String, Route).new
        #Routes
        @routes["/"] = LoginRoute.new "GET", "/", "text/html", false

        #API Routes (TODO: find some way to version the path)
        @routes["/createuser"] = CreateUserRoute.new "POST", "/createuser", "application/json", false
        @routes["/authenticate"] = AuthenticateRoute.new "POST", "/authenticate", "application/json", false
        @routes["/file"] = FilePostRoute.new "POST", "/file", "application/json", true
        @routes["/authorize"] = AuthorizeRoute.new "POST", "/authorize", "application/json", true
        @routes["/sync"] = FileGetRoute.new "GET", "/sync", "*/*", true
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
