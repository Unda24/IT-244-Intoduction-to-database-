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
CREATE TABLE Doctor (
    Doctor_ID INT UNSIGNED,
    License_Number VARCHAR(30) NOT NULL,
    Specialization VARCHAR(80) NOT NULL,
    Consultation_Fee DECIMAL(8,2) NOT NULL,
    Room_Number VARCHAR(10) NOT NULL,
    CONSTRAINT pk_doctor PRIMARY KEY (Doctor_ID),
    CONSTRAINT uq_doctor_license UNIQUE (License_Number),
    CONSTRAINT fk_doctor_staff
        FOREIGN KEY (Doctor_ID)
        REFERENCES Staff (Staff_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT chk_consultation_fee
        CHECK (Consultation_Fee >= 0)
) ENGINE = InnoDB;

CREATE TABLE Admin_Staff (
    Admin_ID INT UNSIGNED,
    Department VARCHAR(80) NOT NULL,
    Position VARCHAR(80) NOT NULL,
    CONSTRAINT pk_admin_staff PRIMARY KEY (Admin_ID),
    CONSTRAINT fk_admin_staff_staff
        FOREIGN KEY (Admin_ID)
        REFERENCES Staff (Staff_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB;
