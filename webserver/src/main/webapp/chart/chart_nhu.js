chartArr = []  // array for chart
teaching_id = []

$(document).ready(function () {
    init()
    $("#header").load("/webserver/header.html");
    $("#footer").load("/webserver/footer.html");
    filterChart();
    visualize();
})

function init() {
  let chartName = ["Gender","Clearance of the Module Objectives", "Useful & Sufficient Learning Materials",
                  "Relevance of the Module Content","Interesting Lessons","Time Spent on Module Workload Outside Classroon",
                  "Module Workload","Difficulty of the Module","Understandable Presentation of the Module Contents",
                  "Variety of Learning Activities","Supportive learning activities","Appropriate Assessment Method",
                  "Lecturer's Encouragement in Critial Thinking and Logics","Helpful Feedback from Lecturer",
                  "Language Skill (English/German)","Appreciation of Students' Ideas and Contributions","Lecturer's In-class Encouragement in Discussion and Questions",
                  "Offering Consulation to Individuals for Academic Support"]
    for (let i = 1; i < 20; i++) {
        $(".chartContainer").append(`<h2 style="text-align: center">${chartName[i]}</h2><canvas id="questionnaireChart${i}" style="width: 800px; height:500px; margin-bottom: 50px;"></canvas>`)
        let myChart = document.getElementById(`questionnaireChart${i}`).getContext('2d');
        let barChart = new Chart(myChart, {
            type: 'bar',
            data: {
                labels: ["Strongly disagree = 1", "2", "3", "4", "Strongly agree = 5", "Not applicable"],
                datasets: [{
                    label: 'Number of response',
                    data: [0,0,0,0,0,0],
                    backgroundColor: '#FFA552',
                    borderColor: '#fd800d',
                    borderWidth: 1,
                    hoverBackgroundColor: '#fd800d'
                }]
            },
            options: {
                scales: {
                    yAxes: [{
                        ticks: {
                            beginatZero: true,
                            min: 0
                        }
                    }]
                }
            }
        })
        chartArr.push(barChart)
    }
}

function filterChart() {
    console.log(teaching_id.length)
    getAcademicYear();
    $("#aca_code").change(() => getSemester())
    $("#sem").change(() => getFaculty())
    $("#fal").change(() => getProgram())
    $("#prog").change(() => getModule())
    $("#mod").change(() => getClass())
    $("#class_code").change(() => getLecturer())
}

function getAcademicYear() {
    teaching_id = []
    $.ajax({
        type: 'GET',
        url: "http://localhost:8080/webserver/chart/validate?aca_code=null&sem_code=null&fa_code=null&pro_code=null&mo_code=null&class_code=null&lec_code=null",
        success: function (data) {
            $("#aca_code").append(`<option value = "${data[0].aca_code}"> ${data[0].aca_code} </option>`)
            teaching_id.push(data[0].teaching_id)
            for (let i = 1; i < data.length; i++) {
                if (data[i].aca_code != data[i-1].aca_code)
                    $("#aca_code").append(`<option value = "${data[i].aca_code}"> ${data[i].aca_code} </option>`)
                teaching_id.push(data[i].teaching_id)
            }
        }
    })
}

function getSemester() {
    teaching_id = []
    $.ajax({
        type: 'GET',
        url: `http://localhost:8080/webserver/chart/validate?aca_code=${String($("#aca_code option:selected").val())}&sem_code=null&fa_code=null&pro_code=null&mo_code=null&class_code=null&lec_code=null`,
        success: function (data) {
            optionRemove(1)
            $("#sem").append(`<option value = "${data[0].sem_code}"> ${data[0].sem_code} </option>`)
            teaching_id.push(data[0].teaching_id)
            for (let i = 1; i < data.length; i++) {
                if (data[i].sem_code != data[i - 1].sem_code)
                    $("#sem").append(`<option value = "${data[i].sem_code}"> ${data[i].sem_code} </option>`)
                teaching_id.push(data[i].teaching_id)
            }
        }
    })
}

function getFaculty() {
    teaching_id = []
    $.ajax({
        type: 'GET',
        url: `http://localhost:8080/webserver/chart/validate?aca_code=${String($("#aca_code option:selected").val())}&sem_code=${String($("#sem option:selected").val())}&fa_code=null&pro_code=null&mo_code=null&class_code=null&lec_code=null`,
        success: function (data) {
            optionRemove(2)
            $("#fal").append(`<option value = "${data[0].fa_code}"> ${data[0].fa_code} - ${data[0].fa_name}</option>`)
            teaching_id.push(data[0].teaching_id)
            for (let i = 1; i < data.length; i++) {
                if (data[i].fa_code != data[i - 1].fa_code)
                    $("#fal").append(`<option value = "${data[i].fa_code}"> ${data[i].fa_code} - ${data[i].fa_name} </option>`)
                teaching_id.push(data[i].teaching_id)
            }
        }
    })
}

function getProgram() {
    teaching_id = []
    $.ajax({
        type: 'GET',
        url: `http://localhost:8080/webserver/chart/validate?aca_code=${String($("#aca_code option:selected").val())}&sem_code=${String($("#sem option:selected").val())}&fa_code=${String($("#fal option:selected").val())}&pro_code=null&mo_code=null&class_code=null&lec_code=null`,
        success: function (data) {
            optionRemove(3)
            $("#prog").append(`<option value = "${data[0].pro_code}"> ${data[0].pro_code} - ${data[0].pro_name} </option>`)
            teaching_id.push(data[0].teaching_id)
            for (let i = 1; i < data.length; i++) {
                if (data[i].pro_code != data[i - 1].pro_code)
                    $("#prog").append(`<option value = "${data[i].pro_code}"> ${data[i].pro_code} - ${data[i].pro_name} </option>`)
                teaching_id.push(data[i].teaching_id)
            }
        }
    })
}

function getModule() {
    teaching_id = []
    $.ajax({
        type: 'GET',
        url: `http://localhost:8080/webserver/chart/validate?aca_code=${String($("#aca_code option:selected").val())}&sem_code=${String($("#sem option:selected").val())}&fa_code=${String($("#fal option:selected").val())}&pro_code=${String($("#prog option:selected").val())}&mo_code=null&class_code=null&lec_code=null`,
        success: function (data) {
            optionRemove(4)
            $("#mod").append(`<option value = "${data[0].mo_code}"> ${data[0].mo_code} - ${data[0].mo_name} </option>`)
            teaching_id.push(data[0].teaching_id)
            for (let i = 1; i < data.length; i++) {
                if (data[i].mo_code != data[i - 1].mo_code)
                    $("#mod").append(`<option value = "${data[i].mo_code}"> ${data[i].mo_code} - ${data[i].mo_name} </option>`)
                teaching_id.push(data[i].teaching_id)
            }
        }
    })
}

function getClass() {
    teaching_id = []
    $.ajax({
        type: 'GET',
        url: `http://localhost:8080/webserver/chart/validate?aca_code=${String($("#aca_code option:selected").val())}&sem_code=${String($("#sem option:selected").val())}&fa_code=${String($("#fal option:selected").val())}&pro_code=${String($("#prog option:selected").val())}&mo_code=${String($("#mod option:selected").val())}&class_code=null&lec_code=null`,
        success: function (data) {
            optionRemove(5)
            $("#class_code").append(`<option value = "${data[0].class_code}"> ${data[0].class_code} </option>`)
            teaching_id.push(data[0].teaching_id)
            for (let i = 1; i < data.length; i++) {
                if (data[i].class_code != data[i - 1].class_code)
                    $("#class_code").append(`<option value = "${data[i].class_code}"> ${data[i].class_code} </option>`)
                teaching_id.push(data[i].teaching_id)
            }
        }
    })
}

function getLecturer() {
    teaching_id = []
    $.ajax({
        type: 'GET',
        url: `http://localhost:8080/webserver/chart/validate?aca_code=${String($("#aca_code option:selected").val())}&sem_code=${String($("#sem option:selected").val())}&fa_code=${String($("#fal option:selected").val())}&pro_code=${String($("#prog option:selected").val())}&mo_code=${String($("#mod option:selected").val())}&class_code=${String($("#class_code option:selected").val())}&lec_code=null`,
        success: function (data) {
            $("#lect option").not(":first").remove()
            $("#lect").append(`<option value = "${data[0].lec_code}"> ${data[0].lec_code} - ${data[0].lec_name} </option>`)
            teaching_id.push(data[0].teaching_id)
            for (let i = 1; i < data.length; i++) {
                if (data[i].lec_code != data[i - 1].lec_code)
                    $("#lect").append(`<option value = "${data[i].lec_code}"> ${data[i].lec_code} - ${data[i].lec_name} </option>`)
                teaching_id.push(data[i].teaching_id)
            }
        }
    })
}

// Use for remove option in each select
function optionRemove(start) {
    optionField = ["sem", "fal", "prog", "mod", "class_code", "lect"]
    for (let i = start - 1; i < optionField.length; i++)
        $(`#${optionField[i]} option`).not(":first").remove()
}

// Visualize chart
function visualize() {
    teaching_id = [...new Set(teaching_id)] // using of set remove duplicate
    console.log(teaching_id.join(","))
    for (let i = 1; i < 20; i++) {
        $.ajax({
            type: 'GET',
            url: `http://localhost:8080/webserver/chart/numberOfAnswer?teaching_id_arr=${teaching_id.join(",")}&answer_id=${i}`,
            success: data => {
                chartArr[i-1].data.labels = Object.keys(data[0])
                chartArr[i-1].data.datasets[0].data = Object.values(data[0])
                chartArr[i-1].update()
            }
        })
    }
}
