DROP DATABASE IF EXISTS healthdotnetdb;
CREATE DATABASE healthdotnetdb;
USE healthdotnetdb;

-- 1. USERS
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    role ENUM('admin','doctor','patient','receptionist') NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    date_of_birth DATE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. DOCTORS (additional fields for doctors)
DROP TABLE IF EXISTS doctors;
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    speciality VARCHAR(100) NOT NULL,
    consultation_fee DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (doctor_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 3. APPOINTMENTS
DROP TABLE IF EXISTS appointments;
CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT,
    speciality_required VARCHAR(100) NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('waiting','scheduled','completed','cancelled','no_show') DEFAULT 'waiting',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- 4. REPORTS
DROP TABLE IF EXISTS reports;
CREATE TABLE reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    diagnosis TEXT,
    prescription_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 5. MEDICINES
DROP TABLE IF EXISTS medicines;
CREATE TABLE medicines (
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. PRESCRIPTIONS (linking report & medicine)
DROP TABLE IF EXISTS prescriptions;
CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT NOT NULL,
    report_id INT NOT NULL,
    dosage VARCHAR(100),
    duration VARCHAR(50),
    instructions TEXT,
    FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id) ON DELETE CASCADE,
    FOREIGN KEY (report_id) REFERENCES reports(report_id) ON DELETE CASCADE
);

-- 7. PAYMENTS
DROP TABLE IF EXISTS payments;
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    patient_id INT NOT NULL,
    total_fee DECIMAL(10,2) NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,
    status ENUM('pending','paid') DEFAULT 'pending',
    payment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 8. ACTIVITY LOGS
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    action VARCHAR(255) NOT NULL,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);


-- Dummy Data Insertion (optional)
USE healthdotnetdb;

-- ======================
-- 1. USERS
-- ======================
INSERT INTO users (role, full_name, username, password, email, phone, date_of_birth)
VALUES
('admin', 'Alice Johnson', 'alice_admin', 'pass123', 'alice@example.com', '9000000001', '1980-05-12'),
('admin', 'Bob Martin', 'bob_admin', 'pass123', 'bob@example.com', '9000000002', '1982-08-20'),
('doctor', 'Dr. John Smith', 'dr_john', 'pass123', 'john.smith@example.com', '9000000003', '1975-03-22'),
('doctor', 'Dr. Emily Davis', 'dr_emily', 'pass123', 'emily.davis@example.com', '9000000004', '1982-07-15'),
('doctor', 'Dr. Michael Lee', 'dr_michael', 'pass123', 'michael.lee@example.com', '9000000005', '1978-11-05'),
('patient', 'Robert Brown', 'robert_b', 'pass123', 'robert.brown@example.com', '9000000006', '1990-09-10'),
('patient', 'Sophia Wilson', 'sophia_w', 'pass123', 'sophia.wilson@example.com', '9000000007', '1995-12-05'),
('patient', 'David Clark', 'david_c', 'pass123', 'david.clark@example.com', '9000000008', '1988-06-21'),
('patient', 'Emma Lewis', 'emma_l', 'pass123', 'emma.lewis@example.com', '9000000009', '1992-01-17'),
('receptionist', 'Karen Taylor', 'karen_r', 'pass123', 'karen.taylor@example.com', '9000000010', '1988-11-30');

-- ======================
-- 2. DOCTORS
-- ======================
INSERT INTO doctors (doctor_id, speciality, consultation_fee)
VALUES
(3, 'Cardiology', 500.00),
(4, 'Dermatology', 300.00),
(5, 'Orthopedics', 400.00);

-- ======================
-- 3. APPOINTMENTS
-- ======================
INSERT INTO appointments (patient_id, doctor_id, speciality_required, appointment_date, status)
VALUES
(6, 3, 'Cardiology', '2025-11-20 10:00:00', 'scheduled'),
(7, 4, 'Dermatology', '2025-11-21 11:30:00', 'scheduled'),
(8, 5, 'Orthopedics', '2025-11-22 09:30:00', 'completed'),
(9, 3, 'Cardiology', '2025-11-23 14:00:00', 'cancelled'),
(6, NULL, 'Dermatology', '2025-11-25 09:00:00', 'scheduled');

-- ======================
-- 4. REPORTS
-- ======================
INSERT INTO reports (appointment_id, doctor_id, patient_id, diagnosis, prescription_notes)
VALUES
(1, 3, 6, 'High blood pressure detected.', 'Take antihypertensive medication daily. Follow up in 2 weeks.'),
(2, 4, 7, 'Mild eczema rash on arms.', 'Apply medicated cream twice daily. Avoid irritants.'),
(3, 5, 8, 'Knee pain due to minor injury.', 'Physiotherapy recommended for 3 weeks. Take painkiller as needed.');

-- ======================
-- 5. MEDICINES
-- ======================
INSERT INTO medicines (name, description, price)
VALUES
('Antihypertensive A', 'Used to control blood pressure.', 250.00),
('Cream B', 'Topical cream for eczema.', 150.00),
('Painkiller C', 'For mild to moderate pain relief.', 100.00),
('Vitamin D', 'Daily vitamin supplement.', 50.00),
('Antibiotic E', 'General purpose antibiotic.', 200.00);

-- ======================
-- 6. PRESCRIPTIONS
-- ======================
INSERT INTO prescriptions (medicine_id, report_id, dosage, duration, instructions)
VALUES
(1, 1, '1 tablet', '2 weeks', 'Take after breakfast'),
(2, 2, 'Apply thin layer', '1 week', 'Apply twice daily'),
(3, 3, '2 tablets', '5 days', 'Take after meals'),
(4, 1, '1 tablet', '1 month', 'Take daily'),
(5, 2, '1 capsule', '7 days', 'Take twice daily');

-- ======================
-- 7. PAYMENTS
-- ======================
INSERT INTO payments (appointment_id, patient_id, total_fee, transaction_id, status)
VALUES
(1, 6, 500.00, 'TXN1001', 'paid'),
(2, 7, 300.00, 'TXN1002', 'pending'),
(3, 8, 400.00, 'TXN1003', 'paid'),
(4, 9, 500.00, 'TXN1004', 'pending');

-- ======================
-- 8. ACTIVITY LOGS
-- ======================
INSERT INTO logs (user_id, action)
VALUES
(1, 'Admin logged in'),
(2, 'Admin updated doctor info'),
(3, 'Doctor created report for patient Robert Brown'),
(4, 'Doctor updated report for patient Sophia Wilson'),
(6, 'Patient booked appointment with Dr. John Smith'),
(7, 'Patient cancelled appointment with Dr. Emily Davis'),
(10, 'Receptionist checked in patient David Clark');
