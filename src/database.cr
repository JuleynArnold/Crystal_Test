require "db"
require "mysql"

class Database
    @connectionString = String.new

    def initialize()
        type = ENV["DB_TYPE"]
        host = ENV["DB_SERVER"]
        port = ENV["DB_PORT"]
        name = ENV["DB_NAME"]
        user = ENV["DB_USER"]
        password = ENV["DB_PASS"]
        @connectionString = "#{type}://#{user}:#{password}@#{host}:#{port}/#{name}"
    end

    #Executes mutable and or nonmutable statements onto the database
    #@param String sql SQL statement to be executed
    #@param NamedTuple list of parameters used in the SQL statement
    #@return String column from a single row
    def pexec(sql : String, params : NamedTuple)
        transformedParams = transformParameters(params)
        DB.open @connectionString do |db|
            db.exec sql, transformedParams
        end
    end

    def pquery(sql : String, params : NamedTuple, returnTypes : NamedTuple)
        transformedParams = transformParameters(params)
        DB.open @connectionString do |db|
            return db.query_all sql, transformedParams, as: returnTypes.class.types
        end
    end

    #Selects one column out of the database from the queried row
    #@param String sql SQL statement to be executed
    #@param NamedTuple list of parameters used in the SQL statement
    #@return String column from a single row
    def selectOne(sql : String, params : NamedTuple)
        item = ""
        DB.open @connectionString do |db|
            item = db.query_one sql, params as: String
        end
        return item
    end

    #Transforms parameters into a format that can be consued by the DB class
    #@param NamedTuple parameter list to be transformed
    def transformParameters(params : NamedTuple)
        newParams = [] of DB::Any
        params.each_value do |value|
            newParams << value.to_s
        end
        return newParams
    end

end
