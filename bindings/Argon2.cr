#Crystallang Argon2 Class binding

@[Link("libargon2")]
lib LibARGON2
    enum ArgonType
        Argon2_d
        Argon2_i
        Argon2_id
    end
    fun verify_password = "argon2i_verify"(
        encoded : Char*,
        pwd : Void*,
        pwdlen : UInt32,
    ) : Int32
    fun create_hash = "argon2i_hash_encoded"(
        t_cost : UInt32,
        m_cost : UInt32,
        parallelism : UInt8,
        pwd : Char*,
        pwdlen : UInt32,
        salt : Char*,
        saltlen : UInt32,
        hashlen : UInt32,
        encoded : Char*,
        encodedlen : UInt32
    ) : Int32
end

class Argon2
    def verify_password(attemptedPassword : String, userPassword : String)
        return LibARGON2.verify_password(userPassword.chars, attemptedPassword.chars, attemptedPassword.size)
    end

    def create_hash(salt : String, password : String)
        # Hashes a password with Argon2i, producing an encoded hash
        # @param t_cost Number of iterations
        # @param m_cost Sets memory usage to m_cost kibibytes
        # @param parallelism Number of threads and compute lanes
        # @param pwd Pointer to password
        # @param pwdlen Password size in bytes
        # @param salt Pointer to salt
        # @param saltlen Salt size in bytes
        # @param hashlen Desired length of the hash in bytes
        # @param encoded Buffer where to write the encoded hash
        # @param encodedlen Size of the buffer (thus max size of the encoded hash)
        saltPointer = salt.chars
        passwordPointer = password.chars
        encodedString = Array(Char).new 128, 'a'
        puts password.bytesize
        puts salt.bytesize
        puts encodedString.size
        puts LibARGON2.create_hash(1, 65536, 2, passwordPointer, password.bytesize, saltPointer, salt.bytesize, 32, encodedString, encodedString.size)
        return encodedString
    end
end

argon2 = Argon2.new
password = "testpasswordbase"
salt = Random::Secure.base64(10)
hashedPassword = argon2.create_hash(salt, password)
puts hashedPassword
#print argon2.verify_password(hashedPassword, "testpassword")
