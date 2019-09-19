abstract class Route
    def initialize()
    end
end

macro generateRouteClass(name, controller, controllermethod, controllerpath)
    require {{controllerpath}}
    class {{name.id}}Route < Route
        getter method, path, content_type, requires_auth

        def initialize(method : String, uripath : String, content_type : String, requires_auth : Bool = false)
            @method = method
            @path = uripath
            @content_type = content_type
            @requires_auth = requires_auth
        end

        def processRoute(context)
            method = context.request.method
            #Eventually create handlers for each of these depending on the
            #Update: This may not be necesary at all given the way the routes are generated
            if method == "GET"
            elsif method == "POST"
            elsif method == "PUT"
            elsif method == "DELETE"
            end
            createdHandler = {{controller.id}}.new context
            return createdHandler.{{controllermethod.id}}
        end
    end
end
