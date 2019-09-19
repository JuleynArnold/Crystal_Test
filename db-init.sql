CREATE DATABASE Crystal_Test;
USE DATABASE Crystal_Test;
CREATE TABLE Users (
    userid int NOT NULL AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    salt VARCHAR(255) NOT NULL,
    basefilepath VARCHAR(255) NOT NULL,
    PRIMARY KEY (userid)
);
CREATE TABLE Files (
    fileid INT NOT NULL AUTO_INCREMENT,
    userid INT NOT NULL,
    filename VARCHAR(255) NOT NULL,
    filesize INT,
    location VARCHAR(255),
    encryptionmethod VARCHAR(255),
    createdtime DATETIME DEFAULT GETUTCDATE(),
    updatetime DATETIME DEFAULT GETUTCDATE(),
    PRIMARY KEY (fileid),
    FOREIGN KEY (userid) REFERENCES Users(userid)
);
CREATE TABLE Sessions (
    sessionid VARCHAR(255) NOT NULL,
    expirationtime INT NOT NULL,
    userid INT NOT NULL,
    createddate DATETIME DEFAULT GETUTCDATE(),
    PRIMARY KEY (sessionid),
    FOREIGN KEY (userid) REFERENCES Users(userid)
);
