# Survey App
 **DISCLAIMER:** This project use for Programming Exercise subject

 
# HOW TO DEPLOY THE SERVER
1. Config `config.properties`
2. Go to `./SQL_server/webserver`
3. Run `mvn clean package cargo:redeploy`
4. Then the `.war` file will be store in `./SQL_server/webseverver/target` 
5. Start Tomcat server from `D://stuff/tomcat.../bin/startup`
6. Access to http://localhost:8080/webserver/

 # API Documentations

### I. Questionaire

`GET` **/class?class_code=all**
- **input:** no input
- **procedure name:** getAllClass
- **output:** return all the class code

`GET` **/class?class_code=class_code**
- **input:** class code of specific class
- **procedure name:** getClassByCode(*class_code*)
- **output:** return (Academic Year, Semester, Faculty, Faculty_name, Program, Program_name, Module, Module_name, Class_code, Lecturer, Lecturer_name) of that class
- *Note:* 1 class can has many lecturer
- **EX:** /class?class_code=23

`GET` **/question**
- **input:** no input
- **procedure name:** getAllQuestion()
- **output:** return (question_id, content) of that class

### II. Chart

`GET` **/chart/validate?aca_code=''&sem_code=''&fa_code=''&pro_code=''&mo_code=''&lec_code=''&class_code=''**
- **input:** 
    - aca_code, sem_code, fa_code, pro_code, mo_code, class_code, lec_code
    - *NOTE:* the input paramter can be null (if null, skip filter that parameter)
- **procedure name:** Validate(*academic_year, semester, faculty, program, module, lecturer, class*)
- **output:** return (Academic Year, Semester, Faculty, Faculty_name, Program, Program_name, Module, Module_name, Class_code, Lecturer, Lecturer_name)
- **EX:** /chart/validate?aca_code=null&sem_code='WS20'&fa_code=null&pro_code=null&mo_code=null&class_code=null&lec_code='23'