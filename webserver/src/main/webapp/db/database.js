$(document).ready(function() {
	init()	
	
	
});

var primaryKey = {aca_year:"aca_code",faculty:"fa_code",program:"pro_code",module:"mo_code",
				  semester:"sem_code",class:"class_code",lecturer:"lec_code",
				  teaching:"id",year_faculty:"id_1",
				  year_fac_pro:"id_2",year_fac_pro_mo:"id_3"}

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
            	
            	delete_bnt = $(`<button class=\"bnt_delete\" value="${option}" id="${"delete"+x}"></button>`).text("Delete")
            	tr.append(delete_bnt)
            	
            	table.append(tr)
            }
            
            
            add_bnt = $(`<button class=\"bnt_add table_btn\" value="${option}"></button>`).text("Add")
            add_form = $(`<div class="add_form_${option}"></div>`)
			keys = addKey[option]
            for(let i =0;i<keys.length;i++){
            	label = $(`<span></span>`).text(keys[i])
            	input = $(`<input type="text" class="${'input_'+keys[i]}" name="${keys[i]}" />`)
				add_form.append(label, input, $(`<br>`))
			}
			submitBtn = $(`<button>Submit</button>`)
			submitBtn.click(() => {
				let arr = $(`.add_form_${option} input`)
				let params = '';
				for (let i = 0; i < keys.length; i++) {
					params += `&${keys[i]}=${arr[i].value}`
				}
				addRow(option, params)
			})

            add_form.append(submitBtn)
            divElement.append(table,add_bnt, add_form)
            
            $(`#${option}`).append(divElement)
			add_form.hide()
            
			add_bnt.click(function () {
				// tr = $(`<tr ></tr>`)
				// for(let i =0;i<keys.length;i++){
				// 	th = $(`<th><div class="add_form_${option}"><input type="text" class="${'input_' + keys[i]}" name="${keys[i]}"/></th></div>`)
				// 	tr.append(th)
				// }
				// submitBtn = $(`<button>Submit</button>`)
				// submitBtn.click(() => {
				// 	let arr = $(`.add_form_${option} input`)
				// 	let params = '';
				// 	for (let i = 0; i < keys.length; i++) {
				// 		params += `&${keys[i]}=${arr[i].value}`
				// 	}
				// 	addRow(option, params)
				// })
				// tr.append($(`<th></th>`).append(submitBtn))
				// table.append(tr)

				count = count+1
				console.log(count)
				if(count%2==1){
					add_form.show()
				}
				else{
					add_form.hide()
				}
            	
			})
                      
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
function addRow(table, param) {
	$.ajax({
		type: 'POST',
		url: "http://localhost:8080/webserver/database/interactTable?table_name=" + table + param,
		success: data => alertMessage("success", 'Success', `Add row to table ${table} successfully. Please reload to see change`),
		error: () => alertMessage('error', 'Error', `Cannot add to table ${table} cause error. Please check any duplicate key`)
	})
}


function deleteRow(table, key){
	$.ajax({
		type: 'DELETE',
		url: "http://localhost:8080/webserver/database/interactTable?table_name=" + table + "&old_key=" + key,
		success: data => alertMessage("success", 'Success', `Delete row in table ${table} successfully. Please reload to see change`),
		error: () => alertMessage('error', 'Error', `Cannot add to table ${table} cause error. Please check delete all foreign key contraint before delete`)
	})
}

function alertMessage(type, title, content) {
	Swal.fire({
		icon: type,
		title: title,
		text: content,
	})
}