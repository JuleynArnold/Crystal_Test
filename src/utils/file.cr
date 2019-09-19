
module FileIO

    # Writes a file to storage
    # @param name Name of the file including extenstion
    # @param data File contents as a string
    # @param basepath
    # @return Base path of the file
    def self.writeFile(name : String? , data : String, basepath)
        if name.is_a?(String)
            fullpath = basepath + name
            File.write(fullpath, data)
            return fullpath
        end
        return ""
    end

    # Writes a file to storage
    # @param name Name of the file including extenstion
    # @param basepath Basepath to the file
    # @param password Password of the user to be used at the cipher key
    # @return Base path of the file
    def self.fileEncrypt(name : String?, basepath : String?, password : String)
        if name.is_a?(String) && basepath.is_a?(String)
            file = File.open(basepath +  name)
            #Encrypt file
            iv = Random::Secure.random_bytes(16)
            cipher = OpenSSL::Cipher.new("aes-128-gcm")
            cipher.encrypt
            cipher.key = password
            cipher.iv = iv

            io = IO::Memory.new
            io.write(iv)
            io.write(cipher.update(file.gets_to_end))
            io.write(cipher.final)
            io.rewind

            #Write encrypyted file and remove unencrypted file
            fullpath = basepath + name
            writeFile(name + ".dat", io.gets_to_end, basepath)
            fork do
                system "rm " + fullpath
            end
        else
            #TODO Some error message encryption failed invalid filename
            #or invalid basepath
        end
    end


    def self.fileDecrypt()
    end
end
