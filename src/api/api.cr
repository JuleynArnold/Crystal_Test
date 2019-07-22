require "../utils/file.cr"
require "json"

class Api

    def initialize(context : HTTP::Server::Context)
        @context = context
    end

    #
    def updateClient(request : HTTP::Request)

    end

    def updateServer()
        #TODO add a database, users, id for each file, associated to a user,
        #and section off storage by user and ensure that only users can access said section
        HTTP::FormData.parse(@context.request) do |part|
            filedata = part.body.gets_to_end
            filename = part.filename
            FileIO.writeFile(filename, filedata)
        end
        json = {status: "success"}.to_json
        return json
    end

    #
    def uploadFile()
    end

    #
    def downloadFile()

    end

    def authenticate()
        #To generate jtoken with hashed
        #expiration time, user,
    end

    def context
        @context
    end
end
