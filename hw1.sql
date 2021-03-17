DROP PROCEDURE IF EXISTS java_app.GetTotalClassesSize;
DELIMITER  //
CREATE PROCEDURE GetTotalClassesSize(
						academic_year VARCHAR(10),  semester VARCHAR(10), 
                        faculty VARCHAR(10), program VARCHAR(10), 
                        module VARCHAR(10), lecturer VARCHAR(10), class VARCHAR(10)) 
BEGIN
	SELECT COUNT(*) AS total_class
FROM (
	SELECT c.code AS class_code, 
			l.code AS lecturer_code, 
            s.code AS semester_code, 
            m.code AS module_code, 
            fap.academic_code AS academic_year_code, 
            fap.program_code, fap.faculty_code
    FROM class c
    JOIN teaching t ON (c.code = t.class_code)
    JOIN lecturer l ON (t.class_code = l.code)
    JOIN semester s ON (s.code = c.semester_code)
    JOIN module m ON (m.code = c.module_code)
    JOIN program_module pm ON (m.code = pm.module_code)
    JOIN program p ON (p.code = pm.program_code)
    JOIN faculty_academic_program fap ON (p.code = fap.program_code)
    WHERE (fap.academic_code = academic_year OR academic_year IS NULL) AND
		(s.code = semester OR semester IS NULL) AND
        (fap.faculty_code = faculty OR faculty IS NULL) AND
        (fap.program_code = program OR program IS NULL) AND
        (m.code = module OR module IS NULL) AND
        (l.code = lecturer OR lecturer IS NULL) AND
        (c.code = class OR class IS NULL)
) AS temp;
END //
DELIMITER ;
