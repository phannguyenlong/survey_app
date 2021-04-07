$(document).ready(function() {
    $("#header").load("/webserver/header.html");
    $("#footer").load("/webserver/footer.html");
    getAcademicYear();
    $("#sem").click(function() {
        getSemester();
    })
    $("#fal").click(function() {
        getFaculty();
    })
    $("#prog").click(function() {
        getProgram();
    })
    $("#mod").click(function() {
        getModule();
    })
    $("#class_code").click(function() {
        getClass();
    })
    $("#lect").click(function() {
        getLecturer();
    })
})

function getAcademicYear() {
    let codes = [];
    $.ajax({
        type: 'GET',
        url: "http://localhost:8080/webserver/chart/validate?aca_code=null&sem_code=null&fa_code=null&pro_code=null&mo_code=null&class_code=null&lec_code=null",
        success: function (data) {
            for (let i = 0; i < data.length; i++) {
                if (!codes.includes(data[i].aca_code)){
                    codes.push(data[i].aca_code)
                }
            }
            for (let i=0; i<codes.length; i++) {
                $("#aca_code").append(`<option value = "${codes[i]}"> ${codes[i]} </option>`)
            }
        }
    })
}

function getSemester() {
    let codes = []
    $.ajax({
        type: 'GET',
        url: `http://localhost:8080/webserver/chart/validate?aca_code=${String($("#aca_code option:selected").val())}&sem_code=null&fa_code=null&pro_code=null&mo_code=null&class_code=null&lec_code=null`,
        success: function (data) {
            for (let i = 0; i < data.length; i++) {
                if (!codes.includes(data[i].sem_code)) {
                    codes.push(data[i].sem_code)
                }
            }


            for (let i = 0; i < codes.length; i++) {
                $("#sem").append(`<option value = "${codes[i]}"> ${codes[i]} </option>`)
            }
        }
    })
}

function getFaculty() {
    let codes = []
    $.ajax({
        type: 'GET',
        url: `http://localhost:8080/webserver/chart/validate?aca_code=${String($("#aca_code option:selected").val())}&sem_code=${String($("#sem option:selected").val())}&fa_code=null&pro_code=null&mo_code=null&class_code=null&lec_code=null`,
        success: function (data) {
            for (let i = 0; i < data.length; i++) {
                if (!codes.includes(data[i].fa_code)) {
                    codes.push(data[i].fa_code)
                }
            }
            for (let i = 0; i < codes.length; i++) {
                $("#fal").append(`<option value = "${codes[i]}"> ${codes[i]} </option>`)
            }
        }
    })
}

function getProgram() {
    let codes = []
    $.ajax({
        type: 'GET',
        url: `http://localhost:8080/webserver/chart/validate?aca_code=${String($("#aca_code option:selected").val())}&sem_code=${String($("#sem option:selected").val())}&fa_code=${String($("#fal option:selected").val())}&pro_code=null&mo_code=null&class_code=null&lec_code=null`,
        success: function (data) {
            for (let i = 0; i < data.length; i++) {
                if (!codes.includes(data[i].pro_code)) {
                    codes.push(data[i].pro_code)
                }
            }
            for (let i = 0; i < codes.length; i++) {
                $("#prog").append(`<option value = "${codes[i]}"> ${codes[i]} </option>`)
            }
        }
    })
}

function getModule() {
    let codes = []
    $.ajax({
        type: 'GET',
        url: `http://localhost:8080/webserver/chart/validate?aca_code=${String($("#aca_code option:selected").val())}&sem_code=${String($("#sem option:selected").val())}&fa_code=${String($("#fal option:selected").val())}&pro_code=${String($("#prog option:selected").val())}&mo_code=null&class_code=null&lec_code=null`,
        success: function (data) {
            for (let i = 0; i < data.length; i++) {
                if (!codes.includes(data[i].mo_code)) {
                    codes.push(data[i].mo_code)
                }
            }
            for (let i = 0; i < codes.length; i++) {
                $("#mod").append(`<option value = "${codes[i]}"> ${codes[i]} </option>`)
            }
        }
    })
}

function getClass() {
    let codes = []
    $.ajax({
        type: 'GET',
        url: `http://localhost:8080/webserver/chart/validate?aca_code=${String($("#aca_code option:selected").val())}&sem_code=${String($("#sem option:selected").val())}&fa_code=${String($("#fal option:selected").val())}&pro_code=${String($("#prog option:selected").val())}&mo_code=${String($("#mod option:selected").val())}&class_code=null&lec_code=null`,
        success: function (data) {
            for (let i = 0; i < data.length; i++) {
                if (!codes.includes(data[i].class_code)) {
                    codes.push(data[i].class_code)
                }
            }
            for (let i = 0; i < codes.length; i++) {
                $("#class_code").append(`<option value = "${codes[i]}"> ${codes[i]} </option>`)
            }
        }
    })
}

function getLecturer() {
    let codes = []
    $.ajax({
        type: 'GET',
        url: `http://localhost:8080/webserver/chart/validate?aca_code=${String($("#aca_code option:selected").val())}&sem_code=${String($("#sem option:selected").val())}&fa_code=${String($("#fal option:selected").val())}&pro_code=${String($("#prog option:selected").val())}&mo_code=${String($("#mod option:selected").val())}&class_code=${String($("#class_code option:selected").val())}&lec_code=null`,
        success: function (data) {
            for (let i = 0; i < data.length; i++) {
                if (!codes.includes(data[i].lec_code)) {
                    codes.push(data[i].lec_code)
                }
            }
            for (let i = 0; i < codes.length; i++) {
                $("#lect").append(`<option value = "${codes[i]}"> ${codes[i]} </option>`)
            }
        }
    })
}