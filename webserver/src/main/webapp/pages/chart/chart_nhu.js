chartArr = []  // array for chart
teaching_id = []

$(document).ready(function () {
    if (Cookies.get("session_key") == null)
		window.location.replace("/webserver/pages/login/login.html");
    init()
    $("#header").load("/webserver/component/header.html");
    $("#footer").load("/webserver/component/footer.html");
    filterChart();
})

/**
 * Filter to visualize Chart
 */
function filterChart() {
    getAllSelect()
}

function getAllSelect(select_id) {
    console.log(select_id)
    teaching_id = []
    let selectArr = ["aca", "sem", "fa", "pro", "mo", "class", "lec"]
    // Generate the parameter (if no input ==> null)
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

/**
 * Reset Button Function
 */
$('#resetButton').click(function() {
    optionField = ["aca", "sem", "fa", "pro", "mo", "class", "lec"]
    for (let i = 0; i < optionField.length; i++)
        $(`#${optionField[i]}`).val("")
    getAllSelect();
});

/**
 * Visualize Chart and Answer 20
 */
$('#visualizeButton').click(function() {
    visualizeChart();
    visualizeAnswer20();
});

/**
 *  Create Chart and its Properties
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
                    backgroundColor: '#e05297',
                        borderColor: '#cc0e74',
                        borderWidth: 1,
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
                        offset: 6
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

/**
 * Visualize chart and its properties
 */
let test;

function visualizeChart() {
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
                $(`#medianVal_${i-1}`).empty().append(`Median = ${medianVal}`)
                $(`#stDev_${i-1}`).empty().append(`Standard Deviation =  ${stDev.toFixed(2)}`)
            }
        })
    }
}

/**
 * Calculate statistic values
 */
function percentageCalculate(test) {
    let percentageValue = []
    let arr = Object.values(test).slice(0, -1)
    for (x of arr){
        pData = x/(jStat.sum(arr))*100
        percentageValue.push(pData.toFixed(1))
    }
    return percentageValue
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

function visualizeAnswer20() {
    $.ajax({
        type: 'GET',
        url: `http://localhost:8080/webserver/chart/getAnswer20?teaching_id=${teaching_id}`,
        success: function (data) {
            if (teaching_id.length == 1) {
                data.map(val => {
                    if (val.answer_20 != null){
                        contentAns = $("<td></td>").text(val.answer_20)
                        $(".answerTable").append($("<tr></tr>").append(contentAns))
                    }
                    else{
                        contentAns = $("<td></td>").text("N/A")
                        $(".answerTable").append($("<tr></tr>").append(contentAns))
                    }
                })

            }

        }
    })

}