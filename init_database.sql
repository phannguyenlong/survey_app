CREATE TABLE faculty (
	code INTEGER AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE program (
	code INTEGER AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE module (
	code INTEGER AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE academic_year (
	code INTEGER AUTO_INCREMENT PRIMARY KEY
);

CREATE TABLE lecturer (
	code INTEGER AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE semester (
	code INTEGER AUTO_INCREMENT PRIMARY KEY
);

CREATE TABLE question (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(20) NOT NULL
);

CREATE TABLE class (
	code INTEGER AUTO_INCREMENT PRIMARY KEY,
    size INTEGER NOT NULL,
    semester_code INTEGER,
    module_code INTEGER,
    FOREIGN KEY (semester_code) REFERENCES semester(code),
    FOREIGN KEY (module_code) REFERENCES module(code)
);

CREATE TABLE question_content (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    content VARCHAR(100) 
);

CREATE TABLE teaching (
	class_code INTEGER,
    lecturer_code INTEGER,
    PRIMARY KEY (class_code, lecturer_code),
    FOREIGN KEY (class_code) REFERENCES class(code),
    FOREIGN KEY (lecturer_code) REFERENCES lecturer(code)
);

CREATE TABLE questionaire (
	class_code INTEGER,
    lecturer_code INTEGER,
    question_id INTEGER,
    PRIMARY KEY (class_code, lecturer_code, question_id),
    FOREIGN KEY (class_code) REFERENCES class(code),
    FOREIGN KEY (lecturer_code) REFERENCES lecturer(code),
    FOREIGN KEY (question_id) REFERENCES question(id)
);

CREATE TABLE F_A_P (
	academic_code INTEGER,
    faculty_code INTEGER,
    program_code INTEGER,
    PRIMARY KEY (academic_code, faculty_code, program_code),
    FOREIGN KEY (academic_code) REFERENCES academic_year(code),
    FOREIGN KEY (faculty_code) REFERENCES faculty(code),
    FOREIGN KEY (program_code) REFERENCES program(code)
);

CREATE TABLE P_A_M (
	academic_code INTEGER,
    module_code INTEGER,
    program_code INTEGER,
    PRIMARY KEY (academic_code, module_code, program_code),
    FOREIGN KEY (academic_code) REFERENCES academic_year(code),
    FOREIGN KEY (module_code) REFERENCES module(code),
    FOREIGN KEY (program_code) REFERENCES program(code)
);


