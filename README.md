# Survey App
 **DISCLAIMER:** This project use for Programming Exercise subject

 # API Documentations

### I. Questionaire

`GET` **/class?class_code=all**
- **input:** no input
- **procedure name:** getAllClass
- **output:** return all the class code

`GET` **/class?class_code=class_code**
- **input:** class code of specific class
- **procedure name:** getClassByCode(*class_code*)
- **output:** return (Academic Year, Semester, Faculty, Program, Module, Class_code, Lecturer) of that class
- *Note:* 1 class can has many lecturer

`GET` **/question**
- **input:** no input
- **procedure name:** getAllQuestion()
- **output:** return (question_id, content) of that class

### II. Chart

`GET` **/chart/validate?a.aca_code=''&s.sem_code=''&f.fa_code=''&p.pro_code=''&m.mo_code=''&c.class_code=''&l.lec_code=''**
- **input:** 
    - aca_code, sem_code, fa_code, pro_code, mo_code, class_code, lec_code
    - *NOTE:* the input paramter can be null (if null, skip filter that parameter)
- **procedure name:** Validate(*academic_year, semester, faculty, program, module, lecturer, class*)
- **output:** return (Academic Year, Semester, Faculty, Program, Module, Class_code, Lecturer) 