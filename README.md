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

### II. Chart

