$(document).ready(function() {
	$("#submit_questionnaire_bu").on("click",
		function(event) {
			getExample()
		})
})


function getExample() {
	$.ajax({
		type: 'GET',
		url: "database",
		success: function(data, textStatus, jqXHR) {
			alert(JSON.stringify(data))
            console.log(data)
		}
	})
}