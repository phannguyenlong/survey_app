$(document).ready(function () {
	console.log("helo")
	$("#header").load("/webserver/header.html")
	$("#footer").load("/webserver/footer.html")
})

$("#test_button").click(function () {
	console.log('Make fake request for questionaire')
	postQuestionaire();
});

function postQuestionaire() {
  	let questionnaire = {
			"class_code": 99,
			"lecturer_code": 23,
			"question1": "Never",
			"question2": "Male",
			"question3": "2",
			"question4": "5",
			"question5": "1",
			"question6": "2",
			"question7": "3",
			"question8": "3",
			"question9": "2",
			"question10": "1",
			"question11": "4",
			"question12": "5",
			"question13": "4",
			"question14": "4",
			"question15": "4",
			"question16": "5",
			"question17": "4",
			"question18": "4",
			"question19": "4",
			"question20": "con cu",
	};
	$.ajax({
		type: 'POST',
		contentType: "application/json",
		url: "/webserver/questionaire/submit",
		data: JSON.stringify(questionnaire),
		dataType: "text",
		success: function(data, textStatus, jqXHR) {
			console.log(data)
		}
	})
}
