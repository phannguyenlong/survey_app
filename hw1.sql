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
            a.code AS academic_year_code, 
            fap.program_code, fap.faculty_code
    FROM class c
    JOIN teaching t ON (c.code = t.class_code)
    JOIN lecturer l ON (t.class_code = l.code)
    JOIN semester s ON (s.code = c.semester_code)
    JOIN module m ON (m.code = c.module_code)
    JOIN p_a_m pam ON (m.code = pam.module_code)
    JOIN academic_year a ON (a.code = pam.academic_code)
    JOIN f_a_p fap ON (a.code = fap.academic_code)
    WHERE (a.code = academic_year OR academic_year IS NULL) AND
		(s.code = semester OR semester IS NULL) AND
        (fap.faculty_code = faculty OR faculty IS NULL) AND
        (fap.program_code = program OR program IS NULL) AND
        (m.code = module OR module IS NULL) AND
        (l.code = lecturer OR lecturer IS NULL) AND
        (c.code = class OR class IS NULL)
) AS temp;
END //
DELIMITER ;

CALL GetTotalClassesSize(1, 2, 3, 4, 6, 1, 3);
