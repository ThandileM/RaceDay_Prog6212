/*
    RaceDay Database
    Module: PROG6212 - Programming 2B

    Entities:
    1. Users
    2. Events
    3. Results
    4. Category
    5. Enrolment
    6. EnrolmentStatus
*/

------------------------------------------------------------
-- 1. CREATE DATABASE
------------------------------------------------------------

IF DB_ID('RaceDayDB') IS NULL
BEGIN
    CREATE DATABASE RaceDayDB;
END;
GO

USE RaceDayDB;
GO


------------------------------------------------------------
-- 2. USERS
------------------------------------------------------------

CREATE TABLE Users
(
    UserId INT IDENTITY(1,1) PRIMARY KEY,

    FirstName VARCHAR(50) NOT NULL,

    LastName VARCHAR(50) NOT NULL,

    Email VARCHAR(150) NOT NULL UNIQUE,

    PasswordHash VARCHAR(255) NOT NULL,

    PhoneNumber VARCHAR(20) NULL,

    Role VARCHAR(20) NOT NULL,

    ProfilePictureUrl VARCHAR(500) NULL,

    CreatedAt DATETIME2 NOT NULL
        DEFAULT SYSDATETIME(),

    CONSTRAINT CK_Users_Role
        CHECK (Role IN ('Organiser', 'Participant'))
);
GO

------------------------------------------------------------
-- 3. EVENTS
------------------------------------------------------------

CREATE TABLE Events
(
    EventId INT IDENTITY(1,1) PRIMARY KEY,

    OrganiserId INT NOT NULL,

    Name VARCHAR(150) NOT NULL,

    Description VARCHAR(MAX) NULL,

    EventDate DATE NOT NULL,

    Location VARCHAR(200) NOT NULL,

    Distance DECIMAL(6,2) NOT NULL,

    BannerImageUrl VARCHAR(500) NULL,

    CreatedAt DATETIME2 NOT NULL
        DEFAULT SYSDATETIME(),

    CONSTRAINT CK_Events_Distance
        CHECK (Distance > 0),

    CONSTRAINT FK_Events_Users
        FOREIGN KEY (OrganiserId)
        REFERENCES Users(UserId)
);
GO

------------------------------------------------------------
-- 4. CATEGORY
------------------------------------------------------------

CREATE TABLE Category
(
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,

    EventId INT NOT NULL,

    Name VARCHAR(100) NOT NULL,

    Description VARCHAR(255) NULL,

    CONSTRAINT FK_Category_Events
        FOREIGN KEY (EventId)
        REFERENCES Events(EventId)
);
GO

------------------------------------------------------------
-- 5. ENROLMENT STATUS
------------------------------------------------------------

CREATE TABLE EnrolmentStatus
(
    StatusId INT IDENTITY(1,1) PRIMARY KEY,

    StatusName VARCHAR(50) NOT NULL UNIQUE,

    Description VARCHAR(200) NULL,
);
GO

------------------------------------------------------------
-- 6. ENROLMENT
------------------------------------------------------------

CREATE TABLE Enrolment
(
    EnrolmentId INT IDENTITY(1,1) PRIMARY KEY,

    ParticipantId INT NOT NULL,

    EventId INT NOT NULL,

    CategoryId INT NOT NULL,

    StatusId INT NOT NULL,

    EnrolmentDate DATETIME2 NOT NULL
        DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Enrolment_Participant_Event
        UNIQUE (ParticipantId, EventId),

    CONSTRAINT FK_Enrolment_Participant
        FOREIGN KEY (ParticipantId)
        REFERENCES Users(UserId),

    CONSTRAINT FK_Enrolment_Event
        FOREIGN KEY (EventId)
        REFERENCES Events(EventId),

    CONSTRAINT FK_Enrolment_Category
        FOREIGN KEY (CategoryId)
        REFERENCES Category(CategoryId),

    CONSTRAINT FK_Enrolment_Status
        FOREIGN KEY (StatusId)
        REFERENCES EnrolmentStatus(StatusId)
);
GO

------------------------------------------------------------
-- 7. RESULTS
------------------------------------------------------------

CREATE TABLE Results
(
    ResultId INT IDENTITY(1,1) PRIMARY KEY,

    EnrolmentId INT NOT NULL UNIQUE,

    RecordedById INT NOT NULL,

    FinishTime TIME NOT NULL,

    FinishingPosition INT NOT NULL,

    TotalFinishers INT NOT NULL,

    RecordedAt DATETIME2 NOT NULL
        DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Results_Enrolment
        FOREIGN KEY (EnrolmentId)
        REFERENCES Enrolment(EnrolmentId),

    CONSTRAINT FK_Results_RecordedBy
        FOREIGN KEY (RecordedById)
        REFERENCES Users(UserId)
);
GO

------------------------------------------------------------
-- 8. SEED ENROLMENT STATUSES
------------------------------------------------------------

INSERT INTO EnrolmentStatus
(
    StatusName
)
VALUES
    ('Pending'),
    ('Confirmed'),
    ('Cancelled');
GO

------------------------------------------------------------
-- 9. SEED USERS
-- These are development placeholder password hashes.
-- The API must use securely hashed passwords.
------------------------------------------------------------

INSERT INTO Users
(
    FirstName,
    LastName,
    Email,
    PasswordHash,
    PhoneNumber,
    Role,
    ProfilePictureUrl
)
VALUES
(
    'Thandile',
    'Mbadu',
    'thandile.organiser@raceday.co.za',
    'HASHED_PASSWORD_ORGANISER_1',
    '0812345678',
    'Organiser',
    NULL
),
(
    'Lisa',
    'Mhleli',
    'lisa.organiser@raceday.co.za',
    'HASHED_PASSWORD_ORGANISER_2',
    '0823456789',
    'Organiser',
    NULL
),
(
    'Hlume',
    'Hlalu',
    'hlume.participant@raceday.co.za',
    'HASHED_PASSWORD_PARTICIPANT_1',
    '0845678912',
    'Participant',
    NULL
),
(
    'Sipho',
    'Nande',
    'sipho.participant@raceday.co.za',
    'HASHED_PASSWORD_PARTICIPANT_2',
    '0854567890',
    'Participant',
    NULL
);
GO

------------------------------------------------------------
-- 10. SEED EVENTS
------------------------------------------------------------

INSERT INTO Events
(
    OrganiserId,
    Name,
    Description,
    EventDate,
    Location,
    Distance,
    BannerImageUrl
)
VALUES
(
    1,
    'Cape Town Summer Run',
    'A community road-running event for athletes of different abilities.',
    '2026-07-05',
    'Cape Town',
    10.00,
    NULL
),
(
    2,
    'Stellenbosch Charity Walk',
    'A charity walking event supporting local community projects.',
    '2027-01-10',
    'Stellenbosch',
    5.00,
    NULL
),
(
    1,
    'Cape Winelands Cycle Challenge',
    'A cycling challenge through the Cape Winelands.',
    '2027-02-20',
    'Paarl',
    50.00,
    NULL
);
GO

------------------------------------------------------------
-- 11. SEED CATEGORIES
------------------------------------------------------------

INSERT INTO Category
(
    EventId,
    Name,
    Description
)
VALUES
(
    1,
    '10 km Open',
    'Open category for participants aged 18 to 60.'
   
),
(
    1,
    '10 km Junior',
    'Junior category for younger participants.'
),
(
    2,
    '5 km Charity Walk',
    'General charity walking category.'
),
(
    3,
    '50 km Cycle Challenge',
    'Open cycling category for experienced cyclists.'
);
GO

------------------------------------------------------------
-- 12. SEED ENROLMENTS
------------------------------------------------------------

INSERT INTO Enrolment
(
    ParticipantId,
    EventId,
    CategoryId,
    StatusId
)
VALUES
(
    3,
    1,
    1,
    2
),
(
    4,
    1,
    1,
    2
),
(
    3,
    2,
    3,
    1
);
GO

------------------------------------------------------------
-- 13. SEED RESULTS
------------------------------------------------------------

INSERT INTO Results
(
    EnrolmentId,
    RecordedById,
    FinishTime,
    FinishingPosition,
    TotalFinishers
)
VALUES
(
    1,
    1,
    '00:52:34',
    15,
    120
),
(
    2,
    1,
    '00:58:12',
    28,
    120
);
GO

------------------------------------------------------------
-- 14. VERIFICATION QUERIES
------------------------------------------------------------

SELECT * FROM Users;
SELECT * FROM Events;
SELECT * FROM Category;
SELECT * FROM EnrolmentStatus;
SELECT * FROM Enrolment;
SELECT * FROM Results;
GO