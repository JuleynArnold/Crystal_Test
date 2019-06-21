class View
    def initialize(*templateparams)
        @name = name
    end

    def name
        @name = String.new
    end
    #Specify where to store the template.
    ECR.def_to_s "../templates/#{name}.ecr"
end
