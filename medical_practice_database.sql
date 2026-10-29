/*
Medical Practice Database

A relational MySQL/MariaDB database designed to support patients,
doctors, appointments, diagnoses, prescriptions, insurance, billing,
and payments.

Developed by Sam Sinclair as part of a team-based database project.
Sam contributed throughout the project, including schema design,
data preparation, SQL queries, testing, and documentation.
*/



-- USE THESE FOR THE CAPSTONE PROJECT'S DATABASE

CREATE DATABASE IF NOT EXISTS medical_practice_db;
USE medical_practice_db;


-- Diagnostic_codes

DROP TABLE IF EXISTS diagnostic_codes;
CREATE TABLE IF NOT EXISTS diagnostic_codes (
    diagnostic_code_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) NOT NULL,
    description VARCHAR(200) NOT NULL,
    category VARCHAR(100) NULL
);


-- Doctors

DROP TABLE IF EXISTS doctors;
CREATE TABLE IF NOT EXISTS doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NULL,
    specialty VARCHAR(100) NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    license_number VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL
);


-- Insurance Companies

DROP TABLE IF EXISTS insurance_companies;
CREATE TABLE IF NOT EXISTS insurance_companies (
    insurance_company_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL
);


-- Medications

DROP TABLE IF EXISTS medications;
CREATE TABLE IF NOT EXISTS medications (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    generic_name VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100) NOT NULL
);


-- Doctor Schedules

DROP TABLE IF EXISTS doctor_schedules;
CREATE TABLE IF NOT EXISTS doctor_schedules (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    day_of_week TINYINT NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);


-- Insurance Policies

DROP TABLE IF EXISTS insurance_policies;
CREATE TABLE IF NOT EXISTS insurance_policies (
    insurance_policy_id INT AUTO_INCREMENT PRIMARY KEY,
    insurance_company_id INT NOT NULL,
    policy_number INT NOT NULL,
    coverage_percent DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (insurance_company_id) REFERENCES 
        insurance_companies(insurance_company_id)
);


-- Patients

DROP TABLE IF EXISTS patients;
CREATE TABLE IF NOT EXISTS patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    insurance_policy_id INT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    home_address VARCHAR(200) NOT NULL,
    registration_date DATE NOT NULL,
    birth_date DATE NOT NULL,
    FOREIGN KEY (insurance_policy_id) REFERENCES
        insurance_policies(insurance_policy_id)
);


-- Patient Allergies

DROP TABLE IF EXISTS patient_allergies;
CREATE TABLE IF NOT EXISTS patient_allergies (
    allergy_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    severity VARCHAR(20) NOT NULL,
    allergy_description VARCHAR(200) NOT NULL,
    diagnosed_date DATE NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);


-- Appointments

DROP TABLE IF EXISTS appointments;
CREATE TABLE IF NOT EXISTS appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    appointment_type VARCHAR(100) NOT NULL,
    scheduled_date DATE NOT NULL,
    scheduled_time TIME NOT NULL,
    duration_minutes INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    fees DECIMAL(10,2) NOT NULL,
    reason_for_visit TEXT NOT NULL,
    notes TEXT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);


-- Appointment Histories

DROP TABLE IF EXISTS appointment_histories;
CREATE TABLE IF NOT EXISTS appointment_histories (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    change_type VARCHAR(20) NOT NULL,
    old_date DATE NOT NULL,
    new_date DATE NOT NULL,
    old_time TIME NOT NULL,
    new_time TIME NOT NULL,
    old_status VARCHAR(20) NULL,
    new_status VARCHAR(20) NOT NULL,
    change_reason VARCHAR(500) NOT NULL,
    change_timestamp TIMESTAMP NOT NULL,
    changed_by VARCHAR(100) NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);


-- Billing Records
DROP TABLE IF EXISTS billing_records;
CREATE TABLE IF NOT EXISTS billing_records (
    billing_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,
    base_fee DECIMAL(10,2) NOT NULL,
    appointment_fee DECIMAL(10,2) NOT NULL,
    duration_fee DECIMAL(10,2) NOT NULL,
    specialty_fee DECIMAL(10,2) NOT NULL,
    prescription_fee DECIMAL(10,2) NOT NULL,
    billing_date DATE NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);


-- Payments

DROP TABLE IF EXISTS payments; 
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    billing_id INT NOT NULL,
    payer_type VARCHAR(100) NOT NULL,
    method VARCHAR(50) NOT NULL,
    transaction_reference VARCHAR(100) NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    FOREIGN KEY (billing_id) REFERENCES billing_records(billing_id)
);


-- Diagnoses

DROP TABLE IF EXISTS diagnoses;
CREATE TABLE IF NOT EXISTS diagnoses (
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    doctor_id INT NOT NULL,
    diagnostic_code_id INT NOT NULL,
    diagnostic_date DATE NOT NULL,
    recorded_time DATETIME NOT NULL,
    notes TEXT NULL,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (diagnostic_code_id) REFERENCES
        diagnostic_codes(diagnostic_code_id)
);


-- Prescriptions

DROP TABLE IF EXISTS prescriptions;
CREATE TABLE IF NOT EXISTS prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    doctor_id INT NOT NULL,
    medication_id INT NOT NULL,
    dosage_amount DECIMAL(10,2) NOT NULL,
    dosage_unit VARCHAR(10) NOT NULL,
    duration_days INT NOT NULL,
    instructions TEXT NOT NULL,
    prescribed_date DATE NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (medication_id) REFERENCES
        medications(medication_id)
);


-- Doctor Appointments

DROP TABLE IF EXISTS doctor_appointments;
CREATE TABLE IF NOT EXISTS doctor_appointments (
    doctor_id INT NOT NULL,
    appointment_id INT NOT NULL,
    PRIMARY KEY (doctor_id, appointment_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- Sample Data

-- doctors

INSERT INTO doctors
    (first_name, last_name, specialty, email, phone, license_number, hire_date)
VALUES
    ('Anaya', 'Patel', 'Dermatology', 'apatel@clinic.com', 
    '204-555-1001', 'MB-DE-10001', '2016-03-15'),
    ('Robert', 'Langford', 'General Practice', 
    'rlangford@clinic.com', '204-555-1002', 'MB-GP-10002', '2014-07-01'),
    ('Kwame', 'Osei', 'Cardiology', 'kosei@clinic.com', 
    '204-555-1003', 'MB-CA-10003', '2018-01-22'),
    ('Sandra', 'Carrington', 'Endocrinology', 
    'scarrington@clinic.com', '204-555-1004', 'MB-EN-10004', '2019-09-10'),
    ('Minh', 'Nguyen', 'Psychiatry', 'mnguyen@clinic.com', 
    '204-555-1005', 'MB-PS-10005', '2020-05-30');

-- doctor_schedules

INSERT INTO doctor_schedules
    (doctor_id, day_of_week, start_time, end_time)
VALUES
    (1, 2, '08:00:00', '16:00:00'),
    (1, 3, '08:00:00', '16:00:00'),
    (1, 4, '08:00:00', '16:00:00'),
    (1, 5, '08:00:00', '16:00:00'),
    (1, 6, '08:00:00', '16:00:00'),
    (2, 2, '09:00:00', '17:00:00'),
    (2, 3, '09:00:00', '17:00:00'),
    (2, 4, '09:00:00', '17:00:00'),
    (2, 5, '09:00:00', '17:00:00'),
    (2, 6, '09:00:00', '17:00:00'),
    (3, 2, '10:00:00', '18:00:00'),
    (3, 3, '10:00:00', '18:00:00'),
    (3, 4, '10:00:00', '18:00:00'),
    (3, 5, '10:00:00', '18:00:00'),
    (3, 6, '10:00:00', '18:00:00'),
    (4, 2, '08:00:00', '16:00:00'),
    (4, 3, '08:00:00', '16:00:00'),
    (4, 4, '08:00:00', '16:00:00'),
    (4, 5, '08:00:00', '16:00:00'),
    (4, 6, '08:00:00', '16:00:00'),
    (5, 2, '08:00:00', '16:00:00'),
    (5, 3, '08:00:00', '16:00:00'),
    (5, 4, '08:00:00', '16:00:00'),
    (5, 5, '08:00:00', '16:00:00'),
    (5, 6, '08:00:00', '16:00:00');

-- diagnostic_codes

INSERT INTO diagnostic_codes
    (code, description, category)
VALUES
    ('E11', 'Type 2 Diabetes', 'Endocrine'),
    ('I10', 'Essential Hypertension', 'Cardiovascular'),
    ('J06.9', 'Upper Respiratory Infection', 'Respiratory'),
    ('M54.5', 'Lower Back Pain', 'Musculoskeletal'),
    ('F32.1', 'Major Depressive Disorder', 'Mental Health'),
    ('K21.0', 'Gastroesophageal Reflux Disease', 'Gastrointestinal'),
    ('L30.9', 'Dermatitis', 'Dermatology'),
    ('J45.9', 'Asthma', 'Respiratory'),
    ('E78.5', 'Hyperlipidemia', 'Endocrine'),
    ('Z00.0', 'General Health Checkup', 'Preventive');

-- medications

INSERT INTO medications
    (name, generic_name, manufacturer)
VALUES
    ('Hydrocortisol', 'Hydrocortisone', 'Pfizer'),
    ('Metformin', 'Metformin HCL', 'Teva Pharma'),
    ('Lisinopril', 'Lisinopril', 'Merck'),
    ('Amoxicillin', 'Amoxicillin Trihydrate', 'Sandoz'),
    ('Sertraline', 'Sertraline HCL', 'AstraZeneca'),
    ('Atorvastatin', 'Atorvastatin Calcium', 'Pfizer'),
    ('Salbutamol', 'Albuterol', 'GlaxoSmithKline'),
    ('Pantoprazole', 'Pantoprazole Sodium', 'Wyeth'),
    ('Glipizide', 'Glipizide', 'Pfizer'),
    ('Ibuprofen', 'Ibuprofen', 'Johnson & Johnson');

-- insurance_companies

INSERT INTO insurance_companies
    (name, phone, email, address)
VALUES
    ('Blue Cross Blue Shield', '204-555-0101', 'contact@bcbs.com', '123 Insurance Ave, Winnipeg, MB'),
    ('Sun Life Financial', '204-555-0202', 'support@sunlife.com', '456 Coverage Blvd, Winnipeg, MB'),
    ('Great-West Life', '204-555-0303', 'info@gwl.com', '789 Policy St, Winnipeg, MB');

-- insurance_policies

INSERT INTO insurance_policies
    (insurance_company_id, policy_number, coverage_percent, start_date, end_date)
VALUES
    (1, 100101, 80.00, '2023-01-01', '2026-12-31'),
    (2, 100102, 70.00, '2023-06-01', '2026-05-31'),
    (3, 100103, 90.00, '2024-01-01', '2027-12-31'),
    (1, 100104, 60.00, '2022-03-01', '2026-02-28'),
    (2, 100105, 75.00, '2024-07-01', '2027-06-30'),
    (3, 100106, 85.00, '2023-09-01', '2026-08-31'),
    (1, 100107, 50.00, '2024-01-01', '2026-12-31'),
    (2, 100108, 95.00, '2023-03-01', '2026-02-28');

-- patients

INSERT INTO patients
    (insurance_policy_id, first_name, last_name, 
    email, phone, home_address, registration_date, birth_date)
VALUES
    (1, 'Alice', 'Thompson', 'alice@email.com', 
    '204-555-2001', '10 Maple St, Winnipeg', '2022-01-15', '1985-04-22'),
    (2, 'Marcus', 'Webb', 'mwebb@email.com', 
    '204-555-2002', '22 Oak Ave, Winnipeg', '2021-08-03', '1972-11-08'),
    (3, 'Carol', 'Diaz', 'cdiaz@email.com', 
    '204-555-2003', '33 Pine Rd, Winnipeg', '2023-03-19', '1990-07-30'),
    (4, 'David', 'Okafor', 'dokafor@email.com', 
    '204-555-2004', '44 Elm Cres, Winnipeg', '2020-12-01', '1965-02-14'),
    (5, 'Randall', 'Simmons', 'rsimmons@email.com', 
    '204-555-2005', '55 Birch Blvd, Winnipeg', '2021-05-07', '1988-09-03'),
    (6, 'Priya', 'Kapoor', 'pkapoor@email.com', 
    '204-555-2006', '66 Cedar Ln, Winnipeg', '2022-11-20', '1995-12-15'),
    (7, 'James', 'Leblanc', 'jleblanc@email.com', 
    '204-555-2007', '77 Spruce Way, Winnipeg', '2023-07-08', '1978-03-27'),
    (8, 'Sofia', 'Reyes', 'sreyes@email.com', 
    '204-555-2008', '88 Willow Dr, Winnipeg', '2023-02-14', '1992-06-11'),
    (NULL, 'Noah', 'Turner', 'notinsured@email.com', '204-555-2010',
    '99 Aspen Rd, Winnipeg', '2024-01-01', '1992-06-15');

-- appointments

INSERT INTO appointments
    (patient_id, appointment_type, scheduled_date, 
    scheduled_time, duration_minutes, status, fees, reason_for_visit, notes)
VALUES
    (1, 'checkup', '2025-05-12', '09:30:00', 30, 
    'completed', 185.00, 'Annual physical exam', NULL),
    (2, 'follow-up', '2025-08-07', '10:00:00', 20, 
    'completed', 175.00, 'Blood pressure follow-up', NULL),
    (3, 'checkup', '2026-01-15', '11:00:00', 30, 
    'completed', 185.00, 'General wellness checkup', NULL),
    (6, 'checkup', '2026-03-06', '16:45:00', 60, 
    'completed', 280.00, 'Skin rash evaluation', 'Ran past end of shift'),
    (2, 'urgent', '2026-01-08', '09:30:00', 45, 
    'completed', 302.50, 'Chest pain evaluation', 'Booked before Dr. Osei shift start'),
    (3, 'follow-up', '2026-01-07', '09:00:00', 30, 
    'completed', 245.00, 'Diabetes management review', NULL),
    (4, 'follow-up', '2026-02-04', '10:30:00', 30, 
    'completed', 270.00, 'Hypertension check', NULL),
    (7, 'specialist-referral', '2026-03-05', '14:00:00',
     90, 'completed', 980.00, 'Cardiology specialist referral', 'High-complexity case'),
    (5, 'checkup', '2025-11-05', '14:00:00', 30, 
    'cancelled', 95.00, 'Annual checkup', NULL),
    (5, 'follow-up', '2025-12-17', '10:00:00', 30, 
    'cancelled', 75.00, 'Blood sugar follow-up', NULL),
    (5, 'checkup', '2026-02-20', '09:00:00', 30, 
    'cancelled', 75.00, 'General wellness', NULL),
    (8, 'specialist-referral', '2025-10-15', '13:00:00', 90, 
    'completed', 395.00, 'Rheumatology referral', NULL),
    (1, 'follow-up', '2025-11-19', '08:30:00', 30, 'completed', 
    270.00, 'Post-treatment follow-up', NULL),
    (4, 'checkup', '2026-02-11', '09:00:00', 30, 'completed', 
    245.00, 'Routine annual checkup', NULL),
    (6, 'checkup', '2026-03-05', '11:00:00', 30, 'completed',
     265.00, 'Skin condition check', NULL),
    (2, 'follow-up', '2025-10-22', '10:00:00', 30, 'completed', 
    245.00, 'Diabetes medication review', NULL),
    (3, 'follow-up', '2025-09-10', '09:00:00', 30, 'completed', 
    245.00, 'Diabetes quarterly check', NULL),
    (4, 'follow-up', '2025-07-16', '11:00:00', 30, 'completed', 
    250.00, 'Diabetes management', NULL),
    (8, 'checkup', '2024-11-10', '10:00:00', 30, 'completed', 
    180.00, 'New patient checkup', 'Over 1 year ago');

-- doctor_appointments

INSERT INTO doctor_appointments
    (doctor_id, appointment_id)
VALUES
    (2, 1),
    (2, 2),
    (2, 3),
    (2, 4),
    (3, 5),
    (4, 6),
    (3, 7),
    (3, 8),
    (2, 9),
    (2, 10),
    (2, 11),
    (3, 12),
    (1, 13),
    (4, 14),
    (1, 15),
    (4, 16),
    (4, 17),
    (4, 18),
    (2, 19);

-- diagnoses

INSERT INTO diagnoses
    (appointment_id, doctor_id, diagnostic_code_id, 
    diagnostic_date, recorded_time, notes)
VALUES
    (1, 2, 10, '2025-05-12', '2025-05-12 09:55:00', 
    'Routine checkup, no abnormalities'),
    (19, 2, 2, '2024-11-10', '2024-11-10 10:25:00', 
    'Elevated blood pressure noted at first visit'),
    (17, 4, 1, '2025-09-10', '2025-09-10 09:30:00', 
    'HbA1c 8.2 — Type 2 Diabetes confirmed'),
    (18, 4, 1, '2025-07-16', '2025-07-16 11:25:00', 
    'Fasting glucose 7.8 mmol/L — Type 2 Diabetes'),
    (9, 2, 3, '2025-11-05', '2025-11-05 14:20:00', 
    'Sore throat, congestion — URI'),
    (4, 2, 7, '2026-03-06', '2026-03-06 17:10:00', 
    'Contact dermatitis, mild inflammation'),
    (8, 3, 9, '2026-03-05', '2026-03-05 14:50:00', 
    'LDL elevated — Hyperlipidemia'),
    (19, 2, 10, '2024-11-10', '2024-11-10 10:30:00', 
    'New patient — general checkup, all clear'),
    (2, 2, 2, '2025-08-07', '2025-08-07 10:20:00', 
    'Blood pressure 145/92 — hypertension ongoing'),
    (3, 2, 1, '2026-01-15', '2026-01-15 11:20:00', 
    'Blood sugar stable with medication'),
    (5, 3, 2, '2026-01-08', '2026-01-08 09:50:00', 
    'Chest pain — ruled out MI, hypertension'),
    (6, 4, 1, '2026-01-07', '2026-01-07 09:25:00', 
    'Diabetes quarterly — well controlled'),
    (7, 3, 2, '2026-02-04', '2026-02-04 10:50:00', 
    'Blood pressure improving with Lisinopril'),
    (12, 3, 8, '2025-10-15', '2025-10-15 13:40:00', 
    'Asthma — moderate persistent'),
    (13, 1, 6, '2025-11-19', '2025-11-19 08:50:00', 
    'GERD — symptoms after meals'),
    (14, 4, 1, '2026-02-11', '2026-02-11 09:20:00', 
    'Type 2 Diabetes follow-up — HbA1c 7.1'),
    (15, 1, 7, '2026-03-05', '2026-03-05 11:20:00', 
    'Dermatitis flare-up — topical treatment'),
    (16, 4, 1, '2025-10-22', '2025-10-22 10:20:00', 
    'Diabetes — adjusting medication dosage');

-- prescriptions

INSERT INTO prescriptions
    (appointment_id, doctor_id, medication_id, dosage_amount, 
    dosage_unit, duration_days, instructions, prescribed_date)
VALUES
    (13, 1, 1, 10.00, 'mg', 14, 
    'Apply cream to affected area twice daily', '2025-11-19'),
    (15, 1, 1, 10.00, 'mg', 14, 
    'Apply to rash area twice daily, avoid face', '2026-03-05'),
    (1, 1, 1, 10.00, 'mg', 7, 
    'Apply to skin irritation once daily', '2025-05-12'),
    (4, 1, 1, 10.00, 'mg', 10, 
    'Apply topically to rash, twice daily', '2026-03-06'),
    (1, 2, 1, 5.00, 'mg', 7, 
    'Apply to skin once daily, 1 week', '2025-05-12'),
    (3, 2, 1, 10.00, 'mg', 14, 
    'Topical application twice daily', '2026-01-15'),
    (12, 3, 1, 10.00, 'mg', 7, 
    'Apply sparingly to affected area', '2025-10-15'),
    (6, 4, 2, 500.00, 'mg', 90, 
    'Take twice daily with meals', '2026-01-07'),
    (16, 4, 2, 500.00, 'mg', 90, 
    'Continue twice daily with meals', '2025-10-22'),
    (17, 4, 2, 500.00, 'mg', 90, 
    'Take with breakfast and dinner', '2025-09-10'),
    (18, 4, 2, 500.00, 'mg', 90, 
    'Take twice daily, monitor blood sugar', '2025-07-16'),
    (14, 4, 2, 500.00, 'mg', 90, 
    'Continue Metformin, increased to 1000mg if needed', '2026-02-11'),
    (6, 4, 9, 5.00, 'mg', 90, 
    'Take once daily before breakfast', '2026-01-07'),
    (16, 4, 9, 5.00, 'mg', 90, 
    'Continue Glipizide, once daily', '2025-10-22'),
    (18, 4, 6, 20.00, 'mg', 90, 
    'Take once daily at bedtime', '2025-07-16'),
    (2, 2, 3, 10.00, 'mg', 30, 
    'Take once daily in the morning', '2025-08-07'),
    (5, 3, 3, 5.00, 'mg', 30, 
    'Take once daily, monitor BP weekly', '2026-01-08'),
    (7, 3, 3, 10.00, 'mg', 30, 
    'Take once daily, reduce sodium intake', '2026-02-04'),
    (9, 2, 4, 500.00, 'mg', 7, 
    'Take 3x daily with food', '2025-11-05'),
    (12, 3, 7, 100.00, 'mcg', 30, 
    'Two puffs as needed, max 4x per day', '2025-10-15'),
    (13, 1, 8, 40.00, 'mg', 30, 
    'Take once daily before breakfast', '2025-11-19'),
    (8, 3, 6, 40.00, 'mg', 90, 
    'Take once daily at bedtime', '2026-03-05'),
    (19, 2, 10, 400.00, 'mg', 5, 
    'Take with food every 8 hours', '2024-11-10');

-- appointment_histories

INSERT INTO appointment_histories
    (appointment_id, change_type, old_date, new_date, 
    old_time, new_time, old_status, new_status, change_reason, change_timestamp, changed_by)
VALUES
    (1, 'status_change', '2025-05-12', '2025-05-12', 
    '09:30:00', '09:30:00', 'scheduled', 'confirmed', 
    'Patient confirmed appointment by phone', '2025-05-10 14:00:00', 'Reception'),
    (2, 'status_change', '2025-08-07', '2025-08-07', 
    '10:00:00', '10:00:00', 'scheduled', 'confirmed', 
    'Confirmed via patient portal', '2025-08-05 09:00:00', 'Reception'),
    (3, 'status_change', '2026-01-15', '2026-01-15', 
    '11:00:00', '11:00:00', 'confirmed', 'completed', 
    'Visit completed successfully', '2026-01-15 12:00:00', 'Reception'),
    (4, 'status_change', '2026-03-06', '2026-03-06', 
    '16:45:00', '16:45:00', 'confirmed', 'completed', 
    'Appointment completed — ran past scheduled end time', '2026-03-06 17:50:00', 'Reception'),
    (5, 'status_change', '2026-01-08', '2026-01-08', 
    '09:30:00', '09:30:00', 'scheduled', 'completed', 
    'Urgent case — seen before scheduled shift start', '2026-01-08 10:20:00', 'Reception'),
    (6, 'status_change', '2026-01-07', '2026-01-07', 
    '09:00:00', '09:00:00', 'confirmed', 'completed', 
    'Visit completed', '2026-01-07 09:35:00', 'Reception'),
    (7, 'status_change', '2026-02-04', '2026-02-04', 
    '10:30:00', '10:30:00', 'confirmed', 'completed', 
    'Visit completed', '2026-02-04 11:05:00', 'Reception'),
    (8, 'status_change', '2026-03-05', '2026-03-05', 
    '14:00:00', '14:00:00', 'confirmed', 'completed', 
    'Specialist referral completed', '2026-03-05 15:35:00', 'Reception'),
    (9, 'cancellation', '2025-11-05', '2025-11-05', 
    '14:00:00', '14:00:00', 'confirmed', 'cancelled', 
    'Patient called to cancel — feeling better', '2025-11-05 09:15:00', 'Randall Simmons'),
    (10, 'cancellation', '2025-12-17', '2025-12-17', 
    '10:00:00', '10:00:00', 'confirmed', 'cancelled', 
    'Patient cancelled via voicemail the evening before', '2025-12-16 20:30:00', 'Randall Simmons'),
    (11, 'cancellation', '2026-02-20', '2026-02-20', 
    '09:00:00', '09:00:00', 'scheduled', 'cancelled', 
    'Patient cancelled well in advance — work conflict', 
    '2026-02-14 11:00:00', 'Randall Simmons'),
    (12, 'status_change', '2025-10-15', '2025-10-15', 
    '13:00:00', '13:00:00', 'confirmed', 'completed', 
    'Referral visit completed', '2025-10-15 14:35:00', 'Reception'),
    (13, 'status_change', '2025-11-19', '2025-11-19', 
    '08:30:00', '08:30:00', 'confirmed', 'completed', 
    'Follow-up completed', '2025-11-19 09:05:00', 'Reception'),
    (14, 'status_change', '2026-02-11', '2026-02-11', 
    '09:00:00', '09:00:00', 'confirmed', 'completed', 
    'Checkup completed', '2026-02-11 09:35:00', 'Reception'),
    (15, 'status_change', '2026-03-05', '2026-03-05', 
    '11:00:00', '11:00:00', 'confirmed', 'completed', 
    'Skin check completed', '2026-03-05 11:35:00', 'Reception'),
    (16, 'status_change', '2025-10-22', '2025-10-22', 
    '10:00:00', '10:00:00', 'confirmed', 'completed', 
    'Medication review completed', '2025-10-22 10:35:00', 'Reception'),
    (17, 'status_change', '2025-09-10', '2025-09-10', 
    '09:00:00', '09:00:00', 'confirmed', 'completed', 
    'Quarterly check completed', '2025-09-10 09:35:00', 'Reception'),
    (18, 'status_change', '2025-07-16', '2025-07-16', 
    '11:00:00', '11:00:00', 'confirmed', 'completed', 
    'Management visit completed', '2025-07-16 11:35:00', 'Reception'),
    (19, 'status_change', '2024-11-10', '2024-11-10', 
    '10:00:00', '10:00:00', 'scheduled', 'completed', 
    'New patient checkup completed', '2024-11-10 10:35:00', 'Reception');

-- billing_records

INSERT INTO billing_records
    (appointment_id, base_fee, appointment_fee, duration_fee, 
    specialty_fee, prescription_fee, billing_date)
VALUES
    (1, 100.00, 50.00, 15.00, 0.00, 20.00, '2025-05-12'),
    (2, 100.00, 50.00, 10.00, 0.00, 15.00, '2025-08-07'),
    (3, 100.00, 50.00, 15.00, 0.00, 20.00, '2026-01-15'),
    (4, 100.00, 50.00, 30.00, 75.00, 25.00, '2026-03-06'),
    (5, 100.00, 75.00, 22.50, 90.00, 15.00, '2026-01-08'),
    (6, 100.00, 50.00, 15.00, 50.00, 30.00, '2026-01-07'),
    (7, 100.00, 50.00, 15.00, 90.00, 15.00, '2026-02-04'),
    (8, 100.00, 150.00, 45.00, 500.00, 185.00, '2026-03-05'),
    (9, 50.00, 25.00, 0.00, 0.00, 20.00, '2025-11-05'),
    (10, 50.00, 25.00, 0.00, 0.00, 0.00, '2025-12-17'),
    (11, 50.00, 25.00, 0.00, 0.00, 0.00, '2026-02-20'),
    (12, 100.00, 75.00, 45.00, 150.00, 25.00, '2025-10-15'),
    (13, 100.00, 50.00, 15.00, 75.00, 30.00, '2025-11-19'),
    (14, 100.00, 50.00, 15.00, 50.00, 30.00, '2026-02-11'),
    (15, 100.00, 50.00, 15.00, 75.00, 25.00, '2026-03-05'),
    (16, 100.00, 50.00, 15.00, 50.00, 30.00, '2025-10-22'),
    (17, 100.00, 50.00, 15.00, 50.00, 30.00, '2025-09-10'),
    (18, 100.00, 50.00, 15.00, 50.00, 35.00, '2025-07-16'),
    (19, 100.00, 50.00, 15.00, 0.00, 15.00, '2024-11-10');

-- payments

INSERT INTO payments
    (billing_id, payer_type, method, transaction_reference, amount_paid, payment_date)
VALUES
    (1, 'insurance', 'direct bill', 'TXN-0001', 148.00, '2025-05-14'),
    (1, 'patient', 'credit card', 'TXN-0002', 37.00, '2025-05-14'),
    (2, 'insurance', 'direct bill', 'TXN-0003', 122.50, '2025-08-09'),
    (2, 'patient', 'debit card', 'TXN-0004', 52.50, '2025-08-09'),
    (3, 'insurance', 'direct bill', 'TXN-0005', 166.50, '2026-01-17'),
    (3, 'patient', 'cash', 'TXN-0006', 18.50, '2026-01-17'),
    (4, 'insurance', 'direct bill', 'TXN-0007', 238.00, '2026-03-08'),
    (4, 'patient', 'credit card', 'TXN-0008', 42.00, '2026-03-08'),
    (5, 'insurance', 'direct bill', 'TXN-0009', 211.75, '2026-01-10'),
    (5, 'patient', 'debit card', 'TXN-0010', 90.75, '2026-01-10'),
    (6, 'insurance', 'direct bill', 'TXN-0011', 220.50, '2026-01-09'),
    (6, 'patient', 'cash', 'TXN-0012', 24.50, '2026-01-09'),
    (7, 'insurance', 'direct bill', 'TXN-0013', 216.00, '2026-02-06'),
    (7, 'patient', 'credit card', 'TXN-0014', 54.00, '2026-02-06'),
    (8, 'insurance', 'direct bill', 'TXN-0015', 490.00, '2026-03-07'),
    (8, 'patient', 'credit card', 'TXN-0016', 490.00, '2026-03-07'),
    (9, 'insurance', 'direct bill', 'TXN-0017', 71.25, '2025-11-07'),
    (9, 'patient', 'cash', 'TXN-0018', 23.75, '2025-11-07'),
    (10, 'insurance', 'direct bill', 'TXN-0019', 56.25, '2025-12-19'),
    (10, 'patient', 'cash', 'TXN-0020', 18.75, '2025-12-19'),
    (11, 'patient', 'cash', 'TXN-0021', 75.00, '2026-02-21'),
    (12, 'insurance', 'direct bill', 'TXN-0022', 375.25, '2025-10-17'),
    (12, 'patient', 'debit card', 'TXN-0023', 19.75, '2025-10-17'),
    (13, 'insurance', 'direct bill', 'TXN-0024', 216.00, '2025-11-21'),
    (13, 'patient', 'credit card', 'TXN-0025', 54.00, '2025-11-21'),
    (14, 'insurance', 'direct bill', 'TXN-0026', 147.00, '2026-02-13'),
    (14, 'patient', 'debit card', 'TXN-0027', 98.00, '2026-02-13'),
    (15, 'insurance', 'direct bill', 'TXN-0028', 225.25, '2026-03-07'),
    (15, 'patient', 'cash', 'TXN-0029', 39.75, '2026-03-07'),
    (16, 'insurance', 'direct bill', 'TXN-0030', 171.50, '2025-10-24'),
    (16, 'patient', 'debit card', 'TXN-0031', 73.50, '2025-10-24'),
    (17, 'insurance', 'direct bill', 'TXN-0032', 220.50, '2025-09-12'),
    (17, 'patient', 'cash', 'TXN-0033', 24.50, '2025-09-12'),
    (18, 'insurance', 'direct bill', 'TXN-0034', 150.00, '2025-07-18'),
    (18, 'patient', 'credit card', 'TXN-0035', 100.00, '2025-07-18'),
    (19, 'insurance', 'direct bill', 'TXN-0036', 171.00, '2024-11-12'),
    (19, 'patient', 'cash', 'TXN-0037', 9.00, '2024-11-12');

    INSERT INTO patient_allergies 
    (patient_id, severity, allergy_description, diagnosed_date)
VALUES
    (1, 'Mild', 'Pollen allergy', '2022-04-10'),
    (2, 'Moderate', 'Penicillin allergy', '2021-09-15'),
    (3, 'Severe', 'Peanut allergy', '2018-06-20'),
    (4, 'Mild', 'Dust allergy', '2020-01-12'),
    (5, 'Moderate', 'Shellfish allergy', '2021-07-08'),
    (6, 'Mild', 'Latex allergy', '2023-02-14'),
    (7, 'Severe', 'Bee sting allergy', '2019-08-03'),
    (8, 'Moderate', 'Ibuprofen allergy', '2023-05-19');


-- Business Analysis Queries

-- List all the appointments that “Dr. Langford” attended in the last year.

SELECT CONCAT('Dr. ', d.last_name) AS doctor_name,  
a.appointment_id
FROM doctors d
JOIN doctor_appointments da ON d.doctor_id = da.doctor_id
JOIN appointments a  ON da.appointment_id = a.appointment_id
WHERE d.last_name = 'Langford'
AND a.scheduled_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR); 

-- Count the number of times that the patient
-- “Randall Simmons” has cancelled an appointment with less than
-- 24 hours notice (cancelled an appointment less than 24 hours 
-- before the appointment was due to occur).


SELECT COUNT(a.appointment_id) AS late_cancellations
FROM appointments a
JOIN patients p ON p.patient_id = a.patient_id
JOIN appointment_histories ap ON a.appointment_id = ap.appointment_id
WHERE p.first_name = 'Randall'
  AND p.last_name = 'Simmons'
  AND ap.new_status = 'cancelled'
  AND TIMESTAMPDIFF(HOUR, ap.change_timestamp,
        TIMESTAMP(a.scheduled_date, a.scheduled_time)) < 24;

 
-- Sort the doctors by the number of prescriptions 
-- of the drug “Hydrocortisol” they’ve given to patients.

SELECT CONCAT('Dr. ', d.last_name) AS doctor_name,
       COUNT(p.prescription_id) AS total_prescriptions
FROM doctors d
JOIN prescriptions p ON d.doctor_id = p.doctor_id
JOIN medications m ON p.medication_id = m.medication_id
WHERE m.name = 'Hydrocortisol'
GROUP BY d.doctor_id, d.last_name
ORDER BY total_prescriptions DESC;  


-- Find the most expensive appointment.

SELECT a.appointment_id, a.reason_for_visit,
       (COALESCE(b.base_fee, 0) +
        COALESCE(b.appointment_fee, 0) +
        COALESCE(b.duration_fee, 0) +
        COALESCE(b.specialty_fee, 0) +
        COALESCE(b.prescription_fee, 0)) AS appointment_total
FROM appointments a
JOIN billing_records b ON a.appointment_id = b.appointment_id
ORDER BY appointment_total DESC
LIMIT 1; 


-- Which appointment type had the highest average duration over the past 6 months?

SELECT a.appointment_type,
       AVG(a.duration_minutes) AS avg_duration
FROM appointments a
WHERE a.scheduled_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) 
GROUP BY a.appointment_type
ORDER BY avg_duration DESC
LIMIT 1;

-- Which day of the week has the highest number 
-- of completed appointments in the past 6 months?

SELECT DAYNAME(a.scheduled_date) AS day_of_week,
       COUNT(a.appointment_id) AS total_completed
FROM appointments a
WHERE a.status = 'completed'
  AND a.scheduled_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY DAYNAME(a.scheduled_date)
ORDER BY total_completed DESC
LIMIT 1;  


--Which 5 medications are most prescribed for “Type 2 Diabetes” diagnoses?

SELECT m.name AS medication_name,
       COUNT(p.prescription_id) AS total_prescribed
FROM diagnoses d
JOIN diagnostic_codes dc ON d.diagnostic_code_id = dc.diagnostic_code_id
JOIN prescriptions p ON d.appointment_id = p.appointment_id
JOIN medications m ON p.medication_id = m.medication_id
WHERE dc.description = 'Type 2 Diabetes'
GROUP BY m.medication_id, m.name
ORDER BY total_prescribed DESC
LIMIT 5; 

-- Which appointment generated the largest uninsured balance (the highest amount that the patient had to pay, after insurance)?

SELECT a.appointment_id, a.reason_for_visit, SUM(p.amount_paid) AS uninsured_balance
FROM appointments a 
JOIN billing_records br ON a.appointment_id = br.appointment_id
JOIN payments p ON p.billing_id = br.billing_id
WHERE p.payer_type = 'patient'
GROUP BY a.appointment_id, a.reason_for_visit
ORDER BY uninsured_balance DESC
LIMIT 1; 

-- For each patient, list their first-ever diagnosis and the doctor that diagnosed it.

WITH FirstDiagnoses AS (SELECT a.patient_id, ds.doctor_id,
    ds.diagnostic_code_id, ds.diagnostic_date,
    ROW_NUMBER() OVER (PARTITION BY a.patient_id
        ORDER BY ds.diagnostic_date ASC, ds.recorded_time ASC) AS rn
    FROM appointments a
    JOIN diagnoses ds ON a.appointment_id = ds.appointment_id)
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient,
       CONCAT('Dr. ', d.last_name) AS doctor,
       dc.description AS first_diagnosis, fd.diagnostic_date 
FROM FirstDiagnoses fd
JOIN patients p ON fd.patient_id = p.patient_id
JOIN doctors d ON fd.doctor_id = d.doctor_id 
JOIN diagnostic_codes dc ON fd.diagnostic_code_id = dc.diagnostic_code_id
WHERE fd.rn = 1
ORDER BY patient; 

--  List all the doctors that worked outside their scheduled hours
--  and identify the appointments where it happened.

SELECT CONCAT('Dr. ', d.last_name) AS doctor_name, a.appointment_id,
       a.scheduled_date, a.scheduled_time
FROM doctors d
JOIN doctor_appointments da ON d.doctor_id = da.doctor_id
JOIN appointments a ON da.appointment_id = a.appointment_id
JOIN doctor_schedules ds ON ds.doctor_id = d.doctor_id
WHERE ds.day_of_week = DAYOFWEEK(a.scheduled_date)
    AND (a.scheduled_time < ds.start_time
    OR ADDTIME(a.scheduled_time, SEC_TO_TIME(a.duration_minutes * 60)) > ds.end_time)
ORDER BY doctor_name, a.appointment_id; 

-- Find all patients with an outstanding balance of at least $<500>.

SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    SUM(
        b.base_fee +
        b.appointment_fee +
        b.duration_fee +
        b.specialty_fee +
        b.prescription_fee
    ) - COALESCE(SUM(py.amount_paid), 0) AS outstanding_balance
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
JOIN billing_records b
    ON a.appointment_id = b.appointment_id
LEFT JOIN payments py
    ON b.billing_id = py.billing_id
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING outstanding_balance >= 500
ORDER BY outstanding_balance DESC;

-- End of Medical Practice Database












      



       
       