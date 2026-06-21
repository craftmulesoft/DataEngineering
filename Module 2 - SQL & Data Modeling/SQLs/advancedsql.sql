/* ==========================================================
   HOSPITAL MANAGEMENT SYSTEM
   PostgreSQL Training Database
   ========================================================== */


-- Create database
CREATE DATABASE hospital_db;

-- Connect to database
-- \c hospital_db;


/* ==========================================================
   DROP TABLES
   ========================================================== */

DROP TABLE IF EXISTS prescriptions;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS departments;

/* ==========================================================
   DEPARTMENTS
   ========================================================== */

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

/* ==========================================================
   DOCTORS
   manager_id creates a self relationship
   ========================================================== */

CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    salary NUMERIC(10,2),
    department_id INT REFERENCES departments(department_id),
    manager_id INT REFERENCES doctors(doctor_id)
);

/* ==========================================================
   PATIENTS
   ========================================================== */

CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    city VARCHAR(50),
    date_of_birth DATE
);

/* ==========================================================
   APPOINTMENTS
   ========================================================== */

CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    doctor_id INT REFERENCES doctors(doctor_id),
    appointment_date DATE,
    consultation_fee NUMERIC(10,2)
);

/* ==========================================================
   PRESCRIPTIONS
   ========================================================== */

CREATE TABLE prescriptions (
    prescription_id SERIAL PRIMARY KEY,
    appointment_id INT REFERENCES appointments(appointment_id),
    medicine_name VARCHAR(100),
    quantity INT
);

/* ==========================================================
   INSERT DEPARTMENTS
   ========================================================== */

INSERT INTO departments (department_name)
VALUES
('Cardiology'),
('Neurology'),
('Pediatrics'),
('Orthopedics'),
('Dermatology');

/* ==========================================================
   INSERT DOCTORS
   ========================================================== */

INSERT INTO doctors
(doctor_name, specialization, salary, department_id, manager_id)
VALUES
('Dr. Sarah Johnson','Cardiologist',12000,1,NULL),
('Dr. Michael Brown','Cardiologist',9500,1,1),
('Dr. David Wilson','Neurologist',11000,2,1),
('Dr. Emma Davis','Pediatrician',8500,3,1),
('Dr. James Miller','Orthopedic Surgeon',10500,4,2),
('Dr. Sophia Taylor','Dermatologist',9000,5,2);

/* ==========================================================
   INSERT PATIENTS
   ========================================================== */

INSERT INTO patients
(first_name,last_name,city,date_of_birth)
VALUES
('John','Smith','Addis Ababa','1990-05-10'),
('Abel','Bekele','Adama','1988-08-21'),
('Hanna','Tesfaye','Bahir Dar','1995-02-15'),
('Meron','Kassa','Hawassa','2000-11-05'),
('Samuel','Ali','Addis Ababa','1985-07-18'),
('Ruth','Mekonnen','Jimma','1998-04-30');

/* ==========================================================
   INSERT APPOINTMENTS
   ========================================================== */

INSERT INTO appointments
(patient_id,doctor_id,appointment_date,consultation_fee)
VALUES
(1,2,'2025-01-10',800),
(2,3,'2025-01-12',1200),
(3,4,'2025-01-15',500),
(4,5,'2025-01-20',1500),
(5,6,'2025-01-25',700),
(1,3,'2025-02-05',1200),
(2,2,'2025-02-10',800),
(6,4,'2025-02-15',500);

/* ==========================================================
   INSERT PRESCRIPTIONS
   ========================================================== */

INSERT INTO prescriptions
(appointment_id,medicine_name,quantity)
VALUES
(1,'Aspirin',10),
(1,'Vitamin C',20),
(2,'Ibuprofen',15),
(3,'Paracetamol',20),
(4,'Calcium Tablets',30),
(5,'Skin Cream',2),
(6,'Migraine Relief',10),
(7,'Blood Pressure Medicine',30),
(8,'Children Syrup',5);

/* ==========================================================
   INNER JOIN
   Show appointments with patient and doctor
   ========================================================== */

SELECT
    a.appointment_id,
    p.first_name,
    p.last_name,
    d.doctor_name,
    a.consultation_fee
FROM appointments a
INNER JOIN patients p
    ON a.patient_id = p.patient_id
INNER JOIN doctors d
    ON a.doctor_id = d.doctor_id;

/* ==========================================================
   LEFT JOIN
   Show all patients even if no appointment exists
   ========================================================== */

SELECT
    p.patient_id,
    p.first_name,
    a.appointment_id
FROM patients p
LEFT JOIN appointments a
    ON p.patient_id = a.patient_id;

/* ==========================================================
   RIGHT JOIN
   Show all appointments
   ========================================================== */

SELECT
    p.first_name,
    a.appointment_id
FROM patients p
RIGHT JOIN appointments a
    ON p.patient_id = a.patient_id;

/* ==========================================================
   FULL OUTER JOIN
   ========================================================== */

SELECT
    p.first_name,
    a.appointment_id
FROM patients p
FULL OUTER JOIN appointments a
    ON p.patient_id = a.patient_id;

/* ==========================================================
   CROSS JOIN
   Every doctor paired with every department
   ========================================================== */

SELECT
    d.doctor_name,
    dept.department_name
FROM doctors d
CROSS JOIN departments dept;

/* ==========================================================
   SELF JOIN
   Doctor and Manager
   ========================================================== */

SELECT
    d.doctor_name AS doctor,
    m.doctor_name AS manager
FROM doctors d
LEFT JOIN doctors m
    ON d.manager_id = m.doctor_id;

/* ==========================================================
   AGGREGATE FUNCTIONS
   ========================================================== */

-- Minimum consultation fee
SELECT MIN(consultation_fee) FROM appointments;

-- Maximum consultation fee
SELECT MAX(consultation_fee) FROM appointments;

-- Number of appointments
SELECT COUNT(*) FROM appointments;

-- Total revenue
SELECT SUM(consultation_fee) FROM appointments;

-- Average doctor salary
SELECT AVG(salary) FROM doctors;

/* ==========================================================
   ORDER BY
   ========================================================== */

SELECT *
FROM doctors
ORDER BY salary DESC;

/* ==========================================================
   LIKE
   ========================================================== */

SELECT *
FROM doctors
WHERE specialization LIKE '%Cardio%';

/* ==========================================================
   IN
   ========================================================== */

SELECT *
FROM patients
WHERE city IN ('Addis Ababa','Adama');

/* ==========================================================
   BETWEEN
   ========================================================== */

SELECT *
FROM doctors
WHERE salary BETWEEN 9000 AND 11000;

/* ==========================================================
   UNION
   Combine doctor and patient names
   ========================================================== */

SELECT doctor_name AS person_name
FROM doctors

UNION

SELECT first_name
FROM patients;

/* ==========================================================
   GROUP BY
   Total appointments per doctor
   ========================================================== */

SELECT
    doctor_id,
    COUNT(*) AS total_appointments
FROM appointments
GROUP BY doctor_id;

/* ==========================================================
   HAVING
   Doctors with more than one appointment
   ========================================================== */

SELECT
    doctor_id,
    COUNT(*) AS total_appointments
FROM appointments
GROUP BY doctor_id
HAVING COUNT(*) > 1;

/* ==========================================================
   EXISTS
   Patients who visited hospital
   ========================================================== */

SELECT *
FROM patients p
WHERE EXISTS (
    SELECT 1
    FROM appointments a
    WHERE a.patient_id = p.patient_id
);

/* ==========================================================
   ANY
   Doctors earning more than ANY doctor in Dermatology
   ========================================================== */

SELECT *
FROM doctors
WHERE salary > ANY (
    SELECT salary
    FROM doctors
    WHERE department_id = 5
);

/* ==========================================================
   ALL
   Doctors earning more than ALL Dermatology doctors
   ========================================================== */

SELECT *
FROM doctors
WHERE salary > ALL (
    SELECT salary
    FROM doctors
    WHERE department_id = 5
);

/* ==========================================================
   ROW_NUMBER()
   ========================================================== */

SELECT
    doctor_name,
    salary,
    ROW_NUMBER() OVER(
        ORDER BY salary DESC
    ) AS row_num
FROM doctors;

/* ==========================================================
   RANK()
   ========================================================== */

SELECT
    doctor_name,
    salary,
    RANK() OVER(
        ORDER BY salary DESC
    ) AS salary_rank
FROM doctors;

/* ==========================================================
   DENSE_RANK()
   ========================================================== */

SELECT
    doctor_name,
    salary,
    DENSE_RANK() OVER(
        ORDER BY salary DESC
    ) AS dense_rank
FROM doctors;

/* ==========================================================
   NTILE()
   ========================================================== */

SELECT
    doctor_name,
    salary,
    NTILE(4) OVER(
        ORDER BY salary DESC
    ) AS quartile
FROM doctors;

/* ==========================================================
   LAG()
   ========================================================== */

SELECT
    doctor_name,
    salary,
    LAG(salary)
    OVER(
        ORDER BY salary
    ) AS previous_salary
FROM doctors;

/* ==========================================================
   LEAD()
   ========================================================== */

SELECT
    doctor_name,
    salary,
    LEAD(salary)
    OVER(
        ORDER BY salary
    ) AS next_salary
FROM doctors;

/* ==========================================================
   PARTITION BY
   Rank doctors within departments
   ========================================================== */

SELECT
    doctor_name,
    department_id,
    salary,

    ROW_NUMBER() OVER(
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS department_rank

FROM doctors;

/* ==========================================================
   FIRST_VALUE()
   ========================================================== */

SELECT
    doctor_name,
    salary,

    FIRST_VALUE(salary)
    OVER(
        ORDER BY salary DESC
    ) AS highest_salary

FROM doctors;

/* ==========================================================
   LAST_VALUE()
   ========================================================== */

SELECT
    doctor_name,
    salary,

    LAST_VALUE(salary)
    OVER(
        ORDER BY salary DESC
        ROWS BETWEEN
        UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS lowest_salary

FROM doctors;

/* ==========================================================
   NTH_VALUE()
   ========================================================== */

SELECT
    doctor_name,
    salary,

    NTH_VALUE(salary,2)
    OVER(
        ORDER BY salary DESC
        ROWS BETWEEN
        UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS second_highest_salary

FROM doctors;