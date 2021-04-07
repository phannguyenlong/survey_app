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
        c.class_code, l.lec_code, l.name AS lec_name, t.id as teaching_id
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
END //
DELIMITER ;

-- Get table
DROP PROCEDURE IF EXISTS java_app.dumpTable;
DELIMITER  //
CREATE PROCEDURE dumpTable(table_name VARCHAR(10)) 
BEGIN
	CASE 
		WHEN table_name = "teaching" THEN 
			SELECT id AS teaching_id,class_code,lecturer_code,l.name FROM teaching t
            JOIN lecturer l ON l.lec_code=t.lecturer_code
            ORDER BY id;
		WHEN table_name = "lecturer" THEN
			SELECT * FROM lecturer
            ORDER BY lec_code;
		WHEN table_name = "semester" THEN
			SELECT * FROM semester
            ORDER BY academic_code;
		WHEN table_name = "aca_year" THEN
			SELECT * FROM academic_year
            ORDER BY aca_code;
		WHEN table_name = "faculty" THEN
			SELECT f.fa_code,f.name AS faculty_name,yf.academic_code FROM faculty f
            JOIN year_faculty yf ON yf.faculty_code=f.fa_code 
            ORDER BY f.name,yf.academic_code;
		WHEN table_name = "program" THEN
			SELECT p.pro_code,p.name AS program_name,f.fa_code,f.name AS faculty_name,yf.academic_code FROM program p
            JOIN year_fac_pro yfp ON yfp.program_code=p.pro_code
            JOIN year_faculty yf ON yf.id_1=yfp.id_1
            JOIN faculty f ON f.fa_code=yf.faculty_code
            ORDER BY p.name,f.name,yf.academic_code;
		WHEN table_name = "module" THEN
			SELECT m.mo_code,m.name AS module_name,p.pro_code,p.name AS program_name,f.fa_code,f.name AS faculty_name,yf.academic_code FROM module m
            JOIN year_fac_pro_mo yfpm ON m.mo_code=yfpm.module_code
            JOIN year_fac_pro yfp ON yfpm.id_2= yfp.id_2
            JOIN program p ON p.pro_code=yfp.program_code
            JOIN year_faculty yf ON yf.id_1=yfp.id_1
            JOIN faculty f ON f.fa_code=yf.faculty_code
            ORDER BY m.name,p.name,f.name,yf.academic_code;
		WHEN table_name = "class" THEN
			SELECT c.class_code,c.size,m.mo_code,m.name AS module_name,p.pro_code,p.name AS program_name,f.fa_code,f.name AS faculty_name,yf.academic_code FROM class c
            JOIN year_fac_pro_mo yfpm ON yfpm.id_3=c.id_3
            JOIN module m ON m.mo_code=yfpm.module_code
            JOIN year_fac_pro yfp ON yfpm.id_2= yfp.id_2
            JOIN program p ON p.pro_code=yfp.program_code
            JOIN year_faculty yf ON yf.id_1=yfp.id_1
            JOIN faculty f ON f.fa_code=yf.faculty_code
            ORDER BY c.class_code;
	END CASE;
END//
DELIMITER ;

-- getNumberOfAnswer Procedure
DROP PROCEDURE IF EXISTS java_app.getNumberOfAnswer;
DELIMITER  //
CREATE PROCEDURE getNumberOfAnswer(class VARCHAR(10), lecturer VARCHAR(10))
BEGIN
	SELECT
		"answer_1" as answer,
		sum(answer_1 = 'Never' ) as op1,
		sum(answer_1 = 'Rarely' ) as op2,
		sum(answer_1 = 'Sometimes' ) as op3,
		sum(answer_1 = 'Often' ) as op4,
		sum(answer_1 = 'Always' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_2" as answer,
		sum(answer_2 = 'Male' ) as op1,
		sum(answer_2 = 'Female' ) as op2,
		sum(answer_2 = 'Other' ) as op3,
		0 as op4,
		0 as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_3" as answer,
		sum(answer_3 = '1' ) as op1,
		sum(answer_3 = '2' ) as op2,
		sum(answer_3 = '3' ) as op3,
		sum(answer_3 = '4' ) as op4,
		sum(answer_3 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_4" as answer,
		sum(answer_4 = '1' ) as op1,
		sum(answer_4 = '2' ) as op2,
		sum(answer_4 = '3' ) as op3,
		sum(answer_4 = '4' ) as op4,
		sum(answer_4 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_5" as answer,
		sum(answer_5 = '1' ) as op1,
		sum(answer_5 = '2' ) as op2,
		sum(answer_5 = '3' ) as op3,
		sum(answer_5 = '4' ) as op4,
		sum(answer_5 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_6" as answer,
		sum(answer_6 = '1' ) as op1,
		sum(answer_6 = '2' ) as op2,
		sum(answer_6 = '3' ) as op3,
		sum(answer_6 = '4' ) as op4,
		sum(answer_6 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_7" as answer,
		sum(answer_7 = '1' ) as op1,
		sum(answer_7 = '2' ) as op2,
		sum(answer_7 = '3' ) as op3,
		sum(answer_7 = '4' ) as op4,
		sum(answer_7 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_8" as answer,
		sum(answer_8 = '1' ) as op1,
		sum(answer_8 = '2' ) as op2,
		sum(answer_8 = '3' ) as op3,
		sum(answer_8 = '4' ) as op4,
		sum(answer_8 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_9" as answer,
		sum(answer_9 = '1' ) as op1,
		sum(answer_9 = '2' ) as op2,
		sum(answer_9 = '3' ) as op3,
		sum(answer_9 = '4' ) as op4,
		sum(answer_9 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_10" as answer,
		sum(answer_10 = '1' ) as op1,
		sum(answer_10 = '2' ) as op2,
		sum(answer_10 = '3' ) as op3,
		sum(answer_10 = '4' ) as op4,
		sum(answer_10 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_11" as answer,
		sum(answer_11 = '1' ) as op1,
		sum(answer_11 = '2' ) as op2,
		sum(answer_11 = '3' ) as op3,
		sum(answer_11 = '4' ) as op4,
		sum(answer_11 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_12" as answer,
		sum(answer_12 = '1' ) as op1,
		sum(answer_12 = '2' ) as op2,
		sum(answer_12 = '3' ) as op3,
		sum(answer_12 = '4' ) as op4,
		sum(answer_12 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_13" as answer,
		sum(answer_13 = '1' ) as op1,
		sum(answer_13 = '2' ) as op2,
		sum(answer_13 = '3' ) as op3,
		sum(answer_13 = '4' ) as op4,
		sum(answer_13 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_14" as answer,
		sum(answer_14 = '1' ) as op1,
		sum(answer_14 = '2' ) as op2,
		sum(answer_14 = '3' ) as op3,
		sum(answer_14 = '4' ) as op4,
		sum(answer_14 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_15" as answer,
		sum(answer_15 = '1' ) as op1,
		sum(answer_15 = '2' ) as op2,
		sum(answer_15 = '3' ) as op3,
		sum(answer_15 = '4' ) as op4,
		sum(answer_15 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_16" as answer,
		sum(answer_16 = '1' ) as op1,
		sum(answer_16 = '2' ) as op2,
		sum(answer_16 = '3' ) as op3,
		sum(answer_16 = '4' ) as op4,
		sum(answer_16 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_17" as answer,
		sum(answer_17 = '1' ) as op1,
		sum(answer_17 = '2' ) as op2,
		sum(answer_17 = '3' ) as op3,
		sum(answer_17 = '4' ) as op4,
		sum(answer_17 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_18" as answer,
		sum(answer_18 = '1' ) as op1,
		sum(answer_18 = '2' ) as op2,
		sum(answer_18 = '3' ) as op3,
		sum(answer_18 = '4' ) as op4,
		sum(answer_18 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer)
	UNION ALL
	SELECT
		"answer_19" as answer,
		sum(answer_19 = '1' ) as op1,
		sum(answer_19 = '2' ) as op2,
		sum(answer_19 = '3' ) as op3,
		sum(answer_19 = '4' ) as op4,
		sum(answer_19 = '5' ) as op5
	FROM
		teaching t JOIN questionaire q ON t.id = q.teaching_id
	WHERE
		(t.class_code = class) AND
		(t.lecturer_code = lecturer);

END //
DELIMITER ;
