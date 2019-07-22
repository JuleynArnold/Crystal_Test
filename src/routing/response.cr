
class Response
    getter content_type : String, content : String

    def initialize()
        @content_type = ""
        @content = ""
    end

    def initialize(content_type : String, content : String)
        @content_type = content_type
        @content = content
    end
end
