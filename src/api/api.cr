require "../utils/file.cr"
require "../utils/credentials.cr"
require "json"
require "jwt"
require "crystal-argon2"

class Api

    def initialize(context : HTTP::Server::Context)
        @context = context
    end

    #
    def updateClient()

    end

    def updateServer()
        user = Credentials.retrieveUser @context.request.headers["Authorization"]
        #Iterate through form data and
        HTTP::FormData.parse(@context.request) do |part|
           filedata = part.body.gets_to_end
           filename = part.filename
           path = FileIO.writeFile(filename, filedata, user["basepath"])
           FileIO.fileEncrypt(filename, path, user["password"])
       end
        json = {success: true}.to_json
        return json
    end

    #
    def uploadFile()
    end

    #
    def downloadFile()

    end

    def authenticate()
        #Ensure sessionID 1ist still valid
        token = @context.request.headers["Authorization"]
        if token.empty? == false
            payload, header = JWT.decode(@context.request.headers["Authorization"], ENV["APP_SECRET"], JWT::Algorithm::HS256)
            if (Credentials.verifySessionID payload["sessionid"]) == true
                return {success: true}.to_json
            else
                return {success: false, message: "Session ID has expired"}.to_json
            end
        else
            return {success: false, message: "Invalid session id"}.to_json
        end
    end

    def login()
        #TODO: Create session name with time expired
        payload, header = JWT.decode(@context.request.headers["Authorization"], ENV["APP_SECRET"], JWT::Algorithm::HS256)
        db = Database.new
        parameters = {username: payload["username"]}
        user = db.selectOne("SELECT userid, password FROM Users where username = ?", parameters)

        if (Argon2::Password.verify_password(payload["password"].to_s, user["password"]) == true)
            sessionid = Credentials.createSessionID user["userid"]
            json = {success: true, sessionid: sessionid}
        else
            json = {success: false, message: "Username or password is incorrect"}
        end
        return json.to_json
    end

    def context
        @context
    end
end
