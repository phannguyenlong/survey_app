-- ================CREATE PROCEDURE==================

-- GET HW3 Procedure
DROP PROCEDURE IF EXISTS java_app.GetHW3;
DELIMITER //
CREATE PROCEDURE GetHW3()
BEGIN 
	SELECT 
		a.aca_code AS aca_year,
		f.name AS fa_name,
		p.name AS pro_name,
		m.name AS mo_name,
		c.class_code AS class_name,
		c.size AS class_size
	FROM class c
	JOIN year_fac_pro_mo yfpm ON (yfpm.id_3 = c.id_3)
	JOIN module m ON (yfpm.module_code = m.mo_code)
	JOIN year_fac_pro yfp ON (yfp.id_2 = yfpm.id_2 )
	JOIN program p ON (p.pro_code = yfp.program_code)
	JOIN year_faculty yf ON (yf.id_1 = yfp.id_1)
	JOIN faculty f ON (f.fa_code = yf.faculty_code)
	JOIN academic_year a ON (yf.academic_code = a.aca_code)
	ORDER BY a.aca_code;
END //
DELIMITER ;

-- getAllClass Procedure
DROP PROCEDURE IF EXISTS getAllClass;
DELIMITER  //
CREATE PROCEDURE getAllClass()
BEGIN
	SELECT
		c.class_code
	FROM
		class c
	ORDER BY c.class_code;
END //
DELIMITER ;

-- getAllClass Procedure
DROP PROCEDURE IF EXISTS getClassByCode;
DELIMITER  //
CREATE PROCEDURE getClassByCode(class VARCHAR (20))
BEGIN
	SELECT 
		a.aca_code, s.sem_code, f.fa_code, f.name AS fa_name, 
        p.pro_code, p.name AS pro_name, m.mo_code, m.name AS mo_name, 
        c.class_code, l.lec_code, l.name AS lec_name 
	FROM class c
	JOIN teaching t ON c.class_code = t.class_code
	JOIN lecturer l ON t.lecturer_code = l.lec_code
	JOIN semester s ON (s.sem_code = c.semester_code)
	JOIN academic_year a ON (a.aca_code = s.academic_code)
    JOIN year_fac_pro_mo yfpm ON (yfpm.id_3 = c.id_3)
	JOIN module m ON (yfpm.module_code = m.mo_code)
    JOIN year_fac_pro yfp ON (yfp.id_2 = yfpm.id_2 )
	JOIN program p ON (p.pro_code = yfp.program_code)
    JOIN year_faculty yf ON (yf.id_1 = yfp.id_1)
	JOIN faculty f ON (f.fa_code = yf.faculty_code)
	WHERE c.class_code=class;
END //
DELIMITER ;

-- getAllQuestion procedure
DROP PROCEDURE IF EXISTS getAllQuestion;
DELIMITER  //
CREATE PROCEDURE getAllQuestion()
BEGIN
	SELECT
		*
	FROM
		question
	ORDER BY id;
END //
DELIMITER ;

-- Validate procedure
DROP PROCEDURE IF EXISTS java_app.Validate;
DELIMITER  //
CREATE PROCEDURE Validate(
						academic_year VARCHAR(10),  semester VARCHAR(10), 
                        faculty VARCHAR(10), program VARCHAR(10), 
                        module VARCHAR(10), lecturer VARCHAR(10), class VARCHAR(10)) 
BEGIN
	SELECT
		a.aca_code, s.sem_code, f.fa_code, f.name AS fa_name, 
        p.pro_code, p.name AS pro_name, m.mo_code, m.name AS mo_name, 
        c.class_code, l.lec_code, l.name AS lec_name 
    FROM class c
	JOIN teaching t ON c.class_code = t.class_code
	JOIN lecturer l ON t.lecturer_code = l.lec_code
	JOIN semester s ON (s.sem_code = c.semester_code)
	JOIN academic_year a ON (a.aca_code = s.academic_code)
    JOIN year_fac_pro_mo yfpm ON (yfpm.id_3 = c.id_3)
	JOIN module m ON (yfpm.module_code = m.mo_code)
    JOIN year_fac_pro yfp ON (yfp.id_2 = yfpm.id_2 )
	JOIN program p ON (p.pro_code = yfp.program_code)
    JOIN year_faculty yf ON (yf.id_1 = yfp.id_1)
	JOIN faculty f ON (f.fa_code = yf.faculty_code)
    WHERE 
		(a.aca_code = academic_year OR academic_year IS NULL) AND
		(s.sem_code = semester OR semester IS NULL) AND
        (f.fa_code = faculty OR faculty IS NULL) AND
        (p.pro_code = program OR program IS NULL) AND
        (m.mo_code = module OR module IS NULL) AND
        (l.lec_code = lecturer OR lecturer IS NULL) AND
        (c.class_code = class OR class IS NULL);
END //
DELIMITER ;

-- Insert into questionaire
DROP PROCEDURE IF EXISTS java_app.insertIntoQuestionaire;
DELIMITER //
CREATE PROCEDURE insertIntoQuestionaire( class VARCHAR(10), lecturer VARCHAR(10), answer_1 VARCHAR(9), answer_2 VARCHAR(6),
									answer_3 VARCHAR(2), answer_4 VARCHAR(2), answer_5 VARCHAR(2), answer_6 VARCHAR(2),
                                    answer_7 VARCHAR(2), answer_8 VARCHAR(2), answer_9 VARCHAR(2), answer_10 VARCHAR(2),
                                    answer_11 VARCHAR(2), answer_12 VARCHAR(2), answer_13 VARCHAR(2), answer_14 VARCHAR(2),
                                    answer_15 VARCHAR(2), answer_16 VARCHAR(2), answer_17 VARCHAR(2), answer_18 VARCHAR(2),
                                    answer_19 VARCHAR(2), answer_20 VARCHAR(100)) 
BEGIN
	SET @teaching = (SELECT id FROM teaching WHERE teaching.class_code = class AND teaching.lecturer_code = lecturer);
	INSERT INTO questionaire (teaching_id, answer_1, answer_2, answer_3, answer_4, answer_5,
							answer_6, answer_7, answer_8, answer_9, answer_10, answer_11, answer_12, answer_13,
                            answer_14, answer_15, answer_16, answer_17, answer_18, answer_19, answer_20)
						VALUES (@teaching, answer_1, answer_2, answer_3, answer_4, answer_5,
						answer_6, answer_7, answer_8, answer_9, answer_10, answer_11, answer_12, answer_13,
						answer_14, answer_15, answer_16, answer_17, answer_18, answer_19, answer_20);
	select @teaching;
END //
DELIMITER ;