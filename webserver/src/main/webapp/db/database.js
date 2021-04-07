$(document).ready(function() {
	init()	
	
	
});

// ID: value = div, value1 = table, value2 = getbnt, value3=bnt_show, value4=bnt_hide
function init() {
	tables = [["aca_year","Academic Year"],["faculty","Faculty"],
	["program","Program"],["module","Module"],
	["semester","Semester"],["class","Class"],
	["lecturer","Lecturer"],["teaching","Teaching"]
	] 

	 //load html component
	$("#header").load("/webserver/header.html")
	$("#footer").load("/webserver/footer.html")

	
	
	for(let i =0;i<tables.length;i++){
		value = tables[i][0]
		content = tables[i][1]
		title = $("<h3>h3>").text(new String(content))
		bnt_get = $(`<button class=\"bnt_table\" value="${value}" id="${value+2}"></button>`).text("Load "+new String(content))
		bnt_show = $(`<button class=\"bnt_show\" value="${value}" id="${value+3}"></button>`).text("SHOW")
    	bnt_hide = $(`<button class=\"bnt_hide\" value="${value}" id="${value+4}"></button>`).text("HIDE")
		div = $(`<div class='table' id="${value}"></div>`).append(title,bnt_get,bnt_show,bnt_hide)
		$("#main").append(div)
	}
	
	$(".bnt_table").click(function(){
		console.log(this)
		getTable(this.value)
	})
	
	// SHOW AND HIDE BUTTONS.
    $(".bnt_show").click(function(){
		$(`#${this.value+1}`).show()
	})
	$(".bnt_hide").click(function(){
		$(`#${this.value+1}`).hide()
	})
	
}
function getTable(option) {
	$.ajax({
		type: 'GET',
		url: "http://localhost:8080/webserver/database/dumpingTable?table_name="+option,
		success: function(data, textStatus, jqXHR) {
            let json = JSON.parse(JSON.stringify(data))
            columns = Object.keys(json[0])  // get All keys of object json.
            
            // create Table:
            tr = $(`<tr ></tr>`)
            for(let j =0;j<columns.length;j++){
            	th = $(`<th class="title_tr"></th>`).text(columns[j])
            	tr.append(th)
            }
            table = $(`<table id="${option+1}" class="table"></table>`).append(tr)
            $(`#${option}`).append(table)
            
            for(let x = 0;x<json.length;x++){
            	tr = $(`<tr ></tr>`)
            	for(let j =0;j<columns.length;j++){
            		th = $(`<th class="content_tr"></th>`).text(json[x][columns[j]])
					tr.append(th)
            	}
            	$(`#${option+1}`).append(tr)
            }

            $(`#${option+2}`).attr('disabled','disabled');
            
            
		},
	})
}
	