
class Response
    #For now only string content
    def initialize(content_type : String, content : String)
        @content_type = content_type
        @content = content
    end

    def content_type
        @content_type
    end

    def content
        @content
    end
end
