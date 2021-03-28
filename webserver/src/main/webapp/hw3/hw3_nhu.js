$(document).ready(function() {
    getHW();
})

function getHW(){
    $.ajax({
        url: "http://localhost:8080/webserver/hw3",
        type: 'GET',
        success: function (data) {
            data.map(val => {
                $(`<tr>
                <td>${val.acayear}</td>
                
                <td>${val.fa_name}</td>
                <td>${val.pro_name}</td>
                <td>${val.mo_name}</td>
                <td>${val.class_name}</td>    
                </tr>`).appendTo(".homework3-table");
            })
        }
    })

}