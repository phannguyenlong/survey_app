$(document).ready(function() {
	getClass()
	
	selectOption()
	getQuestion()
	
});
	

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
			
		}
	})
}

function getQuestion() {
	$.ajax({
		type: 'GET',
		url: "http://localhost:8080/webserver/question",
		success: function(data, textStatus, jqXHR) {
			let json = JSON.parse(JSON.stringify(data))
            for(let i=0;i<json.length;i++){
            	text = json[i].content.split("-")
				question = $("<p></p>").text(new String(text[0]))
				$("#form").append(question)
				answer = text.slice(1,text.length)
				console.log(answer)
				for(let j=0;j<answer.length;j++){
					$("#form").append(`<label>"${new String(answer[j])}"</label>`)
					$("#form").append(`<input type="radio" name="${new String(json[i].id)}" value="${j}"/>`)
				}
				
//				$("#class_code").append(`<option value="${code}">${code}</option>`)
            }
			$("#form").append(`<input type="text" />`)

		}
	})
}


function selectOption(){
		$("#class_code").change(function(){
			$("#aca").children("p").remove();
			$("#sem").children("p").remove();
			$("#pro").children("p").remove();
			$("#mod").children("p").remove();
			$("#lecturer_code").children("option").remove();
       	var code = new String($(this).children("option:selected").val());
		$.ajax({
			type: 'GET',
			url:"http://localhost:8080/webserver/class?class_code="+code,
			success: function(data, textStatus, jqXHR) {
			let json = JSON.parse(JSON.stringify(data))
			$("#aca").append(`<p>"${new String(json[0].aca_code)}"</p>`)
			$("#sem").append(`<p>"${new String(json[0].sem_code)}"</p>`)
			$("#pro").append(`<p>"${new String(json[0].pro_code)}"</p>`)
			$("#mod").append(`<p>"${new String(json[0].mo_code)}"</p>`)
			
			for(let i=0;i<json.length;i++){
            	code = new String(json[i].lec_code)
				$("#lecturer_code").append(`<option value="${code}">${code}</option>`)
            }

		}
    })
})
}
