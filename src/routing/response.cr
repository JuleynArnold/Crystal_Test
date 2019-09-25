
class Response
    getter content_type : String, content : String

    def initialize()
        @content_type = ""
        @content = ""
    end

    def initialize(content_type : String, content : String?)
        @content_type = content_type
        #TODO if the response is not the intended return type handle error.
        if content.is_a?(String)
            @content = content
        else
            @content = ""
        end
    end
end
