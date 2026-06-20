-- Departments
INSERT INTO departments (dept_name, floor_no) VALUES
('Cardiology', 3), ('Orthopaedics', 2), ('Neurology', 4),
('General Medicine', 1), ('Paediatrics', 2), ('Oncology', 5);-- Doctors
INSERT INTO doctors (name, specialization, dept_id, join_date, consult_fee) VALUES
('Dr. Arvind Shah', 'Cardiologist', 1, '2018-06-01', 1500.00),
('Dr. Priya Menon', 'Orthopaedic Surg', 2, '2019-03-15', 1200.00),
('Dr. Rajesh Nair', 'Neurologist', 3, '2017-09-10', 1800.00),
('Dr. Sunita Desai', 'General Physician', 4, '2020-01-20', 800.00),
('Dr. Amit Bose', 'Paediatrician', 5, '2016-11-05', 1000.00),
('Dr. Kavya Reddy', 'Oncologist', 6, '2021-07-12', 2000.00),
('Dr. Vikram Joshi', 'Cardiologist', 1, '2015-04-22', 1600.00),
('Dr. Neha Kapoor', 'Orthopaedic Surg', 2, '2022-08-30', 1100.00);-- Patients
INSERT INTO patients (name, dob, gender, blood_group, contact, city) VALUES
('Ramesh Iyer', '1965-04-12', 'Male', 'O+', '9841001001', 'Chennai'),
('Lakshmi Devi', '1978-11-30', 'Female', 'A+', '9841001002', 'Bangalore'),
('Mohan Verma', '1990-07-22', 'Male', 'B+', '9841001003', 'Delhi'),
('Sunita Patil', '1955-02-14', 'Female', 'AB+', '9841001004', 'Pune'),
('Arjun Krishnan', '1988-09-05', 'Male', 'O-', '9841001005', 'Mumbai'),
('Geeta Sharma', '1972-03-18', 'Female', 'A-', '9841001006', 'Jaipur'),
('Deepak Nambiar', '1995-12-25', 'Male', 'B-', '9841001007', 'Kochi'),
('Pooja Malhotra', '2001-06-08', 'Female', 'O+', '9841001008', 'Chandigarh'),
('Suresh Rajan', '1960-01-19', 'Male', 'A+', '9841001009', 'Hyderabad'),
('Ananya Sen', '1983-08-27', 'Female', 'AB-', '9841001010', 'Kolkata'),
('Hari Prasad', '1945-05-03', 'Male', 'O+', '9841001011', 'Lucknow'),
('Rekha Choudhary', '1968-10-11', 'Female', 'B+', '9841001012', 'Nagpur');-- Admissions
INSERT INTO admissions
(patient_id,doctor_id,dept_id,admit_date,discharge_date,ward,diagnosis,status) VALUES
(1, 1,1,'2023-01-10','2023-01-17','General','Acute Myocardial Infarction','Discharged'),
(2, 2,2,'2023-01-22','2023-01-29','General','Fractured Femur','Discharged'),
(3, 3,3,'2023-02-05','2023-02-12','Private','Migraine with Aura','Discharged'),
(4, 1,1,'2023-02-14','2023-02-20','ICU','Hypertensive Crisis','Discharged'),
(5, 4,4,'2023-03-01','2023-03-05','General','Typhoid Fever','Discharged'),
(6, 5,5,'2023-03-18','2023-03-22','Paediatric','Dengue Fever','Discharged'),
(7, 6,6,'2023-04-02','2023-04-15','Oncology','Lung Cancer Stage II','Discharged'),
(8, 7,1,'2023-04-20','2023-04-25','ICU','Arrhythmia','Discharged'),
(9, 2,2,'2023-05-08','2023-05-15','General','Knee Replacement','Discharged'),
(10,3,3,'2023-05-22','2023-05-28','Private','Epilepsy','Discharged'),
(1, 1,1,'2023-06-05','2023-06-10','ICU','Cardiac Arrest','Discharged'),
(11,4,4,'2023-06-18','2023-06-23','General','Diabetes Complication','Discharged'),
(12,8,2,'2023-07-07','2023-07-14','General','Shoulder Dislocation','Discharged'),
(3, 3,3,'2023-07-20','2023-07-25','Private','Post-op Neurological Check','Discharged'),
(5, 6,6,'2023-08-10','2023-08-20','Oncology','Prostate Cancer Stage I','Discharged'),
(2, 2,2,'2023-09-01','2023-09-08','General','Hip Replacement','Discharged');-- Billing
INSERT INTO billing (admission_id,room_charges,doctor_fee,medicine_charges,lab_charges,total_amount,paid_status) VALUES
(1, 14000, 9000, 8500, 4500, 36000, 'Paid'),
(2, 14000, 7200, 5000, 3000, 29200, 'Paid'),
(3, 14000,10800, 3500, 5000, 33300, 'Partial'),
(4, 18000, 9000,12000, 6000, 45000, 'Paid'),
(5, 8000, 4800, 4000, 2500, 19300, 'Paid'),
(6, 8000, 6000, 5000, 2000, 21000, 'Pending'),
(7, 26000,12000,18000, 8000, 64000, 'Paid'),
(8, 10000, 9600, 7000, 3500, 30100, 'Partial'),
(9, 14000, 7200, 6000, 4000, 31200, 'Paid'),
(10, 12000,10800, 4500, 5500, 32800, 'Paid'),
(11, 10000, 9000,11000, 5000, 35000, 'Paid'),
(12, 10000, 4800, 3000, 2000, 19800, 'Pending'),
(13, 14000, 6600, 5500, 3000, 29100, 'Paid'),
(14, 10000,10800, 3000, 4000, 27800, 'Paid'),
(15, 20000,12000,20000, 10000, 62000, 'Partial'),
(16, 14000, 7200, 7000, 4500, 32700, 'Paid');-- Feedback
INSERT INTO feedback (admission_id,doctor_id,rating,comments,feedback_date) VALUES
(1,1,5,'Excellent care, Dr. Shah was very attentive','2023-01-18'),
(2,2,4,'Good treatment, quick recovery','2023-01-30'),
(3,3,5,'Very thorough diagnosis','2023-02-13'),
(4,1,4,'ICU care was excellent','2023-02-21'),
(5,4,3,'Average experience','2023-03-06'),
(7,6,5,'Dr. Reddy explained everything clearly','2023-04-16'),
(9,2,5,'Knee replacement went perfectly','2023-05-16'),
(11,4,4,'Good follow up care','2023-06-24'),
(13,8,4,'Efficient and professional','2023-07-15'),
(16,2,5,'Best orthopaedic surgeon!','2023-09-09');