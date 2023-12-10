let imgUpload = document.getElementById('upload_imgs')
let imgPreview = document.getElementById('img_preview')
imgUpload.addEventListener('change', previewImgs, false);

let browseFileArray = [];
let allBrowseFiles;
let allFilesIds = 0;
let allFilesIds1=0;

function previewImgs(event) {
	
	let browseFile = imgUpload.files;
	for(let i = 0; i < browseFile.length; i++){
		
		let fileTypeAccepted = attachmentTypeValidation(browseFile[i], i);
		
		if(fileTypeAccepted){
			browseFileArray.push(browseFile[i]);
		}	
	}
	allFilesIds1 = 0;
	 const dataTransfer = new DataTransfer();
	 browseFileArray.forEach(file => {
		 dataTransfer.items.add(file);
		 file.id = allFilesIds1;
		 allFilesIds1++;	
	 });
	 
	 imgUpload.files = dataTransfer.files;
	 
	  totalFiles = imgUpload.files.length;
	
	if (!!totalFiles) {
		imgPreview.classList.remove('quote-imgs-thumbs--hidden');
	}
	$('#img_preview').html("");
	for (var i = 0; i < totalFiles; i++) {
		imgWrapper = document.createElement("div");
		imgWrapper.classList.add('img-preview-wrapper');
		img = document.createElement('img');
		img.src = URL.createObjectURL(event.target.files[i]);
		img.classList.add('img-preview-thumb');
		closeBtn = document.createElement("i");
		closeBtn.id = event.target.files[i].id;
		closeBtn.classList.add('fa-solid', 'fa-trash-can', 'close-btn');
		downloadBtn = document.createElement("i");
		downloadBtn.classList.add('fa-solid', 'fa-file-arrow-down', 'downloadBtn');
		var files = event.target.files;
		var fileName = files[i].name;
		const textNode = document.createElement("p");
		textNode.innerText = fileName
		imgWrapper.appendChild(img);
		imgWrapper.appendChild(closeBtn);
		imgWrapper.appendChild(downloadBtn);
		imgWrapper.appendChild(textNode);
		imgPreview.appendChild(imgWrapper);
		closeBtn.addEventListener('click', (event) => {
			$(event.target).parent().remove();
			deleteFromBrowseFileInput(event.target.id);
		});
	}
	imgUpload.value = '';
}

	$('#add').on('click',function(){
		if(allBrowseFiles === undefined || allBrowseFiles.lenght !== browseFileArray.length){
			let dataTransfer = new DataTransfer();
		    for (let file of browseFileArray) {
		      dataTransfer.items.add(file);
		    }
			
			allBrowseFiles = dataTransfer.files;
		}
		imgUpload.files = allBrowseFiles;
		browseFileArray = [];
	})
	
	function deleteFromBrowseFileInput(id){
		let browsedFileId = parseInt(id);
		let index;
		for (let i=0; i < browseFileArray.length; i++) {
			if(browseFileArray[i].id == browsedFileId){
				index = i;
			}
		}
	
		browseFileArray.splice(index,1);
		let dataTransfer = new DataTransfer();
	    for (let file of browseFileArray) {
	      dataTransfer.items.add(file);
	    }
		
		allBrowseFiles = dataTransfer.files;
	}

$(document).ready(function() {

	let taskAddInputs = document.querySelectorAll('#title');
	let taskAddButton = document.getElementById('add');

	$('#addTaskModal').modal({backdrop: 'static', keyboard: false}, 'show');
		
		$('#lastDate').on('change', function(){
			$('#end_date_validation').text("");
		})

	taskAddInputs.forEach((input) => {
		input.addEventListener('input', () => {
			let titleCheck = $('#title').val().length >= 2 ? true : false;
			if ((titleCheck && $('#description').val().length < 2048)) {
				taskAddButton.disabled = false;
			} else {
				taskAddButton.disabled = true;
			}
		})
	})
	
	let form = document.getElementById("addTaskForm");
	form.addEventListener("submit", function() {
			taskAddButton.disabled = true;
	});
	
	$('#description').on('input', () => {
		if($('#description').val().length < 5000)
			$('#description-validation-id').text("");
		else
			$('#description-validation-id').text("Description should be maximum 5000 charaters");
	})
	
});

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

function showStoryTable(){
	let storyPointTable = document.getElementById('story-point-table');
	storyPointTable.style.display="block";
	
}
function hideStoryPointTable(){
	document.getElementById('story-point-table').style.display="none";
}