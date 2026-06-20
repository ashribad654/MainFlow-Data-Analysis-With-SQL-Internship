CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;
CREATE TABLE departments (
dept_id INT PRIMARY KEY AUTO_INCREMENT,
dept_name VARCHAR(80) NOT NULL,
floor_no INT
);
CREATE TABLE doctors (
doctor_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
specialization VARCHAR(80),
dept_id INT,
join_date DATE,
consult_fee DECIMAL(8,2),
FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
CREATE TABLE patients (
patient_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
dob DATE,
gender ENUM('Male','Female','Other'),
blood_group VARCHAR(5),
contact VARCHAR(15),
city VARCHAR(50)
);
CREATE TABLE admissions (
admission_id INT PRIMARY KEY AUTO_INCREMENT,
patient_id INT,
doctor_id INT,
dept_id INT,
admit_date DATE NOT NULL,
discharge_date DATE,
ward VARCHAR(30),
diagnosis VARCHAR(200),
status ENUM('Admitted','Discharged','ICU') DEFAULT 'Admitted',
FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
CREATE TABLE billing (
bill_id INT PRIMARY KEY AUTO_INCREMENT,
admission_id INT UNIQUE,
room_charges DECIMAL(10,2) DEFAULT 0,
doctor_fee DECIMAL(10,2) DEFAULT 0,
medicine_charges DECIMAL(10,2) DEFAULT 0,
lab_charges DECIMAL(10,2) DEFAULT 0,
total_amount DECIMAL(10,2),
paid_status ENUM('Paid','Pending','Partial') DEFAULT 'Pending',
FOREIGN KEY (admission_id) REFERENCES admissions(admission_id)
);
CREATE TABLE feedback (
feedback_id INT PRIMARY KEY AUTO_INCREMENT,
admission_id INT,
doctor_id INT,
rating TINYINT CHECK (rating BETWEEN 1 AND 5),
comments TEXT,
feedback_date DATE,
FOREIGN KEY (admission_id) REFERENCES admissions(admission_id),
FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);