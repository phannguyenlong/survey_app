let aca_code;

$(document).ready(function() {
    $("#header").load("/webserver/header.html");
    $("#footer").load("/webserver/footer.html");
    getData();
    selectOption();
})

function getData() {
    $.ajax({
        type: 'GET',
        url: "http://localhost:8080/webserver/chart/validate",
        success: function (data) {
            for (let i = 0; i < data.length; i++) {
                if (data[i].aca_code != data[i+1].aca_code){
                    code = new String(data[i].aca_code)
                    $("#aca_code").append(`<option> ${code} </option>`)
                }
            }
        }
    })
}

function selectOption() {
    $("#aca_code").change(function () {
        $("#sem").find('option').remove()
        $("#fal").find('option').remove()
        $("#prog").find('option').remove()
        $("#mod").find('option').remove()
        $("#class_code").find('option').remove()
        $("#lect").find('option').remove()
    })

    $.ajax({
        url: "http://localhost:8080/webserver/chart/validate",
        type: 'GET',
        success: function () {
            hihi
        }
    })
}

