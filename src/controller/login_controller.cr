require "../../src/controller/controller.cr"

class LoginController < Controller
    def initialize(context : HTTP::Server::Context)
        @context = context
        @content = Hash{"username" => "LBL_USERNAME", "password" => "LBL_PASSWORD", "actionRoute" => "authenticate"}
        @name = "Login"
    end

    def generateView()
        #Something create new view or pass in view have not decided
        view = LoginView.new(@content)
        return view.renderView()
    end

    def content
        @content
    end

    def context
        @context
    end

    def name
        @name
    end
end
