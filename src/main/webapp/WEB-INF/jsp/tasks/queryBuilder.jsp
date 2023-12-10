<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="col-12 mx-auto row py-4 px-2 bg-light border mb-4" id="query-bulider-wrapper" style="display:none;">
            <div class="col-md-4">
            <div class="row">
            	<div class="col-md-6">
              <select class="form-select" aria-label="Default select example" >
                <option selected>Select Operation</option>
                <option value="select">Select</option>
                <option value="update" disabled="disabled">Update</option>
                <option value="delete" disabled="disabled">Delete</option>
              </select>
            </div>
            <div class="col-md-6">
              <select class="form-select" aria-label="Default select example" onchange="getField(this)">
                <option selected>Select Field</option>
                <option value="tasks">Task</option>
                <option value="projects" disabled="disabled">Project</option>
                <option value="users" disabled="disabled">User</option>
              </select>
            </div>
            </div>
            </div>
            <div class="col-md-8">
              <div class="input-group ">
                <input type="text" id="queryInput"  class="form-control" placeholder="Data Query" name="query" onblur="onblurEvent(this)">
                <button class="btn btn-secondary px-4" type="button" id="sbmt">Search</button>
              </div>
            </div>
            
          </div>
<script type="text/javascript">
var selection = "";
var selectionQuery = "";
function getField(element) {
	let selectedValue = element.value;
	if(selectedValue === "tasks"){
		suggestions = ["Priority", "Assignee", "Status", "Severity"];

	    $("#queryInput").autocomplete({
	        source: suggestions,
	        minLength: 0, 
	        select: function(event, ui) {
	            event.preventDefault();
	            selection = selection+" "+ui.item.value;
	            selectionQuery = selection+" "+ui.item.value;
	            $(this).val(selection);
	            onselect(ui.item.value);
	        }
	    });

	    $("#queryInput").on("click", function() {
	        $(this).autocomplete("search", "");
	    });
	}
}



function onselect(selectedValue){
	  if(selectedValue == 'Priority'){
		  let options = ['=','!='];
		  $("#queryInput").autocomplete({
		        source: options,
		        minLength: 0, 
		        select: function(event, ui) {
		            event.preventDefault();
		            selectionQuery = selection+" "+ui.item.value;
		            selection = selection+" "+ui.item.value;
		            $(this).val(selection);
		            
		            let priorites = [];
		            $
		     		.ajax({
		     			type: "GET",
		     			url: "${pageContext.request.contextPath}/queries/priorities",
		     			async: false,
		     			success: function(data) {
		     				priorites = data;
		     				console.log(data)
		     			}
		     		});
		           
		            $("#queryInput").autocomplete({
				        source: priorites,
				        minLength: 0, 
				        select: function(event, ui) {
				            event.preventDefault();
				            selectionQuery = selection+" "+ui.item.value;
				            selection = selection+" "+ui.item.value;
				            $(this).val(selection);
				            let operators = ['And','OR','NOT'];
				            $("#queryInput").autocomplete({
						        source: operators,
						        minLength: 0, 
						        select: function(event, ui) {
						            event.preventDefault();
						            selectionQuery = selection+" "+ui.item.value;
						            selection = selection+" "+ui.item.value;
						            $(this).val(selection);
						            onselect(ui.item.value)
						        }
						    });
				        }
				    }); 
				    
		        }
		    });
	  }
	  if(selectedValue == 'Status'){
		  console.log(selectionQuery)
		  let options = ['=','!='];
		  $("#queryInput").autocomplete({
		        source: options,
		        minLength: 0, 
		        select: function(event, ui) {
		            event.preventDefault();
		            selectionQuery = selection+" "+ui.item.value;
		            selection = selection+" "+ui.item.value;
		            $(this).val(selection);
		            let statusList = [];
		            $
		    		.ajax({
		    			type: "GET",
		    			url: "${pageContext.request.contextPath}/queries/status",
		    			async: false,
		    			success: function(data) {
		    				statusList = data;
		    			}
		    		});
		            $("#queryInput").autocomplete({
				        source: statusList,
				        minLength: 0, 
				        select: function(event, ui) {
				            event.preventDefault();
				            console.log(selectionQuery)
				            selectionQuery = selection+" "+ui.item.value;
				            console.log(selectionQuery)
				            selection = selection+" "+ui.item.value;
				            $(this).val(selection);
				            let users = ['And','OR','NOT'];
				            $("#queryInput").autocomplete({
						        source: users,
						        minLength: 0, 
						        select: function(event, ui) {
						            event.preventDefault();
						            selectionQuery = selection+" "+ui.item.value;
						            selection = selection+" "+ui.item.value;
						            $(this).val(selection);
						            onselect(ui.item.value)
						        }
						    });
				        }
				    });
		        }
		    });
	  }
	  
	  if(selectedValue == 'Severity'){
		  console.log(selectionQuery)
		  let options = ['=','!='];
		  $("#queryInput").autocomplete({
		        source: options,
		        minLength: 0, 
		        select: function(event, ui) {
		            event.preventDefault();
		            selectionQuery = selection+" "+ui.item.value;
		            selection = selection+" "+ui.item.value;
		            $(this).val(selection);
		            let severities = [];
		            $
		    		.ajax({
		    			type: "GET",
		    			url: "${pageContext.request.contextPath}/queries/severities",
		    			async: false,
		    			success: function(data) {
		    				severities = data;
		    			}
		    		});
		            $("#queryInput").autocomplete({
				        source: severities,
				        minLength: 0, 
				        select: function(event, ui) {
				            event.preventDefault();
				            selectionQuery = selection+" "+ui.item.value;
				            selection = selection+" "+ui.item.value;
				            $(this).val(selection);
				            let users = ['And','OR','NOT'];
				            $("#queryInput").autocomplete({
						        source: users,
						        minLength: 0, 
						        select: function(event, ui) {
						            event.preventDefault();
						            selectionQuery = selection+" "+ui.item.value;
						            selection = selection+" "+ui.item.value;
						            $(this).val(selection);
						            onselect(ui.item.value)
						        }
						    });
				        }
				    });
		        }
		    });
	  }
	  if(selectedValue == 'Assignee'){
		  let options = ['=','!='];
		  $("#queryInput").autocomplete({
		        source: options,
		        minLength: 0, 
		        select: function(event, ui) {
		            event.preventDefault();
		            selection = selection+" "+ui.item.value;
		            $(this).val(selection);
		            let assignees = {};
		            $
		    		.ajax({
		    			type: "GET",
		    			url: "${pageContext.request.contextPath}/queries/assignees",
		    			async: false,
		    			success: function(data) {
		    				if(data){
		    					for (var i = 0; i < data.length; i++) {
			    					let temp = data[i];
			    					let key = temp.firstName+" "+temp.lastName;
			    					let value = temp.id+"";
			    					assignees[key]=value;
								}
		    					 $("#queryInput").autocomplete({
		    						    source:Object.keys(assignees),
		    					        minLength: 0, 
		    					        select: function(event, ui) {
		    					            event.preventDefault();
		    					            const selectedValue = ui.item.value;
		    				                const selectedLabel = assignees[selectedValue]; 

		    					            selectionQuery = selection+" "+selectedLabel;
		    					            selection = selection+" "+ui.item.value;
		    					            console.log(selectionQuery)
		    					            $(this).val(selection);
		    					            let users = ['And','OR','NOT'];
		    					            $("#queryInput").autocomplete({
		    							        source: users,
		    							        minLength: 0, 
		    							        select: function(event, ui) {
		    							            event.preventDefault();
		    							            selectionQuery = selectionQuery+" "+ui.item.value;
		    							            selection = selection+" "+ui.item.value;
		    							            $(this).val(selection);
		    							        }
		    							    });
		    					        }
		    					    });
		    				}
		    			}
		    		});
		        }
		    });
	  }
	  if(selectedValue == 'And' || selectedValue == 'OR' || selectedValue == 'NOT'){
		  refreshList(suggestions);
	  }
}


function refreshList(options){
	  $("#queryInput").autocomplete({
	        source: options,
	        minLength: 0, 
	        select: function(event, ui) {
	            event.preventDefault();
	            selectionQuery = selection+" "+ui.item.value;
	            selection = selection+" "+ui.item.value;
	            $(this).val(selection);
	            onselect(ui.item.value);
	        }
	    });
}
function onblurEvent(e){
	selection = e.value;
	e.value = selection;
	
}
$(document).on('input',function(){
	 selection = $("#queryInput").val();
	 $("#queryInput").val(selection);
});
$(document).ready(function(){
	  $("#sbmt").click(function(){
		  console.log(selectionQuery)
	    $.post("${pageContext.request.contextPath}/queries",
	    {
	      operation:'',
	      queryField:'Task',
	      query: selectionQuery
	    },
	    function(data,status){
		if(data){
			let tbody = document.getElementById('task_body');
			tbody.innerHTML="";
			 for (var i = 0; i < data.length; i++) {
					let temp = data[i];
					let tr = document.createElement('tr');
			            let td1 = document.createElement( 'td' );
			            td1.setAttribute( 'class', 'font-size-12 mb-1  px-0' );
			            td1.style.width = "70%";
			            let h5 = document.createElement( 'h5' );
			            h5.setAttribute( 'class', 'font-size-14 mb-1 nowrap' );

			            if ( temp.taskType == "Task" ) {
			                let i = document.createElement( 'i' );
			                i.setAttribute( 'class', 'fa fa-check-square text-primary' );
			                h5.appendChild( i );
			            }
			            else if ( temp.taskType == "Bug" ) {
			                let i = document.createElement( 'i' );
			                i.setAttribute( 'class', 'fa fa-stop-circle text-danger' );
			                h5.appendChild( i );
			            }
			            else if(temp.taskType == "User Story"){
			            	let i = document.createElement( 'i' );
			            	i.setAttribute( 'class', 'fa fa-bookmark text-success' );
			                h5.appendChild( i );
			            }
			            else{
			            	let i = document.createElement( 'i' );
			            	i.setAttribute( 'class', 'fa-solid fa-bolt' );
			            	 i.setAttribute('style', 'color: #904ee2; font-size: 17px;');
			                h5.appendChild( i );
			            }
			            
			            let atd1 = document.createElement( 'a' );
			            atd1.setAttribute( 'class', 'project-initial-name' );
			            atd1.setAttribute( 'href', '${pageContext.request.contextPath}/tasks/updateTaskForm/' + temp.id );
			            atd1.innerHTML = temp.ticket;
			            h5.appendChild( atd1 );

			            let atd2 = document.createElement( 'a' );
			            atd2.setAttribute( 'class', 'colorLight' );
			            atd2.setAttribute( 'href', '${pageContext.request.contextPath}/tasks/updateTaskForm/' + temp.id );
			            atd2.innerHTML = temp.title;
			            h5.appendChild( atd2 );
			            td1.appendChild( h5 );

			            let td2 = document.createElement( 'td' );
			            td2.setAttribute( 'class', 'font-size-12 mb-1  px-0' );
			            td2.style.width = "10%";

			            if ( temp.priority == "Low" ) {
			                let span = document.createElement( 'span' );
			                span.setAttribute( 'class', 'badge priority-low' );
			                span.innerHTML = temp.priority;
			                td2.appendChild( span );
			            }

			            if ( temp.priority == "High" ) {
			                let span = document.createElement( 'span' );
			                span.setAttribute( 'class', 'badge priority-high' );
			                span.innerHTML = temp.priority;
			                td2.appendChild( span );
			            }
			            if ( temp.priority == "Medium" ) {
			                let span = document.createElement( 'span' );
			                span.setAttribute( 'class', 'badge priority-medium' );
			                span.innerHTML = temp.priority;
			                td2.appendChild( span );
			            }

			            if ( temp.priority != "Medium" && temp.priority != "High" && temp.priority != "Low" ) {
			                let span = document.createElement( 'span' );
			                span.setAttribute( 'class', 'badge priority-medium' );
			                span.innerHTML = temp.priority;
			                td2.appendChild( span );
			            }

			            let td3 = document.createElement( 'td' );
			            td3.setAttribute( 'class', 'font-size-12 mb-1 px-0' );
			            td3.style.width = "10%";
			            td3.innerHTML = temp.storyPoints;


			            let td4 = document.createElement( 'td' );
			            td4.setAttribute( 'class', 'font-size-12 mb-1 px-0' );
			            td4.style.width = "10%";

			            if ( temp.status == "TO-DO" ) {
			                let span = document.createElement( 'span' );
			                span.setAttribute( 'class', 'badge lavender-pinocchio' );
			                span.innerHTML = temp.status;
			                td4.appendChild( span );
			            }
			            if ( temp.status == "In-Progress" ) {
			                let span = document.createElement( 'span' );
			                span.setAttribute( 'class', 'badge lavender-mist' );
			                span.innerHTML = temp.status;
			                td4.appendChild( span );
			            }
			            if ( temp.status == "Open" ) {
			                let span = document.createElement( 'span' );
			                span.setAttribute( 'class', 'badge lavender-pinocchio' );
			                span.innerHTML = temp.status;
			                td4.appendChild( span );
			            }
			            if ( temp.status == "Rejected" ) {
			                let span = document.createElement( 'span' );
			                span.setAttribute( 'class', 'badge aqua-spring' );
			                span.innerHTML = temp.status;
			                td4.appendChild( span );
			            }
			            if ( temp.status == "Active" ) {
			                let span = document.createElement( 'span' );
			                span.setAttribute( 'class', 'badge badge-soft-primary' );
			                span.innerHTML = temp.status;
			                td4.appendChild( span );
			            }
			            if ( temp.status == "Inactive" ) {
			                let span = document.createElement( 'span' );
			                span.setAttribute( 'class', 'badge in-active' );
			                span.innerHTML = temp.status;
			                td4.appendChild( span );
			            }
			            if ( temp.status != "TO-DO" && temp.status != "In-Progress" && temp.status != "Open" && temp.status != "Rejected" && temp.status != "Active" && temp.status != "Inactive" ) {
			                let span = document.createElement( 'span' );
			                span.setAttribute( 'class', 'badge aqua-spring' );
			                span.innerHTML = temp.status;
			                td4.appendChild( span );
			            }
			            
			            let td5 = document.createElement( 'td' );
			            td5.setAttribute( 'class', 'font-size-12 mb-1 px-0' );
			            td5.style.width = "10%";
			            td5.style.textTransform="capitalize";
			            td5.innerHTML=temp.assigneName;
			            
			            let td6 = document.createElement( 'td' );
			            td6.setAttribute( 'class', 'font-size-12 mb-1 px-1' );
			            td6.style.width = "10%";
			            td6.style.textTransform="capitalize";
			            td6.innerHTML=temp.reporter;
			            
			            tr.appendChild(td1);
			            tr.appendChild(td2);
			            tr.appendChild(td3);
			            tr.appendChild(td4);
			            tr.appendChild(td5);
			            tr.appendChild(td6);
			            tbody.appendChild(tr);
			 }
		}else{
			console.log('data not came')
		}	
	    });
	  });
	});
	
	
</script>