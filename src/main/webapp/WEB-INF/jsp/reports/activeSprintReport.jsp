<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>

<head>

<link href="${pageContext.request.contextPath}/css/task.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/table.css"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
.report-info {
	min-width: 250px;
	margin: 0px 10px 10px 10px;
}

.report-info .form-text {
	font-size: 12px;
	font-weight: 400;
	color: #5f6367;
}

.report-info .form-control {
	padding: 0.25rem 0.5rem;
}

table.dataTable thead th, table.dataTable thead td {
	padding: 10px 10px;
	border-bottom: 1px solid #838282;
	font-size: 13px;
	font-weight: 600;
}

#selectionForm input {
	font-size: 13px;
}

#selectionForm button {
	font-size: 13px;
}
</style>
</head>

<body>
	<jsp:include page="../common/header.jsp"></jsp:include>

	<div class="main-content ">
		<div class="col-md-12">
			<div class="row">
				<div class="col-md-12 title">
					<h4>Active Sprint Report</h4>
				</div>
				<div class="row">
					<form id="selectionForm" method="post">
						<div
							class="d-flex justify-content-start align-items-center flex-wrap bg-light border rounded my-3 p-2">
							<div class="report-info">
								<div class="form-text">Project</div>
								<select name="projectId" class="form-select form-select-sm"
									onchange="getSelectedProject()" id="project-drop-down">
									<option value="0" selected="selected">Select Project</option>
									<c:forEach items="${projectList}" var="project">
										<option value="${project.id}">${project.name }</option>
									</c:forEach>
								</select>
							</div>
							
							<div class="report-info">
								<div class="form-text">Active Sprint</div>
								<select name="sprintId" class="form-select form-select-sm" id="sprint-drop-down">
									<option value="0" selected="selected">Select Sprint</option>
								</select>
							</div>

							<div class="report-info">
								<div class="form-text">User</div>
								<select name="userId" class="form-select form-select-sm"
									id="users-drop-down">
									<option value="0" selected="selected">Select User</option>
								</select>
							</div>

							<div class="report-info">
								<div class="form-text">Status</div>
								<select name="taskStatus" class="form-select form-select-sm"
									id="status-drop-down">
									<option value="0" selected="selected">Select Status</option>
								</select>
							</div>

							<div class="report-info">
								<div class="form-text">Select Timespan</div>
								<select name="timespan" class="form-select form-select-sm"
									id="time-drop-down" onchange="getTimeSpan()">
									<option value="0" disabled="disabled" selected="selected">Select
										Time</option>

									<option value="1">Current Week</option>
									<option value="2">Current Month</option>
									<option value="3">Last Month</option>
									<option value="4">Current Year</option>
									<option value="5">Custom</option>
								</select>
							</div>

							<div class="report-info">
								<div class="form-text">Start Date</div>
								<input type="datetime-local" name="fromDate" id="fromDate"
									class="form-control">
							</div>
							<div class="report-info">
								<div class="form-text">End Date</div>
								<input type="datetime-local" name="toDate" id="toDate"
									class="form-control">
							</div>

							<div class="report-info">
								<div class="form-text" style="visibility: collapse;">action-btn</div>
								<button type="button" class="btn btn-primary btn-sm "
									onclick="generateJSON()" id="generate-report">Generate
									Report</button>

								<div class="dropdown" style="display: initial"
									id="report-button-dropdown">
									<button class="btn btn-primary btn-sm dropdown-toggle"
										type="button" id="dropdownMenuButton1"
										data-bs-toggle="dropdown" aria-expanded="false">Download
										Report</button>
									<ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
										<li><a class="dropdown-item" href="javascript:void(0)"
											onclick="downloadExcel('${pageContext.request.contextPath}')">Excel</a></li>
										<li><a class="dropdown-item" href="javascript:void(0)"
											onclick="downloadPdf('${pageContext.request.contextPath}')">PDF</a></li>

									</ul>
								</div>

								<button type="button" class="btn btn-primary btn-sm "
									onclick="sendEmail('${pageContext.request.contextPath}')"
									id="send-email">Send Mail</button>

							</div>

						</div>

					</form>
				</div>
				<div>
					<span id="no-record-span" style="display: none">No Record
						found !!!!</span>
				</div>
				<div>
					<table class="table-new " id="tableID"
						style="max-width: 100% !important; display: none;">
						<thead>

							<tr>
								<th>Title</th>
								<th>Priority</th>
								<th>Story Points</th>
								<th>Status</th>
								<th>Assigned-To</th>
							</tr>
						</thead>
						<tbody id="task_body">


						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
    <c:if test="${not empty successMessage || not empty errorMsg}">

		<script type="text/javascript">
			var successMessage = "${successMessage}";
	        if (successMessage) {
	            toastr.success(successMessage);
	        }
	
	        var errorMessage = "${errorMsg}";
	        if (errorMessage) {
	            toastr.error(errorMessage);
	        }		
        </script>

	</c:if>
	<script>

			function getTimeSpan () {
				let selectElement = document.getElementById( "time-drop-down" );
				let selectedValue = selectElement.value;
				let startDateInput = document.getElementById( "fromDate" );
				let toDateInput = document.getElementById( "toDate" );

				if ( selectedValue == 1 ) {
					let currentDate = new Date();
					let formattedCurrentDate = currentDate.toISOString().slice( 0, 16 );
					toDateInput.value = formattedCurrentDate;

					let currentDayOfWeek = currentDate.getDay();

					let daysToSubtract = currentDayOfWeek;

					let firstDayOfWeek = new Date( currentDate );
					firstDayOfWeek.setDate( currentDate.getDate() - daysToSubtract );

					let formattedStartDate = firstDayOfWeek.toISOString().slice( 0, 16 );
					startDateInput.value = formattedStartDate;
					startDateInput.readOnly = "readOnly";
					toDateInput.readOnly = "readOnly";
				}
				if ( selectedValue == 2 ) {
					let currentDate = new Date();
					let formattedCurrentDate = currentDate.toISOString().slice( 0, 16 );
					toDateInput.value = formattedCurrentDate;

					currentDate.setDate( 1 );
					let formattedstartDate = currentDate.toISOString().slice( 0, 16 );
					startDateInput.value = formattedstartDate;
					startDateInput.readOnly = "readOnly";
					toDateInput.readOnly = "readOnly";
				}

				if ( selectedValue == 3 ) {
					let currentDate = new Date();
					currentDate.setDate( 1 );
					currentDate.setDate( 0 );
					let formattedToDate = currentDate.toISOString().slice( 0, 16 );
					toDateInput.value = formattedToDate;
					toDateInput.readOnly = "readOnly";

					var currDate = new Date();
					currDate.setDate( 1 );
					currDate.setMonth( currDate.getMonth() - 1 );
					let formattedStartDate = currDate.toISOString().slice( 0, 16 );
					startDateInput.value = formattedStartDate;
					startDateInput.readOnly = "readOnly";
				}

				if ( selectedValue == 4 ) {
					let currentDate = new Date();
					let formattedCurrentDate = currentDate.toISOString().slice( 0, 16 );
					toDateInput.value = formattedCurrentDate;

					var currDate = new Date();
					currDate.setMonth( 0 );
					currDate.setDate( 1 );
					let formattedStartDate = currDate.toISOString().slice( 0, 16 );
					startDateInput.value = formattedStartDate;
					startDateInput.readOnly = "readOnly";
					toDateInput.readOnly = "readOnly";
				}

				if ( selectedValue == 5 ) {
					startDateInput.removeAttribute( "readonly" );
					toDateInput.removeAttribute( "readonly" );
				}

			}

			function downloadExcel (basePath) {
				let form = document.getElementById( 'selectionForm' );
				if(!validate(form)){
	                return;
	            }
				form.action = basePath + "/report/download/active/sprints/excel";
				form.submit();
			}
			function sendEmail (basePath) {
				let form = document.getElementById( 'selectionForm' );
				if(!validate(form)){
	                return;
	            }
				$.ajax({
				      type: "POST",
				      url: basePath + "/report/download/active/sprints/send-mail",
				      data: $("#selectionForm").serialize(),
				    }).done(function (data) {
				        if(data=='success'){
				        	toastr.success("Mail Sent Successfully");
				        } else {
				        	toastr.error(data);
				        }
				 });
			}
			function downloadPdf (basePath) {
				let form = document.getElementById( 'selectionForm' );
				if(!validate(form)){
	                return;
	            }
				form.action = basePath + "/report/download/active/sprints/pdf";
				
				form.submit();
			}
             
			 document.addEventListener('DOMContentLoaded', function () {
		            enableDisableGenerateButton();
		        });

		        document.getElementById("project-drop-down").addEventListener("change", function () {
		            enableDisableGenerateButton();
		        });

		        function enableDisableGenerateButton() {
		            var projectDropdown = document.getElementById("project-drop-down");
		            var generateButton = document.getElementById("generate-report");

		            if (projectDropdown.value == "0") {
		                generateButton.disabled = true; 
		            } else {
		                generateButton.disabled = false; 
		            }
		        }
			
			function generateJSON () {
				const form = document.getElementById( 'selectionForm' );
				if(!validate(form)){
	                return;
	            }
				const formData = new FormData( form );
				const jsonData = {};

				for ( const pair of formData.entries() ) {
					jsonData[ pair[ 0 ] ] = pair[ 1 ];
				}
				

				const jsonString = JSON.stringify( jsonData );
				$.ajax( {
					type: 'POST',
					url: '${pageContext.request.contextPath}/reports/sprints/active/tasks',
					data: jsonString,
					contentType: 'application/json',
					success: function ( response ) {
						let noRecordFoundSpan1 = document.getElementById( 'no-record-span' );
						noRecordFoundSpan1.innerHTML = "";
						if(typeof response === "string"){
							let noRecordFoundSpan = document.getElementById( 'no-record-span' );
							noRecordFoundSpan.style.display = "block";
							noRecordFoundSpan.innerHTML = "No active sprint!!!";
							return;
						}
						let table = document.getElementById( 'tableID' );
						table.style.display = "none";
						let body = document.getElementById( 'task_body' );
						let noRecordFoundSpan = document.getElementById( 'no-record-span' );
						body.innerHTML = "";
						noRecordFoundSpan.style.display = "none";
						if ( response.length == 0 ) {
							noRecordFoundSpan.style.display = "block";
							noRecordFoundSpan.innerHTML = "No record found !!!";
						} else {
							table.style.display = "block";
							for ( var i = 0; i < response.length; i++ ) {
								let data = response[ i ];
								let tr = document.createElement( 'tr' );
								let td1 = document.createElement( 'td' );
								td1.setAttribute( 'class', 'font-size-12 mb-1  px-0 ' );
								td1.style.width = "60%";

								let h5 = document.createElement( 'h5' );
								h5.setAttribute( 'class', 'font-size-14 mb-1 nowrap' );
								if ( data.taskType == 'Task' ) {
									let i = document.createElement( 'i' );
									i.setAttribute( 'class', 'fa fa-check-square text-primary' );
									h5.appendChild( i );
								}
								if ( data.taskType == 'Bug' ) {
									let i = document.createElement( 'i' );
									i.setAttribute( 'class', 'fa fa-stop-circle text-danger' );
									h5.appendChild( i );
								}
								if( data.taskType == 'User Story'){
									let i = document.createElement( 'i' );
									i.setAttribute( 'class', 'fa fa-bookmark text-success' );
									h5.appendChild( i );
								}
								if( data.taskType == 'Epic'){
									let i = document.createElement( 'i' );
									i.setAttribute( 'class', 'fa-solid fa-bolt' );
									i.style.color = "#904ee2";
									i.style.fontSize = "17px";
									h5.appendChild( i );
								}
								let a1 = document.createElement( 'a' );
								a1.setAttribute( 'class', 'project-initial-name' );
								a1.href = "${pageContext.request.contextPath}/tasks/updateTaskForm/" + data.id;
								a1.innerHTML = data.ticket;

								let a2 = document.createElement( 'a' );
								a2.setAttribute( 'class', 'colorLight' );
								a2.href = "${pageContext.request.contextPath}/tasks/updateTaskForm/" + data.id;
								a2.innerHTML = data.title;

								h5.appendChild( a1 );
								h5.appendChild( a2 );

								td1.appendChild( h5 );

								let td2 = document.createElement( 'td' );
								td2.setAttribute( 'class', 'font-size-12 mb-1  px-0' );
								td2.style.width = "10%";

								let spantd2 = document.createElement( 'span' );
								if ( data.priority == "Low" ) {
									spantd2.setAttribute( 'class', 'badge priority-low' );
								}
								else if ( data.priority == "Medium" ) {
									spantd2.setAttribute( 'class', 'badge priority-medium' );
								}
								else {
									spantd2.setAttribute( 'class', 'badge priority-high' );
								}
								spantd2.innerHTML = data.priority;
								td2.appendChild( spantd2 );

								let td3 = document.createElement( 'td' );
								td3.setAttribute( 'class', 'font-size-12 mb-1 px-0' );
								td3.style.width = "10%";
								td3.innerHTML = data.story_point;

								let td4 = document.createElement( 'td' );
								td4.setAttribute( 'class', 'font-size-12 mb-1 px-0' );
								td4.style.width = "10%";
								let spantd4 = document.createElement( 'span' );
								spantd4.setAttribute( 'class', 'badge lavender-pinocchio' );
								spantd4.innerHTML = data.status;

								td4.appendChild( spantd4 );

								let td5 = document.createElement( 'td' );
								td5.setAttribute( 'class', 'font-size-12 mb-1 px-0' );
								td5.style.width = "10%";
								td5.style.textTransform = "capitalize";
								td5.innerHTML = data.assigneName;

								tr.appendChild( td1 );
								tr.appendChild( td2 );
								tr.appendChild( td3 );
								tr.appendChild( td4 );
								tr.appendChild( td5 );

								body.appendChild( tr );
							}
						}
					},
					error: function ( error ) {
						console.error( 'Error sending data:', error );
					}
				} );
			}

			function getSelectedProject () {
				var selectElement = document.getElementById( "project-drop-down" );
				var selectedValue = selectElement.value;
				
				$.ajax( {
					type: "GET",
					url: "${pageContext.request.contextPath}/reports/active-sprints/"
						+ selectedValue,
					async: false,
					success: function ( data ) {
						let usersSelect = document.getElementById( 'sprint-drop-down' );
						usersSelect.innerHTML = "";
						let newOption = document.createElement( "option" );
						newOption.value = "-1";
						newOption.textContent = "Select Sprint";
						newOption.disabled = "disabled";
						newOption.selected = "selected"
						usersSelect.appendChild( newOption );
						for ( let i = 0; i < data.length; i++ ) {
							let temp = data[ i ];
							let newOption = document.createElement( "option" );
							newOption.value = temp.id;
							newOption.textContent = temp.name;
							usersSelect.appendChild( newOption );
						}
					}
				} );

				$.ajax( {
					type: "GET",
					url: "${pageContext.request.contextPath}/reports/users-by-project/"
						+ selectedValue,
					async: false,
					success: function ( data ) {
						let usersSelect = document.getElementById( 'users-drop-down' );
						usersSelect.innerHTML = "";
						let newOption = document.createElement( "option" );
						newOption.value = "-1";
						newOption.textContent = "Select User";
						newOption.disabled = "disabled";
						newOption.selected = "selected"
						usersSelect.appendChild( newOption );
						let newOption1 = document.createElement( "option" );
						newOption1.value = "0";
						newOption1.textContent = "All";
						usersSelect.appendChild( newOption1 );
						for ( let i = 0; i < data.length; i++ ) {
							let temp = data[ i ];
							let newOption = document.createElement( "option" );
							newOption.value = temp.id;
							newOption.textContent = temp.firstName + " " + temp.lastName;
							usersSelect.appendChild( newOption );
						}
					}
				} );

				$.ajax( {
					type: "GET",
					url: "${pageContext.request.contextPath}/reports/status-by-project/"
						+ selectedValue,
					async: false,
					success: function ( data ) {
						let statusSelect = document.getElementById( 'status-drop-down' );
						statusSelect.innerHTML = "";
						let newOption = document.createElement( "option" );
						newOption.value = "-1";
						newOption.textContent = "Select task status";
						newOption.disabled = "disabled";
						newOption.selected = "selected"
						statusSelect.appendChild( newOption );
						let newOption1 = document.createElement( "option" );
						newOption1.value = "0";
						newOption1.textContent = "All";
						statusSelect.appendChild( newOption1 );
						for ( let i = 0; i < data.length; i++ ) {
							let temp = data[ i ];
							let newOption = document.createElement( "option" );
							newOption.value = temp.status;
							newOption.textContent = temp.status;
							statusSelect.appendChild( newOption );
						}
					}
				} );
			}
			
			document.addEventListener('DOMContentLoaded', function() {
			    const fromDateInput = document.getElementById('fromDate');

			    fromDateInput.addEventListener('keydown', function(event) {
			        event.preventDefault();
			    });

			    fromDateInput.addEventListener('click', function() {
			        this.blur();
			    });
			});
			
			document.addEventListener('DOMContentLoaded', function() {
			    const fromDateInput = document.getElementById('toDate');

			    fromDateInput.addEventListener('keydown', function(event) {
			        event.preventDefault();
			    });

			    fromDateInput.addEventListener('click', function() {
			        this.blur();
			    });
			});
			
			function validate(form){
				const formData = new FormData( form );
				const jsonData = {};

				for ( const pair of formData.entries() ) {
					jsonData[ pair[ 0 ] ] = pair[ 1 ];
				}
				if(jsonData.projectId == 0){
					toastr.error("Please select project.");
					return false;
				}
				console.log(jsonData);
				if(jsonData.sprintId == undefined){
					toastr.error("Please select sprint.");
					return false;
				}
				return true;
			}

		</script>
</body>

</html>