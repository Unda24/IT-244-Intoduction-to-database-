CREATE TABLE Staff (
    Staff_ID INT UNSIGNED AUTO_INCREMENT,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Hire_Date DATE NOT NULL,
    CONSTRAINT pk_staff PRIMARY KEY (Staff_ID),
    CONSTRAINT uq_staff_phone UNIQUE (Phone),
    CONSTRAINT uq_staff_email UNIQUE (Email),
    CONSTRAINT chk_staff_phone
        CHECK (Phone REGEXP '^05[0-9]{8}$')
) ENGINE = InnoDB;