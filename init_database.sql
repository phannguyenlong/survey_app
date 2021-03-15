-- CREATE TABLE path
-- Clean up old table
DROP TABLE IF EXISTS f_a_p;
DROP TABLE IF EXISTS p_a_m;
DROP TABLE IF EXISTS question_content;
DROP TABLE IF EXISTS questionaire;
DROP TABLE IF EXISTS teaching;
DROP TABLE IF EXISTS class;
DROP TABLE IF EXISTS academic_year;
DROP TABLE IF EXISTS faculty;
DROP TABLE IF EXISTS lecturer;
DROP TABLE IF EXISTS module;
DROP TABLE IF EXISTS program;
DROP TABLE IF EXISTS question;
DROP TABLE IF EXISTS semester;

-- Create table
CREATE TABLE faculty (
	code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE program (
	code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE module (
	code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE academic_year (
	code VARCHAR(10) PRIMARY KEY
);

CREATE TABLE lecturer (
	code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE semester (
	code VARCHAR(10) PRIMARY KEY
);

CREATE TABLE question (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(20) NOT NULL
);

CREATE TABLE class (
	code VARCHAR(10) PRIMARY KEY,
    size INTEGER NOT NULL,
    semester_code VARCHAR(10),
    module_code VARCHAR(10),
    FOREIGN KEY (semester_code) REFERENCES semester(code) ON DELETE CASCADE,
    FOREIGN KEY (module_code) REFERENCES module(code) ON DELETE CASCADE
);

CREATE TABLE question_content (
	id INTEGER,
    content VARCHAR(100),
    PRIMARY KEY (id, content)
);

CREATE TABLE teaching (
	class_code VARCHAR(10),
    lecturer_code VARCHAR(10),
    PRIMARY KEY (class_code, lecturer_code),
    FOREIGN KEY (class_code) REFERENCES class(code) ON DELETE CASCADE,
    FOREIGN KEY (lecturer_code) REFERENCES lecturer(code) ON DELETE CASCADE
);

CREATE TABLE questionaire (
	class_code VARCHAR(10),
    lecturer_code VARCHAR(10),
    question_id INTEGER,
    PRIMARY KEY (class_code, lecturer_code, question_id),
    FOREIGN KEY (class_code) REFERENCES class(code) ON DELETE CASCADE,
    FOREIGN KEY (lecturer_code) REFERENCES lecturer(code) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE
);

CREATE TABLE F_A_P (
	academic_code VARCHAR(10),
    faculty_code VARCHAR(10),
    program_code VARCHAR(10),
    PRIMARY KEY (academic_code, faculty_code, program_code),
    FOREIGN KEY (academic_code) REFERENCES academic_year(code) ON DELETE CASCADE,
    FOREIGN KEY (faculty_code) REFERENCES faculty(code) ON DELETE CASCADE,
    FOREIGN KEY (program_code) REFERENCES program(code) ON DELETE CASCADE
);

CREATE TABLE P_A_M (
	academic_code VARCHAR(10),
    module_code VARCHAR(10),
    program_code VARCHAR(10),
    PRIMARY KEY (academic_code, module_code, program_code),
    FOREIGN KEY (academic_code) REFERENCES academic_year(code) ON DELETE CASCADE,
    FOREIGN KEY (module_code) REFERENCES module(code) ON DELETE CASCADE,
    FOREIGN KEY (program_code) REFERENCES program(code) ON DELETE CASCADE
);


-- Insert Data

-- Falcuty
INSERT INTO faculty (name) VALUE ('')
