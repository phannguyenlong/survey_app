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

-- Interact with year_faculty
DROP PROCEDURE IF EXISTS java_app.year_facultyInteract;
DELIMITER  //
CREATE PROCEDURE year_facultyInteract(action VARCHAR(10),old_key VARCHAR(20),new_key VARCHAR(20),a_code VARCHAR(10),f_code VARCHAR(10))
BEGIN
	CASE
		WHEN action="dump" THEN 
			SELECT * FROM year_faculty ORDER BY id_1;
        WHEN action="delete" THEN 
			DELETE FROM year_faculty WHERE id_1 = old_key;
		WHEN action="update" THEN 
			UPDATE year_faculty
			SET id_1 = IFNULL(new_key,old_key), academic_code = IFNULL(a_code,academic_code),faculty_code = IFNULL(f_code,faculty_code)
			WHERE id_1 = old_key;
		WHEN action="create" THEN
			INSERT INTO year_faculty(id_1,academic_code,faculty_code) VALUES (old_key,a_code,f_code);
	END CASE;
END//
DELIMITER ;

-- Interact with year_fac_pro
DROP PROCEDURE IF EXISTS java_app.year_fac_proInteract;
DELIMITER  //
CREATE PROCEDURE year_fac_proInteract(action VARCHAR(10),old_key INT,id VARCHAR(20),code VARCHAR(10))
BEGIN
	CASE
		WHEN action="dump" THEN 
			SELECT * FROM year_fac_pro ORDER BY id_2;
        WHEN action="delete" THEN 
			DELETE FROM year_fac_pro WHERE id_2 = old_key;
		WHEN action="update" THEN 
			UPDATE year_fac_pro
			SET id_1 = IFNULL(id,id_1),program_code = IFNULL(code,program_code)
			WHERE id_2 = old_key;
		WHEN action="create" THEN
			INSERT INTO year_fac_pro(id_1,program_code) VALUES (id,code);
	END CASE;
END//
DELIMITER ;

-- Interact with year_fac_pro_mo
DROP PROCEDURE IF EXISTS java_app.year_fac_pro_moInteract;
DELIMITER  //
CREATE PROCEDURE year_fac_pro_moInteract(action VARCHAR(10),old_key INT,id INT,code VARCHAR(10))
BEGIN
	CASE
		WHEN action="dump" THEN 
			SELECT * FROM year_fac_pro_mo ORDER BY id_3;
        WHEN action="delete" THEN 
			DELETE FROM year_fac_pro_mo WHERE id_3 = old_key;
		WHEN action="update" THEN 
			UPDATE year_fac_pro_mo
			SET id_2 = IFNULL(id,id_2),module_code = IFNULL(code,module_code)
			WHERE id_3 = old_key;
		WHEN action="create" THEN
			INSERT INTO year_fac_pro_mo(id_2,module_code) VALUES (id,code);
	END CASE;
END//
DELIMITER ;

-- Interact with teaching
DROP PROCEDURE IF EXISTS java_app.teachingInteract;
DELIMITER  //
CREATE PROCEDURE teachingInteract(action VARCHAR(10),old_key INT,c_code INT,lec_code INT)
BEGIN
	CASE
		WHEN action="dump" THEN 
			SELECT * FROM teaching ORDER BY id;
        WHEN action="delete" THEN 
			DELETE FROM teaching WHERE id = old_key;
		WHEN action="update" THEN 
			UPDATE teaching
			SET class_code = IFNULL(c_code,class_code),lecturer_code = IFNULL(lec_code,lecturer_code)
			WHERE id= old_key;
		WHEN action="create" THEN
			INSERT INTO teaching(class_code,lecturer_code) VALUES (c_code,lec_code);
	END CASE;
END//
DELIMITER ;
											    
-- getNumberOfAnswer Procedure
DROP PROCEDURE IF EXISTS getNumberOfAnswer;
DELIMITER  //
CREATE PROCEDURE getNumberOfAnswer(array_teaching_id VARCHAR(30), answer_id INT)
BEGIN
SET @teachingId_arr = array_teaching_id;
IF answer_id = 1 THEN
	SET @s=CONCAT('SELECT	
				sum(answer_',answer_id,'= "Never") as Option1, 
				sum(answer_',answer_id,'= "Rarely") as Option2,
				sum(answer_',answer_id,'= "Sometimes") as Option3,
				sum(answer_',answer_id,'= "Often") as Option4,
				sum(answer_',answer_id,'= "Always") as Option5,
				0 as Option6
			FROM questionaire 
			WHERE teaching_id IN (', @teachingID_arr, ');');
ELSEIF answer_id = 2 THEN
	SET @s=CONCAT('SELECT 
				sum(answer_',answer_id,'= "Male") as Option1, 
				sum(answer_',answer_id,'= "Female") as Option2,
				sum(answer_',answer_id,'= "Other") as Option3,
				0 as Option4,
				0 as Option5,
				0 as Option6
			FROM questionaire 
			WHERE teaching_id IN (', @teachingID_arr, ');');
ELSEIF answer_id IN (3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19) THEN
	SET @s=CONCAT('SELECT	
				sum(answer_',answer_id,'= "1") as Option1, 
				sum(answer_',answer_id,'= "2") as Option2,
				sum(answer_',answer_id,'= "3") as Option3,
				sum(answer_',answer_id,'= "4") as Option4,
				sum(answer_',answer_id,'= "5") as Option5,
				sum(answer_',answer_id,'= "NA") as Option6
			FROM questionaire 
			WHERE teaching_id IN (', @teachingID_arr, ');');
END IF;
PREPARE stmt1 FROM @s;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;
END//
DELIMITER ;

-- Interact with faculty
DROP PROCEDURE IF EXISTS java_app.facultyInteract;
DELIMITER //
CREATE PROCEDURE facultyInteract(action VARCHAR(10),old_key VARCHAR(10),new_key VARCHAR(10),fname VARCHAR(50))
BEGIN
	CASE
		WHEN action = "dump" THEN
			SELECT * FROM faculty ORDER BY fa_code;
		WHEN action = "delete" THEN
			DELETE FROM faculty  WHERE fa_code = old_key;
		WHEN action = "update" THEN
			UPDATE faculty 
				SET fa_code = IFNULL(new_key, old_key), name = IFNULL(fname, name) 
                WHERE fa_code = old_key;
		WHEN action = "create" THEN 
			INSERT INTO faculty(fa_code, name) VALUES (new_key, fname);
	END CASE;
END //
DELIMITER ;

-- Interact with program
DROP PROCEDURE IF EXISTS java_app.programInteract;
DELIMITER //
CREATE PROCEDURE programInteract(action VARCHAR(10),old_key VARCHAR(10),new_key VARCHAR(10),pname VARCHAR(50))
BEGIN
	CASE
		WHEN action = "dump" THEN
			SELECT * FROM program ORDER BY pro_code;
		WHEN action = "delete" THEN
			DELETE FROM program  WHERE pro_code = old_key;
		WHEN action = "update" THEN
			UPDATE program 
				SET pro_code = IFNULL(new_key, old_key), name = IFNULL(pname, name) 
                WHERE pro_code = old_key;
		WHEN action = "create" THEN 
			INSERT INTO program(pro_code, name) VALUES (new_key, pname);
	END CASE;
END //
DELIMITER ;

-- Interact with module
DROP PROCEDURE IF EXISTS java_app.moduleInteract;
DELIMITER //
CREATE PROCEDURE moduleInteract(action VARCHAR(10),old_key VARCHAR(10),new_key VARCHAR(10),mname VARCHAR(50))
BEGIN
	CASE
		WHEN action = "dump" THEN
			SELECT * FROM module ORDER BY mo_code;
		WHEN action = "delete" THEN
			DELETE FROM module  WHERE mo_code = old_key;
		WHEN action = "update" THEN
			UPDATE module 
				SET mo_code = IFNULL(new_key, old_key), name = IFNULL(mname, name) 
                WHERE mo_code = old_key;
		WHEN action = "create" THEN 
			INSERT INTO module(mo_code, name) VALUES (new_key, mname);
	END CASE;
END //
DELIMITER ;

-- Interact with academic_year
DROP PROCEDURE IF EXISTS java_app.aca_yearInteract;
DELIMITER //
CREATE PROCEDURE aca_yearInteract(action VARCHAR(10),old_key VARCHAR(10),new_key VARCHAR(10))
BEGIN
	CASE
		WHEN action = "dump" THEN
			SELECT * FROM academic_year ORDER BY aca_code;
		WHEN action = "delete" THEN
			DELETE FROM academic_year  WHERE aca_code = old_key;
		WHEN action = "update" THEN
			UPDATE academic_year 
				SET aca_code = IFNULL(new_key, old_key) 
                WHERE aca_code = old_key;
		WHEN action = "create" THEN 
			INSERT INTO academic_year(aca_code) VALUES (new_key);
	END CASE;
END //
DELIMITER ;

-- Interact with semester
DROP PROCEDURE IF EXISTS java_app.semesterInteract;
DELIMITER //
CREATE PROCEDURE semesterInteract(action VARCHAR(10),old_key VARCHAR(10),new_key VARCHAR(10),code VARCHAR(10))
BEGIN
	CASE
		WHEN action = "dump" THEN
			SELECT * FROM semester ORDER BY academic_code;
		WHEN action = "delete" THEN
			DELETE FROM semester WHERE sem_code = old_key;
		WHEN action = "update" THEN
			UPDATE semester 
				SET sem_code = IFNULL(new_key, old_key), academic_code = IFNULL(code, academic_code) 
                WHERE sem_code = old_key;
		WHEN action = "create" THEN 
			INSERT INTO semester(sem_code, academic_code) VALUES (new_key, code);
	END CASE;
END //
DELIMITER ;

-- Interact with lecturer
DROP PROCEDURE IF EXISTS java_app.lecturerInteract;
DELIMITER //
CREATE PROCEDURE lecturerInteract(action VARCHAR(10),old_key INT,lname VARCHAR(30))
BEGIN
	CASE
		WHEN action = "dump" THEN
			SELECT * FROM lecturer ORDER BY lec_code;
		WHEN action = "delete" THEN
			DELETE FROM lecturer WHERE lec_code = old_key;
		WHEN action = "update" THEN
			UPDATE lecturer 
				SET name = IFNULL(lname, name) 
                WHERE lec_code = old_key;
		WHEN action = "create" THEN 
			INSERT INTO lecturer(name) VALUES (lname);
	END CASE;
END //
DELIMITER ;

-- Interact with class
DROP PROCEDURE IF EXISTS java_app.classInteract;
DELIMITER //
CREATE PROCEDURE classInteract(action VARCHAR(10),old_key INT,csize INT,code VARCHAR(10),id INT)
BEGIN
	CASE
		WHEN action = "dump" THEN
			SELECT * FROM class ORDER BY class_code;
		WHEN action = "delete" THEN
			DELETE FROM class WHERE class_code = old_key;
		WHEN action = "update" THEN
			UPDATE class 
				SET size = IFNULL(csize, size), semester_code = IFNULL(code, semester_code), id_3 = IFNULL(id, id_3)
                WHERE class_code = old_key;
		WHEN action = "create" THEN 
			INSERT INTO class(size, semester_code, id_3) VALUES (csize, code, id);
	END CASE;
END //
DELIMITER ;
