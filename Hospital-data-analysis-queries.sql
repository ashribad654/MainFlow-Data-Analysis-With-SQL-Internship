-- Patient admissions with doctor and department details
SELECT p.name AS patient_name,
p.gender,
TIMESTAMPDIFF(YEAR, p.dob, CURDATE()) AS age,
d.name AS doctor_name,
dept.dept_name,
a.admit_date,
a.discharge_date,
DATEDIFF(a.discharge_date, a.admit_date) AS length_of_stay,
a.diagnosis,
a.ward
FROM admissions a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN departments dept ON a.dept_id = dept.dept_id
ORDER BY a.admit_date;

-- Average length of stay per department
SELECT dept.dept_name,
COUNT(a.admission_id) AS total_admissions,
ROUND(AVG(DATEDIFF(a.discharge_date,
a.admit_date)), 1) AS avg_stay_days,
MAX(DATEDIFF(a.discharge_date, a.admit_date)) AS max_stay_days,
MIN(DATEDIFF(a.discharge_date, a.admit_date)) AS min_stay_days
FROM admissions a
JOIN departments dept ON a.dept_id = dept.dept_id
WHERE a.discharge_date IS NOT NULL
GROUP BY dept.dept_id, dept.dept_name
ORDER BY avg_stay_days DESC;

-- Total billing by department and payment status
SELECT dept.dept_name,
b.paid_status,
COUNT(*) AS num_bills,
SUM(b.total_amount) AS total_billed,
ROUND(AVG(b.total_amount), 2) AS avg_bill
FROM billing b
JOIN admissions a ON b.admission_id = a.admission_id
JOIN departments dept ON a.dept_id = dept.dept_id
GROUP BY dept.dept_name, b.paid_status
ORDER BY dept.dept_name, total_billed DESC;

-- Step 1: Find all discharged admissions-- Step 2: Self-join to find if same patient was readmitted within 30 days
WITH discharged_patients AS (
SELECT patient_id,
admission_id,
discharge_date,
diagnosis
FROM admissions
WHERE status = 'Discharged'
AND discharge_date IS NOT NULL
)
SELECT p.name AS patient_name,
d1.discharge_date AS first_discharge,
d1.diagnosis AS first_diagnosis,
d2.admit_date AS readmission_date,
DATEDIFF(d2.admit_date,
d1.discharge_date) AS days_between
FROM discharged_patients d1
JOIN admissions d2
ON d1.patient_id = d2.patient_id
AND d2.admit_date > d1.discharge_date
AND DATEDIFF(d2.admit_date, d1.discharge_date) <= 30
JOIN patients p ON d1.patient_id = p.patient_id
ORDER BY days_between;

-- CTE 1: Count patients per doctor
WITH doctor_patients AS (
SELECT doctor_id,
COUNT(DISTINCT patient_id) AS unique_patients,
COUNT(admission_id) AS total_admissions
FROM admissions
GROUP BY doctor_id
),-- CTE 2: Average rating per doctor
doctor_ratings AS (
SELECT doctor_id,
ROUND(AVG(rating), 2) AS avg_rating,
COUNT(rating) AS feedback_count
FROM feedback
GROUP BY doctor_id
),-- CTE 3: Revenue generated per doctor
doctor_revenue AS (
SELECT a.doctor_id,
SUM(b.total_amount) AS total_revenue
FROM admissions a
JOIN billing b ON a.admission_id = b.admission_id
GROUP BY a.doctor_id
)-- Final SELECT: join all three CTEs
SELECT d.name AS doctor_name,
d.specialization,
dp.total_admissions,
dp.unique_patients,
COALESCE(dr.avg_rating, 'No rating') AS avg_rating,
drev.total_revenue
FROM doctors d
JOIN doctor_patients dp ON d.doctor_id = dp.doctor_id
LEFT JOIN doctor_ratings dr ON d.doctor_id = dr.doctor_id
JOIN doctor_revenue drev ON d.doctor_id = drev.doctor_id
ORDER BY drev.total_revenue DESC;

-- Running total of monthly hospital revenue
SELECT YEAR(a.admit_date) AS yr,
MONTHNAME(a.admit_date) AS month_name,
MONTH(a.admit_date) AS month_num,
SUM(b.total_amount) AS monthly_revenue,
SUM(SUM(b.total_amount))
OVER (ORDER BY YEAR(a.admit_date), MONTH(a.admit_date))
AS running_total
FROM billing b
JOIN admissions a ON b.admission_id = a.admission_id
GROUP BY YEAR(a.admit_date), MONTH(a.admit_date), MONTHNAME(a.admit_date)
ORDER BY yr, month_num;

-- Rank doctors by admissions WITHIN each department
SELECT dept.dept_name,
d.name AS doctor_name,
COUNT(a.admission_id) AS admissions,
RANK() OVER (
PARTITION BY dept.dept_id
ORDER BY COUNT(a.admission_id) DESC
) AS dept_rank
FROM admissions a
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN departments dept ON a.dept_id = dept.dept_id
GROUP BY dept.dept_id, dept.dept_name, d.doctor_id, d.name
ORDER BY dept.dept_name, dept_rank;

-- Create a view: complete patient admission summary
CREATE OR REPLACE VIEW vw_admission_summary AS
SELECT
a.admission_id,
p.name AS patient_name,
TIMESTAMPDIFF(YEAR, p.dob, a.admit_date) AS age_at_admission,
p.gender,
p.blood_group,
d.name AS doctor_name,
d.specialization,
dept.dept_name,
a.admit_date,
a.discharge_date,
DATEDIFF(a.discharge_date, a.admit_date) AS stay_days,
a.ward,
a.diagnosis,
a.status,
b.total_amount AS bill_amount,
b.paid_status
FROM admissions a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN departments dept ON a.dept_id = dept.dept_id
LEFT JOIN billing b ON a.admission_id = b.admission_id;-- Now you can query the view as easily as a simple table!
SELECT * FROM vw_admission_summary WHERE dept_name = 'Cardiology';-- Find expensive admissions using the view:
SELECT patient_name, doctor_name, diagnosis, bill_amount
FROM vw_admission_summary
WHERE bill_amount > 50000
ORDER BY bill_amount DESC;

-- Change delimiter so MySQL doesn't confuse semicolons inside the procedure
DELIMITER $$
CREATE PROCEDURE GenerateMonthlyReport(IN p_year INT, IN p_month INT)
BEGIN-- Section 1: Summary statistics
SELECT 'MONTHLY HOSPITAL REPORT' AS report_title,
p_year AS report_year,
p_month AS report_month;-- Section 2: Admissions count and revenue
SELECT COUNT(a.admission_id) AS total_admissions,
SUM(b.total_amount) AS total_revenue,
ROUND(AVG(b.total_amount),2) AS avg_bill_per_patient,
SUM(CASE WHEN b.paid_status='Paid' THEN b.total_amount ELSE 0 END) AS paid_amount,
SUM(CASE WHEN b.paid_status='Pending' THEN b.total_amount ELSE 0 END) AS pending_amount
FROM admissions a
JOIN billing b ON a.admission_id = b.admission_id
WHERE YEAR(a.admit_date) = p_year
AND MONTH(a.admit_date) = p_month;-- Section 3: Admissions per department this month
SELECT dept.dept_name,
COUNT(a.admission_id) AS admissions,
SUM(b.total_amount) AS dept_revenue
FROM admissions a
JOIN departments dept ON a.dept_id = dept.dept_id
JOIN billing b ON a.admission_id = b.admission_id
WHERE YEAR(a.admit_date) = p_year
AND MONTH(a.admit_date) = p_month
GROUP BY dept.dept_id, dept.dept_name
ORDER BY dept_revenue DESC;-- Section 4: Doctor workload this month
SELECT d.name AS doctor_name,
COUNT(a.admission_id) AS patients_treated
FROM admissions a
JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE YEAR(a.admit_date) = p_year
AND MONTH(a.admit_date) = p_month
GROUP BY d.doctor_id, d.name
ORDER BY patients_treated DESC;
END$$
DELIMITER ;-- Call the procedure for January 2023:
CALL GenerateMonthlyReport(2023, 1);-- Call for any other month — same procedure, different parameters:
CALL GenerateMonthlyReport(2023, 5);
