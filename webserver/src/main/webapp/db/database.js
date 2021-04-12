$(document).ready(function() {
	init()	
	
	
});

var primaryKey = {aca_year:"aca_code",faculty:"fa_code",program:"pro_code",module:"mo_code",
				  semester:"sem_code",class:"class_code",lecturer:"lec_code",
				  teaching:"id",year_faculty:"id_1",
				  year_fac_pro:"id_2",year_fac_pro_mo:"id_3"}

var modifyKey = {faculty:["new_key","name"],module:["new_key","name"],program:["new_key","name"],aca_year:["new_key"],lecturer:["new_key"],
semester:["new_key","code"],teaching:["new_key","c_code","lec_code"],class:["new_key","size","code","id"],year_fac_pro_mo: ["new_key","id","code"],
year_fac_pro:["new_key","id","code"],year_faculty:["new_key","a_code","f_code"]}

var addKey = {faculty:["old_key","name"],module:["old_key","name"],program:["old_key","name"],aca_year:["old_key"],lecturer:["old_key"],
semester:["old_key","code"],teaching:["old_key","c_code","lec_code"],class:["old_key","size","code","id"],year_fac_pro_mo: ["old_key","id","code"],
year_fac_pro:["old_key","id","code"],year_faculty:["old_key","a_code","f_code"]}

// ID: value = div, value1 = table, value2 = getbnt, value3=bnt_show, value4=bnt_hide, value5=div(table,bnt_add,form)
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
		title = $("<h2 class='table_name'>h2>").text(new String(content))
		bnt_get = $(`<button class=\"bnt_table table_btn\" value="${value}" id="${value+2}"></button>`).text("Load "+new String(content))
		bnt_show = $(`<button class=\"bnt_show table_btn\" value="${value}" id="${value+3}"></button>`).text("SHOW")
    	bnt_hide = $(`<button class=\"bnt_hide table_btn\" value="${value}" id="${value+4}"></button>`).text("HIDE")
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
	var count=0
	$.ajax({
		type: 'GET',
		url: "http://localhost:8080/webserver/database/interactTable?table_name="+option,
		success: function(data, textStatus, jqXHR) {
			$(`.${option+5}`).remove()
			
            let json = JSON.parse(JSON.stringify(data))
            columns = Object.keys(json[0])  // get All keys of object json.
            var divElement = $(`<div class="${option+5}"></div>`)
            // create Table:
            tr = $(`<tr style="background-color: #FD800D" ></tr>`)
            for(let j =0;j<columns.length;j++){
            	th = $(`<th class="title_tr"></th>`).text(columns[j])
				tr.append(th)
			}
			tr.append($(`<th class="title_tr"></th>`))
            table = $(`<table id="${option+1}" class="table_content"></table>`).append(tr)
            
            for(let x = 0;x<json.length;x++){
            	tr = $(`<tr ></tr>`)
            	for(let j =0;j<columns.length;j++){
					th = $(`<th class="${'content_tr_' + columns[j]}"></th>`).text(json[x][columns[j]])
					tr.append(th)
            	}
            	
            	delete_bnt = $(`<button class=\"bnt_delete action_btn\" value="${option}" id="${"delete"+x}"></button>`).text("Delete")
            	modify_bnt = $(`<button class=\"bnt_modify action_btn\" value="${option}"></button>`).text("Modify")
            	tr.append(modify_bnt,delete_bnt)
            	
            	table.append(tr)
            }
            
            
            add_bnt = $(`<button class=\"bnt_add table_btn\" value="${option}"></button>`).text("Add")
            divElement.append(table,add_bnt)
            
            $(`#${option}`).append(divElement)
            
			add_bnt.click(function () {
				if ($(`#${option + 1}`).children().last().attr("id") != "input_row") {
					keys = addKey[option]
					tr = $(`<tr id="input_row"></tr>`)
					for (let i = 0; i < keys.length; i++) {
						th = $(`<th><div class="add_form_${option}"><input type="text" placeholder="${keys[i]}" class="${'input_' + keys[i]}" name="${keys[i]}"/></th></div>`)
						tr.append(th)
					}
					submitBtn = $(`<button class="action_btn">Submit</button>`)
					submitBtn.click(() => {
						let arr = $(`.add_form_${option} input`)
						let params = '';
						for (let i = 0; i < keys.length; i++) {
							params += `&${keys[i]}=${arr[i].value}`
						}
						addRow(option, params)
						getTable(option)
					})
					tr.append($(`<th></th>`).append(submitBtn))
					$(`#${option + 1}`).append(tr)
				} else
					$(`#${option + 1}`).children().last().remove()
			})
                      
            $(".bnt_delete").click(function(){
            	value = this.value
            	key = primaryKey[value]
            	selector = $(this).siblings(".content_tr_"+key)[0]
				result_key = $(selector).text()
				deleteRow(value, result_key)
				getTable(option)
			})
			
			$(".bnt_modify").click(function(){
				value = this.value
            	key = primaryKey[value]
            	selector = $(this).siblings(".content_tr_"+key)[0]
				result_key = $(selector).text()
				
				
				keys = modifyKey[option]
				tr = $(`<tr id="input_row"></tr>`)
				for (let i = 0; i < keys.length; i++) {
					th = $(`<th><div class="modify_form_${option}"><input type="text" placeholder="${keys[i]}" class="${'input_' + keys[i]}" name="${keys[i]}"/></th></div>`)
					tr.append(th)
				}
				submitBtn = $(`<button class="action_btn">Submit</button>`)
				submitBtn.click(() => {
					let arr = $(`.modify_form_${option} input`)
					let params = '';
					for (let i = 0; i < keys.length; i++) {
						params += `&${keys[i]}=${arr[i].value}`
					}
					console.log(result_key)
					modifyRow(option, result_key,params)
					getTable(option)
				})
				tr.append($(`<th></th>`).append(submitBtn))
				//$(this).parent()[0].insertAfter(tr);
				tr.insertAfter($(this).parent()[0])
				
				
			})
	
		},
	})
		
}
function addRow(table, param) {
	$.ajax({
		type: 'POST',
		async: false, // turn of async for reload table properly
		url: "http://localhost:8080/webserver/database/interactTable?table_name=" + table + param,
		success: data => alertMessage("success", 'Success', `Add row to table ${table} successfully. Please reload to see change`),
		error: () => alertMessage('error', 'Error', `Cannot add to table ${table} cause error. Please check any duplicate key`)
	})
}


function deleteRow(table, key){
	$.ajax({
		type: 'DELETE',
		async: false, // turn of async for reload table properly
		url: "http://localhost:8080/webserver/database/interactTable?table_name=" + table + "&old_key=" + key,
		success: data => alertMessage("success", 'Success', `Delete row in table ${table} successfully. Please reload to see change`),
		error: () => alertMessage('error', 'Error', `Cannot deleete data from table ${table} cause error. Please check delete all foreign key contraint before delete`)
	})
}

function modifyRow(table,key,param){
	$.ajax({
		type: 'PUT',
		async: false,
		url: "http://localhost:8080/webserver/database/interactTable?table_name="+table+"&old_key="+key+param,
		success:data => alertMessage("success",'Success',`Modify row successfully`),
		error: () => alertMessage('error', 'Error', `Cannot modify to table ${table} cause error. Please check any duplicate key`)
		
	})
}

function alertMessage(type, title, content) {
	Swal.fire({
		icon: type,
		title: title,
		text: content,
	})
}