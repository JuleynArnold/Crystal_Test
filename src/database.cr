require "db"
require "mysql"

class Database
    def initialize(type : String, host : String,  port : String, name : String, user : String, password : String)
        connectionString = "#{type}://#{user}:#{password}@#{host}:#{port}/#{name}"
        @db = DB.open connectionString
    end

    def pquery(sql : String, params : Array)
        result = @db.query sql, params
        return result
    end

    def close()
        @db.close
    end

    def db
        @db = DB::Database.new
    end
end
