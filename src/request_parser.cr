require "../src/view/view.cr"
require "../src/controller/controller.cr"
require "../src/controller/login_controller.cr"

module RequestParser
    extend self
    def parse(request : HTTP::Request)
        body = request.body
        headers = request.headers

        view = request.headers.get("view")
        requestModule = request.headers.get("module")

        puts view

        if view == Nil || view == ""
            #Default to login screen for now.
            viewer = View.new "login"
            controller = LoginController.new "login"
        else
            controller = Controller.new requestModule
            viewer = View.new view controller.content
        end


    end

end
