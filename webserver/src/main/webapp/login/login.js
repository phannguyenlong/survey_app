$("#login_button").click(() => {
    $.ajax({
        type: "POST",
        // contentType: "application/json",
        url: `http://localhost:8080/webserver/authentication?username=${$('#usr').val()}&password=${$('#password').val()}`,
        dataType: "text",
        success: function (data, textStatus, jqXHR) {
            console.log("success");
        },
    });
});
