$(document).ready(function() {
    $("#header").load("/webserver/header.html");
    $("#footer").load("/webserver/footer.html");
    filterChart();
})

function filterChart() {
    getAcademicYear();
    $("#aca_code").change(() => {
        getSemester()
    })
    $("#sem").change(function() {
        // getSemester();
        getFaculty();
    })
    $("#fal").change(function() {
        // getFaculty();
        getProgram();
    })
    $("#prog").change(function() {
        // getProgram();
        getModule();
    })
    $("#mod").change(function() {
        // getModule();
        getClass()
    })
    $("#class_code").change(function() {
        // getClass();
        getLecturer();
    })
    // $("#lect").click(function() {
    //     getLecturer();
    // })
}
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
            // $("#sem option").not(":first").remove();
            optionRemove(1)
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
            // $("#fal option").not(":first").remove()
            optionRemove(2)
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
            // $("#prog option").not(":first").remove()
            optionRemove(3)
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
            // $("#mod option").not(":first").remove()
            optionRemove(4)
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
            // $("#class_code option").not(":first").remove()
            optionRemove(5)
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
            $("#lect option").not(":first").remove()
            for (let i = 0; i < codes.length; i++) {
                $("#lect").append(`<option value = "${codes[i]}"> ${codes[i]} </option>`)
            }
        }
    })
}

function optionRemove(start) {
    optionField = ["sem", "fal", "prog", "mod", "class_code", "lect"]
    for (let i = start - 1; i < optionField.length; i++)
        $(`#${optionField[i]} option`).not(":first").remove()
}