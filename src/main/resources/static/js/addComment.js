
function deleteCommentFile(id,commentId){
	let taskId = $('input[name="taskId"]').val();
	let contextPath = $("#contextPathInput").val();
	$.ajax( {
         url: contextPath+'/comment/delete/file/' + id,
		 type: 'GET',
        data: {
            id: id
        },
        success: function ( data ) {
			  if ( data === 'File deleted' ) {
				 let itemToDelete = document.getElementById( 'cmdFileWrapper' + id );
	                itemToDelete.remove();
				getAllFiles(commentId,taskId);
				 
			 }
        }
    } );
}

function getAllFiles(commentId, taskId){
	let contextPath = $("#contextPathInput").val();
	 $.ajax( {
        type: 'GET',
        url: contextPath+'/comment/attachment/' + commentId + '/' + taskId,
		data: {
			commentId:commentId,
			taskId: taskId
		},
        success: function ( data ) {
						$('#img_preview1' + commentId).html("");
						if(data.length != 0){
								for(var item  of data){
	
								let attachmentsData = `	<div
																					class="img-thumbs-wrapper  d-flex justify-content-start align-items-center"
																					id="img_preview1">
																								<a id="cmdFileWrapper${item.id}">
																									<div class="img-preview-wrapper" id="">
																									<a href="${contextPath}/image/${item.docUrl}" class="img-preview-link">
																										<img src="${contextPath}/image/${item.docUrl}"
																											data-mfp-src="${contextPath}/image/${item.docUrl}"
																											class="img-preview-thumb" id="myimg"> 
																									</a>
																											<a class="text-success"> 
																											<!-- ------------------------------------------------------------delete comment attachment button----------------------------------------- -->
																											<i class="fa-solid fa-trash-can close-btn" style="cursor:pointer"
																												id="deleteAttchmenetBtn"
																												onclick="deleteCommentFile(${item.id},${commentId})"></i>
																										</a> <a href="${contextPath}/image/${item.docUrl}" download>
																											<i class="fa-solid fa-file-arrow-down downloadBtn"></i></a>
																										<p>file.extention</p>
																									</div>
																								</a>
																						</div>`
								
								
								let parentDiv = document.getElementById('img_preview1' + commentId);
								let newElement = document.createElement('div');
								newElement.innerHTML = attachmentsData;
								parentDiv.appendChild(newElement);
							}
							$('.img-preview-link').magnificPopup({
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
						    });
						}else{
							let attachmentsData = `<div><h6>No Attachment Available</h6></div>`;
							let parentDiv = document.getElementById('img_preview1' + commentId);
								let newElement = document.createElement('div');
								newElement.innerHTML = attachmentsData;
								parentDiv.appendChild(newElement);
						}
		}
	});
}