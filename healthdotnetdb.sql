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

-- Sample Data Insertion
USE healthdotnetdb;

-- 1. USERS
INSERT INTO users (role, full_name, username, password, email, phone, date_of_birth)
VALUES
('admin', 'Admin User', 'admin1', 'pass123', 'admin@example.com', '9000000001', '1980-01-01'),
('doctor', 'Doctor One', 'doctor1', 'pass123', 'doctor1@example.com', '9000000002', '1975-01-01'),
('doctor', 'Doctor Two', 'doctor2', 'pass123', 'doctor2@example.com', '9000000003', '1980-01-01'),
('patient', 'Patient One', 'patient1', 'pass123', 'patient1@example.com', '9000000004', '1990-01-01'),
('patient', 'Patient Two', 'patient2', 'pass123', 'patient2@example.com', '9000000005', '1992-01-01'),
('patient', 'Patient Three', 'patient3', 'pass123', 'patient3@example.com', '9000000006', '1992-10-01'),
('patient', 'Patient Four', 'patient4', 'pass123', 'patient4@example.com', '9000000007', '2000-11-01'),
('receptionist', 'Receptionist One', 'receptionist1', 'pass123', 'reception1@example.com', '9000000008', '1985-01-01');

-- 2. DOCTORS
INSERT INTO doctors (doctor_id, speciality, consultation_fee)
VALUES
(2, 'General', 100.00),
(3, 'Pediatrics', 150.00);

-- 3. APPOINTMENTS
INSERT INTO appointments (patient_id, doctor_id, speciality_required, appointment_date, status)
VALUES
(4, 2, 'General', '2025-11-20 09:00:00', 'scheduled'),
(5, 3, 'Pediatrics', '2025-11-21 10:00:00', 'waiting'),
(4, NULL, 'Dermatology', '2025-11-22 11:00:00', 'waiting');

-- 5. MEDICINES
INSERT INTO medicines (name, description, price)
VALUES
('Medicine A', 'Generic medicine A', 50.00),
('Medicine B', 'Generic medicine B', 75.00),
('Medicine C', 'Generic medicine C', 100.00);

