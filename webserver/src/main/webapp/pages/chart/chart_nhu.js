chartArr = []  // array for chart
teaching_id = []

$(document).ready(function () {
    if (Cookies.get("session_key") == null)
		window.location.replace("/webserver/pages/login/login.html");
    init()
    $("#header").load("/webserver/component/header.html");
    $("#footer").load("/webserver/component/footer.html");
    filterChart();
    //visualize();
})

/**
 * Filter to visualize Chart
 */

function filterChart() {
    //console.log(teaching_id.length)
    // getAcademicYear();
    getAllSelect()
    // $("#aca_code").change(() => getSemester())
    // $("#sem").change(() => getFaculty())
    // $("#fal").change(() => getProgram())
    // $("#prog").change(() => getModule())
    // $("#mod").change(() => getClass())
    // $("#class_code").change(() => getLecturer())
    // $("#lect").change(() => {
    //     teaching_id = [$("#lect option:selected").val()]
    // })
}

function getAllSelect(select_id) {
    console.log(select_id)
    teaching_id = []
    let selectArr = ["aca", "sem", "fa", "pro", "mo", "class", "lec"]
    // Generate the paramter (if no input ==> null)
    let params = "";
    for (let i = 0; i < selectArr.length; i++) {
        if ($(`#${selectArr[i]} option:selected`).val() == '')
            params += selectArr[i] + "_code=null"
        else if (selectArr[i] == "fa" || selectArr[i] == "lec" || selectArr[i] == "pro")
            params += selectArr[i] + "_code='" + $(`#${selectArr[i]} option:selected`).val() + "'"
        else
            params += selectArr[i] + "_code=" + $(`#${selectArr[i]} option:selected`).val()
        params += i == selectArr.length - 1 ? "" : "&"
    }

    console.log(params)
    // optionRemoveNew(select_id)
    $.ajax({
        type: 'GET',
        url: "http://localhost:8080/webserver/chart/validate?" + params,
        success: function (data) {
            let arr = [[], [], [], [], [], [], []] // array for filter duplicate
            let cacheArr = [[], [], [], [], [], [], []]
            if (cacheArr[0] != null)
                for (let i = 0; i < selectArr.length; i++) {
                    $(`#${selectArr[i]} option`).not(":first").each(function() {
                        cacheArr[i].push(String($(this).val()))
                    })
                }
            // Add data to select
            for (let x = 0; x < data.length; x++) {
                for (let i = 0; i < selectArr.length; i++) {
                    if (!arr[i].includes(String(data[x][`${selectArr[i]}_code`]))) {
                        arr[i].push(String(data[x][`${selectArr[i]}_code`]))
                        if (!cacheArr[i].includes(String(data[x][`${selectArr[i]}_code`]))) {
                            if (selectArr[i] == "class" || selectArr[i] == "sem")
                                $(`#${selectArr[i]}`).append(`<option value = "${String(data[x][`${selectArr[i]}_code`])}"> ${data[x][`${selectArr[i]}_code`]}</option>`)
                            else
                                $(`#${selectArr[i]}`).append(`<option value = "${String(data[x][`${selectArr[i]}_code`])}"> ${data[x][`${selectArr[i]}_code`]} - ${data[x][`${selectArr[i]}_name`]} </option>`)
                        }
                    }
                }
                teaching_id.push(data[x].teaching_id)
            }
            console.log(arr)
            console.log(cacheArr)
            // filter redundant
            for (let i = 0; i < selectArr.length; i++) {
                $(`#${selectArr[i]} option`).not(":first").each(function () {
                    if (!arr[i].includes($(this).val())) {
                        $(`#${selectArr[i]} option[value='${$(this).val()}']`).remove()
                    }
                })
            }
        }
    })
}

function getAcademicYear() {
    teaching_id = []
    $.ajax({
        type: 'GET',
        url: "http://localhost:8080/webserver/chart/validate?aca_code=null&sem_code=null&fa_code=null&pro_code=null&mo_code=null&class_code=null&lec_code=null",
        success: function (data) {
            $("#aca_code").append(`<option value = "${data[0].aca_code}"> ${data[0].aca_code} - ${data[0].aca_name} </option>`)
            teaching_id.push(data[0].teaching_id)
            for (let i = 1; i < data.length; i++) {
                if (data[i].aca_code != data[i-1].aca_code)
                    $("#aca_code").append(`<option value = "${data[i].aca_code}"> ${data[i].aca_code} - ${data[i].aca_name} </option>`)
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
        url: `http://localhost:8080/webserver/chart/validate?aca_code=${String($("#aca_code option:selected").val())}&sem_code=${String($("#sem option:selected").val())}&fa_code='${String($("#fal option:selected").val())}'&pro_code=null&mo_code=null&class_code=null&lec_code=null`,
        success: function (data) {
            optionRemove(3)
            $("#pro").append(`<option value = "${data[0].pro_code}"> ${data[0].pro_code} - ${data[0].pro_name} </option>`)
            teaching_id.push(data[0].teaching_id)
            for (let i = 1; i < data.length; i++) {
                if (data[i].pro_code != data[i - 1].pro_code)
                    $("#pro").append(`<option value = "${data[i].pro_code}"> ${data[i].pro_code} - ${data[i].pro_name} </option>`)
                teaching_id.push(data[i].teaching_id)
            }
        }
    })
}

function getModule() {
    teaching_id = []
    $.ajax({
        type: 'GET',
        url: `http://localhost:8080/webserver/chart/validate?aca_code=${String($("#aca_code option:selected").val())}&sem_code=${String($("#sem option:selected").val())}&fa_code='${String($("#fal option:selected").val())}'&pro_code='${String($("#pro option:selected").val())}'&mo_code=null&class_code=null&lec_code=null`,
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
        url: `http://localhost:8080/webserver/chart/validate?aca_code=${String($("#aca_code option:selected").val())}&sem_code=${String($("#sem option:selected").val())}&fa_code='${String($("#fal option:selected").val())}'&pro_code='${String($("#pro option:selected").val())}'&mo_code=${String($("#mod option:selected").val())}&class_code=null&lec_code=null`,
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
        url: `http://localhost:8080/webserver/chart/validate?aca_code=${String($("#aca_code option:selected").val())}&sem_code=${String($("#sem option:selected").val())}&fa_code='${String($("#fal option:selected").val())}'&pro_code='${String($("#pro option:selected").val())}'&mo_code=${String($("#mod option:selected").val())}&class_code=${String($("#class_code option:selected").val())}&lec_code=null`,
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
    optionField = ["sem", "fal", "pro", "mod", "class_code", "lect"]
    for (let i = start - 1; i < optionField.length; i++)
        $(`#${optionField[i]} option`).not(":first").remove()
}

// Use for remove option in each select
function optionRemoveNew(skip) {
    optionField = ["aca","sem", "fa", "pro", "mo", "class", "lec"]
    for (let i = 0; i < optionField.length; i++) {
        if (optionField[i] == skip) continue
        $(`#${optionField[i]} option`).not(":first").remove()
    }
}


/**
 *  Visualize Chart and its Properties
 */
function init() {
    let chartName = ["Class Attendance", "Gender","Clearance of the Module Objectives", "Useful & Sufficient Learning Materials",
        "Relevance of the Module Content","Interesting Lessons","Time Spent on Module Workload Outside Classroom",
        "Overall Module Workload","Difficulty of the Module","Understandable Presentation of the Module Contents",
        "Variety of Learning Activities","Supportive learning activities","Appropriate Assessment Method",
        "Lecturer's Encouragement in Critical Thinking and Logic","Helpful Feedback from Lecturer",
        "Language Skill (English/German)","Appreciation of Students' Ideas and Contributions","Lecturer's In-class Encouragement in Discussion and Questions",
        "Offering Consultation to Individuals for Academic Support"]

    for (let i = 0; i < 19; i++) {
        let labelArr, xMax
        if (i == 0) {
            labelArr = ["Never", "Rarely", "Sometimes", "Often", "Always"]
            xMax = 5.5
        }
        else if (i == 1) {
            labelArr = ["Male", "Female", "Other"]
            xMax = 3.5
        }
        else if (i == 6) {
            labelArr = ["< 1 hour", "1-2", "2-3", "3-4", "> 5 hours"]
            xMax = 5.5
        }
        else {
            labelArr = ["Strongly disagree = 1", "2", "3", "4", "Strongly agree = 5", "Not applicable"]
            xMax = 6.5
        }
        $(".chartContainer").append(`<h2 style="text-align: center; margin-top: 50px">Percentage of Respondents by ${chartName[i]}</h2><canvas id="questionnaireChart${i}" style="width: 800px; height:500px; "></canvas>`)
        let myChart = document.getElementById(`questionnaireChart${i}`).getContext('2d');
        let barChart = new Chart(myChart, {
            type: 'bar',
            data: {
                datasets: [{
                    // type: 'bar',
                    label: 'Percentage of response',
                    data: [0,0,0,0,0,0],
                    backgroundColor: '#FFA552',
                    borderColor: '#fd800d',
                    borderWidth: 1,
                    hoverBackgroundColor: '#fd800d'
                }
                , {
                    type: 'scatterWithErrorBars',
                    label: 'Mean',
                    xAxisID: 'mean_id',
                    // yAxisID: 'invoice-amount',
                    data: [{ x: 0.5, y: 0, xMin: 0, xMax: 0 }],
                    backgroundColor: 'rgb(255, 99, 132)'
                }
                ],
                labels: labelArr,
            },
            options: {
                scales: {
                    xAxes: [{
                        display: true,
                        stacked: true,
                        scaleLabel: {
                            display: true,
                        },
                        },{
                        id: "mean_id",
                        type: 'linear',
                        display: false,
                        stacked: false,
                        scaleLabel: {
                            display: false,
                            labelString: 'Days',
                        },
                        ticks: {
                            // beginAtZero: true,
                            stepSize: 0.5,
                            suggestedMin: 0.5,
                            suggestedMax: xMax
                        }
                    }],
                    yAxes: [{
                        ticks: {
                            beginatZero: true,
                            min: 0,
                            max: 100,
                            callback: function (value) {
                                return value + '%';
                            }
                        },
                        scaleLabel: {
                            display: true,
                            labelString: "Percentage",
                            fontColor: '#979797',
                            fontSize: 18,
                        }

                    }]
                },
                plugins: {
                    datalabels: {
                        formatter: (value, ctx) => {
                            if (ctx.chart.data.datasets.indexOf(ctx.dataset) == 1) {
                                return value.x.toFixed(2); // for error bar number
                            }
                            return value + "%"; // for bar number
                        },
                        color: '#000',
                        anchor: 'end',
                        align: 'top',
                        offset: 10
                    }
                }
            }
        })
        chartArr.push(barChart)
        $(".chartContainer").append(`<p id="numResp_${i}"> Number of Response =  </p>`)
        $(".chartContainer").append(`<p id="respRate_${i}"> Response rate =  </p>`)
        $(".chartContainer").append(`<p id="meanVal_${i}"> Mean = </p>`)
        $(".chartContainer").append(`<p id="medianVal_${i}"> Median = </p>`)
        $(".chartContainer").append(`<p id="stDev_${i}"> Standard Deviation =  </p>`)
    }
}

function percentageCalculate(test) {
    let percentageValue = []
    let arr = Object.values(test).slice(0, -1)
    for (x of arr){
        pData = x/(jStat.sum(arr))*100
        percentageValue.push(pData.toFixed(1))
    }
    return percentageValue
}

let test;
// Visualize chart
function visualize() {
    teaching_id = [...new Set(teaching_id)] // using of set remove duplicate
    for (let i = 1; i < 20; i++) {
        $.ajax({
            type: 'GET',
            url: `http://localhost:8080/webserver/chart/numberOfAnswer?teaching_id_arr=${teaching_id.join(",")}&answer_id=${i}`,
            success: data => {
                orderedData = Object.keys(data[0]).sort().reduce(
                    (obj,key) => {
                        obj[key] = data[0][key];
                        return obj;
                    }, {}
                );
                test = orderedData;

                // calculate statistic
                let arrayPercentage = percentageCalculate(orderedData)
                sum = jStat.sum(Object.values(orderedData).slice(0, -1))
                numResp = sum - orderedData['Option6']
                respRate = numResp/orderedData['class_size']*100

                let arrValues = addValue(orderedData)
                meanVal = jStat.mean(arrValues)
                medianVal = jStat.median(arrValues)
                stDev = jStat.stdev(arrValues)

                // update chart
                chartArr[i - 1].data.datasets[0].data = arrayPercentage
                max = Math.max(...Object.values(orderedData).slice(0, -1)) / sum * 100
                max = max < 90 ? max + 10 : max
                chartArr[i-1].data.datasets[1].data =  [{ x: meanVal, y: max, xMin: meanVal - stDev, xMax: meanVal + stDev }]
                chartArr[i-1].update()

                $(`#numResp_${i-1}`).empty().append(`Number of Response =  ${numResp}`)
                $(`#respRate_${i-1}`).empty().append(`Response rate = ${respRate.toFixed(2) + '%'}`)
                $(`#meanVal_${i-1}`).empty().append(`Mean = ${meanVal.toFixed(2)}`)
                $(`#stDev_${i-1}`).empty().append(`Standard Deviation =  ${stDev.toFixed(2)}`)
            }
        })
    }
}

function addValue(test) {
    let arrVal = []
    for (j = 0 ; j < test['Option1']; j ++){
        arrVal.push(1);
    }
    for (j = 0 ; j < test['Option2']; j ++){
        arrVal.push(2)
    }
    for (j = 0 ; j < test['Option3']; j ++){
        arrVal.push(3)
    }
    for (j = 0 ; j < test['Option4']; j ++){
        arrVal.push(4)
    }
    for (j = 0 ; j < test['Option5']; j ++){
        arrVal.push(5)
    }
    for (j = 0 ; j < test['Option6']; j ++){
        arrVal.push(0)
    }
    return arrVal
}