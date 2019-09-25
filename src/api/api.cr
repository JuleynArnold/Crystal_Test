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
        #user = Credentials.retrieveUser @context.request.headers["Authorization"]
        #Iterate through form data and
        #HTTP::FormData.parse(@context.request) do |part|
        #   filedata = part.body.gets_to_end
        #   filename = part.filename
        #   path = FileIO.writeFile(filename, filedata, user["basepath"])
        #   FileIO.fileEncrypt(filename, path, user["password"])
        #end
        #json = {success: true}.to_json
        #return json
    end

    #
    def uploadFile()
    end

    #
    def downloadFile()

    end

    def authorize()
        token = @context.request.headers["Authorization"]
        if token.empty? == false
            if (Credentials.verifySessionID token) == true
                return {success: true}.to_json
            else
                return {success: false, message: "Session ID has expired"}.to_json
            end
        else
            return {success: false, message: "Invalid session id"}.to_json
        end
    end

    #Ensure sessionID 1ist still valid
    #@return String JSON contains success or failure
    def authenticate()
        #TODO: Create session name with time expired
        payload, header = JWT.decode(@context.request.headers["Authorization"], ENV["APP_SECRET"], JWT::Algorithm::HS256)
        db = Database.new
        parameters = {username: payload["username"].to_s}
        returnTypes = {userid: 0, password: ""}
        results = db.pquery("SELECT userid, password FROM Users where username = ?", parameters, returnTypes)
        user = results[0]
        attemptedPassword = payload["password"].to_s
        dbPassword = user["password"]
        begin
            if (Argon2::Password.verify_password(attemptedPassword, dbPassword) == Argon2::Response::ARGON2_OK)
                sessionid = Credentials.createSessionID user["userid"]
                json = {success: true, sessionid: sessionid}
            else
                json = {success: false, message: "Username or password is incorrect"}
            end
        rescue ex
            json = {success: false, message: ex.message}
        end
        return json.to_json
    end

    def context
        @context
    end
end
