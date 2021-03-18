-- ======================CREATE GUEST USER======================
-- CREATE USER 'guest'@'localhost' IDENTIFIED BY 'password';
-- GRANT ALL PRIVILEGES ON * . * TO 'guest'@'localhost';

-- ======================CREATE TABLE path======================
-- Clean up old table
DROP TABLE IF EXISTS question_content;
DROP TABLE IF EXISTS questionaire;
DROP TABLE IF EXISTS teaching;
DROP TABLE IF EXISTS class;
DROP TABLE IF EXISTS semester;
DROP TABLE IF EXISTS academic_year;
DROP TABLE IF EXISTS module;
DROP TABLE IF EXISTS program;
DROP TABLE IF EXISTS faculty;
DROP TABLE IF EXISTS lecturer;
DROP TABLE IF EXISTS question;

-- Create table
CREATE TABLE faculty (
	code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE program (
	code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
	faculty_code VARCHAR(10),
    FOREIGN KEY (faculty_code) REFERENCES faculty(code)
);

CREATE TABLE module (
	code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    program_code VARCHAR(10),
	FOREIGN KEY (program_code) REFERENCES program(code)
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
    academic_code VARCHAR(10),
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

-- ======================Insert Data======================

-- Falcuty
INSERT INTO faculty (code, name) VALUE ('FECO', 'Faculty of Economics');
INSERT INTO faculty (code, name) VALUE ('FENG', 'Faculty of Engineering');
INSERT INTO faculty (code, name) VALUE ('FIT', 'Faculty of  Information Technology');
INSERT INTO faculty (code, name) VALUE ('FLAW', 'Faculty of Law');
INSERT INTO faculty (code, name) VALUE ('FMUS', 'Faculty of Music');

-- Program
-- Faculty of economic
INSERT INTO program (code, name, faculty_code) VALUES ('BA', 'Business Administration', 'FECO');
INSERT INTO program (code, name, faculty_code) VALUES ('LOG', 'Logistics', 'FECO');
INSERT INTO program (code, name, faculty_code) VALUES ('ECO', 'Economics', 'FECO');
-- Faculty of Engineering
INSERT INTO program (code, name, faculty_code) VALUES ('ME', 'Mechanical Engineering', 'FENG');
INSERT INTO program (code, name, faculty_code) VALUES ('EE', 'Electrical Engineering', 'FENG');
INSERT INTO program (code, name, faculty_code) VALUES ('CE', 'Civil Engineering', 'FENG');
-- Faculty of IT
INSERT INTO program (code, name, faculty_code) VALUES ('CSE', 'Computer Science', 'FIT');
INSERT INTO program (code, name, faculty_code) VALUES ('BIS', 'Business Information System', 'FIT');
INSERT INTO program (code, name, faculty_code) VALUES ('ITSEC', 'Information Technology Security', 'FIT');
-- Faculty of Law
INSERT INTO program (code, name, faculty_code) VALUES ('ELAW', 'Economic Law', 'FLAW');
INSERT INTO program (code, name, faculty_code) VALUES ('CLAW', 'Commercial Law', 'FLAW');
INSERT INTO program (code, name, faculty_code) VALUES ('CVLAW', 'Civil Law', 'FLAW');
-- Faculty of Music
INSERT INTO program (code, name, faculty_code) VALUES ('VOCAL', 'Vocalist', 'FMUS');
INSERT INTO program (code, name, faculty_code) VALUES ('COMP', 'Music Composed', 'FMUS');
INSERT INTO program (code, name, faculty_code) VALUES ('INS', 'Instrument', 'FMUS');

-- Module
-- general
INSERT INTO module (code, name, program_code) VALUES ('MABA', 'Mathematic', 'BA');
INSERT INTO module (code, name, program_code) VALUES ('MALO', 'Mathematic', 'LOG');
INSERT INTO module (code, name, program_code) VALUES ('MAEC', 'Mathematic', 'ECO');
INSERT INTO module (code, name, program_code) VALUES ('MAME', 'Mathematic', 'ME');
INSERT INTO module (code, name, program_code) VALUES ('MAEE', 'Mathematic', 'EE');
INSERT INTO module (code, name, program_code) VALUES ('MACE', 'Mathematic', 'CE');
INSERT INTO module (code, name, program_code) VALUES ('MACS', 'Mathematic', 'CSE');
INSERT INTO module (code, name, program_code) VALUES ('MABI', 'Mathematic', 'BIS');
INSERT INTO module (code, name, program_code) VALUES ('MAIT', 'Mathematic', 'ITSEC');
-- BA
INSERT INTO module (code, name, program_code) VALUES ('MAK', 'Marketing', 'BA');
INSERT INTO module (code, name, program_code) VALUES ('MAN', 'Management', 'BA');
-- Logistics
INSERT INTO module (code, name, program_code) VALUES ('LOT', 'Logistic Theory', 'LOG');
INSERT INTO module (code, name, program_code) VALUES ('IOM', 'Import and Export management', 'LOG');
-- Economics
INSERT INTO module (code, name, program_code) VALUES ('MAE', 'Macro Economic', 'ECO');
INSERT INTO module (code, name, program_code) VALUES ('MIE', 'Micro Economic', 'ECO');

-- ME
INSERT INTO module (code, name, program_code) VALUES ('PHYS', 'Physic', 'ME');
INSERT INTO module (code, name, program_code) VALUES ('CHEM', 'Chemistry', 'ME');
-- EE
INSERT INTO module (code, name, program_code) VALUES ('AUTO', 'Automation', 'EE');
INSERT INTO module (code, name, program_code) VALUES ('HWE', 'Hardware Engineering', 'EE');
-- Civil Engineering
INSERT INTO module (code, name, program_code) VALUES ('UWM', 'Urban Water Management', 'CE');
INSERT INTO module (code, name, program_code) VALUES ('TRE', 'Traffic Engineering', 'CE');

-- CSE
INSERT INTO module (code, name, program_code) VALUES ('PE', 'Programming Exercise', 'CSE');
INSERT INTO module (code, name, program_code) VALUES ('SWE', 'Software Engineering', 'CSE');
-- BIS
INSERT INTO module (code, name, program_code) VALUES ('DBSYS', 'Database System', 'BIS');
INSERT INTO module (code, name, program_code) VALUES ('SARC', 'System Architecture', 'BIS');
-- ITSEC
INSERT INTO module (code, name, program_code) VALUES ('CNET', 'Computer Network', 'ITSEC');
INSERT INTO module (code, name, program_code) VALUES ('CRYP', 'Cryptography', 'ITSEC');

-- general Law
INSERT INTO module (code, name, program_code) VALUES ('ALEL', 'Administration Law', 'ELAW');
INSERT INTO module (code, name, program_code) VALUES ('ALCL', 'Administration Law', 'CLAW');
INSERT INTO module (code, name, program_code) VALUES ('ALCV', 'Administration Law', 'CVLAW');
-- Economic Law
INSERT INTO module (code, name, program_code) VALUES ('ILAW', 'International Law', 'ELAW');
INSERT INTO module (code, name, program_code) VALUES ('IVML', 'Investment Law', 'ELAW');
-- Commercial Law
INSERT INTO module (code, name, program_code) VALUES ('DITL', 'Domestic and International Tax Law', 'CLAW');
INSERT INTO module (code, name, program_code) VALUES ('IPL', 'Intellectual Property Law', 'CLAW');
-- Civil Law
INSERT INTO module (code, name, program_code) VALUES ('HRL', 'Human Rights Law', 'CVLAW');
INSERT INTO module (code, name, program_code) VALUES ('CVPD', 'Civil Procedure', 'CVLAW');

-- general Music
INSERT INTO module (code, name, program_code) VALUES ('MTVO', 'Music Theory', 'VOCAL');
INSERT INTO module (code, name, program_code) VALUES ('MTCO', 'Music Theory', 'COMP');
INSERT INTO module (code, name, program_code) VALUES ('MTIN', 'Music Theory', 'INS');

-- Vocal
INSERT INTO module (code, name, program_code) VALUES ('PERF', 'Performance-oriented', 'VOCAL');
INSERT INTO module (code, name, program_code) VALUES ('HAR', 'Harmony', 'VOCAL');
-- Instru
INSERT INTO module (code, name, program_code) VALUES ('KBS', 'Keyboard Skill', 'COMP');
INSERT INTO module (code, name, program_code) VALUES ('NTT', 'Notation', 'COMP');
-- Composed
INSERT INTO module (code, name, program_code) VALUES ('HOM', 'History of Music', 'INS');
INSERT INTO module (code, name, program_code) VALUES ('CMP', 'Composition', 'INS');

-- Academic year
INSERT INTO academic_year (code) VALUES ('2016-2017');
INSERT INTO academic_year (code) VALUES ('2017-2018');
INSERT INTO academic_year (code) VALUES ('2018-2019');
INSERT INTO academic_year (code) VALUES ('2019-2020');
INSERT INTO academic_year (code) VALUES ('2020-2021');

-- Lecturer
INSERT INTO lecturer (code, name) VALUES ('1', 'Jo Urvoy');
INSERT INTO lecturer (code, name) VALUES ('2', 'Winslow Flatt');
INSERT INTO lecturer (code, name) VALUES ('3', 'Estel Nenci');
INSERT INTO lecturer (code, name) VALUES ('4', 'Tiffy Falco');
INSERT INTO lecturer (code, name) VALUES ('5', 'Stephan Berard');
INSERT INTO lecturer (code, name) VALUES ('6', 'Sissy Ellamont');
INSERT INTO lecturer (code, name) VALUES ('7', 'Caresa Greengrass');
INSERT INTO lecturer (code, name) VALUES ('8', 'Cyril Fadden');
INSERT INTO lecturer (code, name) VALUES ('9', 'Anthe Roony');
INSERT INTO lecturer (code, name) VALUES ('10', 'Anjanette Andrivot');
INSERT INTO lecturer (code, name) VALUES ('11', 'Wiley Durno');
INSERT INTO lecturer (code, name) VALUES ('12', 'Peria Kaman');
INSERT INTO lecturer (code, name) VALUES ('13', 'Cleveland Hylden');
INSERT INTO lecturer (code, name) VALUES ('14', 'Barny Pizzie');
INSERT INTO lecturer (code, name) VALUES ('15', 'Sinclair Crommett');
INSERT INTO lecturer (code, name) VALUES ('16', 'Gerti Izat');
INSERT INTO lecturer (code, name) VALUES ('17', 'Brook Flattman');
INSERT INTO lecturer (code, name) VALUES ('18', 'Dunc Whife');
INSERT INTO lecturer (code, name) VALUES ('19', 'Hilde Booler');
INSERT INTO lecturer (code, name) VALUES ('20', 'Fredi Forty');
INSERT INTO lecturer (code, name) VALUES ('21', 'Layne Whitton');
INSERT INTO lecturer (code, name) VALUES ('22', 'Demetria Loughrey');
INSERT INTO lecturer (code, name) VALUES ('23', 'Le VZ');

-- Semester
INSERT INTO semester (code, academic_code) VALUES ('WS16', '2016-2017');
INSERT INTO semester (code, academic_code) VALUES ('SS17', '2016-2017');
INSERT INTO semester (code, academic_code) VALUES ('WS17', '2017-2018');
INSERT INTO semester (code, academic_code) VALUES ('SS18', '2017-2018');
INSERT INTO semester (code, academic_code) VALUES ('WS18', '2018-2019');
INSERT INTO semester (code, academic_code) VALUES ('SS19', '2018-2019');
INSERT INTO semester (code, academic_code) VALUES ('WS19', '2019-2020');
INSERT INTO semester (code, academic_code) VALUES ('SS20', '2019-2020');
INSERT INTO semester (code, academic_code) VALUES ('WS20', '2020-2021');
INSERT INTO semester (code, academic_code) VALUES ('SS21', '2020-2021');

-- Class
-- CSE
insert into class (code, size, semester_code, module_code) values (1, 47, 'WS16', 'MACS');
insert into class (code, size, semester_code, module_code) values (2, 57, 'SS17', 'PE');
insert into class (code, size, semester_code, module_code) values (3, 61, 'SS17', 'SWE');
insert into class (code, size, semester_code, module_code) values (4, 43, 'WS17', 'MACS');
insert into class (code, size, semester_code, module_code) values (5, 43, 'SS18', 'PE');
insert into class (code, size, semester_code, module_code) values (6, 43, 'SS18', 'SWE');
insert into class (code, size, semester_code, module_code) values (7, 61, 'WS18', 'MACS');
insert into class (code, size, semester_code, module_code) values (8, 47, 'SS19', 'PE');
insert into class (code, size, semester_code, module_code) values (9, 53, 'SS19', 'SWE');
insert into class (code, size, semester_code, module_code) values (10, 53, 'WS19', 'MACS');
insert into class (code, size, semester_code, module_code) values (11, 43, 'SS20', 'PE');
insert into class (code, size, semester_code, module_code) values (12, 53, 'SS20', 'SWE');
insert into class (code, size, semester_code, module_code) values (13, 57, 'WS20', 'MACS');
insert into class (code, size, semester_code, module_code) values (14, 53, 'SS21', 'PE');
insert into class (code, size, semester_code, module_code) values (15, 53, 'SS21', 'SWE');
-- BIS
insert into class (code, size, semester_code, module_code) values (16, 47, 'WS16', 'MABI');
insert into class (code, size, semester_code, module_code) values (17, 57, 'SS17', 'DBSYS');
insert into class (code, size, semester_code, module_code) values (18, 61, 'SS17', 'SARC');
insert into class (code, size, semester_code, module_code) values (19, 61, 'WS17', 'MABI');
insert into class (code, size, semester_code, module_code) values (20, 57, 'SS18', 'DBSYS');
insert into class (code, size, semester_code, module_code) values (21, 57, 'SS18', 'SARC');
insert into class (code, size, semester_code, module_code) values (22, 57, 'WS18', 'MABI');
insert into class (code, size, semester_code, module_code) values (23, 47, 'SS19', 'DBSYS');
insert into class (code, size, semester_code, module_code) values (24, 43, 'SS19', 'SARC');
insert into class (code, size, semester_code, module_code) values (25, 53, 'WS19', 'MABI');
insert into class (code, size, semester_code, module_code) values (26, 57, 'SS20', 'DBSYS');
insert into class (code, size, semester_code, module_code) values (27, 61, 'SS20', 'SARC');
insert into class (code, size, semester_code, module_code) values (28, 53, 'WS20', 'MABI');
insert into class (code, size, semester_code, module_code) values (29, 61, 'SS21', 'DBSYS');
insert into class (code, size, semester_code, module_code) values (30, 53, 'SS21', 'SARC');
-- ME
insert into class (code, size, semester_code, module_code) values (31, 42, 'WS16', 'MAME');
insert into class (code, size, semester_code, module_code) values (32, 37, 'SS17', 'PHYS');
insert into class (code, size, semester_code, module_code) values (33, 41, 'SS17', 'CHEM');
insert into class (code, size, semester_code, module_code) values (34, 41, 'WS17', 'MAME');
insert into class (code, size, semester_code, module_code) values (35, 53, 'SS18', 'PHYS');
insert into class (code, size, semester_code, module_code) values (36, 34, 'SS18', 'CHEM');
insert into class (code, size, semester_code, module_code) values (37, 61, 'WS18', 'MAME');
insert into class (code, size, semester_code, module_code) values (38, 67, 'SS19', 'PHYS');
insert into class (code, size, semester_code, module_code) values (39, 64, 'SS19', 'CHEM');
insert into class (code, size, semester_code, module_code) values (40, 67, 'WS19', 'MAME');
insert into class (code, size, semester_code, module_code) values (41, 37, 'SS20', 'PHYS');
insert into class (code, size, semester_code, module_code) values (42, 33, 'SS20', 'CHEM');
insert into class (code, size, semester_code, module_code) values (43, 46, 'WS20', 'MAME');
insert into class (code, size, semester_code, module_code) values (44, 41, 'SS21', 'PHYS');
insert into class (code, size, semester_code, module_code) values (45, 31, 'SS21', 'CHEM');
-- ITSEC
insert into class (code, size, semester_code, module_code) values (46, 67, 'WS17', 'MAIT');
insert into class (code, size, semester_code, module_code) values (47, 37, 'SS18', 'CNET');
insert into class (code, size, semester_code, module_code) values (48, 63, 'SS18', 'CRYP');
insert into class (code, size, semester_code, module_code) values (49, 57, 'WS18', 'MAIT');
insert into class (code, size, semester_code, module_code) values (50, 48, 'SS19', 'CNET');
insert into class (code, size, semester_code, module_code) values (51, 38, 'SS19', 'CRYP');
insert into class (code, size, semester_code, module_code) values (52, 62, 'WS19', 'MAIT');
insert into class (code, size, semester_code, module_code) values (53, 47, 'SS20', 'CNET');
insert into class (code, size, semester_code, module_code) values (54, 35, 'SS20', 'CRYP');
insert into class (code, size, semester_code, module_code) values (55, 61, 'WS20', 'MAIT');
insert into class (code, size, semester_code, module_code) values (56, 31, 'SS21', 'CNET');
insert into class (code, size, semester_code, module_code) values (57, 44, 'SS21', 'CRYP');
-- EE
insert into class (code, size, semester_code, module_code) values (61, 67, 'WS17', 'MAEE');
insert into class (code, size, semester_code, module_code) values (62, 64, 'SS18', 'AUTO');
insert into class (code, size, semester_code, module_code) values (63, 42, 'SS18', 'HWE');
insert into class (code, size, semester_code, module_code) values (64, 32, 'WS18', 'MAEE');
insert into class (code, size, semester_code, module_code) values (65, 58, 'SS19', 'AUTO');
insert into class (code, size, semester_code, module_code) values (66, 50, 'SS19', 'HWE');
insert into class (code, size, semester_code, module_code) values (67, 59, 'WS19', 'MAEE');
insert into class (code, size, semester_code, module_code) values (68, 58, 'SS20', 'AUTO');
insert into class (code, size, semester_code, module_code) values (69, 50, 'SS20', 'HWE');
insert into class (code, size, semester_code, module_code) values (70, 46, 'WS20', 'MAEE');
insert into class (code, size, semester_code, module_code) values (71, 65, 'SS21', 'AUTO');
insert into class (code, size, semester_code, module_code) values (72, 39, 'SS21', 'HWE');
-- BA
insert into class (code, size, semester_code, module_code) values (58, 59, 'WS17', 'MABA');
insert into class (code, size, semester_code, module_code) values (59, 57, 'SS18', 'MAK');
insert into class (code, size, semester_code, module_code) values (60, 56, 'SS18', 'MAN');
-- LOG
insert into class (code, size, semester_code, module_code) values (73, 62, 'WS18', 'MALO');
insert into class (code, size, semester_code, module_code) values (74, 44, 'SS19', 'LOT');
insert into class (code, size, semester_code, module_code) values (75, 63, 'SS19', 'IOM');
-- ELAW
insert into class (code, size, semester_code, module_code) values (76, 55, 'WS18', 'ALEL');
insert into class (code, size, semester_code, module_code) values (77, 54, 'SS19', 'ILAW');
insert into class (code, size, semester_code, module_code) values (78, 32, 'SS19', 'IVML');
-- CE
insert into class (code, size, semester_code, module_code) values (79, 55, 'WS19', 'MACE');
insert into class (code, size, semester_code, module_code) values (80, 46, 'SS20', 'UWM');
insert into class (code, size, semester_code, module_code) values (81, 47, 'SS20', 'TRE');
insert into class (code, size, semester_code, module_code) values (82, 33, 'WS20', 'MACE');
insert into class (code, size, semester_code, module_code) values (83, 48, 'SS21', 'UWM');
insert into class (code, size, semester_code, module_code) values (84, 58, 'SS21', 'TRE');
-- ECO
insert into class (code, size, semester_code, module_code) values (85, 65, 'WS19', 'MAEC');
insert into class (code, size, semester_code, module_code) values (86, 51, 'SS20', 'MAE');
insert into class (code, size, semester_code, module_code) values (87, 54, 'SS20', 'MIE');
insert into class (code, size, semester_code, module_code) values (88, 34, 'WS20', 'MAEC');
insert into class (code, size, semester_code, module_code) values (89, 52, 'SS21', 'MAE');
insert into class (code, size, semester_code, module_code) values (90, 32, 'SS21', 'MIE');
-- CLAW
insert into class (code, size, semester_code, module_code) values (91, 66, 'WS19', 'ALCL');
insert into class (code, size, semester_code, module_code) values (92, 36, 'SS20', 'DITL');
insert into class (code, size, semester_code, module_code) values (93, 60, 'SS20', 'IPL');
-- CVLAW
insert into class (code, size, semester_code, module_code) values (94, 51, 'WS20', 'ALCV');
insert into class (code, size, semester_code, module_code) values (95, 40, 'SS21', 'HRL');
insert into class (code, size, semester_code, module_code) values (96, 39, 'SS21', 'CVPD');
-- COMP
insert into class (code, size, semester_code, module_code) values (97, 50, 'WS20', 'MTCO');
insert into class (code, size, semester_code, module_code) values (98, 40, 'SS21', 'KBS');
insert into class (code, size, semester_code, module_code) values (99, 32, 'SS21', 'NTT');

-- Teaching
-- FECO
insert into teaching (class_code, lecturer_code) values (58, 3);
insert into teaching (class_code, lecturer_code) values (59, 3);
insert into teaching (class_code, lecturer_code) values (60, 4);
insert into teaching (class_code, lecturer_code) values (86, 2);
insert into teaching (class_code, lecturer_code) values (89, 3);
insert into teaching (class_code, lecturer_code) values (85, 5);
insert into teaching (class_code, lecturer_code) values (88, 4);
insert into teaching (class_code, lecturer_code) values (87, 3);
insert into teaching (class_code, lecturer_code) values (90, 2);
insert into teaching (class_code, lecturer_code) values (75, 4);
insert into teaching (class_code, lecturer_code) values (74, 1);
insert into teaching (class_code, lecturer_code) values (73, 5);
insert into teaching (class_code, lecturer_code) values (58, 1);
insert into teaching (class_code, lecturer_code) values (59, 4);
insert into teaching (class_code, lecturer_code) values (60, 2);
insert into teaching (class_code, lecturer_code) values (86, 3);
insert into teaching (class_code, lecturer_code) values (89, 5);
insert into teaching (class_code, lecturer_code) values (85, 4);
insert into teaching (class_code, lecturer_code) values (88, 2);
-- FENG
insert into teaching (class_code, lecturer_code) values (79, 7);
insert into teaching (class_code, lecturer_code) values (82, 9);
insert into teaching (class_code, lecturer_code) values (81, 10);
insert into teaching (class_code, lecturer_code) values (84, 8);
insert into teaching (class_code, lecturer_code) values (80, 6);
insert into teaching (class_code, lecturer_code) values (83, 7);
insert into teaching (class_code, lecturer_code) values (62, 9);
insert into teaching (class_code, lecturer_code) values (65, 6);
insert into teaching (class_code, lecturer_code) values (68, 10);
insert into teaching (class_code, lecturer_code) values (71, 8);
insert into teaching (class_code, lecturer_code) values (63, 9);
insert into teaching (class_code, lecturer_code) values (66, 9);
insert into teaching (class_code, lecturer_code) values (69, 6);
insert into teaching (class_code, lecturer_code) values (72, 6);
insert into teaching (class_code, lecturer_code) values (61, 10);
insert into teaching (class_code, lecturer_code) values (64, 7);
insert into teaching (class_code, lecturer_code) values (67, 9);
insert into teaching (class_code, lecturer_code) values (70, 10);
insert into teaching (class_code, lecturer_code) values (33, 6);
insert into teaching (class_code, lecturer_code) values (36, 6);
insert into teaching (class_code, lecturer_code) values (39, 8);
insert into teaching (class_code, lecturer_code) values (42, 8);
insert into teaching (class_code, lecturer_code) values (45, 10);
insert into teaching (class_code, lecturer_code) values (31, 6);
insert into teaching (class_code, lecturer_code) values (34, 6);
insert into teaching (class_code, lecturer_code) values (37, 9);
insert into teaching (class_code, lecturer_code) values (40, 9);
insert into teaching (class_code, lecturer_code) values (43, 8);
insert into teaching (class_code, lecturer_code) values (32, 6);
insert into teaching (class_code, lecturer_code) values (35, 8);
insert into teaching (class_code, lecturer_code) values (38, 9);
insert into teaching (class_code, lecturer_code) values (41, 10);
insert into teaching (class_code, lecturer_code) values (44, 10);
insert into teaching (class_code, lecturer_code) values (79, 10);
insert into teaching (class_code, lecturer_code) values (81, 8);
insert into teaching (class_code, lecturer_code) values (84, 10);
insert into teaching (class_code, lecturer_code) values (80, 7);
insert into teaching (class_code, lecturer_code) values (83, 9);
insert into teaching (class_code, lecturer_code) values (62, 8);
insert into teaching (class_code, lecturer_code) values (65, 10);
-- FIT
insert into teaching (class_code, lecturer_code) values (17, 13);
insert into teaching (class_code, lecturer_code) values (20, 11);
insert into teaching (class_code, lecturer_code) values (23, 11);
insert into teaching (class_code, lecturer_code) values (26, 15);
insert into teaching (class_code, lecturer_code) values (29, 15);
insert into teaching (class_code, lecturer_code) values (16, 12);
insert into teaching (class_code, lecturer_code) values (19, 14);
insert into teaching (class_code, lecturer_code) values (22, 13);
insert into teaching (class_code, lecturer_code) values (25, 12);
insert into teaching (class_code, lecturer_code) values (28, 13);
insert into teaching (class_code, lecturer_code) values (18, 14);
insert into teaching (class_code, lecturer_code) values (21, 15);
insert into teaching (class_code, lecturer_code) values (24, 11);
insert into teaching (class_code, lecturer_code) values (27, 15);
insert into teaching (class_code, lecturer_code) values (30, 14);
insert into teaching (class_code, lecturer_code) values (1, 11);
insert into teaching (class_code, lecturer_code) values (10, 11);
insert into teaching (class_code, lecturer_code) values (13, 12);
insert into teaching (class_code, lecturer_code) values (4, 12);
insert into teaching (class_code, lecturer_code) values (7, 13);
insert into teaching (class_code, lecturer_code) values (11, 15);
insert into teaching (class_code, lecturer_code) values (14, 15);
insert into teaching (class_code, lecturer_code) values (2, 11);
insert into teaching (class_code, lecturer_code) values (5, 15);
insert into teaching (class_code, lecturer_code) values (8, 13);
insert into teaching (class_code, lecturer_code) values (12, 12);
insert into teaching (class_code, lecturer_code) values (15, 13);
insert into teaching (class_code, lecturer_code) values (3, 15);
insert into teaching (class_code, lecturer_code) values (6, 14);
insert into teaching (class_code, lecturer_code) values (9, 11);
insert into teaching (class_code, lecturer_code) values (47, 15);
insert into teaching (class_code, lecturer_code) values (50, 13);
insert into teaching (class_code, lecturer_code) values (53, 15);
insert into teaching (class_code, lecturer_code) values (56, 12);
insert into teaching (class_code, lecturer_code) values (48, 15);
insert into teaching (class_code, lecturer_code) values (51, 14);
insert into teaching (class_code, lecturer_code) values (54, 15);
insert into teaching (class_code, lecturer_code) values (57, 13);
insert into teaching (class_code, lecturer_code) values (46, 11);
insert into teaching (class_code, lecturer_code) values (49, 15);
insert into teaching (class_code, lecturer_code) values (52, 15);
insert into teaching (class_code, lecturer_code) values (55, 13);
insert into teaching (class_code, lecturer_code) values (26, 14);
insert into teaching (class_code, lecturer_code) values (29, 11);
insert into teaching (class_code, lecturer_code) values (19, 13);
insert into teaching (class_code, lecturer_code) values (22, 14);
insert into teaching (class_code, lecturer_code) values (25, 15);
insert into teaching (class_code, lecturer_code) values (18, 15);
-- FLAW
insert into teaching (class_code, lecturer_code) values (91, 19);
insert into teaching (class_code, lecturer_code) values (92, 16);
insert into teaching (class_code, lecturer_code) values (93, 16);
insert into teaching (class_code, lecturer_code) values (94, 20);
insert into teaching (class_code, lecturer_code) values (96, 20);
insert into teaching (class_code, lecturer_code) values (95, 17);
insert into teaching (class_code, lecturer_code) values (76, 19);
insert into teaching (class_code, lecturer_code) values (77, 20);
insert into teaching (class_code, lecturer_code) values (78, 17);
insert into teaching (class_code, lecturer_code) values (91, 20);
insert into teaching (class_code, lecturer_code) values (92, 20);
insert into teaching (class_code, lecturer_code) values (93, 20);
insert into teaching (class_code, lecturer_code) values (94, 16);
insert into teaching (class_code, lecturer_code) values (96, 17);
insert into teaching (class_code, lecturer_code) values (95, 19);
insert into teaching (class_code, lecturer_code) values (76, 20);
insert into teaching (class_code, lecturer_code) values (78, 16);
insert into teaching (class_code, lecturer_code) values (91, 17);
insert into teaching (class_code, lecturer_code) values (96, 18);
-- FMUS
insert into teaching (class_code, lecturer_code) values (98, 21);
insert into teaching (class_code, lecturer_code) values (97, 21);
insert into teaching (class_code, lecturer_code) values (99, 23);
insert into teaching (class_code, lecturer_code) values (97, 23);
insert into teaching (class_code, lecturer_code) values (99, 21);