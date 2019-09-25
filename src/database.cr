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

    def pexec(sql : String, params : NamedTuple)
        transformedParams = transformParameters(params)
        DB.open @connectionString do |db|
            db.exec sql, transformedParams
        end
    end

    def pquery(sql : String, params : NamedTuple)
        #TODO: Probably give this the option for the Int32 to be the id instead of sequential count
        count = 0
        queryResults = Hash(Int32, Hash(String, String)).new
        transformedParams = transformParameters(params)
        DB.open @connectionString do |db|
            db.query(sql, transformedParams) do |rs|
                row = {} of String => String
                params.each do |key, value|
                    row[key.to_s] = rs.read(String)
                end
                queryResults[count] = row
                count+= 1
            end
        end
        return queryResults
    end

    def selectOne(sql : String, params : NamedTuple)
        queriedResults = pquery(sql, params)
        return queriedResults[0]
    end

    def transformParameters(params : NamedTuple)
        newParams = [] of DB::Any
        params.each_value do |value|
            newParams << value.to_s
        end
        return newParams
    end

end
