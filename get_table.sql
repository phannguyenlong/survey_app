DROP PROCEDURE IF EXISTS GetTable;
DELIMITER  //
CREATE PROCEDURE GetTable(table_name VARCHAR(20)) 
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
		WHEN table_name = "academic year" THEN
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