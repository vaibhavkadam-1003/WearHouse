let imgUpload;
$(document).ready(function(){
	
	$('#addTaskModal').modal({backdrop: 'static', keyboard: false}, 'show');
	$('#addTaskModal').on('hidden.bs.modal', function() {
      window.location.reload();
    });
	
	imgUpload = document.getElementById( 'upload_imgs' )
	let imgPreview = document.getElementById( 'img_preview' )
	imgUpload.addEventListener( 'change', previewImgs, false );
	
	let browseFileArray = [];
	function previewImgs ( event ) {
	    
		let browseFile = imgUpload.files;
		for(let i = 0; i < browseFile.length; i++){
			let fileTypeAccepted = attachmentTypeValidation(browseFile[i], i);
			
			if(fileTypeAccepted){
				browseFileArray.push(browseFile[i]);
			}
		}
		
	sendFilesToServer(browseFileArray);	
	browseFileArray = [];
		
		$('#img_preview').html("");		
		const dataTransfer = new DataTransfer();
		 browseFileArray.forEach(file => {
			 dataTransfer.items.add(file);
		 });		
				
		imgUpload.files = dataTransfer.files;
		 
		totalFiles = imgUpload.files.length;				
				
	    if ( !!totalFiles ) {
	        imgPreview.classList.remove( 'quote-imgs-thumbs--hidden' );
	    }
	    for ( var i = 0; i < totalFiles; i++ ) {
	        imgWrapper = document.createElement( "div" );
	        imgWrapper.classList.add( 'img-preview-wrapper' );
	        img = document.createElement( 'img' );
	        img.src = URL.createObjectURL( event.target.files[ i ] );
	        img.classList.add( 'img-preview-thumb' );
	        closeBtn = document.createElement( "i" );
	        closeBtn.classList.add( 'fa-solid', 'fa-trash-can', 'close-btn' );
	        downloadBtn = document.createElement( "i" );
	        downloadBtn.classList.add( 'fa-solid', 'fa-file-arrow-down', 'downloadBtn' );
	        let files = event.target.files;
	        let fileName = files[ i ].name;
	        const textNode = document.createElement( "p" );
	        textNode.innerText = fileName
	        imgWrapper.appendChild( img );
	        imgWrapper.appendChild( closeBtn );
	        imgWrapper.appendChild( downloadBtn );
	        imgWrapper.appendChild( textNode );
	        imgPreview.appendChild( imgWrapper );
	        closeBtn.addEventListener( 'click', ( event ) => {
	            $( event.target ).parent().remove();
	        } );
	    }
		imgUpload.files = newFileList;
	}
})

function sendFilesToServer(files) {
    
	let formData = new FormData();
	let contextPath = $("#contextPathInput").val();

     for (let index = 0; index < files.length; index++) {
        formData.append('files', files[index]);
    }

	 var taskId = $('input[name="taskId"]').val();
	formData.append('taskId', taskId);

	
    $.ajax({
        url: contextPath+'/tasks/addTaskAttachment',
        type: 'POST',
        data: formData,
        contentType: false,
        processData: false,
        success: function (response) {
			if ( response === 'Task Attachments Uploaded' ) {
				 getTaskAttachmentsModal();
				 
			 }
        },
        error: function (error) {
            console.error('Error uploading files:', error);
        }
    });
}


function updateTask(id,projectId){
	
	let contextPath = $("#contextPathInput").val();
	
	if(projectId === undefined)
		projectId = 0;
	$.ajax( {
        type: 'GET',
        url: contextPath+'/tasks/updateTaskFormModal/' + id + "/" + projectId,
		data: {
			taskId: id
		},
        success: function ( data ) {
        	document.getElementById('task-type-id').textContent = data.task.ticket;
			document.getElementById('task-id').value = id;
			document.getElementById('default-project-id').value = projectId;
			document.getElementById('title').value = data.task.title;
			document.getElementById('description').value = data.task.description;
			let selectTaskType = document.getElementById('taskType');
			setSelectOptionsAndSelectValue(selectTaskType, data.taskType, data.task.taskType);
			let selectStatus = document.getElementById('statusModalId');
			setStatusOptions(selectStatus, data.taskStatus, data.task.status);
			let selectAssigneeTo = document.getElementById('assignedTo');
			setAssigneeToOptions(selectAssigneeTo, data.otherUsers,data.scrumUsers,data.lists, data.task.assignedTo);
			let selectPriorities = document.getElementById('priority');
			setPrioritiesOptions(selectPriorities, data.priorities, data.task.priority);
			let selectSeverities = document.getElementById('severity');
			setSeveritiesOptions(selectSeverities, data.severties, data.task.severity);
			let selectSprints = document.getElementById('sprint');
			setSprintOptions(selectSprints, data.sprints, data.task.sprint);			
			document.getElementById('creation-date').innerHTML = data.task.addedOn;
			let selectStoryPoint = document.getElementById('story_point');
			setStoryPointOptions(selectStoryPoint, data.taskStoryPoint, data.task.story_point);
			document.getElementById('originalEstimate').value = data.task.originalEstimate;
			document.getElementById('timeTracking').value = data.task.timeTracking;

			
			/*------------------------ Comment Data-----------------------------------------------------*/
			document.getElementById( 'nav-tabContent' ).innerHTML="";
			
			let blockData = `<div class=" send-comment  " style="display: none;">
                                            <div class="row">
                                                <div class="col-md-10 mx-auto comment-box"
                                                    style="background-color: #e0e0e0; padding: 15px 30px 5px; margin-top: 5px; border-radius: 5px;"
                                                    style="background-color: #e4e4e4;">
                                                    <h6>Add Comment</h6>
                                                    <div class=" ">
                                                        <input type="hidden" name="taskId"
                                                            value="${id}">
                                                        <input type="hidden" name="addedBy"
                                                            value=""> <input type="text"
                                                            class="form-control"
                                                            placeholder="Add a comment..."
                                                            required="required"
                                                            aria-label="Recipient's username"
                                                            name="comment" id="commentInput" onkeyup="addCommentFunction();"
                                                            aria-describedby="button-addon2">
                                                    </div>

                                                    <label
                                                        class="btn btn-success btn-sm text-white comment-btn"
                                                        style="background-color: #198754;"> <i
                                                            class="fa-solid fa-paperclip  "></i>
                                                        Attachment <input class="show-for-sr"
                                                            type="file" id="commentAtt"
                                                            name="commentFiles" multiple
                                                            style="display: none;" accept="image/*"
                                                            onchange="cmdAttachmentChange()" />
                                                    </label>

                                                    <button
                                                        class="btn btn-primary btn-sm my-3 comment-btn"
                                                        style="background-color: #3d8bfd;" type="button"
                                                        id="addCommentBtn" onclick="addCommentModal()">
                                                        <i class="fa fa-paper-plane"
                                                            aria-hidden="true"></i>
                                                        Submit
                                                    </button>

                                                    <button type="button"
                                                        class="comment-close-btn btn-close comment-btn"
                                                        aria-label="Close"></button>

                                                </div>
                                            </div>

                                        </div>`
            let parentDiv = document.getElementById( 'nav-tabContent' );
            let newElement = document.createElement( 'div' );
            newElement.innerHTML = blockData;
            parentDiv.appendChild( newElement.firstChild );
			
			for(let i = 0; i < data.allComment.length; i++){
					let first = data.allComment[i].firstName;
					let last = data.allComment[i].lastName; 
					let firstNameFirstChar = first.substring(0,1);
					let lastNameFirstChar = last.substring(0,1);	
					let innerData = `<a id="comId${data.allComment[i].id}">
	                    <div class="tab-pane fade show active" id="nav-comment" role="tabpanel" aria-labelledby="nav-comment-tab">
	                        <div class="d-flex justify-content-start align-items-start comment">
	                            <div class="comment-user">${firstNameFirstChar}${lastNameFirstChar}</div>
	                            <div class="comment-text w-100">
	                                <div class="d-flex justify-content-between align-items-start w-100">
	                                    <h6>${data.allComment[i].firstName} ${data.allComment[i].lastName}</h6>
	                                    <span> ${data.allComment[i].thisTimeAgo} Edited</span>
	                                </div>
	
									<div  id="commentDiv${data.allComment[i].id}">
	                                	<p>${data.allComment[i].comment}</p>
		                                <div class="mt-2">
		                                    <i class="fa-solid fa-pen-to-square text-primary " onclick="editClickModal(${data.allComment[i].id})"></i>
		                                    <i class="fa fa-file text-primary me-2" aria-hidden="true" onclick="getAllFiles(${data.allComment[i].id},${id})"></i>
		                                    <i class="fa-solid fa-trash text-danger mx-2" onclick="deleteClick(${data.allComment[i].id})"></i>
		                                    <div class="img-thumbs-wrapper  d-flex justify-content-start align-items-center" id="img_preview1${data.allComment[i].id}"></div>							
		                                </div>
									 </div>
									 
									<div style="display:none; background-color: rgb(224, 224, 224); padding: 15px 30px 5px; margin-top: 10px; border-radius: 5px; position: relative;" id="editDivId${data.allComment[i].id}">
										<grammarly-extension data-grammarly-shadow-root="true" style="position: absolute; top: 0px; left: 0px; pointer-events: none;" class="dnXmp"></grammarly-extension><grammarly-extension data-grammarly-shadow-root="true" style="position: absolute; top: 0px; left: 0px; pointer-events: none;" class="dnXmp"></grammarly-extension>
										<div class=" my-2">
											<input type="hidden" value="${data.allComment[i].addedOn}" id="addedOnId${data.allComment[i].id}">

											<textarea type="text" class="form-control edit-comment" id="updateCommentInput${data.allComment[i].id}" spellcheck="false" onchange="updateCommentFunction(this)">${data.allComment[i].comment}</textarea>

											<label class="btn btn-success btn-sm text-white comment-btn" style="background-color: #198754;"> <i class="fa-solid fa-paperclip  " ></i> Attachment
												<input class="show-for-sr" type="file" id="commentAtt${data.allComment[i].id}" name="commentFiles1" multiple="" style="display: none;" onclick="attachmentUploadFunction('${data.allComment[i].id}', '${data.allComment[i].comment}')" onchange="cmdUpdateAttachmentChange(${data.allComment[i].id})" accept="image/*">
											</label> <i class="fa-sharp fa-solid fa-xmark   text-dark comment-xmark" onclick="editClickCloseModal(${data.allComment[i].id})"> </i>

											<button class=" update-comment btn btn-primary btn-sm  comment-btn" id="updateCommentBtn${data.allComment[i].id}" onclick="updateCommentModal(${data.allComment[i].id})" style="background-color: #3d8bfd;" type="button">
												<i class="fa-solid fa-circle-check  me-2"></i>Update
											</button>
										</div>
									</div>
									 
	                            </div>
	                        </div>
	                    </div>
	                </a>`;
	
	            let parentDiv = document.getElementById( 'nav-tabContent' );
	            let newElement = document.createElement( 'div' );
	            newElement.innerHTML = innerData;
	            parentDiv.appendChild( newElement.firstChild );	
				//$("#nav-tabContent").load(" #nav-tabContent"); 
			}
			
			$(".edit-task").click(function(){
				$(".update-task-btn").css("display", "block");
			});
	
	
			$(".add-comment").click(function(e){ 
				$(".send-comment").css("display", "block"); 
			});
	
			$(".comment-close-btn").click(function(){
				$(".send-comment").css("display", "none");
			});
	
			$("#addCommentBtn").click(function(){ 
				$(".send-comment").css("display", "none");
			});
	
			showModal();
			
			 $("#addCommentBtn").prop('disabled', true);
			 $(".update-comment").prop('disabled', true);
			 
		},
	    error: function (error) {
	        console.error("Error fetching data:", error);
	    }
	})
	//$('#addTaskModal').modal('show');
}

function editClickModal(id){
	$("#editDivId"+id).css("display", "block");	
	$('#commentDiv'+id).toggle();
}

function addCommentFunction() {
	$("#commentInput").val().length >=2 ? $("#addCommentBtn").prop('disabled', false) : $("#addCommentBtn").prop('disabled', true);
}

function updateCommentFunction(textareaElement) {
	var textareaValue = $(textareaElement).val();

	let textareaId = $(textareaElement).attr("id");
	let numericString = textareaId.replace(/\D/g, "");
	if (textareaValue.length >= 2) {
		$("#updateCommentBtn" + numericString).prop("disabled", false);
	} else {
		$(".update-comment").prop('disabled', true); // Disable the button
	}

}

function attachmentUploadFunction(id, comment){
	
	let commentFiles = $('#commentAtt'+id)[0].files;
	
	if(comment.length >=2  || commentFiles.length <=0){
		$("#updateCommentBtn" + id).prop("disabled", false);
	}
	else{
		$(".update-comment").prop('disabled', true); // Disable the button
	}
}

function editClickCloseModal(id){
	$("#editDivId"+id).css("display", "none");
	$('#commentDiv'+id).toggle();
}

function showModal(){
	$('#addTaskModal').modal('show');
	setRemainingTime();
}

function closeUpdateTaskModal(){
	$('#addTaskModal').modal('hide');
}

function setSelectOptionsAndSelectValue(selectElement, options, currentValue){
	selectElement.innerHTML = "";
	for (var i = 0; i < options.length; i++) {
	    var option = document.createElement("option");
	    option.text = options[i];
	    option.value = options[i];
	    
	    if (options[i] === "Story") {
            option.style.display = "none";
        }
        
	    selectElement.appendChild(option);
	    
	     if (option.text === currentValue) {
	      option.selected = true;
	    }
    }

}

function setStatusOptions(selectElement, options, currentValue){
	selectElement.innerHTML = "";
	for (var i = 0; i < options.length; i++) {
	    var option = document.createElement("option");
	    option.text = options[i].status;
	    option.value = options[i].status;
	    
	    selectElement.appendChild(option);
	    
	    if (option.text === currentValue) {
	      option.selected = true;
	    }
	    
    }
}

function setAssigneeToOptions(selectElement, others,users,all, currentValue){
	selectElement.innerHTML = "";
	
	let defaultOption = document.createElement("option");
    defaultOption.text = "Unassigned";
    defaultOption.value = "";
    if (currentValue === null || currentValue === undefined) {
        defaultOption.selected = true;
    }
    
	for (var i = 0; i < all.length; i++) {
		if(all[i].id== currentValue){
		    let option = document.createElement("option");
		    option.text = all[i].firstName + " " + all[i].lastName;
		    option.value = all[i].id;
		    selectElement.appendChild(option);
		    option.selected = true;
		    break;
    	}
	}
	let scrumGroup = document.createElement('optgroup');
	scrumGroup.label="Scrum Team Members";
	for (var i = 0; i < users.length; i++) {
		if(users[i].id!= currentValue){
			let option = document.createElement("option");
		    option.text = users[i].firstName + " " + users[i].lastName;
		    option.value = users[i].id;
		    scrumGroup.appendChild(option);
		}
	}
	let otherUserGroup = document.createElement('optgroup');
	otherUserGroup.label="Other Users";
	for (var i = 0; i < others.length; i++) {
		if(others[i].id!= currentValue){
			let option = document.createElement("option");
		    option.text = others[i].firstName + " " + others[i].lastName;
		    option.value = others[i].id;
		    otherUserGroup.appendChild(option);
		}
	}
	selectElement.appendChild(defaultOption);
	selectElement.appendChild(scrumGroup);
	selectElement.appendChild(otherUserGroup);
	
}
function setPrioritiesOptions(selectElement, options, currentValue){
	selectElement.innerHTML = "";
	for (var i = 0; i < options.length; i++) {
	    var option = document.createElement("option");
	    option.text = options[i].priority;
	    option.value = options[i].priority;
	    selectElement.appendChild(option);
	    
	     if (option.value === currentValue) {
	      	option.selected = true;
	    }
    }
}

function setSeveritiesOptions(selectElement, options, currentValue){
	selectElement.innerHTML = "";
	for (var i = 0; i < options.length; i++) {
	    var option = document.createElement("option");
	    option.text = options[i].severity;
	    option.value = options[i].severity;
	    selectElement.appendChild(option);
	    
	     if (option.value === currentValue) {
	      	option.selected = true;
	    }
    }
}

function setSprintOptions(selectElement, options, currentValue){	
	selectElement.innerHTML = "";
	  let option1 = document.createElement("option");
        option1.text ="Select Sprint";
	    option1.value = 0;
	    selectElement.appendChild(option1);
	for (var i = 0; i < options.length; i++) {
	    var option = document.createElement("option");
        option.text = options[i].name;
	    option.value = options[i].id;
	    selectElement.appendChild(option);
	   
	     if (options[i].id === currentValue) {
	      	option.selected = true;
	    }
    }
}


function setStoryPointOptions(selectElement, options, currentValue){
	selectElement.innerHTML = "";
	for (var i = 0; i < options.length; i++) {
	    var option = document.createElement("option");
	    option.text = options[i].storyPoint;
	    //option.value = options[i].id;
	    selectElement.appendChild(option);
	    
	     if (option.text === currentValue) {
	      	option.selected = true;
	    }
    }
}

function updateTaskModal() {

	let contextPath = $("#contextPathInput").val();

	let id = $('#task-id').val();
	let project = document.getElementById('default-project-id').value
	let title = document.getElementById("title").value;
	let description = document.getElementById("description").value;
	let taskType = $('#taskType').val();
	let status = $('#statusModalId').val();
	let assignedTo = $('#assignedTo').val();
	let priority = $('#priority').val();
	let severity = $('#severity').val();
	let sprint = $('#sprint').val();
	let story_point = $('#story_point').val();
	let originalEstimate = $('#originalEstimate').val();
	let timeTracking = $('#timeTracking').val();

	if (title.length < 2) {
		toastr.error('Title must be at least 2 characters long.');
	}
	else {

		var formData = new FormData();
		formData.append('project', project);
		formData.append('id', id);
		formData.append('taskType', taskType);
		formData.append('title', title);
		formData.append('description', description);
		formData.append('status', status);
		formData.append('assignedTo', assignedTo);
		formData.append('priority', priority);
		formData.append('severity', severity);
		if (sprint !== null && sprint !== undefined) {
			formData.append('sprint', sprint);
		}

		formData.append('story_point', story_point);
		formData.append('originalEstimate', originalEstimate);
		formData.append('timeTracking', timeTracking);


		$.ajax({
			type: 'POST',
			url: contextPath + '/tasks/updateTaskModal',
			processData: false,
			contentType: false,
			data: formData,
			success: function(data) {
				toastr.success('Task updated successfully', '', { timeOut: 1000 }); // Display for 1 seconds (1000 milliseconds)
			},
			error: function(xhr, status, error) {
				// Handle the error here
				console.log(xhr, status, error);
				toastr.error("Unable to update task");
			}
		});

	}


}

//History code---------------------------------------------------------------------
function getTaskHistoryModal(basePath){
	let taskId = $('#task-id').val();
	$.ajax( {
        type: 'GET',
        url: basePath+'/taskHistory/' + taskId,
		data: {
			taskId: taskId
		},
        success: function ( data ) {
			$('#historyParentDiv').html("");
			if(data.length != 0){
				for(let item of data){
					let first = item.firstName;
					let last = item.lastName; 
					let firstNameFirstChar = first.substring(0,1);
					let lastNameFirstChar = last.substring(0,1);	
					let originalTime = item.addedOn.toString();
					let fromLogoChars;
					let toLogoChars;
					if(item.field === 'ASSIGNED-TO'){
						let name = item.fromValue;
							let parts = name.split(" ");
							let firstNameFirstChar = parts[0].substring(0, 1);
							let lastNameFirstChar = parts[1].substring(0, 1);
							fromLogoChars = firstNameFirstChar+lastNameFirstChar;
							
							name = item.toValue;
							parts = name.split(" ");
							firstNameFirstChar = parts[0].substring(0, 1);
							lastNameFirstChar = parts[1].substring(0, 1);
							toLogoChars = firstNameFirstChar+lastNameFirstChar;
					}
					
					let historyData = `<div class="d-flex justify-content-start align-items-baseline p-2 border-bottom"> 
															<div class="history-user">${firstNameFirstChar}${lastNameFirstChar}</div>
															<div>
																<p><b>${item.firstName} ${item.lastName}</b> ${item.action} <b>${item.field}</b></p>
																<div class="d-flex justify-content-start align-items-baseline  history-data  ">
																	${item.fromValue !== null && item.toValue !== null && item.field !== 'ASSIGNED-TO' ? `<h6>${item.fromValue} <b> -> </b> ${item.toValue}</h6>` : ''}
																	${item.field === 'ASSIGNED-TO' ? `<div class="history-user1">${fromLogoChars}</div><h6>${item.fromValue}&nbsp; <b> -> </b> &nbsp; &nbsp;</h6><div class="history-user1">${toLogoChars}</div><h6>${item.toValue}</h6>` : ''}
																</div>
																<span id="timeToggleSpan${item.id}" onclick="timeToggle(${item.id}, '${item.addedOn}', '${item.thisTimeAgo}')"  data-bs-toggle="tooltip" data-bs-placement="top" title="Click here to see original time">${item.thisTimeAgo}</span>
															</div>
														 </div>`;
					let parentDiv = document.getElementById('historyParentDiv');
					let newElement = document.createElement('div');
					newElement.innerHTML = historyData;
					parentDiv.insertBefore(newElement.firstChild, parentDiv.firstChild);
				}
			}
			
		}
	});
}
var booleanToggle = false;
function timeToggle(id, addedOn, thisTimeAgo){
	if(booleanToggle == false){
		$('#timeToggleSpan'+id).html("");
		let dateTime = addedOn.split("T");
		let date = dateTime[0];
		let time = dateTime[1];
		document.getElementById("timeToggleSpan"+id).innerHTML = date + " " + time;
		booleanToggle = true;
	}else if(booleanToggle == true){
		document.getElementById("timeToggleSpan"+id).innerHTML = thisTimeAgo;
		booleanToggle = false;
	}
}

//Task Attachment tab----------------------------------------------------------------------------------------
function getTaskAttachmentsModal(){
	
	let contextPath = $("#contextPathInput").val();
	
	let taskId = $('#task-id').val();
	$.ajax( {
        type: 'GET',
        url: contextPath+'/tasks/updateAttchaments/' + taskId,
		data: {
			taskId: taskId
		},
        success: function ( data ) {
			$('#img_preview').html("");
			if(data.length != 0){
				for(let item of data){
					let attachmentsData = `<div class="img-preview-wrapper">
															<a href="${contextPath}/image/${item.docUrl}"
																class="img-preview-link"> <img
																src="${contextPath}/image/${item.docUrl}"
																data-mfp-src="${contextPath}/image/${item.docUrl}"
																class="img-preview-thumb" id="myimg">
															</a> <a class="text-success">
																<button class="fa-solid fa-trash-can close-btn"
																	id="deleteAttchmenetBtn"
																	onclick="deleteTaskAttachment(${item.id},${taskId})"></button>
															</a> <a href="${contextPath}/image/${item.docUrl}"
																download="${item.docFileName}"><i
																class="fa-solid fa-file-arrow-down downloadBtn"></i></a>
															<p>${item.docFileName}</p>
														</div>`
					let parentDiv = document.getElementById('img_preview');
					let newElement = document.createElement('div');
					newElement.innerHTML = attachmentsData;
					parentDiv.appendChild(newElement);	
				}
			}else{
				let attachmentsData = `<div><h6>No Attachment Available </h6></div>`;
				let parentDiv = document.getElementById('img_preview');
				let newElement = document.createElement('div');
				newElement.innerHTML = attachmentsData;
				parentDiv.appendChild(newElement);
			}
			
			$( '.img-preview-link' ).magnificPopup( {
		        type: 'image',
		        gallery: {
		            enabled: true
		        },
		        mainClass: 'mfp-with-zoom',
		        zoom: {
		            enabled: true,
		            duration: 300,
		            easing: 'ease-in-out'
		        },
				callbacks: {
			        open: function() {
			         
			            this.container.css('z-index', 10000);
			            this.wrap.css('z-index', 10001);
			        },
			    },
		    } );
		}
	});
}

function deleteTaskAttachment ( attachmentId, taskId ) {
	
	let contextPath = $("#contextPathInput").val();
	
	$.ajax( {
         url: contextPath+'/tasks/delete/attachment/' + attachmentId,
		 type: 'GET',
        data: {
            id: attachmentId
        },
        success: function ( data ) {
			  if ( data === 'File deleted' ) {
				 getTaskAttachmentsModal(taskId);
				 
			 }
        }
    } );
}

function addCommentModal() {
		
		let contextPath = $("#contextPathInput").val();
        var taskId = $('input[name="taskId"]').val();
		var comment = $('#commentInput').val();
		
					  var commentFiles = $('input[name="commentFiles"]')[0].files;
		
		  var formData = new FormData();
		  formData.append('taskId', taskId);
		  formData.append('comment', comment);
		
		  for (var i = 0; i < commentFiles.length; i++) {
		    formData.append('commentFiles', commentFiles[i]);
			
		  }
		
        $.ajax( {
            url: contextPath+'/comment/addTaskComment',
		    type: 'POST',
		    data: formData,
		    processData: false,
		    contentType: false,
            success: function(data) {
				
				window.localStorage.setItem("coomentData",data.comment);
				window.localStorage.setItem("addedOn",data.addedOn);
				
				let first = data.firstName;
				let last = data.lastName; 
				let firstNameFirstChar = first.substring(0,1);
				let lastNameFirstChar = last.substring(0,1);	
				
				var innerData = `<a id="comId${data.id}">
                    <div class="tab-pane fade show active" id="nav-comment" role="tabpanel" aria-labelledby="nav-comment-tab">
                        <div class="d-flex justify-content-start align-items-start comment">
                            <div class="comment-user">${firstNameFirstChar}${lastNameFirstChar}</div>
                            <div class="comment-text w-100">
                                <div class="d-flex justify-content-between align-items-start w-100">
                                    <h6>${data.firstName} ${data.lastName}</h6>
                                    <span> ${data.thisTimeAgo}</span>
                                </div>

								<div  id="commentDiv${data.id}">
                                	<p>${data.comment}</p>
	                                <div class="mt-2">
	                                	<i class="fa-solid fa-pen-to-square text-primary " onclick="editClickModal(${data.id})"></i>
	                                    <i class="fa fa-file text-primary me-2" aria-hidden="true" onclick="getAllFiles(${data.id},${taskId})"></i>
	                                    <i class="fa-solid fa-trash text-danger mx-2" onclick="deleteClick(${data.id})"></i>
										<div class="img-thumbs-wrapper  d-flex justify-content-start align-items-center" id="img_preview1${data.id}"></div>
	                                </div>
								 </div>
							
								<div style="display:none; background-color: rgb(224, 224, 224); padding: 15px 30px 5px; margin-top: 10px; border-radius: 5px; position: relative;" id="editDivId${data.id}">
										<grammarly-extension data-grammarly-shadow-root="true" style="position: absolute; top: 0px; left: 0px; pointer-events: none;" class="dnXmp"></grammarly-extension><grammarly-extension data-grammarly-shadow-root="true" style="position: absolute; top: 0px; left: 0px; pointer-events: none;" class="dnXmp"></grammarly-extension>
										<div class=" my-2">
											<input type="hidden" value="${data.addedOn}" id="addedOnId${data.id}">

											<textarea type="text" class="form-control edit-comment" id="updateCommentInput${data.id}" spellcheck="false" onchange="updateCommentFunction(this)">${data.comment}</textarea>

											<label class="btn btn-success btn-sm text-white comment-btn" style="background-color: #198754;"> <i class="fa-solid fa-paperclip  "></i> Attachment
												<input class="show-for-sr" type="file" id="commentAtt${data.id}" name="commentFiles1" multiple="" style="display: none;" onclick="attachmentUploadFunction('${data.id}', '${data.comment}')" onchange="cmdUpdateAttachmentChange(${data.id})" accept="image/*">
											</label> <i class="fa-sharp fa-solid fa-xmark   text-dark comment-xmark" onclick="editClickCloseModal(${data.id})"> </i>

											<button class="update-comment btn btn-primary btn-sm  comment-btn" id="updateCommentBtn${data.id}" onclick="updateCommentModal(${data.id})" style="background-color: #3d8bfd;" type="button">
												<i class="fa-solid fa-circle-check  me-2"></i>Update
											</button>
										</div>
									</div>
							
                            </div>
                        </div>
                    </div>
                </a>`;

                let parentDiv = document.getElementById( 'nav-tabContent' );
                let newElement = document.createElement( 'div' );
                newElement.innerHTML = innerData;
                parentDiv.appendChild( newElement.firstChild );
                $( '#commentInput' ).val( "" );
				
				$(".send-comment").css("display", "none");
				$("#addCommentBtn").prop('disabled', true);
				
            },
            error: function ( xhr, status, error ) {
                console.log( xhr, status, error );
            }
        } );
    } ;
    
function updateCommentModal(id){
	
	let contextPath = $("#contextPathInput").val();
	let taskId = $('input[name="taskId"]').val();
    let comment = $('#updateCommentInput'+id).val();
	let dateTimeString = $('#addedOnId'+id).val();
	let commentFiles = $('#commentAtt'+id)[0].files;
	
	var formData = new FormData();
		formData.append('id', id);
		formData.append('taskId', taskId);
		formData.append('comment', comment);
		formData.append('dateTimeString', dateTimeString);
		
		for (var i = 0; i < commentFiles.length; i++) {
		    formData.append('commentFiles', commentFiles[i]);
		  }

        $.ajax({
            url: contextPath+'/comment/update',
            type: 'POST',
           data: formData,
		    processData: false,
		    contentType: false,
            success: function(data) {
			
				let itemToDelete1 = document.getElementById('comId'+id);
					itemToDelete1.remove();
				
				window.localStorage.setItem("coomentData",data.comment);
				window.localStorage.setItem("addedOn",data.addedOn);
				
				let first = data.firstName;
				let last = data.lastName; 
				let firstNameFirstChar = first.substring(0,1);
				let lastNameFirstChar = last.substring(0,1);	
				
				let innerData = `<a id="comId${data.id}">
                    <div class="tab-pane fade show active" id="nav-comment" role="tabpanel" aria-labelledby="nav-comment-tab">
                        <div class="d-flex justify-content-start align-items-start comment">
                            <div class="comment-user">${firstNameFirstChar}${lastNameFirstChar}</div>
                            <div class="comment-text w-100">
                                <div class="d-flex justify-content-between align-items-start w-100">
                                    <h6>${data.firstName} ${data.lastName}</h6>
                                    <span> ${data.thisTimeAgo} Edited</span>
                                </div>

								<div  id="commentDiv${data.id}">
                                	<p>${data.comment}</p>
	                                <div class="mt-2">
	                                    <i class="fa-solid fa-pen-to-square text-primary " onclick="editClickModal(${data.id})"></i>
	                                    <i class="fa fa-file text-primary me-2" aria-hidden="true" onclick="getAllFiles(${data.id},${taskId})"></i>
	                                    <i class="fa-solid fa-trash text-danger mx-2" onclick="deleteClick(${data.id})"></i>
										<div class="img-thumbs-wrapper  d-flex justify-content-start align-items-center" id="img_preview1${data.id}"></div>
	                                </div>
								 </div>
							
								<div style="display:none; background-color: rgb(224, 224, 224); padding: 15px 30px 5px; margin-top: 10px; border-radius: 5px; position: relative;" id="editDivId${data.id}">
										<grammarly-extension data-grammarly-shadow-root="true" style="position: absolute; top: 0px; left: 0px; pointer-events: none;" class="dnXmp"></grammarly-extension><grammarly-extension data-grammarly-shadow-root="true" style="position: absolute; top: 0px; left: 0px; pointer-events: none;" class="dnXmp"></grammarly-extension>
										<div class=" my-2">
											<input type="hidden" value="${data.addedOn}" id="addedOnId${data.id}">

											<textarea type="text" class="form-control edit-comment" id="updateCommentInput${data.id}" spellcheck="false" onchange="updateCommentFunction(this)">${data.comment}</textarea>

											<label class="btn btn-success btn-sm text-white comment-btn" style="background-color: #198754;"> <i class="fa-solid fa-paperclip  "></i> Attachment
												<input class="show-for-sr" type="file" id="commentAtt${data.id}" name="commentFiles1" multiple="" style="display: none;" onclick="attachmentUploadFunction('${data.id}', '${data.comment}')"  onchange="cmdUpdateAttachmentChange(${data.id})" accept="image/*">
											</label> <i class="fa-sharp fa-solid fa-xmark   text-dark comment-xmark" onclick="editClickCloseModal(${data.id})"> </i>

											<button class="update-comment btn btn-primary btn-sm  comment-btn" id="updateCommentBtn${data.id}" onclick="updateCommentModal(${data.id})" style="background-color: #3d8bfd;" type="button">
												<i class="fa-solid fa-circle-check  me-2"></i>Update
											</button>
										</div>
									</div>
							
                            </div>
                        </div>
                    </div>
                </a>`;

            let parentDiv = document.getElementById( 'nav-tabContent' );
            let newElement = document.createElement( 'div' );
            newElement.innerHTML = innerData;
            parentDiv.appendChild( newElement.firstChild );

			$(".update-comment").prop('disabled', true);    
        },
        error: function ( xhr, status, error ) {
            console.log( xhr, status, error );
        }
    } ); 
}

function deleteClick ( id ) {

	let contextPath = $("#contextPathInput").val();
    var commentId = id;
    
    $.ajax( {
        url: contextPath+'/comment/delete/' + commentId,
        type: 'GET',
        data: {
            commentId: commentId
        },
        success: function ( data ) {
            if ( data === 'Comment deleted' ) {
              let itemToDelete = document.getElementById( 'comId' + commentId );
                itemToDelete.remove();
			$("#addCommentBtn").prop('disabled', true);
            }
        },
        error: function ( xhr, status, error ) {
            console.log( xhr, status, error );
        }
    } );
}


function addTaskAttachmentModal(files){
	
		  let contextPath = $("#contextPathInput").val();
		  let taskId = $('#task-id').val();
		  var formData = new FormData();
		  formData.append('id', taskId);
		
		  for (var i = 0; i < files.length; i++) {
		    formData.append('files', files[i]);
			
		  }
		
        $.ajax( {
            url: contextPath+'/tasks/update/task-attachment',
		    type: 'POST',
		    data: formData,
		    processData: false,
		    contentType: false,
            success: function(data) {
				if(data === "Task Attachments Updated")
					getTaskAttachmentsModal();
			},
            error: function ( xhr, status, error ) {
                console.log( xhr, status, error );
            }
        } );
}

let newFileList;
function attachmentTypeValidation(attachedFile, index) {
	let file = attachedFile;
	let fileName = file.name;
	let reg = /(.*?)\.(jpg|jpeg|png)$/;
	let fileSize = file.size;
			
	if (!fileName.match(reg)) {
		toastr.error("Invalid file type! <br>" + fileName +"<br> (only JPG | JPEG | PNG allowed) ");
		const indexToRemove = index; 
  		const updatedFiles = Array.from(imgUpload.files).filter((_, index) => index !== indexToRemove);
		const dataTransfer = new DataTransfer();
		updatedFiles.forEach(file => dataTransfer.items.add(file));
		imgUpload.files = dataTransfer.files;
		
		return false;
	}
	else if (fileSize > 5242880) { //for 5mb
		toastr.error("Max file size limit exceeded !! max size 5MB <br>" + fileName);
		const indexToRemove = index; 
  		const updatedFiles = Array.from(imgUpload.files).filter((_, index) => index !== indexToRemove);
		const dataTransfer = new DataTransfer();
		updatedFiles.forEach(file => dataTransfer.items.add(file));
		imgUpload.files = dataTransfer.files;
		return false;
	}
	return true;
}


function setRemainingTime(){
				let originalTime = document.getElementById( 'originalEstimate' ).value;
				let timeTracked = document.getElementById( 'timeTracking' ).value;
				let originalTimeInMinute = convertTimeStringToMinutes( originalTime );
				let trackedTimeInMinute = convertTimeStringToMinutes(timeTracked );
				let remainingTimeInMinute = originalTimeInMinute - trackedTimeInMinute;
				let remainingTime  = convertMinutesToTimeString( remainingTimeInMinute );
				document.getElementById( 'remainingTime' ).value = remainingTime;
				console.log(remainingTime)
				
			}
			
