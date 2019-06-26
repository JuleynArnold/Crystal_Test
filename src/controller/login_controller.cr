require "../../src/controller/controller.cr"

class LoginController < Controller
    def initialize(requestModule : String, body)
        #TODO: Eventually do something with the body
        @name = requestModule
        @content = Hash{"username" => "LBL_USERNAME", "password" => "LBL_PASSWORD", "actionRoute" => "authenticate"}
    end

    def content
        @content
    end

    def name
        @name
    end
end
