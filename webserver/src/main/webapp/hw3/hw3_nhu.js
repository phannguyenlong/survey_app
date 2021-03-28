$(document).ready(function() {
    getHW();
})

function getHW(){
    $.ajax({
        url: "http://localhost:8080/webserver/hw3",
        type: 'GET',
        success: function (data) {
            data.map(val => {
                aca_year = $("<td></td>").text(val[i].aca_year)
                fal = $("<td></td>").text(val[i].fa_name)
                pro_name = $("<td></td>").text(val[i].pro_name)
                mo_name = $("<td></td>").text(val[i].mo_name)
                class_name = $("<td></td>").text(val[i].class_name)
                $("homework3-table").append($("<tr><tr>").append(fal,mo_name,aca_year,pro_name,class_name));
            }
        };
    })

})