-- ===============GetAcademicYearsOfFaculty==============
DROP PROCEDURE IF EXISTS GetAcademicYearsOfFaculty;
DELIMITER  //
CREATE PROCEDURE GetAcademicYearsOfFaculty(faculty VARCHAR(10)) 
BEGIN
	SELECT s.academic_code 
    FROM faculty f
	JOIN program p ON p.faculty_code = f.code
    JOIN module m ON m.program_code = p.code
    JOIN class c ON c.module_code = m.code
	JOIN semester s ON s.code = c.semester_code
    WHERE 
        f.code = faculty OR faculty IS NULL
	GROUP BY s.academic_code
    ORDER BY s.academic_code;
END //
DELIMITER ;

CALL GetAcademicYearsOfFaculty('FECO');

-- ===============GetLecturersTeachingClass==============
DROP PROCEDURE IF EXISTS GetLecturersTeachingClass;
DELIMITER  //
CREATE PROCEDURE GetLecturersTeachingClass(class VARCHAR(10)) 
BEGIN
	SELECT l.name 
    FROM lecturer l
	JOIN teaching t ON t.lecturer_code = l.code
    WHERE 
        t.class_code = class OR class IS NULL;
END //
DELIMITER ;

CALL GetLecturersTeachingClass(30); 

-- ===============GetModuleOfProgAndAca==============
DROP PROCEDURE IF EXISTS GetModuleOfProgAndAca;
DELIMITER  //
CREATE PROCEDURE GetModuleOfProgAndAca(academic_year VARCHAR(10), program VARCHAR(10))
BEGIN
	SELECT
		m.name 
	FROM
		program p 
        JOIN module m ON p.code = m.program_code
        JOIN class c ON m.code = c.module_code
        JOIN semester s ON c.semester_code = s.code
        JOIN academic_year a ON s.academic_code = a.code
	WHERE
		(a.code = academic_year or academic_year IS NULL) AND
		(p.code = program or program IS NULL);
END //
DELIMITER ;

CALL GetModuleOfProgAndAca('2020-2021', 'EE');


-- ===============GetProgramOfFaculty==============
DROP PROCEDURE IF EXISTS GetProgramOfFaculty;
DELIMITER  //
CREATE PROCEDURE GetProgramOfFaculty(faculty VARCHAR(10)) 
BEGIN
	SELECT
		p.name 
	FROM
		program p 
        JOIN faculty f ON p.faculty_code = f.code
	WHERE
		f.code = faculty or faculty IS NULL;
END //
DELIMITER ;

CALL GetProgramOfFaculty('FENG');
