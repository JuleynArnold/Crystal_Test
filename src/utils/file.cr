
module FileIO

    def self.writeFile(name : String? , data : String, basepath = "storage/")
        if name.is_a?(String)
            fullpath = basepath + name
            File.write(fullpath, data)
            return fullpath
        end
        return false
    end
end
