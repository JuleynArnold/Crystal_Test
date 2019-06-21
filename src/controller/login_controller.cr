require "../../src/controller/controller.cr"

class LoginController < Controller
    def initialize(body)
        #TODO: Eventually do something with the body
        @content["username"] = "LBL_USERNAME"
        @content["password"] = "LBL_PASSWORD"
    end

    def content
        @content = Array.new of String
    end
end
