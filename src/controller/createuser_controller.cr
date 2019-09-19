require "../../src/controller/controller.cr"
require "crystal-argon2"
class CreateUserController < Controller
    def initialize(context : HTTP::Server::Context)
        @context = context
    end

    def createUser()
        db = Database.new
        formData = Hash(String, String).new
        HTTP::FormData.parse(@context.request) do |part|
           formData[part.name] = part.body.gets_to_end
        end
        username = formData["username"]
        password = formData["password"]
        hasher = Argon2::Password.new(t_cost: 2, m_cost: 16)
        passwordHashed = hasher.create(password)
        userbasefilepath = Random::Secure.base64(20)
        parameters = {username: username, password: passwordHashed, basefilepath: userbasefilepath}
        db.pquery("INSERT INTO Users (username, password, basefilepath), VALUES (?,?,?,?)", parameters)
        fork do
            system "mkdir storage/" + userbasefilepath
        end
        return {success: true, message: "User Created"}.to_json
    end

    def context
        @context
    end

    def name
        @name
    end
end
