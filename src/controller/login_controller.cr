require "../../src/controller/controller.cr"

class LoginController < Controller
    def content
        @content
    end

    def name
        @name
    end

    def initialize(requestModule : String, body)
        #TODO: Eventually do something with the body
        @content = Hash(String, String).new
        @content["username"] = "LBL_USERNAME"
        @content["password"] = "LBL_PASSWORD"
        @content["actionRoute"] = "authenticate"
        @name = requestModule
    end
end
