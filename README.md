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

`POST` **/questionaire/submit**
- **input:** input JSON string of questionarie *(put json into request body)*
- **procedure name:** insertIntoQuestionaire(class_code, lectecturer, question1, question2, question3, question4, question5, question6, question7,  question8, question9, question10, question11, question12, question13, question14, question15, question16, question17, question18)
- **output:** return status code of request

### II. Chart

`GET` **/chart/validate?aca_code=''&sem_code=''&fa_code=''&pro_code=''&mo_code=''&lec_code=''&class_code=''**
- **input:** 
    - aca_code, sem_code, fa_code, pro_code, mo_code, class_code, lec_code
    - *NOTE:* the input paramter can be null (if null, skip filter that parameter)
- **procedure name:** Validate(*academic_year, semester, faculty, program, module, lecturer, class*)
- **output:** return (Academic Year, Semester, Faculty, Faculty_name, Program, Program_name, Module, Module_name, Class_code, Lecturer, Lecturer_name)
- **EX:** /chart/validate?aca_code=null&sem_code='WS20'&fa_code=null&pro_code=null&mo_code=null&class_code=null&lec_code='23'

`GET` **/chart/numberOfAnswer?class_code=''&lecturer_code=''
- **input:** class_code, lecturer_code
- **procedure name:** getNumberOfAnswer(*class_code, lecturer_code*)
    - Find `teaching_id` using `class_code`, `lecturer_code`
    - Filter questionaire table using `teaching_id` 
    - Return table sum of each option for each answer
- **output:**

| **Table**                    | **Option1** | **Option2** | **Option3** | **Option4** | **Option5** |
|------------------------------|-------------|-------------|-------------|-------------|-------------|
| A1                           | 20          | 30          | 40          | 20          | 10          |
| A2                           | 30          | 20          | 25          | 15          | 66          |
| ...                          | ...         | ...         | ...         | ...         | ...         |
| A19 (dont count question 20) | ...         | ...         | ...         | ...         | ...         |

`GET` **/chart/propertiesOfAnswer?class_code=''&lecturer_code=''
- **input:** class_code, lecturer_code
- **procedure name:** getPropertiesOfAnswer(*class_code, lecturer_code*)
    - Find `teaching_id` using `class_code`, `lecturer_code`
    - Filter questionaire table using `teaching_id`
    - sum:= `SELECT COUNT(*) FROM qfilterd_table`
    - Return table sum of each option for each answer
- **output:**

| **Table**                    | **n**     | **Mean (AVG)** | **sd (STD)** | **reponse_rate** | **sum** |
|------------------------------|------------|----------------|--------------|------------------|---------|
| A1                           | (sum - NA) | ...            | ...          | n/sum * 100      | 200     |
| A2                           | (sum - NA) | ...            | ...          | n/sum * 100      | 200     |
| ...                          | (sum - NA) | ...            | ...          | n/sum * 100      | 200     |
| A19 (dont count question 20) | (sum - NA) | ...            | ...          | n/sum * 100      | 200     |


### III. Database
`GET` **/database/dumpingTable?table_name=''
- **input:** table_name with option `{aca_year, faculty, program, module, semster, class, lecturer, teaching}`
- **procedure name:** dumpTable(*table_name*)
- **output:** fix for each option.
  - Faculty ==> aca_year | faculty
  - program ==> aca_year | faculty| program
  - class ==> aca | faculty | program | module | semester | class
  - ...

