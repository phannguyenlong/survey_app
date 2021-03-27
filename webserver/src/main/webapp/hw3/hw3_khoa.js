$(document).ready(function() {
	data = getExample()
	
})


function getExample() {
	$.ajax({
		type: 'GET',
		url: "http://localhost:8080/webserver/hw3",
		success: function(data, textStatus, jqXHR) {
            let json = JSON.parse(JSON.stringify(data))
            for(let i=0;i<json.length;i++){
            	fal = $("<td></td>").text(json[i].fa_name)
            	mo_name = $("<td></td>").text(json[i].mo_name)
            	aca_year = $("<td></td>").text(json[i].aca_year)
            	pro_name = $("<td></td>").text(json[i].pro_name)
            	class_name = $("<td></td>").text(json[i].class_name)            	
            	$("table").append($("<tr><tr>").append(fal,mo_name,aca_year,pro_name,class_name))
            }
            
			
		}
	})
}