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
- **procedure name:** Validate(*academic_year, semester, faculty, program, module, lecturer, class, teaching_id*)
- **output:** return (Academic Year, Semester, Faculty, Faculty_name, Program, Program_name, Module, Module_name, Class_code, Lecturer, Lecturer_name)
- **EX:** /chart/validate?aca_code=null&sem_code='WS20'&fa_code=null&pro_code=null&mo_code=null&class_code=null&lec_code='23'

`GET` **/chart/numberOfAnswer?teaching_id_arr=''&answer_id=''**
- **input:** 
    - teaching_id_arr: array of teaching id *(ex: teaching_id_arr="1,17")
    - answer_id: index of answer *(ex: answer of question 1 ==> answer_id=1)*
- **procedure name:** getNumberOfAnswer(*array_teaching_id, answer_id*)
    - Filter questionaire table using `teaching_id` 
    - Return table sum of each option for that answer_id *(including number of NA question)
    - Then the server will calculate each the `n`, `Mean`, `sd`, `reponse_rate`, `sum`
    - Finally send the reponse to the client
- **output:**

| **Option1** | **Option2** | **Option3** | **Option4** | **Option5** | **Option6** | **n** | **mean** | **sd** | **reponse_rate** | **sum** |
|-------------|-------------|-------------|-------------|-------------|-------------|-------|----------|--------|------------------|---------|
| 20          | 30          | 40          | 20          | 10          | 10          | 120   | 4.4      | 20     | 10               | 130     |


### III. Database
`GET` **/database/interactTable?table_name=''**
- **input:** 
  - table_name with option `{aca_year, faculty, program, module, semester, class, lecturer, teaching, year_faculty, year_fac_pro, year_fac_pro_mo}`
- **procedure name:** table_name + "Interact" (*"dump"*)
- **output:** content of that table

`DELETE` **/database/interactTable?table_name=''&old_key**
- **input:**
  - table_name with option `{aca_year, faculty, program, module, semester, class, lecturer, teaching, year_faculty, year_fac_pro, year_fac_pro_mo}` and old_key
   + table_name = "year_faculty": old_key, new_key, a_code, f_code
   + table_name = "year_fac_pro": old_key, id, code
   + table_name = "year_fac_pro_mo": old_key, id, code
   + table_name = "class": old_key,size,code,id
   + table_name = "teaching": old_key,c_code, lec_code
   + table_name = "semester": old_key, new_key, code
   + table_name = "lecturer": old_key, name 
   + table_name = "aca_year": old_key, new_key
   + table_name = "module" or "program" or "faculty": old_key, new_key, name
    - Which:
     + old_key, new_key: old and new primary key of that table
     + name: name column in table (if possible, if not set *null* - *for ex: table module, program, faculty, lecturer*) 
     + code: additional code (if not set null - *for ex: year_faculty, year_fac_pro, year_fac_pro_mo, teaching, class*)
     + id: additional id (if not set null - *for ex: year_faculty, year_fac_pro, year_fac_pro_mo, class*)
     + size: size for class table (if not class table, set null)
- **procedure name:** table_name + "Interact" (*"delete", key*)

`PUT` **/database/interactTable?table_name=''&**
- **input:**
  - table_name with option `{aca_year, faculty, program, module, semester, class, lecturer, teaching, year_faculty, year_fac_pro, year_fac_pro_mo}`
   + table_name = "year_faculty": old_key, new_key, a_code, f_code
   + table_name = "year_fac_pro": old_key, id, code
   + table_name = "year_fac_pro_mo": old_key, id, code
   + table_name = "class": old_key, size, code, id
   + table_name = "teaching": old_key, c_code, lec_code
   + table_name = "semester": old_key, new_key, code
   + table_name = "lecturer": old_key, name 
   + table_name = "aca_year": old_key, new_key
   + table_name = "module" or "program" or "faculty": old_key, new_key, name
    - which:
     + old_key, new_key: old and new primary key of that table
     + name: name column in table (if possible, if not set *null* - *for ex: table module, program, faculty, lecturer*) 
     + code: additional code (if not set null - *for ex: year_faculty, year_fac_pro, year_fac_pro_mo, teaching, class*)
     + id: additional id (if not set null - *for ex: year_faculty, year_fac_pro, year_fac_pro_mo, class*)
     + size: size for class table (if not class table, set null)
- **procedure name:** table_name + "Interact" (*"update"*, *other param that is not null in order `old_key, new_key, name, code, code2, id, size`*)
  - The database has to generate the procedure name
  - Then need to check and add param that is not null **in order like above**

`POST` **/database/interactTable?table_name=''&key**
- **input:**
  - table_name with option `{aca_year, faculty, program, module, semester, class, lecturer, teaching, year_faculty, year_fac_pro, year_fac_pro_mo}`
   + table_name = "year_faculty": old_key, new_key, a_code, f_code
   + table_name = "year_fac_pro": old_key, id, code
   + table_name = "year_fac_pro_mo": old_key, id, code
   + table_name = "class": old_key, size, code, id
   + table_name = "teaching": old_key, c_code, lec_code
   + table_name = "semester": old_key, new_key, code
   + table_name = "lecturer": old_key, name 
   + table_name = "aca_year": old_key, new_key
   + table_name = "module" or "program" or "faculty": old_key, new_key, name
    - which:
     + key: key for that table (if key of that table is auto_increment, set null - *for ex: teaching, class, lecterer, year_faculty, year_fac_pro, year_fac_pro_mo*)
- **procedure name:** table_name + "Interact" (*"create"*, *other param that is not null in order `key, name, code, code2, id, size`*)
  - The database has to generate the procedure name
  - Then need to check and add param that is not null **in order like above**
