let imgUpload = document.getElementById( 'upload_imgs' )
let imgPreview = document.getElementById( 'img_preview' )
imgUpload.addEventListener( 'change', previewImgs, false );

let browseFileArray = [];
function previewImgs ( event ) {
    
	let browseFile = imgUpload.files;
	let fileCount = browseFile.length;
	
	if(fileCount !=0){	
	for(let i = 0; i < browseFile.length; i++){
		let fileTypeAccepted = attachmentTypeValidation(browseFile[i], i);
		
		if(fileTypeAccepted){
			browseFileArray.push(browseFile[i]);
		}
	}
	
	sendFilesToServer(browseFileArray);	
	browseFileArray = [];
			
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
}

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
				 getTaskAttachments(taskId);
				 toastr.success("Attachment added successfully");
			 }
			 else{
				 toastr.error("Unable to add attachment");
			 }
        },
        error: function (error) {
            console.error('Error uploading files:', error);
        }
    });
}



function task () {
    
	if($('#title').val().length>2)
		$( "#update" ).submit();
	else
		$( "#title-validation-id" ).text("Cannot be blank");	
}

function deleteTask ( attachmentId, taskId ) {
	let contextPath = $("#contextPathInput").val();
	$.ajax( {
         url: contextPath+'/tasks/delete/attachment/' + attachmentId,
		 type: 'GET',
        data: {
            id: attachmentId
        },
        success: function ( data ) {
			  if ( data === 'File deleted' ) {
				 getTaskAttachments(taskId);
				 toastr.success("Attachment deleted successfully", {
				    timeOut: 1000 // 1000 milliseconds (1 seconds)
				});
			 }
			 else{
				toastr.error("Unable to delete attachment");
			 }
        }
    } );
}

$( document ).ready( function () {
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
        }
    } );
	
	let fileArray = [];
	$('#commentAtt').on('change',function(){
		 let cmdAtt = $('input[name="commentFiles"]')[0].files;
			for(let cmdFiles of cmdAtt)
			fileArray.push(cmdFiles);
	})

    $( '#addCommentBtn' ).click( function () {
		  let contextPath = $("#contextPathInput").val();
          var taskId = $('input[name="taskId"]').val();
		  var comment = $('#commentInput').val();
		  var commentFiles = $('input[name="commentFiles"]')[0].files; // Use [0].files to retrieve the selected files as an array
		
		  var formData = new FormData();
		  formData.append('taskId', taskId);
		  formData.append('comment', comment);
		
		  for (var i = 0; i < fileArray.length; i++) {
		    formData.append('commentFiles', fileArray[i]);
			
		  }
		  fileArray = [];
		 
		   
		 if($("#addCommentBtn")!="none"){
			submitButton.disabled = true;
		}else{
			 submitButton.disabled = false;
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
	                                    <i class="fa-solid fa-pen-to-square text-primary " onclick="editClick(${data.id})"></i>
	                                    <i class="fa-solid fa-trash text-danger mx-2" onclick="deleteClick(${data.id})"></i>
										<h6 class="text-primary" onclick="getAllFiles(${data.id},${taskId})" style="cursor: pointer;">Attachments</h6>
	                                </div>
								 </div>
							
								<div  style="display:none;" id="editDivId${data.id}">
									<div class="d-flex justify-content-start align-items-center">
										<input type="hidden" value="${data.addedOn}" id="addedOnId${data.id}">
										<input type="text" class="form-control rounded-0" id="updateCommentInput${data.id}">
										<label class="btn btn-success">  <i class="fa-solid fa-paperclip  "></i><input
											class="show-for-sr" type="file" id="commentAtt1${data.id }" name="commentFiles1"
											multiple style="display: none;"
											accept="application/msword, application/vnd.ms-excel, text/plain, application/pdf, image/*" />
										</label> 
										<i class="fa-solid fa-circle-check fa-beat px-2 text-success" onclick="update(${data.id})"></i>
										<i class="fa-sharp fa-solid fa-xmark fa-shake text-danger" onclick="editClick(${data.id})"></i>
									</div>
								</div>
							
                            </div>
                        </div>
                    </div>
                </a>`;

                let parentDiv = document.getElementById( 'nav-tabContent' );
                let newElement = document.createElement( 'div' );
                newElement.innerHTML = innerData;
                parentDiv.insertBefore(newElement.firstChild, parentDiv.firstChild);
                $( '#commentInput' ).val( "" );
				$("#comId"+data.id)
																	.load(
																			" #comId"+data.id); 


            },
            error: function ( xhr, status, error ) {
                console.log( xhr, status, error );
            }
        } );
    } );

	$('#description').on('input', () => {
		if($('#description').val().length < 5000)
			$('#description-validation-id').text("");
		else
			$('#description-validation-id').text("Description should be maximum 5000 charaters");
	})
	
    let quickStoryAddInputs = document.querySelectorAll('#commentInput');
    let submitButton = document.getElementById("addCommentBtn");
   
    submitButton.disabled = true;
    quickStoryAddInputs.forEach((input) => {
        input.addEventListener('input', () => {
			let commentInput = $('#commentInput').val().trim();
           if (commentInput.length >= 2 && !(/^\s+$/.test(commentInput))) {
                submitButton.disabled = false;
            } else {
                submitButton.disabled = true;            
            }
        })
    })

} );

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
            }
        },
        error: function ( xhr, status, error ) {
            console.log( xhr, status, error );
        }
    } );
}

function editClick(id) {
	
	$('#editDivId'+id).toggle();
  	$('#commentDiv'+id).toggle();

	let com = window.localStorage.getItem('coomentData');
	let addedOn = window.localStorage.getItem('addedOn');
	
	let commentValue = $('#commentId'+id).text();
	let addedOnValue = $('#addedOnId'+id).val();
	
	if(commentValue == "" && (com != null && com != undefined)){
		$('#updateCommentInput'+id).val(com);
	}else{
		$('#updateCommentInput'+id).val(commentValue);
	}
	
	if(addedOnValue === undefined && addedOn != null){
		$('#addedOnId'+id).val(addedOn);
	}
	
	$(".comment-btn").prop('disabled', true); 
	
	com = window.localStorage.clear();
}

function update(id){
		let contextPath = $("#contextPathInput").val();
		let taskId = $('input[name="taskId"]').val();
        let comment = $('#updateCommentInput'+id).val();
       
		let dateTimeString = $('#addedOnId'+id).val();
		let commentFiles = $('#commentAtt1'+id)[0].files;
		
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
	                                    <i class="fa-solid fa-pen-to-square text-primary " onclick="editClick(${data.id})"></i>
	                                    <i class="fa-solid fa-trash text-danger mx-2" onclick="deleteClick(${data.id})"></i>
										<h6 class="text-primary" onclick="getAllFiles(${data.id},${taskId})" style="cursor: pointer;">Attachments</h6>
	                                </div>
								 </div>
							
								<div  style="display:none;" id="editDivId${data.id}">
									<div class="d-flex justify-content-start align-items-center">
									<input type="hidden" value="${data.addedOn}" id="addedOnId${data.id}">
										<input type="text" class="form-control rounded-0" id="updateCommentInput${data.id}">
										<label class="btn btn-success">  <i class="fa-solid fa-paperclip  "></i><input
											class="show-for-sr" type="file" id="commentAtt1${data.id }" name="commentFiles1"
											multiple style="display: none;" onchange="cmdUpdateAttachmentChange(${data.id })"
											accept="image/*" />
										</label> 
										<i class="fa-solid fa-circle-check fa-beat px-2 text-success" onclick="update(${data.id})"></i>
										<i class="fa-sharp fa-solid fa-xmark fa-shake text-danger" onclick="editClick(${data.id})"></i>
										<h6 class="text-primary" onclick="getAllFiles(${data.id},${taskId})" style="cursor: pointer;">Attachments</h6>
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
			
			$("#nav-tabContent").load(" #nav-tabContent"); 
            
        },
        error: function ( xhr, status, error ) {
            console.log( xhr, status, error );
        }
    } ); 
}

function showStoryTable () {
    document.getElementById( 'story-point-table' ).style.display = "block";
}

function getTaskAttachments(taskId, contextPath){
	
	let contextPathNew = $("#contextPathInput").val();
	if(contextPath == null || contextPath == ''){
		contextPath = contextPathNew;
	}

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
																	onclick="deleteTask(${item.id},${taskId})"></button>
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
		        }
		    } );
		}
	});
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

function getTaskHistory(taskId){
	let contextPath = $("#contextPathInput").val();
	$.ajax( {
        type: 'GET',
        url: contextPath+'/taskHistory/' + taskId,
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

function cmdAttachmentChange(){
	let imgUpload = document.getElementById( 'commentAtt' );
	let browseFileArray = [];
	
	let browseFile = imgUpload.files;
	for(let i = 0; i < browseFile.length; i++){
		let fileTypeAccepted = attachmentTypeValidation(browseFile[i], i);
		
		if(fileTypeAccepted){
			browseFileArray.push(browseFile[i]);
		}
	}
			
	const dataTransfer = new DataTransfer();
	 browseFileArray.forEach(file => {
		 dataTransfer.items.add(file);
	 });		
			
	imgUpload.files = dataTransfer.files;
}

function cmdUpdateAttachmentChange(id){
	let imgUpload = document.getElementById( 'commentAtt1'+id );
	let browseFileArray = [];
	
	let browseFile = imgUpload.files;
	for(let i = 0; i < browseFile.length; i++){
		let fileTypeAccepted = attachmentTypeValidation(browseFile[i], i);
		
		if(fileTypeAccepted){
			browseFileArray.push(browseFile[i]);
		}
	}
			
	const dataTransfer = new DataTransfer();
	 browseFileArray.forEach(file => {
		 dataTransfer.items.add(file);
	 });		
			
	imgUpload.files = dataTransfer.files;
}

function statusDropdown(o, taskId, e) {
	var currentStatus= e;
	let contextPath = $("#contextPathInput").val();
	$.ajax({
		type: "GET",
		url: contextPath+'/tasks/status/' + currentStatus,
		data: { value: currentStatus },
		success: function(data) {
			var statusList = data.map(function(item) {
				return item.status;
			});
			createStatusListElements(taskId, statusList);
		},
		error: function() {
			console.error("AJAX request failed");
		}
	});
}

function createStatusListElements(taskId, statusList) {
	const ulElement = document.getElementById("main-UI");
	ulElement.innerHTML = '';
	for (const status of statusList) {
		const liElement = document.createElement("li");
		const anchorElement = document.createElement("a");
		anchorElement.href = "#";
		anchorElement.textContent = status;
		anchorElement.className = "dropdown-item";
		liElement.appendChild(anchorElement);
		ulElement.appendChild(liElement);

		liElement.addEventListener("click", function() {
			handleStatusItemClick(taskId, status);
		});
	}
}

function handleStatusItemClick(taskId, status) {
	const buttonElement = document.getElementById("myButton");
	buttonElement.value = status;
	let contextPath = $("#contextPathInput").val();

	$.ajax({
		type: "POST", 
		url: contextPath+'/tasks/updateTaskStatus/' + taskId + "/" + status,
		data: { value: status },
		success: function(data) {
			if (data == "Task Status Updated") {
			
				toastr.success("Task Updated successfully");
				setTimeout(function() {
					location.reload(true);
				}, 1000)
			}
			else
				toastr.error("Unable to update task");
		},
		error: function() {
			console.error("AJAX request failed");
		}
	});

}

function updateCommentFunction(textareaElement) {
	
	var textareaValue = $(textareaElement).val().trim();
	
	if (textareaValue === '' || textareaValue.length < 2) {
        $(".comment-btn").prop('disabled', true); // Disable the button
    } else {
        $(".comment-btn").prop("disabled", false);
    }
}

function uploadAttachmentFunction(id, comment){
	
	let commentFiles = $('#commentAtt1'+id)[0].files;
	let textareaValue = $('#updateCommentInput' + id).val().trim();
	
	if (commentFiles.length > 0 || textareaValue.length >= 2) {
        $("#updateCommentButton" + id).prop("disabled", false);
    } else {
        $("#updateCommentButton" + id).prop("disabled", true);
    }
}