require "../utils/file.cr"
require "../utils/credentials.cr"
require "json"
require "jwt"
require "crystal-argon2"

class Api

    def initialize(context : HTTP::Server::Context)
        @context = context
    end

    #Updates the client with
    def updateClient()

    end

    #Recieves the files from the client and uploads them to the server
    #@return String JSON success or failure message
    def updateServer()
        user = Credentials.retrieveUser @context.request.headers["Authorization"]
        #Iterate through form data and
        HTTP::FormData.parse(@context.request) do |part|
           filedata = part.body.gets_to_end
           filename = part.filename
           if user.is_a?(NamedTuple)
               fullbasepath = "storage/" + user["basefilepath"]
               isFileWritten = FileIO.writeFile(filename, filedata, fullbasepath)
               if isFileWritten == true
                   newFileName = FileIO.fileEncrypt(filename, fullbasepath, user["password"])
                   #size = FileIO.getFileSize(newFileName, fullbasepath)
                   FileIO.addFileRecord(user["userid"], newFileName, 0, fullbasepath, "aes-128-gcm")
               else
                   return {success: false, message: "Failure to write one or more files for the given user"}.to_json
               end
           else
               return {success: false, message: "Failure to find cloud storage for the given user"}.to_json
           end
        end
        return {success: true}.to_json
    end

    #Returns file updated on the client side to the user.
    #@return String JSON success of failure message
    def updateClient()
        db = Database.new
        sql = "SELECT filename, filesize, createdtime, updatedtime FROM Files WHERE userid = ?" #TODO query based on updated time difference.
        user = Credentials.retrieveUser @context.request.headers["Authorization"]

        if user.is_a?(Nil)
            return {success: false, message: "Could not find a user with the given credentials"}.to_json
        end

        params = {userid: user["userid"]}
        returnTypes =  {filename: "", filesize: 0, createdtime: Time.utc, updatedtime: Time.utc}
        files = db.pquery(sql, params, returnTypes)
        return {success: true, contents: files}.to_json
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
        user = db.selectRow("SELECT userid, password FROM Users where username = ?", parameters, returnTypes)

        if user.is_a?(Nil)
            return {success: false, message: "Could not find a user with the given credentials"}.to_json
        end

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
