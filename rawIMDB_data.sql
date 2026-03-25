DROP TABLE IF EXISTS rawIMDB_data;
CREATE TABLE rawIMDB_data(
    college_ID INT,
    college_name VARCHAR(32),
    dept_code VARCHAR(32),
    dept_name VARCHAR(64),
    course_code VARCHAR(32),
    course_number INT,
    course_name VARCHAR(64),
    section_number INT,
    section_semester VARCHAR(32),
    section_year YEAR,
    student_ID INT,
    firstName VARCHAR(32),
    middleName VARCHAR(32),
    lastName VARCHAR(32),
    graduatingYear YEAR,
    letterGrade VARCHAR(2)
)engine=InnoDB;

-- Load raw data
LOAD DATA LOCAL INFILE 'raw_data.tsv' INTO TABLE raw_data 
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Load data into student
INSERT INTO student(ID, firstName,middleName,lastName,graduatingYear)
SELECT DISTINCT student_ID,firstName,middleName,lastName,graduatingYear FROM raw_data;


-- Load data into college
INSERT INTO college(ID, name)
SELECT DISTINCT college_ID, college_name FROM raw_data;


-- Load data into department
INSERT INTO department(code, name,college_ID)
SELECT DISTINCT dept_code, dept_name,college_ID FROM raw_data;


-- Load data into course
INSERT INTO course(code, number, name, department_code)
SELECT DISTINCT course_code, course_number, course_name, dept_code FROM raw_data;



-- Load data into section
INSERT INTO section(course_code,course_number,number,semester,year)
SELECT DISTINCT course_code,course_number, section_number,section_semester,section_year FROM raw_data;


-- Load data into enrollment
INSERT INTO enrollment(student_ID, section_course_code, section_course_number, section_number, section_semester, section_year,letterGrade)
SELECT DISTINCT student_ID, course_code, course_number, section_number, section_semester, section_year,letterGrade FROM raw_data;