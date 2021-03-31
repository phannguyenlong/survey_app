$(document).ready(function () {
	console.log("helo")
	$("#header").load("header.html")
	$("#footer").load("footer.html")
})

$("#test_button").click(function () {
	console.log('Make fake request for questionaire')
	postQuestionaire();
});

function postQuestionaire() {
  	let questoionaire = {
			"class_code": 1,
			"lecturer_code": 99,
			"question1": "3",
			"question2": "4",
			"question3": "2",
			"question4": "5",
			"question5": "1",
			"question6": "2",
			"question7": "3",
			"question8": "3",
			"question9": "2",
			"question10": "1",
			"question12": "5",
			"question13": "4",
			"question14": "4",
			"question15": "4",
	};
	$.ajax({
		type: 'POST',
		contentType: "application/json",
		url: "/webserver/database",
		data: JSON.stringify(questoionaire),
		dataType: "text",
		success: function(data, textStatus, jqXHR) {
			console.log(data)
		}
	})
}
