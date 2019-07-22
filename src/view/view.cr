require "ecr"
#TODO: May add a language parameter to translate the labels
macro generateViewClass(name, templatepath)
    class {{name.id}}View
        def initialize(templateparams : Hash(String,String))
            @name = {{name}}
            @template_parameters = templateparams
        end

        def name
            @name
        end

        def renderView : String
            return ECR.render {{templatepath}}
        end
        #Specify where to store the template.
        ECR.def_to_s {{templatepath}}
    end
end

#Generating new view classes
#@param Name of view
#@param Template Path for the view
generateViewClass "Login", "templates/login.ecr"
