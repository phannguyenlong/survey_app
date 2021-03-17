-- ======================CREATE GUEST USER======================
-- CREATE USER 'guest'@'localhost' IDENTIFIED BY 'password';
-- GRANT ALL PRIVILEGES ON * . * TO 'guest'@'localhost';

-- ======================CREATE TABLE path======================
-- Clean up old table
DROP TABLE IF EXISTS faculty_academic_program;
DROP TABLE IF EXISTS question_content;
DROP TABLE IF EXISTS program_module;
DROP TABLE IF EXISTS questionaire;
DROP TABLE IF EXISTS teaching;
DROP TABLE IF EXISTS class;
DROP TABLE IF EXISTS semester;
DROP TABLE IF EXISTS academic_year;
DROP TABLE IF EXISTS faculty;
DROP TABLE IF EXISTS lecturer;
DROP TABLE IF EXISTS module;
DROP TABLE IF EXISTS program;
DROP TABLE IF EXISTS question;

-- Create table
CREATE TABLE faculty (
	code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
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
	code VARCHAR(10) PRIMARY KEY,
    academic_code VARCHAR(1),
    FOREIGN KEY (academic_code) REFERENCES academic_year(code)
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
    FOREIGN KEY (semester_code) REFERENCES semester(code),
    FOREIGN KEY (module_code) REFERENCES module(code)
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
    FOREIGN KEY (class_code) REFERENCES class(code),
    FOREIGN KEY (lecturer_code) REFERENCES lecturer(code)
);

CREATE TABLE questionaire (
	class_code VARCHAR(10),
    lecturer_code VARCHAR(10),
    question_id INTEGER,
    PRIMARY KEY (class_code, lecturer_code, question_id),
    FOREIGN KEY (class_code) REFERENCES class(code),
    FOREIGN KEY (lecturer_code) REFERENCES lecturer(code),
    FOREIGN KEY (question_id) REFERENCES question(id)
);

CREATE TABLE faculty_academic_program (
	academic_code VARCHAR(10),
    faculty_code VARCHAR(10),
    program_code VARCHAR(10),
    PRIMARY KEY (academic_code, faculty_code, program_code),
    FOREIGN KEY (academic_code) REFERENCES academic_year(code),
    FOREIGN KEY (faculty_code) REFERENCES faculty(code),
    FOREIGN KEY (program_code) REFERENCES program(code)
);

CREATE TABLE program_module (
    module_code VARCHAR(10),
    program_code VARCHAR(10),
    PRIMARY KEY (module_code, program_code),
    FOREIGN KEY (module_code) REFERENCES module(code),
    FOREIGN KEY (program_code) REFERENCES program(code)
);


-- ======================Insert Data======================

-- Falcuty
INSERT INTO faculty (code, name) VALUE ('FECO', 'Faculty of Economics');
INSERT INTO faculty (code, name) VALUE ('FENG', 'Faculty of Engineering');
INSERT INTO faculty (code, name) VALUE ('FIT', 'Faculty of  Information Technology');
INSERT INTO faculty (code, name) VALUE ('FLAW', 'Faculty of Law');
INSERT INTO faculty (code, name) VALUE ('FMUS', 'Faculty of Music');

-- Program
-- Faculty of economic
INSERT INTO program (code, name) VALUES ('BA', 'Business Administration');
INSERT INTO program (code, name) VALUES ('LOG', 'Logistics');
INSERT INTO program (code, name) VALUES ('ECO', 'Economics');
-- Faculty of Engineering
INSERT INTO program (code, name) VALUES ('ME', 'Mechanical Engineering');
INSERT INTO program (code, name) VALUES ('EE', 'Electrical Engineering');
INSERT INTO program (code, name) VALUES ('CE', 'Civil Engineering');
-- Faculty of IT
INSERT INTO program (code, name) VALUES ('CSE', 'Computer Science');
INSERT INTO program (code, name) VALUES ('BIS', 'Business Information System');
INSERT INTO program (code, name) VALUES ('ITSEC', 'Information Technology Security');
-- Faculty of Law
INSERT INTO program (code, name) VALUES ('ELAW', 'Economic Law');
INSERT INTO program (code, name) VALUES ('CLAW', 'Commercial Law');
INSERT INTO program (code, name) VALUES ('CVLAW', 'Civil Law');
-- Faculty of Music
INSERT INTO program (code, name) VALUES ('VOCAL', 'Vocalist');
INSERT INTO program (code, name) VALUES ('COMP', 'Music Composed');
INSERT INTO program (code, name) VALUES ('INS', 'Instrument');

-- Module
-- general
INSERT INTO module (code, name) VALUES ('MATH', 'Mathematic');

-- BA
INSERT INTO module (code, name) VALUES ('MAK', 'Marketing');
INSERT INTO module (code, name) VALUES ('MAN', 'Management');
-- Logistics
INSERT INTO module (code, name) VALUES ('LOT', 'Logistic Theory');
INSERT INTO module (code, name) VALUES ('IOM', 'Import and Export management');
-- Economics
INSERT INTO module (code, name) VALUES ('MAE', 'Macro Economic');
INSERT INTO module (code, name) VALUES ('MIE', 'Micro Economic');

-- ME
INSERT INTO module (code, name) VALUES ('PHYS', 'Physic');
INSERT INTO module (code, name) VALUES ('CHEM', 'Chemistry');
-- EE
INSERT INTO module (code, name) VALUES ('AUTO', 'Automation');
INSERT INTO module (code, name) VALUES ('HWE', 'Hardware Engineering');
-- Civil Engineering
INSERT INTO module (code, name) VALUES ('UWM', 'Urban Water Management');
INSERT INTO module (code, name) VALUES ('TRE', 'Traffic Engineering');

-- CSE
INSERT INTO module (code, name) VALUES ('PE', 'Programming Exercise');
INSERT INTO module (code, name) VALUES ('SWE', 'Software Engineering');
-- BIS
INSERT INTO module (code, name) VALUES ('DBSYS', 'Database System');
INSERT INTO module (code, name) VALUES ('SARC', 'System Architecture');
-- ITSEC
INSERT INTO module (code, name) VALUES ('CNET', 'Computer Network');
INSERT INTO module (code, name) VALUES ('CRYP', 'Cryptography');

-- general Law
INSERT INTO module (code, name) VALUES ('ALAW', 'Administration Law');
-- Economic Law
INSERT INTO module (code, name) VALUES ('ILAW', 'International Law');
INSERT INTO module (code, name) VALUES ('IVML', 'Investment Law');
-- Commercial Law
INSERT INTO module (code, name) VALUES ('DITL', 'Domestic and International Tax Law');
INSERT INTO module (code, name) VALUES ('IPL', 'Intellectual Property Law');
-- Civil Law
INSERT INTO module (code, name) VALUES ('HRL', 'Human Rights Law');
INSERT INTO module (code, name) VALUES ('CVPD', 'Civil Procedure');

-- general Music
INSERT INTO module (code, name) VALUES ('MTHEO', 'Music Theory');
-- Vocal
INSERT INTO module (code, name) VALUES ('PERF', 'Performance-oriented');
INSERT INTO module (code, name) VALUES ('HAR', 'Harmony');
-- Instru
INSERT INTO module (code, name) VALUES ('KBS', 'Keyboard Skill');
INSERT INTO module (code, name) VALUES ('NTT', 'Notation');
-- Composed
INSERT INTO module (code, name) VALUES ('HOM', 'History of Music');
INSERT INTO module (code, name) VALUES ('CMP', 'Composition');


