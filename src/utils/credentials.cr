require "../database.cr"

module Credentials
    @@SESSION_EXPIRATION_TIME = 21600

    #Creates a session ID with a 6hr expiration time
    #@param Int32 userid User to create the new session for
    def self.createSessionID(userid)
        ssid = Random::Secure.base64(20)
        timeFormatter = Time::Format.new "%s"
        iat = timeFormatter.format(Time.now).to_i
        db = Database.new
        parameters = {sessionid: ssid, userid: userid, expirationtime: iat + @@SESSION_EXPIRATION_TIME}
        db.pexec("INSERT INTO Sessions (sessionid, userid, expirationtime) VALUES (?,?,?)", parameters)
        return ssid
    end

    def self.verifySessionID(ssid)
        timeFormatter = Time::Format.new "%s"
        now = timeFormatter.format(Time.now).to_i
        db = Database.new
        parameters = {sessionid: ssid}
        returnTypes = {expirationtime: 0}
        result = db.pquery("SELECT expirationtime FROM Sessions WHERE sessionid = ?", parameters, returnTypes)
        row = result[0]
        if now - row["expirationtime"].to_i > @@SESSION_EXPIRATION_TIME
            return false
        else
            return true
        end
    end

    def self.retrieveUser(ssid)
        db = Database.new
        parameters = {sessionid: ssid}
        user = db.pquery("SELECT * FROM Users where username = (SELECT userid FROM Sessions WHERE sessionid = ?)", parameters)
        return user
    end
end
