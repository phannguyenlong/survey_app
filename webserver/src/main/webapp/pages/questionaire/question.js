let questions;
let class_code;
let lecturer_code;

$(document).ready(function () {
	if (Cookies.get("session_key") == null)
		window.location.replace("/webserver/pages/login/login.html");
	init()	
});

function init() {
	// get data from server
	getClass()
	selectOption()
	getQuestion()

	// load html component
	$("#header").load("/webserver/component/header.html")
	$("#footer").load("/webserver/component/footer.html")

	$("#submit_bnt").click(function(){
		submitQuestion(questions)
	})
}
	

function getClass() {
	$.ajax({
		type: 'GET',
		url: "http://localhost:8080/webserver/class?class_code=all",
		success: function(data, textStatus, jqXHR) {
            let json = JSON.parse(JSON.stringify(data))
            for(let i=0;i<json.length;i++){
            	code = new String(json[i].class_code)
				$("#class_code").append(`<option value="${code}">${code}</option>`)
            }
		},
		error: () => alertMessage('error', 'Error', 'There is something wrong with server')
	})
}

function getQuestion() {
	$.ajax({
		type: 'GET',
		url: "http://localhost:8080/webserver/question",
		success: function(data, textStatus, jqXHR) {
			let json = JSON.parse(JSON.stringify(data))
			questions = json
            for(let i=0;i<json.length;i++){
            	text = json[i].content.split("-")
				question = $("<p class=\"question\"></p>").text(new String(text[0]))
				$("#form").append(question)
				answer = text.slice(1,text.length)
				for(let j=0;j<answer.length;j++){
					text = $("<p class=\"answer\" ></p>").text(new String(answer[j]))
					$("#form").append(text)
					if(i<2)
						$("#form").append(`<input type="radio" name="${new String(json[i].id)}" value="${answer[j]}"/>`)
					else
						$("#form").append(`<input type="radio" name="${new String(json[i].id)}" value="${j+1}"/>`)
				}				
            }
			$("#form").append(`<input style="width: 90%; height: 70px" type="text" id="text_input" />`)			
		},
		error: () => alertMessage('error', 'Error', 'There is something wrong with server')
	})
}


function selectOption(){
		$("#class_code").change(function(){
			$("#aca").children("p").remove();
			$("#sem").children("p").remove();
			$("#fal").children("p").remove();
			$("#pro").children("p").remove();
			$("#mod").children("p").remove();
			$("#lecturer_code").children("option").remove();
       	var code = new String($(this).children("option:selected").val());
		class_code = $(this).children("option:selected").val()
		$.ajax({
			type: 'GET',
			url:"http://localhost:8080/webserver/class?class_code="+code,
			success: function(data, textStatus, jqXHR) {
				let json = JSON.parse(JSON.stringify(data))
				$("#aca").append(`<p class="info_value">${json[0].aca_code}</p>`)
				$("#sem").append(`<p class="info_value">${json[0].sem_code}</p>`)
				$("#fal").append(`<p class="info_value">${json[0].fa_code} - ${json[0].fa_name}</p>`)
				$("#pro").append(`<p class="info_value">${json[0].pro_code} - ${json[0].pro_name}</p>`)
				$("#mod").append(`<p class="info_value">${json[0].mo_code} - ${json[0].mo_name}</p>`)
				
				for(let i=0;i<json.length;i++){
					name = new String(`${json[i].lec_code} - ${json[i].lec_name}`)
					$("#lecturer_code").append(`<option value="${json[i].lec_code}">${name}</option>`)
				}
			},
			error: () => alertMessage('error', 'Error', 'There is something wrong with server')
		})
	})
}

function submitQuestion(json){
	var answers = {};

	lecturer_code = document.getElementById("lecturer_code").value
	
	answers.class_code = parseInt(class_code);
	answers.lecturer_code=parseInt(lecturer_code);
	 
	var isPost = true;
	console.log("Submit",json)

	for(let i=0;i<json.length-1;i++){
        const rbs = document.querySelectorAll(`input[name="${new String(json[i].id)}"]`);
        let selectedValue;
        for (let j=0;j<rbs.length;j++) {
			//let element = {}
            if (rbs[j].checked) {
				selectedValue = rbs[j].value;
				if(parseInt(selectedValue)==6)
					selectedValue = "NA";
				break;
            }			
        }
		if(selectedValue===undefined)
			isPost = false;
		else {
			num = i+1;
			index = "question".concat(num)
			answers[index] = selectedValue //ES5 from variable to key values
		}
    };
	console.log(answers);
	
	selectedValue = document.getElementById("text_input").value
	index = "question".concat(20)
	answers[index] = selectedValue 
	
	if(isPost ===true) {
		$.ajax({
			type: 'POST',
			contentType: "application/json",
			url:"http://localhost:8080/webserver/questionaire/submit",
			data:JSON.stringify(answers),
			dataType:"text",
			success: function (data, textStatus, jqXHR) {
				alertMessage('success', 'Success', 'Your answer has been submmited. Thanks for filling our survey')
				// reload the question
				$("#form").empty();
				getQuestion();
			},
			error: () => alertMessage('error', 'Error', 'There is something wrong with server. Please check that you have filled in class and teacher option')
		})
	}
	else
		alertMessage('error', "Error", 'Please fill in all answer before submit')
}

function alertMessage(type, title, content) {
	Swal.fire({
		icon: type,
		title: title,
		text: content,
	})
}