require "../database.cr"

module FileIO

    # Writes a file to storage
    # @param String | nil Name of the file including extenstion
    # @param String File contents as a string
    # @return Base path of the file
    def self.writeFile(name : String? , data : String, basepath)
        if name.is_a?(String)
            fullpath = basepath + "/" + name
            File.write(fullpath, data)
            return true
        else
            #invalid file name recieved or path recieved
            return false
        end
    end

    # Writes a file to storage encrypyted
    # @param String | nil Name of the file including extenstion
    # @param String | nil Basepath to the file
    # @param String Password of the user to be used at the cipher key
    # @return Base path of the file
    def self.fileEncrypt(name : String?, basepath : String?, password : String)
        if name.is_a?(String) && basepath.is_a?(String)
            fullpath = basepath + "/" + name
            file = File.open(fullpath)
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
            newFileName = name + ".dat"
            writeFile(newFileName, io.gets_to_end, basepath)
            fork do
                system "rm " + fullpath
            end
            return newFileName
        else
            #TODO Some error message encryption failed invalid filename or invalid basepath
            return ""
        end
    end

    # Decrypts an file in storage and returns the contained data
    # @param String | nil Name of the file including extenstion
    # @param String | nil Basepath to the file
    # @param String Password of the user to be used at the cipher key
    # @return String Data of the File
    def self.fileDecrypt(name : String?, basepath : String?, password : String)
        if name.is_a?(String) && basepath.is_a?(String)
            fullpath = basepath + "/" + name
            file = File.open(fullpath)
            filedata = file.gets_to_end

            #Decrypt the file
            cipher.decrypt
            cipher.key = password
            cipher.iv = filedata

            io = IO::Memory.new
            io.write(cipher.update(filedata))
            io.write(cipher.final)
            io.rewind

            #TODO: Return files to user unencrypted
            io.gets_to_end
        end
    end

    #Gets the filesize of the provided file
    #@param String Name of the File
    #@param String Basepath of the file
    #@return Int32 filesize in bytes
    def self.getFileSize(name : String?,  basepath : String?)
        #if name.is_a?(String) && basepath.is_a?(String)
        #    cmd = "wc --bytes < " + basepath + "/" + name
        #    stdout = IO::Memory.new
        #    stderr = IO::Memory.new
        #    status = Process.run(cmd, args: nil, output: stdout, error: stderr)
        #    filesize = 0
        #    if status.success?
        #         filesize = stdout.to_s
        #         filesize = filesize.to_i
        #    end
        #    return filesize
        #end
    end

    #Add database entry for given file
    #@param Int32 Userid to associate the file with
    #@return Void
    def self.addFileRecord(userid : Int32, filename : String, filesize : Int32, location : String, encryption : String)
        db = Database.new
        parameters = {userid: userid, filename: filename, filesize: filesize, location: location, encryptionmethod: encryption}
        db.pexec("INSERT INTO Files (userid, filename, filesize, location, encryptionmethod) VALUES (?,?,?,?,?)", parameters)
    end

    #Update the updatetime for the file record
    #@param Int32 Userid to associate the file with
    #@return Void
    def self.updateFileRecord(userid : Int32)
        db = Database.new
        parameters = {userid: userid}
        db.pexec("UPDATE Files SET (updatetime = CURRENT_TIMESTAMP()) WHERE userid = ?", parameters)
    end

end
