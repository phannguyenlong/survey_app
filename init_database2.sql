-- ======================CREATE SCHEMA======================
-- CREATE SCHEMA java_app;
-- USE java_app;

-- ======================CREATE GUEST USER======================
-- CREATE USER 'guest'@'localhost' IDENTIFIED BY 'password';
-- GRANT ALL PRIVILEGES ON * . * TO 'guest'@'localhost';

-- ======================CREATE TABLE path======================
-- Clean up old table
DROP TABLE IF EXISTS answer;
DROP TABLE IF EXISTS questionaire;
DROP TABLE IF EXISTS teaching;
DROP TABLE IF EXISTS class;
DROP TABLE IF EXISTS year_fac_pro_mo;
DROP TABLE IF EXISTS year_fac_pro;
DROP TABLE IF EXISTS year_faculty;
DROP TABLE IF EXISTS semester;
DROP TABLE IF EXISTS academic_year;
DROP TABLE IF EXISTS module;
DROP TABLE IF EXISTS program;
DROP TABLE IF EXISTS faculty;
DROP TABLE IF EXISTS lecturer;
DROP TABLE IF EXISTS question;

-- Create table
CREATE TABLE faculty (
	fa_code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE program (
	pro_code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE module (
	mo_code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE academic_year (
	aca_code VARCHAR(10) PRIMARY KEY
);

CREATE TABLE lecturer (
	lec_code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE semester (
	sem_code VARCHAR(10) PRIMARY KEY,
    academic_code VARCHAR(10),
    FOREIGN KEY (academic_code) REFERENCES academic_year(aca_code)
);

CREATE TABLE question (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    content VARCHAR(200)
);

CREATE TABLE year_faculty (
	id_1 VARCHAR(20) PRIMARY KEY,
    academic_code VARCHAR(10),
    faculty_code VARCHAR(10),
    FOREIGN KEY (academic_code) REFERENCES academic_year(aca_code),
    FOREIGN KEY (faculty_code) REFERENCES faculty(fa_code)
);

CREATE TABLE year_fac_pro (
	id_2 INT AUTO_INCREMENT PRIMARY KEY,
    id_1 VARCHAR(20),
    program_code VARCHAR(10),
    FOREIGN KEY (id_1) REFERENCES year_faculty(id_1),
    FOREIGN KEY (program_code) REFERENCES program(pro_code)
);

CREATE TABLE year_fac_pro_mo (
	id_3 INT AUTO_INCREMENT PRIMARY KEY,
    id_2 INT,
    module_code VARCHAR(10),
    FOREIGN KEY (id_2) REFERENCES year_fac_pro(id_2),
    FOREIGN KEY (module_code) REFERENCES module(mo_code)
);

CREATE TABLE class (
	class_code VARCHAR(10) PRIMARY KEY,
    size INTEGER NOT NULL,
    semester_code VARCHAR(10),
    id_3 INT,
    FOREIGN KEY (semester_code) REFERENCES semester(sem_code),
    FOREIGN KEY (id_3) REFERENCES year_fac_pro_mo(id_3)
);

CREATE TABLE teaching (
	class_code VARCHAR(10),
    lecturer_code VARCHAR(10),
    PRIMARY KEY (class_code, lecturer_code),
    FOREIGN KEY (class_code) REFERENCES class(class_code),
    FOREIGN KEY (lecturer_code) REFERENCES lecturer(lec_code)
);

CREATE TABLE questionaire (
	id INT AUTO_INCREMENT PRIMARY KEY,
	class_code VARCHAR(10),
    lecturer_code VARCHAR(10),
    FOREIGN KEY (class_code) REFERENCES class(class_code),
    FOREIGN KEY (lecturer_code) REFERENCES lecturer(lec_code)
);

CREATE TABLE answer (
	questionaire_id INT ,
    answer_1 VARCHAR(9) NOT NULL,
    answer_2 VARCHAR(6) NOT NULL,
    answer_3 VARCHAR(2) NOT NULL,
    answer_4 VARCHAR(2) NOT NULL,
    answer_5 VARCHAR(2) NOT NULL,
    answer_6 VARCHAR(2) NOT NULL,
    answer_7 VARCHAR(2) NOT NULL,
    answer_8 VARCHAR(2) NOT NULL,
    answer_9 VARCHAR(2) NOT NULL,
    answer_10 VARCHAR(2) NOT NULL,
    answer_11 VARCHAR(2) NOT NULL,
    answer_12 VARCHAR(2) NOT NULL,
    answer_13 VARCHAR(2) NOT NULL,
    answer_14 VARCHAR(2) NOT NULL,
    answer_15 VARCHAR(2) NOT NULL,
    answer_16 VARCHAR(2) NOT NULL,
    answer_17 VARCHAR(2) NOT NULL,
    answer_18 VARCHAR(2) NOT NULL,
    answer_19 VARCHAR(2) NOT NULL,
    answer_20 VARCHAR(100) NOT NULL,
	FOREIGN KEY (questionaire_id) REFERENCES questionaire(id),
    CHECK  ((answer_1="Never" or answer_1="Rarely" or answer_1="Sometimes" or answer_1="Often" or answer_1="Always") and
			(answer_2="Male" or answer_2="Female" or answer_2="Other") and
			(answer_3 BETWEEN 1 AND 5 or answer_3 = "NA") and 
			(answer_4 BETWEEN 1 AND 5 or answer_4 = "NA") and 
			(answer_5 BETWEEN 1 AND 5 or answer_5 = "NA") and
            (answer_6 BETWEEN 1 AND 5 or answer_6 = "NA") and 
			(answer_7 BETWEEN 1 AND 5 or answer_7 = "NA") and 
			(answer_8 BETWEEN 1 AND 5 or answer_8 = "NA") and
            (answer_9 BETWEEN 1 AND 5) and
            (answer_10 BETWEEN 1 AND 5) and
            (answer_11 BETWEEN 1 AND 5) and
            (answer_12 BETWEEN 1 AND 5 or answer_12 = "NA") and 
			(answer_13 BETWEEN 1 AND 5 or answer_13 = "NA") and 
			(answer_14 BETWEEN 1 AND 5 or answer_14 = "NA") and
            (answer_15 BETWEEN 1 AND 5 or answer_15 = "NA") and 
			(answer_16 BETWEEN 1 AND 5 or answer_16 = "NA") and 
			(answer_17 BETWEEN 1 AND 5 or answer_17 = "NA") and
            (answer_18 BETWEEN 1 AND 5 or answer_18 = "NA") and 
			(answer_19 BETWEEN 1 AND 5 or answer_19 = "NA"))
);
-- ======================Insert Data======================

-- Falcuty
INSERT INTO faculty (fa_code, name) VALUE ('FECO', 'Faculty of Economics');
INSERT INTO faculty (fa_code, name) VALUE ('FENG', 'Faculty of Engineering');
INSERT INTO faculty (fa_code, name) VALUE ('FIT', 'Faculty of  Information Technology');
INSERT INTO faculty (fa_code, name) VALUE ('FLAW', 'Faculty of Law');
INSERT INTO faculty (fa_code, name) VALUE ('FMUS', 'Faculty of Music');

-- Academic year
INSERT INTO academic_year (aca_code) VALUES ('2016-2017');
INSERT INTO academic_year (aca_code) VALUES ('2017-2018');
INSERT INTO academic_year (aca_code) VALUES ('2018-2019');
INSERT INTO academic_year (aca_code) VALUES ('2019-2020');
INSERT INTO academic_year (aca_code) VALUES ('2020-2021');

-- year_faculty
INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2016-2017_FIT", "2016-2017", "FIT");
INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2016-2017_FENG", "2016-2017", "FENG");

INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2017-2018_FECO", "2017-2018", "FECO");
INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2017-2018_FENG", "2017-2018", "FENG");
INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2017-2018_FIT", "2017-2018", "FIT");

INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2018-2019_FECO", "2018-2019", "FECO");
INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2018-2019_FENG", "2018-2019", "FENG");
INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2018-2019_FIT", "2018-2019", "FIT");
INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2018-2019_FLAW", "2018-2019", "FLAW");

INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2019-2020_FECO", "2019-2020", "FECO");
INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2019-2020_FENG", "2019-2020", "FENG");
INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2019-2020_FIT", "2019-2020", "FIT");
INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2019-2020_FLAW", "2019-2020", "FLAW");

INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2020-2021_FECO", "2020-2021", "FECO");
INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2020-2021_FENG", "2020-2021", "FENG");
INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2020-2021_FIT", "2020-2021", "FIT");
INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2020-2021_FLAW", "2020-2021", "FLAW");
INSERT INTO year_faculty (id_1, academic_code, faculty_code) VALUES ("2020-2021_FMUS", "2020-2021", "FMUS");

-- Program
-- Faculty of economic
INSERT INTO program (pro_code, name) VALUES ('BA', 'Business Administration');
INSERT INTO program (pro_code, name) VALUES ('LOG', 'Logistics');
INSERT INTO program (pro_code, name) VALUES ('ECO', 'Economics');
-- Faculty of Engineering
INSERT INTO program (pro_code, name) VALUES ('ME', 'Mechanical Engineering');
INSERT INTO program (pro_code, name) VALUES ('EE', 'Electrical Engineering');
INSERT INTO program (pro_code, name) VALUES ('CE', 'Civil Engineering');
-- Faculty of IT
INSERT INTO program (pro_code, name) VALUES ('CSE', 'Computer Science');
INSERT INTO program (pro_code, name) VALUES ('BIS', 'Business Information System');
INSERT INTO program (pro_code, name) VALUES ('ITSEC', 'Information Technology Security');
-- Faculty of Law
INSERT INTO program (pro_code, name) VALUES ('ELAW', 'Economic Law');
INSERT INTO program (pro_code, name) VALUES ('CLAW', 'Commercial Law');
INSERT INTO program (pro_code, name) VALUES ('CVLAW', 'Civil Law');
-- Faculty of Music
INSERT INTO program (pro_code, name) VALUES ('VOCAL', 'Vocalist');
INSERT INTO program (pro_code, name) VALUES ('COMP', 'Music Composed');
INSERT INTO program (pro_code, name) VALUES ('INS', 'Instrument');

-- year_fac_pro
INSERT INTO year_fac_pro(id_1, program_code) VALUES("2016-2017_FIT", "BIS");
INSERT INTO year_fac_pro(id_1, program_code) VALUES("2016-2017_FIT", "CSE");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2016-2017_FENG", "ME");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2017-2018_FECO", "BA");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2017-2018_FENG", "ME");
INSERT INTO year_fac_pro(id_1, program_code) VALUES("2017-2018_FENG", "EE");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2017-2018_FIT", "BIS");
INSERT INTO year_fac_pro(id_1, program_code) VALUES("2017-2018_FIT", "ITSEC");
INSERT INTO year_fac_pro(id_1, program_code) VALUES("2017-2018_FIT", "CSE");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2018-2019_FECO", "LOG");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2018-2019_FENG", "ME");
INSERT INTO year_fac_pro(id_1, program_code) VALUES("2018-2019_FENG", "EE");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2018-2019_FIT", "BIS");
INSERT INTO year_fac_pro(id_1, program_code) VALUES("2018-2019_FIT", "ITSEC");
INSERT INTO year_fac_pro(id_1, program_code) VALUES("2018-2019_FIT", "CSE");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2018-2019_FLAW", "ELAW");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2019-2020_FECO", "ECO");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2019-2020_FENG", "ME");
INSERT INTO year_fac_pro(id_1, program_code) VALUES("2019-2020_FENG", "EE");
INSERT INTO year_fac_pro(id_1, program_code) VALUES("2019-2020_FENG", "CE");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2019-2020_FIT", "BIS");
INSERT INTO year_fac_pro(id_1, program_code) VALUES("2019-2020_FIT", "ITSEC");
INSERT INTO year_fac_pro(id_1, program_code) VALUES("2019-2020_FIT", "CSE");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2019-2020_FLAW", "CLAW");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2020-2021_FECO", "ECO");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2020-2021_FENG", "ME");
INSERT INTO year_fac_pro(id_1, program_code) VALUES("2020-2021_FENG", "EE");
INSERT INTO year_fac_pro(id_1, program_code) VALUES("2020-2021_FENG", "CE");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2020-2021_FIT", "BIS");
INSERT INTO year_fac_pro(id_1, program_code) VALUES("2020-2021_FIT", "ITSEC");
INSERT INTO year_fac_pro(id_1, program_code) VALUES("2020-2021_FIT", "CSE");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2020-2021_FLAW", "CVLAW");

INSERT INTO year_fac_pro(id_1, program_code) VALUES("2020-2021_FMUS", "COMP");

-- Module
-- general
INSERT INTO module (mo_code, name) VALUES ('MABA', 'Mathematic');
INSERT INTO module (mo_code, name) VALUES ('MALO', 'Mathematic');
INSERT INTO module (mo_code, name) VALUES ('MAEC', 'Mathematic');
INSERT INTO module (mo_code, name) VALUES ('MAME', 'Mathematic');
INSERT INTO module (mo_code, name) VALUES ('MAEE', 'Mathematic');
INSERT INTO module (mo_code, name) VALUES ('MACE', 'Mathematic');
INSERT INTO module (mo_code, name) VALUES ('MACS', 'Mathematic');
INSERT INTO module (mo_code, name) VALUES ('MABI', 'Mathematic');
INSERT INTO module (mo_code, name) VALUES ('MAIT', 'Mathematic');
-- BA
INSERT INTO module (mo_code, name) VALUES ('MAK', 'Marketing');
INSERT INTO module (mo_code, name) VALUES ('MAN', 'Management');
-- Logistics
INSERT INTO module (mo_code, name) VALUES ('LOT', 'Logistic Theory');
INSERT INTO module (mo_code, name) VALUES ('IOM', 'Import and Export management');
-- Economics
INSERT INTO module (mo_code, name) VALUES ('MAE', 'Macro Economic');
INSERT INTO module (mo_code, name) VALUES ('MIE', 'Micro Economic');

-- ME
INSERT INTO module (mo_code, name) VALUES ('PHYS', 'Physic');
INSERT INTO module (mo_code, name) VALUES ('CHEM', 'Chemistry');
-- EE
INSERT INTO module (mo_code, name) VALUES ('AUTO', 'Automation');
INSERT INTO module (mo_code, name) VALUES ('HWE', 'Hardware Engineering');
-- Civil Engineering
INSERT INTO module (mo_code, name) VALUES ('UWM', 'Urban Water Management');
INSERT INTO module (mo_code, name) VALUES ('TRE', 'Traffic Engineering');

-- CSE
INSERT INTO module (mo_code, name) VALUES ('PE', 'Programming Exercise');
INSERT INTO module (mo_code, name) VALUES ('SWE', 'Software Engineering');
-- BIS
INSERT INTO module (mo_code, name) VALUES ('DBSYS', 'Database System');
INSERT INTO module (mo_code, name) VALUES ('SARC', 'System Architecture');
-- ITSEC
INSERT INTO module (mo_code, name) VALUES ('CNET', 'Computer Network');
INSERT INTO module (mo_code, name) VALUES ('CRYP', 'Cryptography');

-- general Law
INSERT INTO module (mo_code, name) VALUES ('ALEL', 'Administration Law');
INSERT INTO module (mo_code, name) VALUES ('ALCL', 'Administration Law');
INSERT INTO module (mo_code, name) VALUES ('ALCV', 'Administration Law');
-- Economic Law
INSERT INTO module (mo_code, name) VALUES ('ILAW', 'International Law');
INSERT INTO module (mo_code, name) VALUES ('IVML', 'Investment Law');
-- Commercial Law
INSERT INTO module (mo_code, name) VALUES ('DITL', 'Domestic and International Tax Law');
INSERT INTO module (mo_code, name) VALUES ('IPL', 'Intellectual Property Law');
-- Civil Law
INSERT INTO module (mo_code, name) VALUES ('HRL', 'Human Rights Law');
INSERT INTO module (mo_code, name) VALUES ('CVPD', 'Civil Procedure');

-- general Music
INSERT INTO module (mo_code, name) VALUES ('MTVO', 'Music Theory');
INSERT INTO module (mo_code, name) VALUES ('MTCO', 'Music Theory');
INSERT INTO module (mo_code, name) VALUES ('MTIN', 'Music Theory');

-- Vocal
INSERT INTO module (mo_code, name) VALUES ('PERF', 'Performance-oriented');
INSERT INTO module (mo_code, name) VALUES ('HAR', 'Harmony');
-- Instru
INSERT INTO module (mo_code, name) VALUES ('KBS', 'Keyboard Skill');
INSERT INTO module (mo_code, name) VALUES ('NTT', 'Notation');
-- Composed
INSERT INTO module (mo_code, name) VALUES ('HOM', 'History of Music');
INSERT INTO module (mo_code, name) VALUES ('CMP', 'Composition');

-- year_fac_pro_mo
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (1,'MABI');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (1,'DBSYS');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (1,'SARC');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (2,'SWE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (2,'MACS');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (2,'PE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (3,'MAME');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (3,'PHYS');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (3,'CHEM');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (4,'MABA');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (4,'MAK');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (4,'MAN');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (5,'MAME');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (5,'CHEM');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (5,'PHYS');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (6,'MAEE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (6,'AUTO');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (6,'HWE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (7,'MABI');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (7,'DBSYS');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (7,'SARC');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (8,'MAIT');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (8,'CRYP');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (8,'CNET');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (9,'MACS');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (9,'SWE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (9,'PE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (10,'MALO');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (10,'IOM');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (10,'LOT');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (11,'MAME');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (11,'CHEM');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (11,'PHYS');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (12,'MAEE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (12,'AUTO');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (12,'HWE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (13,'MABI');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (13,'DBSYS');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (13,'SARC');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (14,'MAIT');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (14,'CNET');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (14,'CRYP');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (15,'MACS');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (15,'SWE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (15,'PE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (16,'ALEL');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (16,'IVML');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (16,'ILAW');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (17,'MIE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (17,'MAEC');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (17,'MAE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (18,'MAME');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (18,'CHEM');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (18,'PHYS');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (19,'MAEE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (19,'AUTO');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (19,'HWE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (20,'MACE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (20,'TRE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (20,'UWM');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (21,'MABI');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (21,'DBSYS');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (21,'SARC');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (22,'MAIT');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (22,'CNET');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (22,'CRYP');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (23,'MACS');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (23,'SWE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (23,'PE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (24,'ALCL');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (24,'DITL');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (24,'IPL');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (25,'MIE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (25,'MAEC');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (25,'MAE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (26,'MAME');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (26,'CHEM');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (26,'PHYS');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (27,'MAEE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (27,'AUTO');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (27,'HWE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (28,'MACE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (28,'TRE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (28,'UWM');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (29,'MABI');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (29,'DBSYS');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (29,'SARC');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (30,'MAIT');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (30,'CNET');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (30,'CRYP');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (31,'MACS');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (31,'SWE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (31,'PE');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (32,'ALCV');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (32,'CVPD');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (32,'HRL');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (33,'KBS');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (33,'NTT');
INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (33,'MTCO');

-- Lecturer
INSERT INTO lecturer (lec_code, name) VALUES ('1', 'Jo Urvoy');
INSERT INTO lecturer (lec_code, name) VALUES ('2', 'Winslow Flatt');
INSERT INTO lecturer (lec_code, name) VALUES ('3', 'Estel Nenci');
INSERT INTO lecturer (lec_code, name) VALUES ('4', 'Tiffy Falco');
INSERT INTO lecturer (lec_code, name) VALUES ('5', 'Stephan Berard');
INSERT INTO lecturer (lec_code, name) VALUES ('6', 'Sissy Ellamont');
INSERT INTO lecturer (lec_code, name) VALUES ('7', 'Caresa Greengrass');
INSERT INTO lecturer (lec_code, name) VALUES ('8', 'Cyril Fadden');
INSERT INTO lecturer (lec_code, name) VALUES ('9', 'Anthe Roony');
INSERT INTO lecturer (lec_code, name) VALUES ('10', 'Anjanette Andrivot');
INSERT INTO lecturer (lec_code, name) VALUES ('11', 'Wiley Durno');
INSERT INTO lecturer (lec_code, name) VALUES ('12', 'Peria Kaman');
INSERT INTO lecturer (lec_code, name) VALUES ('13', 'Cleveland Hylden');
INSERT INTO lecturer (lec_code, name) VALUES ('14', 'Barny Pizzie');
INSERT INTO lecturer (lec_code, name) VALUES ('15', 'Sinclair Crommett');
INSERT INTO lecturer (lec_code, name) VALUES ('16', 'Gerti Izat');
INSERT INTO lecturer (lec_code, name) VALUES ('17', 'Brook Flattman');
INSERT INTO lecturer (lec_code, name) VALUES ('18', 'Dunc Whife');
INSERT INTO lecturer (lec_code, name) VALUES ('19', 'Hilde Booler');
INSERT INTO lecturer (lec_code, name) VALUES ('20', 'Fredi Forty');
INSERT INTO lecturer (lec_code, name) VALUES ('21', 'Layne Whitton');
INSERT INTO lecturer (lec_code, name) VALUES ('22', 'Demetria Loughrey');
INSERT INTO lecturer (lec_code, name) VALUES ('23', 'Le VZ');

-- Semester
INSERT INTO semester (sem_code, academic_code) VALUES ('WS16', '2016-2017');
INSERT INTO semester (sem_code, academic_code) VALUES ('SS17', '2016-2017');
INSERT INTO semester (sem_code, academic_code) VALUES ('WS17', '2017-2018');
INSERT INTO semester (sem_code, academic_code) VALUES ('SS18', '2017-2018');
INSERT INTO semester (sem_code, academic_code) VALUES ('WS18', '2018-2019');
INSERT INTO semester (sem_code, academic_code) VALUES ('SS19', '2018-2019');
INSERT INTO semester (sem_code, academic_code) VALUES ('WS19', '2019-2020');
INSERT INTO semester (sem_code, academic_code) VALUES ('SS20', '2019-2020');
INSERT INTO semester (sem_code, academic_code) VALUES ('WS20', '2020-2021');
INSERT INTO semester (sem_code, academic_code) VALUES ('SS21', '2020-2021');

-- Class
-- CSE
insert into class (class_code, size, semester_code,id_3) values (1, 47, 'WS16',4);
insert into class (class_code, size, semester_code,id_3) values (2, 57, 'SS17',5);
insert into class (class_code, size, semester_code,id_3) values (3, 61, 'SS17',6);
insert into class (class_code, size, semester_code,id_3) values (4, 43, 'WS17',25);
insert into class (class_code, size, semester_code,id_3) values (5, 43, 'SS18',26);
insert into class (class_code, size, semester_code,id_3) values (6, 43, 'SS18',27);
insert into class (class_code, size, semester_code,id_3) values (7, 61, 'WS18',43);
insert into class (class_code, size, semester_code,id_3) values (8, 47, 'SS19',44);
insert into class (class_code, size, semester_code,id_3) values (9, 53, 'SS19',45);
insert into class (class_code, size, semester_code,id_3) values (10, 53, 'WS19',67);
insert into class (class_code, size, semester_code,id_3) values (11, 43, 'SS20',68);
insert into class (class_code, size, semester_code,id_3) values (12, 53, 'SS20',69);
insert into class (class_code, size, semester_code,id_3) values (13, 57, 'WS20',91);
insert into class (class_code, size, semester_code,id_3) values (14, 53, 'SS21',92);
insert into class (class_code, size, semester_code,id_3) values (15, 53, 'SS21',93);
-- BIS
insert into class (class_code, size, semester_code,id_3) values (16, 47, 'WS16',1);
insert into class (class_code, size, semester_code,id_3) values (17, 57, 'SS17',2);
insert into class (class_code, size, semester_code,id_3) values (18, 61, 'SS17',3);
insert into class (class_code, size, semester_code,id_3) values (19, 61, 'WS17',19);
insert into class (class_code, size, semester_code,id_3) values (20, 57, 'SS18',20);
insert into class (class_code, size, semester_code,id_3) values (21, 57, 'SS18',21);
insert into class (class_code, size, semester_code,id_3) values (22, 57, 'WS18',37);
insert into class (class_code, size, semester_code,id_3) values (23, 47, 'SS19',38);
insert into class (class_code, size, semester_code,id_3) values (24, 43, 'SS19',39);
insert into class (class_code, size, semester_code,id_3) values (25, 53, 'WS19',61);
insert into class (class_code, size, semester_code,id_3) values (26, 57, 'SS20',62);
insert into class (class_code, size, semester_code,id_3) values (27, 61, 'SS20',63);
insert into class (class_code, size, semester_code,id_3) values (28, 53, 'WS20',85);
insert into class (class_code, size, semester_code,id_3) values (29, 61, 'SS21',86);
insert into class (class_code, size, semester_code,id_3) values (30, 53, 'SS21',87);
-- ME
insert into class (class_code, size, semester_code,id_3) values (31, 42, 'WS16',7);
insert into class (class_code, size, semester_code,id_3) values (32, 37, 'SS17',8);
insert into class (class_code, size, semester_code,id_3) values (33, 41, 'SS17',9);
insert into class (class_code, size, semester_code,id_3) values (34, 41, 'WS17',13);
insert into class (class_code, size, semester_code,id_3) values (35, 53, 'SS18',14);
insert into class (class_code, size, semester_code,id_3) values (36, 34, 'SS18',15);
insert into class (class_code, size, semester_code,id_3) values (37, 61, 'WS18',31);
insert into class (class_code, size, semester_code,id_3) values (38, 67, 'SS19',32);
insert into class (class_code, size, semester_code,id_3) values (39, 64, 'SS19',33);
insert into class (class_code, size, semester_code,id_3) values (40, 67, 'WS19',52);
insert into class (class_code, size, semester_code,id_3) values (41, 37, 'SS20',53);
insert into class (class_code, size, semester_code,id_3) values (42, 33, 'SS20',54);
insert into class (class_code, size, semester_code,id_3) values (43, 46, 'WS20',76);
insert into class (class_code, size, semester_code,id_3) values (44, 41, 'SS21',77);
insert into class (class_code, size, semester_code,id_3) values (45, 31, 'SS21',78);
-- ITSEC
insert into class (class_code, size, semester_code,id_3) values (46, 67, 'WS17',22);
insert into class (class_code, size, semester_code,id_3) values (47, 37, 'SS18',23);
insert into class (class_code, size, semester_code,id_3) values (48, 63, 'SS18',24);
insert into class (class_code, size, semester_code,id_3) values (49, 57, 'WS18',40);
insert into class (class_code, size, semester_code,id_3) values (50, 48, 'SS19',41);
insert into class (class_code, size, semester_code,id_3) values (51, 38, 'SS19',42);
insert into class (class_code, size, semester_code,id_3) values (52, 62, 'WS19',64);
insert into class (class_code, size, semester_code,id_3) values (53, 47, 'SS20',65);
insert into class (class_code, size, semester_code,id_3) values (54, 35, 'SS20',66);
insert into class (class_code, size, semester_code,id_3) values (55, 61, 'WS20',88);
insert into class (class_code, size, semester_code,id_3) values (56, 31, 'SS21',89);
insert into class (class_code, size, semester_code,id_3) values (57, 44, 'SS21',90);
-- EE
insert into class (class_code, size, semester_code,id_3) values (61, 67, 'WS17',16);
insert into class (class_code, size, semester_code,id_3) values (62, 64, 'SS18',17);
insert into class (class_code, size, semester_code,id_3) values (63, 42, 'SS18',18);
insert into class (class_code, size, semester_code,id_3) values (64, 32, 'WS18',34);
insert into class (class_code, size, semester_code,id_3) values (65, 58, 'SS19',35);
insert into class (class_code, size, semester_code,id_3) values (66, 50, 'SS19',36);
insert into class (class_code, size, semester_code,id_3) values (67, 59, 'WS19',55);
insert into class (class_code, size, semester_code,id_3) values (68, 58, 'SS20',56);
insert into class (class_code, size, semester_code,id_3) values (69, 50, 'SS20',57);
insert into class (class_code, size, semester_code,id_3) values (70, 46, 'WS20',79);
insert into class (class_code, size, semester_code,id_3) values (71, 65, 'SS21',80);
insert into class (class_code, size, semester_code,id_3) values (72, 39, 'SS21',81);
-- BA
insert into class (class_code, size, semester_code,id_3) values (58, 59, 'WS17',10);
insert into class (class_code, size, semester_code,id_3) values (59, 57, 'SS18',11);
insert into class (class_code, size, semester_code,id_3) values (60, 56, 'SS18',12);
-- LOG
insert into class (class_code, size, semester_code,id_3) values (73, 62, 'WS18',28);
insert into class (class_code, size, semester_code,id_3) values (74, 44, 'SS19',29);
insert into class (class_code, size, semester_code,id_3) values (75, 63, 'SS19',30);
-- ELAW
insert into class (class_code, size, semester_code,id_3) values (76, 55, 'WS18',46);
insert into class (class_code, size, semester_code,id_3) values (77, 54, 'SS19',47);
insert into class (class_code, size, semester_code,id_3) values (78, 32, 'SS19',48);
-- CE
insert into class (class_code, size, semester_code,id_3) values (79, 55, 'WS19',58);
insert into class (class_code, size, semester_code,id_3) values (80, 46, 'SS20',59);
insert into class (class_code, size, semester_code,id_3) values (81, 47, 'SS20',60);
insert into class (class_code, size, semester_code,id_3) values (82, 33, 'WS20',82);
insert into class (class_code, size, semester_code,id_3) values (83, 48, 'SS21',83);
insert into class (class_code, size, semester_code,id_3) values (84, 58, 'SS21',84);
-- ECO
insert into class (class_code, size, semester_code,id_3) values (85, 65, 'WS19',49);
insert into class (class_code, size, semester_code,id_3) values (86, 51, 'SS20',50);
insert into class (class_code, size, semester_code,id_3) values (87, 54, 'SS20',51);
insert into class (class_code, size, semester_code,id_3) values (88, 34, 'WS20',73);
insert into class (class_code, size, semester_code,id_3) values (89, 52, 'SS21',74);
insert into class (class_code, size, semester_code,id_3) values (90, 32, 'SS21',75);
-- CLAW
insert into class (class_code, size, semester_code,id_3) values (91, 66, 'WS19',70);
insert into class (class_code, size, semester_code,id_3) values (92, 36, 'SS20',71);
insert into class (class_code, size, semester_code,id_3) values (93, 60, 'SS20',72);
-- CVLAW
insert into class (class_code, size, semester_code,id_3) values (94, 51, 'WS20',94);
insert into class (class_code, size, semester_code,id_3) values (95, 40, 'SS21',95);
insert into class (class_code, size, semester_code,id_3) values (96, 39, 'SS21',96);
-- COMP
insert into class (class_code, size, semester_code,id_3) values (97, 50, 'WS20',97);
insert into class (class_code, size, semester_code,id_3) values (98, 40, 'SS21',98);
insert into class (class_code, size, semester_code,id_3) values (99, 32, 'SS21',99);

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

-- Question
insert into question (content) values ('How often did you attend class for this module?-Never-Rarely-Sometimes-Often-Always');
insert into question (content) values ('What is your gender?-Male-Female-Other');
insert into question (content) values ('The module objective have been clear to me.-Strongly disagree=1-2-3-4-Strongly agree=5-NA');
insert into question (content) values ('The learning materials (e.g. course books, handouts, etc.) have been sufficient and useful.-Strongly disagree=1-2-3-4-Strongly agree=5-NA');
insert into question (content) values ('The content of the module has always been relevant.-Strongly disagree=1-2-3-4-Strongly agree=5-NA');
insert into question (content) values ('The lessons have been interesting.-Strongly disagree=1-2-3-4-Strongly agree=5-NA');
insert into question (content) values ('The module workload outside classroom such as homework, assignments, exercises, exam preparation, ect. has been-<1hour=1-2-3-4->5hours=5');
insert into question (content) values ('The overall module workload has been-Too little=1-2-3-4-Too much=5');
insert into question (content) values ('The level of difficulty of the module has been-Too low=1-2-3-4-Too high=5');
insert into question (content) values ('Module contents have been presented understandably.-Strongly disagree=1-2-3-4-Strongly agree=5-NA');
insert into question (content) values ('Various learning activities have been used to teach the content.-Strongly disagree=1-2-3-4-Strongly agree=5-NA');
insert into question (content) values ('The learning activities have supported the intended learning outcomes.-Strongly disagree=1-2-3-4-Strongly agree=5-NA');
insert into question (content) values ('The assessment methods (tests, assignment, group work, etc.) are appropriate.-Strongly disagree=1-2-3-4-Strongly agree=5-NA');
insert into question (content) values ('Students have been encouraged to apply critical thinking and logics to better understand the course material.-Strongly disagree=1-2-3-4-Strongly agree=5-NA');
insert into question (content) values ('The lecturer has given feedback (about your answers or performance in assignments, reports, presentations, etc.) and it was helpful.-Strongly disagree=1-2-3-4-Strongly agree=5-NA');
insert into question (content) values ('The language skills (English / German) of the lecturer were excellent.-Strongly disagree=1-2-3-4-Strongly agree=5-NA');
insert into question (content) values ("The lecturer has listened to students' ideas and contributions.-Strongly disagree=1-2-3-4-Strongly agree=5-NA");
insert into question (content) values ('The lecturer has encouraged discussion and questions in class.-Strongly disagree=1-2-3-4-Strongly agree=5-NA');
insert into question (content) values ('The lecturer has offered consultation to individuals for academic support.-Strongly disagree=1-2-3-4-Strongly agree=5-NA');
insert into question (content) values ('Additional comments about what you liked or disliked and suggestions for further improvement:');

-- Answer
insert into questionaire(class_code,lecturer_code) values (1,1);
insert into answer (questionaire_id,answer_1,answer_2,answer_3,answer_4,answer_5,answer_6,answer_7,answer_8,answer_9,answer_10,answer_11,answer_12,answer_13,answer_14,answer_15,answer_16,answer_17,answer_18,answer_19,answer_20) values (1,"Always","Female","na","NA","4","1","1","1","2","3","5","1","1","1","1","1","1","1","1","1");