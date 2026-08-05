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
CREATE TABLE Patient (
    Patient_ID INT UNSIGNED AUTO_INCREMENT,
    National_ID CHAR(10) NOT NULL,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Date_of_Birth DATE NOT NULL,
    Gender ENUM('Male', 'Female') NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(100),
    City VARCHAR(50) NOT NULL,
    Address VARCHAR(200),
    Blood_Type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    CONSTRAINT pk_patient PRIMARY KEY (Patient_ID),
    CONSTRAINT uq_patient_national_id UNIQUE (National_ID),
    CONSTRAINT uq_patient_phone UNIQUE (Phone),
    CONSTRAINT uq_patient_email UNIQUE (Email),
    CONSTRAINT chk_patient_phone
        CHECK (Phone REGEXP '^05[0-9]{8}$'),
    CONSTRAINT chk_patient_national_id
        CHECK (National_ID REGEXP '^[12][0-9]{9}$')
) ENGINE = InnoDB;
CREATE TABLE Appointment (
    Appointment_ID INT UNSIGNED AUTO_INCREMENT,
    Patient_ID INT UNSIGNED NOT NULL,
    Doctor_ID INT UNSIGNED NOT NULL,
    Appointment_Date DATE NOT NULL,
    Appointment_Time TIME NOT NULL,
    Reason VARCHAR(255) NOT NULL,
    Status ENUM('Scheduled', 'Completed', 'Cancelled', 'Missed') NOT NULL
        DEFAULT 'Scheduled',
    CONSTRAINT pk_appointment PRIMARY KEY (Appointment_ID),
    CONSTRAINT fk_appointment_patient
        FOREIGN KEY (Patient_ID)
        REFERENCES Patient (Patient_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_appointment_doctor
        FOREIGN KEY (Doctor_ID)
        REFERENCES Doctor (Doctor_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT uq_doctor_appointment_slot
        UNIQUE (Doctor_ID, Appointment_Date, Appointment_Time)
) ENGINE = InnoDB;
CREATE TABLE Treatment (
    Treatment_ID INT UNSIGNED AUTO_INCREMENT,
    Appointment_ID INT UNSIGNED NOT NULL,
    Diagnosis VARCHAR(255) NOT NULL,
    Treatment_Description VARCHAR(500) NOT NULL,
    Treatment_Date DATE NOT NULL,
    Notes VARCHAR(500),
    Treatment_Cost DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_treatment PRIMARY KEY (Treatment_ID),
    CONSTRAINT uq_treatment_appointment UNIQUE (Appointment_ID),
    CONSTRAINT fk_treatment_appointment
        FOREIGN KEY (Appointment_ID)
        REFERENCES Appointment (Appointment_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_treatment_cost
        CHECK (Treatment_Cost >= 0)
) ENGINE = InnoDB;

CREATE TABLE Medicine (
    Medicine_ID INT UNSIGNED AUTO_INCREMENT,
    Medicine_Name VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    Unit_Price DECIMAL(8,2) NOT NULL,
    Stock_Quantity INT UNSIGNED NOT NULL DEFAULT 0,
    Expiry_Date DATE NOT NULL,
    CONSTRAINT pk_medicine PRIMARY KEY (Medicine_ID),
    CONSTRAINT uq_medicine_name UNIQUE (Medicine_Name),
    CONSTRAINT chk_medicine_price
        CHECK (Unit_Price >= 0)
) ENGINE = InnoDB;
