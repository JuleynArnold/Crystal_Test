require "../database.cr"

module Credentials

    def self.createSessionID(userid)
        ssid = Random::Secure.base64(20)
        timeFormatter = Time::Format.new "%s"
        iat = timeFormatter.format(Time.now).to_i / 100
        db = Database.new
        parameters = {sessionid: ssid, userid: userid, expirationtime: iat + 43200}
        db.pquery("INSERT INTO Sessions (sessionid, userid, expirationtime), VALUES (?,?,?)", parameters)
        return ssid
    end

    def self.verifySessionID(ssid)
        timeFormatter = Time::Format.new "%s"
        now = timeFormatter.format(Time.now).to_i / 100
        db = Database.new
        parameters = {sessionid: ssid}
        result = db.selectOne("SELECT expirationtime FROM Sessions WHERE sessionid = ?", parameters)
        if now - result["expirationtime"].to_i > 43200
            return false
        else
            return true
        end
    end

    def self.retrieveUser(ssid)
        db = Database.new
        parameters = {sessionid: ssid}
        user = db.selectOne("SELECT * FROM Users where username = (SELECT userid FROM Sessions WHERE sessionid = ?)", parameters)
        return user
    end
end
