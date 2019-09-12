require "../CRYSTAL_ENV.cr"
require "http/server"
require "../src/database.cr"
require "../src/routing/request_parser.cr"
require "io"
require "logger"

#db = Database.new ENV["DB_TYPE"], ENV["DB_SERVER"], ENV["DB_PORT"],  ENV["DB_NAME"],  ENV["DB_USER"], ENV["DB_PASS"]

server = HTTP::Server.new do |context|
    response = RequestParser.parse(context)
    context.response.content_type = response.content_type
    #puts response
    #puts response.content
    #puts response.content_type
    context.response.print response.content
end

#May add back in host as second param
address = server.bind_tcp ENV["HOST"], 4000
server.listen
