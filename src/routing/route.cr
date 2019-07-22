abstract class Route
    def initialize()
    end
end

macro generateRouteClass(name, controller, controllermethod, controllerpath)
    require {{controllerpath}}
    class {{name.id}}Route < Route
        getter method, path, content_type

        def initialize(method : String, uripath : String, content_type : String)
            @method = method
            @path = uripath
            @content_type = content_type
        end

        def processRoute(context)
            method = context.request.method
            #Eventually create handlers for each of these depending on the
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

#Define Custom Routes here
generateRouteClass("Login", "LoginController", "generateView", "../controller/login_controller.cr")
generateRouteClass("FilePost", "Api" , "updateServer", "../api/api.cr")
