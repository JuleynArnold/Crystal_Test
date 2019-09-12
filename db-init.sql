CREATE TABLE Users (
    userid int NOT NULL,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    PRIMARY KEY (userid)
)
CREATE TABLE Files (
    fileid INT NOT NULL,
    userid INT NOT NULL,
    filename VARCHAR(255) NOT NULL,
    filesize INT,
    location VARCHAR(255),
    encryptionmethod VARCHAR(255),
    createdtime DATETIME DEFAULT GETUTCDATE(),
    updatetime DATETIME DEFAULT GETUTCDATE(),
    PRIMARY KEY (fileid),
    FOREIGN KEY (userid) REFERENCES Users(userid)
)
