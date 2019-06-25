require "../CRYSTAL_ENV.cr"
require "http/server"
require "../src/database.cr"
require "../src/routing/request_parser.cr"

db = Database.new ENV["DB_TYPE"], ENV["DB_SERVER"], ENV["DB_PORT"],  ENV["DB_NAME"],  ENV["DB_USER"], ENV["DB_PASS"]

server = HTTP::Server.new do |context|
    response = RequestParser.parse(context.request)
    context.response.content_type = response.content_type
    context.response.print response.content
end

address = server.bind_tcp 4000
puts "Listening on http://#{address}"
server.listen
