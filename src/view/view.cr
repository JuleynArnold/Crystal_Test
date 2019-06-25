require "ecr"

class View
    def initialize(name, templateparams : Hash(String,String) )
        @name = name
        @template_name =  "../../templates/#{@name}.ecr"
        @template_parameters = templateparams
    end

    def name
        @name = String.new
    end

    def template_name
        @template_name
    end

    def renderView : String
        return ECR.render "templates/login.ecr"
    end
    #Specify where to store the template.
    ECR.def_to_s "templates/login.ecr"
end
