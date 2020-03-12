CREATE DATABASE Crystal_Test;
USE Crystal_Test;
CREATE TABLE Users (
    userid int NOT NULL AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
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
    createdtime DATETIME DEFAULT CURRENT_TIMESTAMP(),
    updatedtime DATETIME DEFAULT CURRENT_TIMESTAMP(),
    PRIMARY KEY (fileid),
    FOREIGN KEY (userid) REFERENCES Users(userid)
);
CREATE TABLE Sessions (
    sessionid VARCHAR(255) NOT NULL,
    expirationtime BIGINT NOT NULL,
    userid INT NOT NULL,
    createdtime DATETIME DEFAULT CURRENT_TIMESTAMP(),
    PRIMARY KEY (sessionid),
    FOREIGN KEY (userid) REFERENCES Users(userid)
);
