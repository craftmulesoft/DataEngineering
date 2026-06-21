/*
==========================================================
POSTGRESQL NORMALIZATION & CARDINALITY COMPLETE EXAMPLE
==========================================================

Topics Covered:

NORMALIZATION:
1. UNF - Unnormalized Form
2. 1NF - First Normal Form
3. 2NF - Second Normal Form
4. 3NF - Third Normal Form
5. BCNF - Boyce Codd Normal Form
6. 4NF - Fourth Normal Form
7. 5NF - Fifth Normal Form
8. 6NF - Sixth Normal Form

CARDINALITY:
1. One-to-One
2. One-to-Many
3. Many-to-One
4. Many-to-Many

Database:
PostgreSQL

==========================================================
*/


CREATE DATABASE craft_db;

-- Connect to database before running the rest


/*=========================================================
1. UNNORMALIZED FORM (UNF)

Problem:
Data contains repeating groups.

Example:
Student table contains multiple courses in one column.

=========================================================*/


CREATE TABLE student_UNF
(
    student_id INT,
    student_name VARCHAR(50),
    courses VARCHAR(200)
);


INSERT INTO student_UNF VALUES
(1,'John','Database,Python,SQL'),
(2,'Mary','Java,Cloud');


/*
Problem:
Courses are stored as a list.
This violates atomic values rule.
*/


/*=========================================================
2. FIRST NORMAL FORM (1NF)

Rule:
- Each column contains atomic values
- No repeating groups

=========================================================*/


CREATE TABLE student_1NF
(
    student_id INT,
    student_name VARCHAR(50),
    course VARCHAR(50)
);


INSERT INTO student_1NF VALUES
(1,'John','Database'),
(1,'John','Python'),
(1,'John','SQL'),
(2,'Mary','Java'),
(2,'Mary','Cloud');



/*=========================================================
3. SECOND NORMAL FORM (2NF)

Rule:
- Must be in 1NF
- Remove partial dependency

Example:
Student and Course information separated.

=========================================================*/


CREATE TABLE students
(
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(50)
);


CREATE TABLE courses
(
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100)
);



CREATE TABLE student_courses
(
    student_id INT,
    course_id INT,

    PRIMARY KEY(student_id,course_id),

    FOREIGN KEY(student_id)
    REFERENCES students(student_id),

    FOREIGN KEY(course_id)
    REFERENCES courses(course_id)
);



INSERT INTO students(student_name)
VALUES
('John'),
('Mary');


INSERT INTO courses(course_name)
VALUES
('SQL'),
('Python'),
('Cloud');


INSERT INTO student_courses VALUES
(1,1),
(1,2),
(2,3);



/*=========================================================
4. THIRD NORMAL FORM (3NF)

Rule:
- Must be 2NF
- Remove transitive dependency

Example:

Employee -> Department -> Department Location

=========================================================*/


CREATE TABLE departments
(
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100),
    location VARCHAR(100)
);


CREATE TABLE employees
(
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(100),
    department_id INT,

    FOREIGN KEY(department_id)
    REFERENCES departments(department_id)
);



INSERT INTO departments
(department_name,location)
VALUES
('IT','Addis Ababa'),
('HR','Nairobi');


INSERT INTO employees
(employee_name,department_id)
VALUES
('Alex',1),
('Sarah',2);



/*=========================================================
5. BOYCE CODD NORMAL FORM (BCNF)

Rule:
Every determinant must be a candidate key.

Example:
Teacher can teach only assigned courses.

=========================================================*/


CREATE TABLE teachers
(
    teacher_id SERIAL PRIMARY KEY,
    teacher_name VARCHAR(100)
);


CREATE TABLE teacher_courses
(
    teacher_id INT,
    course_id INT,

    PRIMARY KEY(teacher_id,course_id),

    FOREIGN KEY(teacher_id)
    REFERENCES teachers(teacher_id),

    FOREIGN KEY(course_id)
    REFERENCES courses(course_id)
);



INSERT INTO teachers(teacher_name)
VALUES
('David'),
('Anna');


INSERT INTO teacher_courses VALUES
(1,1),
(2,2);



/*=========================================================
6. FOURTH NORMAL FORM (4NF)

Rule:
Remove multi-valued dependencies.

Example:
Employee has multiple skills and languages.
Separate tables.

=========================================================*/


CREATE TABLE employee_skills
(
    employee_id INT,
    skill VARCHAR(50)
);


CREATE TABLE employee_languages
(
    employee_id INT,
    language VARCHAR(50)
);



INSERT INTO employee_skills VALUES
(1,'SQL'),
(1,'Python');


INSERT INTO employee_languages VALUES
(1,'English'),
(1,'Amharic');



/*=========================================================
7. FIFTH NORMAL FORM (5NF)

Rule:
Remove join dependencies.

Example:
Supplier supplies Products to Locations.

=========================================================*/


CREATE TABLE suppliers
(
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100)
);


CREATE TABLE products
(
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100)
);


CREATE TABLE supplier_product_location
(
    supplier_id INT,
    product_id INT,
    location VARCHAR(100),

    PRIMARY KEY
    (
        supplier_id,
        product_id,
        location
    )
);



INSERT INTO suppliers(supplier_name)
VALUES
('ABC Supplier');


INSERT INTO products(product_name)
VALUES
('Laptop');


INSERT INTO supplier_product_location
VALUES
(1,1,'Addis Ababa');



/*=========================================================
8. SIXTH NORMAL FORM (6NF)

Rule:
Used mainly in temporal databases.

Data split by time periods.

=========================================================*/


CREATE TABLE employee_salary_history
(
    employee_id INT,
    salary INT,
    valid_from DATE,
    valid_to DATE,

    PRIMARY KEY
    (
        employee_id,
        valid_from
    )
);



INSERT INTO employee_salary_history
VALUES
(1,5000,'2026-01-01','2026-06-01'),
(1,6000,'2026-06-02','2026-12-31');





/*
==========================================================
CARDINALITY EXAMPLES
==========================================================
*/


/*=========================================================
1. ONE TO ONE

One person has one passport

Person 1 -------- 1 Passport

=========================================================*/


CREATE TABLE persons
(
    person_id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);



CREATE TABLE passports
(
    passport_id SERIAL PRIMARY KEY,

    person_id INT UNIQUE,

    passport_number VARCHAR(50),

    FOREIGN KEY(person_id)
    REFERENCES persons(person_id)
);



INSERT INTO persons(name)
VALUES
('John');


INSERT INTO passports
(person_id,passport_number)
VALUES
(1,'P12345');




/*=========================================================
2. ONE TO MANY

One department has many employees

Department 1 -------- Many Employees

=========================================================*/


CREATE TABLE company_departments
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);



CREATE TABLE company_employees
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),

    department_id INT,

    FOREIGN KEY(department_id)
    REFERENCES company_departments(id)
);



INSERT INTO company_departments(name)
VALUES
('Finance');


INSERT INTO company_employees
(name,department_id)
VALUES
('Mike',1),
('Tom',1);




/*=========================================================
3. MANY TO ONE

Many orders belong to one customer

Many Orders -------- 1 Customer

=========================================================*/


CREATE TABLE customers
(
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100)
);



CREATE TABLE orders
(
    order_id SERIAL PRIMARY KEY,

    customer_id INT,

    order_date DATE,

    FOREIGN KEY(customer_id)
    REFERENCES customers(customer_id)
);



INSERT INTO customers(customer_name)
VALUES
('Amazon Customer');


INSERT INTO orders
(customer_id,order_date)
VALUES
(1,'2026-06-01'),
(1,'2026-06-02');




/*=========================================================
4. MANY TO MANY

Students can enroll in many courses
Courses can have many students

Student M -------- M Course

Requires junction table

=========================================================*/


CREATE TABLE university_students
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);



CREATE TABLE university_courses
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);



CREATE TABLE enrollments
(
    student_id INT,
    course_id INT,


    enrollment_date DATE,


    PRIMARY KEY
    (
        student_id,
        course_id
    ),


    FOREIGN KEY(student_id)
    REFERENCES university_students(id),


    FOREIGN KEY(course_id)
    REFERENCES university_courses(id)
);



INSERT INTO university_students(name)
VALUES
('Alice'),
('Bob');



INSERT INTO university_courses(name)
VALUES
('Database'),
('Networking');



INSERT INTO enrollments
VALUES
(1,1,'2026-06-01'),
(1,2,'2026-06-01'),
(2,1,'2026-06-02');



/*
==========================================================
END OF NORMALIZATION AND CARDINALITY EXAMPLES
==========================================================
*/