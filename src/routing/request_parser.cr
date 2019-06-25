require "../view/view.cr"
require "../controller/controller.cr"
require "../controller/login_controller.cr"
require "./response.cr"

module RequestParser
    extend self
    def parse(request : HTTP::Request)
        body = request.body
        headers = request.headers

        if headers.has_key?("view")
            view = headers.get("view")
        end

        if headers.has_key?("module")
            requestModule = headers.get("module")
        end

        controller = LoginController.new "login", body
        viewer = View.new controller.name, controller.content

        response = Response.new "text/html", viewer.renderView()
        return response
    end

end
