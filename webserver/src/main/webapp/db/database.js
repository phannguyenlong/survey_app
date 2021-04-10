$(document).ready(function() {
	init()	
	
	
});

var primaryKey = {aca_year:"aca_code",faculty:"fa_code",program:"pro_code",module:"mo_code",
				  semester:"sem_code",class:"class_code",lecturer:"lec_code",
				  teaching:"id",year_faculty:"id_1",
				  year_fac_pro:"id_2",year_fac_pro_mo:"id_3"}

var addKey = {faculty:["old_key","name"]}

// ID: value = div, value1 = table, value2 = getbnt, value3=bnt_show, value4=bnt_hide
function init() {
	tables = [["aca_year","Academic Year"],["faculty","Faculty"],
	["program","Program"],["module","Module"],
	["semester","Semester"],["class","Class"],
	["lecturer","Lecturer"],["teaching","Teaching"], ["year_faculty","Year and Faculty"],["year_fac_pro","Year, Faculty and Program"],
	["year_fac_pro_mo","Year, Faculty, Program and Module"]
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
		url: "http://localhost:8080/webserver/database/interactTable?table_name="+option,
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
            		th = $(`<th class="${'content_tr_'+columns[j]}"></th>`).text(json[x][columns[j]])
					tr.append(th)
            	}
            	
            	delete_bnt = $(`<button class=\"bnt_delete\" value="${option}" id="${"delete"+x}"></button>`).text("Delete")
            	tr.append(delete_bnt)
            	
            	$(`#${option+1}`).append(tr)
            }
            
            
            add_bnt = $(`<button class=\"bnt_add\" value="${option}"></button>`).text("Add")
            $(`#${option}`).append(add_bnt)
            add_form = $(`<form class="add_form" method="POST" action="${'http://localhost:8080/webserver/database/interactTable'}"></form>`)
            add_form.append($(`<input readonly type="text" name="table_name" value="${new String(option)}"/>`),$(`<br>`))
            keys = addKey[option]
            for(let i =0;i<keys.length;i++){
            	label = $(`<span></span>`).text(keys[i])
            	input = $(`<input type="text" class="${'input_'+keys[i]}" name="${keys[i]}" />`)
            	add_form.append(label,input,$(`<br>`))
            }
            add_form.append($(`<input class = "submit_add" type="submit" value = "submit" id="${'submit_add_'+option}">`))
            $(`#${option}`).append(add_form)
            add_form.hide()
            
            $(".bnt_add").click(function(){
            	add_form.toggle()
			})
            

            $(`#${option+2}`).attr('disabled','disabled');
            
            $(".bnt_delete").click(function(){
            	value = this.value
            	key = primaryKey[value]
            	selector = $(this).siblings(".content_tr_"+key)[0]
				result_key = $(selector).text()
				deleteRow(value, result_key)
				// delete : $($(this).parent()[0]).content_tr
			})
	
		},
	})
		
}
function deleteRow(table, key){
	$.ajax({
		type: 'DELETE',
		url: "http://localhost:8080/webserver/database/interactTable?table_name="+table+"&old_key="+key,
		success: function(data, textStatus, jqXHR) {
				alert(data)
			}
		})
}
	