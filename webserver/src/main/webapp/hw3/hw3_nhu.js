$(document).ready(function() {
    getHW();
})

/*
function getHW(){
    $.ajax({
        url: "http://localhost:8080/webserver/hw3",
        type: 'GET',
        success: function (data) {
            data.map(val => {
                $(`<tr>
                <td>${val.aca_year}</td>
                
                <td>${val.fa_name}</td>
                <td>${val.pro_name}</td>
                <td>${val.mo_name}</td>
                <td>${val.class_name}</td>    
                </tr>`).appendTo(".homework3-table");
            })
        }
    })

}
*/

function getHW() {
    $.ajax({
        type: 'GET',
        url: "http://localhost:8080/webserver/hw3",
        success: function(data) {
            data.map(val => {
                aca_year = $("<td align='center'></td>").text(val.aca_year)
                fal = $("<td></td>").text(val.fa_name)
                pro_name = $("<td></td>").text(val.pro_name)
                mo_name = $("<td></td>").text(val.mo_name)
                class_name = $("<td align='center'></td>").text(val.class_name)
                $(".homework3-table").append($("<tr></tr>").append(aca_year, fal, pro_name, mo_name, class_name));
            })
        }
    })
}