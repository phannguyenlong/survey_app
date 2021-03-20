DROP PROCEDURE IF EXISTS java_app.GetTotalClassesSize;
DELIMITER  //
CREATE PROCEDURE GetTotalClassesSize(
						academic_year VARCHAR(10),  semester VARCHAR(10), 
                        faculty VARCHAR(10), program VARCHAR(10), 
                        module VARCHAR(10), lecturer VARCHAR(10), class VARCHAR(10)) 
BEGIN
	SELECT SUM(size) AS total_class
	FROM (
	SELECT DISTINCT c.code, c.size AS size
    FROM class c
	JOIN teaching t ON c.code = t.class_code
	JOIN lecturer l ON t.lecturer_code = l.code
	JOIN semester s ON (s.code = c.semester_code)
	JOIN academic_year a ON (a.code = s.academic_code)
	JOIN module m ON (c.module_code = m.code)
	JOIN program p ON (p.code = m.program_code)
	JOIN faculty f ON (f.code = p.faculty_code)
    WHERE 
		(a.code = academic_year OR academic_year IS NULL) AND
		(s.code = semester OR semester IS NULL) AND
        (f.code = faculty OR faculty IS NULL) AND
        (p.code = program OR program IS NULL) AND
        (m.code = module OR module IS NULL) AND
        (l.code = lecturer OR lecturer IS NULL) AND
        (c.code = class OR class IS NULL)
) AS temp;
END //
DELIMITER ;

CALL GetTotalClassesSize(null,"SS21",null,null,null,23,null);

-- Code for testing 
select * from class c
JOIN teaching t ON c.code = t.class_code
JOIN lecturer l ON t.lecturer_code = l.code
JOIN semester s ON (s.code = c.semester_code)
JOIN academic_year a ON (a.code = s.academic_code)
JOIN module m ON (c.module_code = m.code)
JOIN program p ON (p.code = m.program_code)
JOIN faculty f ON (f.code = p.faculty_code)
WHERE l.code = 23
order by c.code
