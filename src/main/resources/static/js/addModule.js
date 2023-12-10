$(document).ready(function() {

$('#addModuleModel').modal({backdrop: 'static', keyboard: false}, 'show');

let id=document.getElementById("title") 
let btn=document.getElementById("user-add")

id.addEventListener("input", (e)=>{
	if(e.target.value.length>=2){		
		btn.disabled = false;
	}else{
		btn.disabled = true;
	}
});
});