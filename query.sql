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

CREATE TABLE Prescription ( 
    Prescription_ID INT UNSIGNED AUTO_INCREMENT,
    Treatment_ID INT UNSIGNED NOT NULL,
    Medicine_ID INT UNSIGNED NOT NULL,
    Dosage VARCHAR(80) NOT NULL,
    Frequency VARCHAR(80) NOT NULL,
    Duration_Days SMALLINT UNSIGNED NOT NULL,
    Instructions VARCHAR(255),
    Quantity SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT pk_prescription PRIMARY KEY (Prescription_ID),
    CONSTRAINT uq_treatment_medicine UNIQUE (Treatment_ID, Medicine_ID),
    CONSTRAINT fk_prescription_treatment
        FOREIGN KEY (Treatment_ID)
        REFERENCES Treatment (Treatment_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_prescription_medicine
        FOREIGN KEY (Medicine_ID)
        REFERENCES Medicine (Medicine_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_duration_days
        CHECK (Duration_Days > 0),
    CONSTRAINT chk_prescription_quantity
        CHECK (Quantity > 0)
) ENGINE = InnoDB;

CREATE TABLE Payment (
    Payment_ID INT UNSIGNED AUTO_INCREMENT,
    Treatment_ID INT UNSIGNED NOT NULL,
    Payment_Date DATE,
    Amount DECIMAL(10,2) NOT NULL,
    Payment_Method ENUM('Cash', 'Card', 'Mada', 'Apple Pay', 'Insurance') NOT NULL,
    Payment_Status ENUM('Pending', 'Partially Paid', 'Paid') NOT NULL
        DEFAULT 'Pending',
    Transaction_Reference VARCHAR(50),
    CONSTRAINT pk_payment PRIMARY KEY (Payment_ID),
    CONSTRAINT uq_payment_treatment UNIQUE (Treatment_ID),
    CONSTRAINT uq_payment_reference UNIQUE (Transaction_Reference),
    CONSTRAINT fk_payment_treatment
        FOREIGN KEY (Treatment_ID)
        REFERENCES Treatment (Treatment_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_payment_amount
        CHECK (Amount >= 0),
    CONSTRAINT chk_payment_date_status
        CHECK (
            (Payment_Status = 'Pending' AND Payment_Date IS NULL)
            OR
            (Payment_Status IN ('Partially Paid', 'Paid') AND Payment_Date IS NOT NULL)
        )
) ENGINE = InnoDB;
INSERT INTO Staff
    (Staff_ID, First_Name, Last_Name, Phone, Email, Hire_Date)
VALUES
    (1, 'Khalid', 'Alqahtani', '0501234567', 'k.alqahtani@smartclinic.sa', '2021-02-14'),
    (2, 'Noura', 'Alharbi', '0512345678', 'n.alharbi@smartclinic.sa', '2020-09-01'),
    (3, 'Faisal', 'Alotaibi', '0523456789', 'f.alotaibi@smartclinic.sa', '2022-01-10'),
    (4, 'Reem', 'Alghamdi', '0534567890', 'r.alghamdi@smartclinic.sa', '2019-06-23'),
    (5, 'Saad', 'Alshammari', '0545678901', 's.alshammari@smartclinic.sa', '2023-03-05'),
    (6, 'Huda', 'Alzahrani', '0556789012', 'h.alzahrani@smartclinic.sa', '2021-08-15'),
    (7, 'Majed', 'Aldossari', '0567890123', 'm.aldossari@smartclinic.sa', '2020-11-20'),
    (8, 'Abeer', 'Almutairi', '0578901234', 'a.almutairi@smartclinic.sa', '2022-05-18'),
    (9, 'Turki', 'Alanazi', '0589012345', 't.alanazi@smartclinic.sa', '2023-07-02'),
    (10, 'Lama', 'Alsubaie', '0590123456', 'l.alsubaie@smartclinic.sa', '2024-01-14');

INSERT INTO Doctor
    (Doctor_ID, License_Number, Specialization, Consultation_Fee, Room_Number)
VALUES
    (1, 'SCFHS-D-10001', 'Family Medicine', 250.00, 'A101'),
    (2, 'SCFHS-D-10002', 'Pediatrics', 300.00, 'A102'),
    (3, 'SCFHS-D-10003', 'Dermatology', 350.00, 'B201'),
    (4, 'SCFHS-D-10004', 'Internal Medicine', 320.00, 'B202'),
    (5, 'SCFHS-D-10005', 'Orthopedics', 400.00, 'C301');

INSERT INTO Admin_Staff
    (Admin_ID, Department, Position)
VALUES
    (6, 'Reception', 'Receptionist'),
    (7, 'Finance', 'Accountant'),
    (8, 'Medical Records', 'Records Officer'),
    (9, 'Human Resources', 'HR Coordinator'),
    (10, 'Administration', 'Clinic Supervisor');
INSERT INTO Patient
    (Patient_ID, National_ID, First_Name, Last_Name, Date_of_Birth,
     Gender, Phone, Email, City, Address, Blood_Type)
VALUES
    (1, '1023456789', 'Abdullah', 'Alzahrani', '1992-04-16', 'Male', '0509876543', 'abdullah.alzahrani@example.sa', 'Riyadh', 'Al Malqa District, Riyadh', 'O+'),
    (2, '1098765432', 'Sara', 'Alharbi', '1988-11-03', 'Female', '0518765432', 'sara.alharbi@example.sa', 'Jeddah', 'Al Rawdah District, Jeddah', 'A+'),
    (3, '1122334455', 'Mohammed', 'Alqahtani', '2001-07-22', 'Male', '0527654321', 'mohammed.alqahtani@example.sa', 'Dammam', 'Al Faisaliyah District, Dammam', 'B+'),
    (4, '1234567890', 'Norah', 'Alotaibi', '1996-02-10', 'Female', '0536543210', 'norah.alotaibi@example.sa', 'Makkah', 'Al Aziziyah District, Makkah', 'AB+'),
    (5, '1987654321', 'Fahad', 'Alshammari', '1979-09-28', 'Male', '0545432109', 'fahad.alshammari@example.sa', 'Madinah', 'Qurban District, Madinah', 'O-');

INSERT INTO Appointment
    (Appointment_ID, Patient_ID, Doctor_ID, Appointment_Date, Appointment_Time, Reason, Status)
VALUES
    (1, 1, 1, '2026-07-05', '09:00:00', 'Routine health examination', 'Completed'),
    (2, 2, 2, '2026-07-06', '10:30:00', 'Child fever and sore throat', 'Completed'),
    (3, 3, 3, '2026-07-07', '12:00:00', 'Persistent skin rash', 'Completed'),
    (4, 4, 4, '2026-07-08', '14:00:00', 'Fatigue and high blood pressure', 'Completed'),
    (5, 5, 5, '2026-07-09', '16:30:00', 'Knee pain after exercise', 'Completed');
INSERT INTO Treatment
    (Treatment_ID, Appointment_ID, Diagnosis, Treatment_Description, Treatment_Date, Notes, Treatment_Cost)
VALUES
    (1, 1, 'Vitamin D deficiency', 'Clinical evaluation and vitamin D replacement plan', '2026-07-05', 'Follow-up laboratory test recommended after eight weeks', 250.00),
    (2, 2, 'Acute bacterial tonsillitis', 'Antibiotic treatment with fever management instructions', '2026-07-06', 'Return if symptoms do not improve within three days', 300.00),
    (3, 3, 'Allergic dermatitis', 'Topical treatment and avoidance of identified irritants', '2026-07-07', 'Use fragrance-free skin products', 350.00),
    (4, 4, 'Primary hypertension', 'Blood-pressure management plan and lifestyle counselling', '2026-07-08', 'Record blood pressure twice daily', 320.00),
    (5, 5, 'Mild knee sprain', 'Rest, cold compress, pain management, and physiotherapy advice', '2026-07-09', 'Avoid strenuous exercise for two weeks', 400.00);

INSERT INTO Medicine
    (Medicine_ID, Medicine_Name, Description, Unit_Price, Stock_Quantity, Expiry_Date)
VALUES
    (1, 'Vitamin D3 50000 IU', 'Weekly vitamin D soft-gel capsules', 18.00, 120, '2027-12-31'),
    (2, 'Amoxicillin 500 mg', 'Oral antibiotic capsules', 22.50, 200, '2027-06-30'),
    (3, 'Hydrocortisone Cream 1%', 'Topical corticosteroid cream', 16.75, 85, '2027-10-31'),
    (4, 'Amlodipine 5 mg', 'Blood-pressure control tablets', 28.00, 150, '2028-01-31'),
    (5, 'Paracetamol 500 mg', 'Pain-relief and fever-reduction tablets', 8.50, 300, '2028-03-31');

INSERT INTO Prescription 
    (Prescription_ID, Treatment_ID, Medicine_ID, Dosage, Frequency, Duration_Days, Instructions, Quantity)
VALUES
    (1, 1, 1, 'One capsule', 'Once weekly', 56, 'Take after a main meal', 8),
    (2, 2, 2, 'One capsule', 'Three times daily', 7, 'Complete the full course', 21),
    (3, 3, 3, 'Apply a thin layer', 'Twice daily', 10, 'For external use only', 1),
    (4, 4, 4, 'One tablet', 'Once daily', 30, 'Take at the same time each day', 30),
    (5, 5, 5, 'Two tablets', 'Every eight hours when needed', 5, 'Do not exceed eight tablets in 24 hours', 20);

INSERT INTO Payment
    (Payment_ID, Treatment_ID, Payment_Date, Amount, Payment_Method, Payment_Status, Transaction_Reference)
VALUES
    (1, 1, '2026-07-05', 250.00, 'Mada', 'Paid', 'TXN-SA-20260705-001'),
    (2, 2, '2026-07-06', 300.00, 'Card', 'Paid', 'TXN-SA-20260706-002'),
    (3, 3, '2026-07-07', 350.00, 'Apple Pay', 'Paid', 'TXN-SA-20260707-003'),
    (4, 4, '2026-07-08', 160.00, 'Insurance', 'Partially Paid', 'TXN-SA-20260708-004'),
    (5, 5, NULL, 400.00, 'Cash', 'Pending', NULL);
UPDATE Payment
SET
    Payment_Date = '2026-07-10',
    Payment_Method = 'Mada',
    Payment_Status = 'Paid',
    Transaction_Reference = 'TXN-SA-20260710-005'
WHERE Payment_ID = 5;
DELETE FROM Prescription
WHERE Prescription_ID = 5;
SELECT
    Appointment_ID,
    Appointment_Date,
    Appointment_Time,
    Reason,
    Status
FROM Appointment
WHERE Status = 'Completed'
  AND Appointment_Date BETWEEN '2026-07-05' AND '2026-07-09'
ORDER BY Appointment_Date, Appointment_Time;
SELECT
    a.Appointment_ID,
    CONCAT(p.First_Name, ' ', p.Last_Name) AS Patient_Name,
    CONCAT(s.First_Name, ' ', s.Last_Name) AS Doctor_Name,
    d.Specialization,
    a.Appointment_Date,
    a.Appointment_Time,
    a.Status
FROM Appointment AS a
INNER JOIN Patient AS p
    ON a.Patient_ID = p.Patient_ID
INNER JOIN Doctor AS d
    ON a.Doctor_ID = d.Doctor_ID
INNER JOIN Staff AS s
    ON d.Doctor_ID = s.Staff_ID
ORDER BY a.Appointment_Date, a.Appointment_Time;
SELECT
    p.Patient_ID,
    CONCAT(p.First_Name, ' ', p.Last_Name) AS Patient_Name,
    t.Treatment_Cost
FROM Patient AS p
INNER JOIN Appointment AS a
    ON p.Patient_ID = a.Patient_ID
INNER JOIN Treatment AS t
    ON a.Appointment_ID = t.Appointment_ID
WHERE t.Treatment_Cost > (
    SELECT AVG(Treatment_Cost)
    FROM Treatment
)
ORDER BY t.Treatment_Cost DESC;
SELECT
    d.Doctor_ID,
    CONCAT(s.First_Name, ' ', s.Last_Name) AS Doctor_Name,
    d.Specialization,
    COUNT(a.Appointment_ID) AS Appointment_Count,
    ROUND(AVG(t.Treatment_Cost), 2) AS Average_Treatment_Cost
FROM Doctor AS d
INNER JOIN Staff AS s
    ON d.Doctor_ID = s.Staff_ID
LEFT JOIN Appointment AS a
    ON d.Doctor_ID = a.Doctor_ID
LEFT JOIN Treatment AS t
    ON a.Appointment_ID = t.Appointment_ID
GROUP BY
    d.Doctor_ID,
    s.First_Name,
    s.Last_Name,
    d.Specialization
ORDER BY Appointment_Count DESC;
