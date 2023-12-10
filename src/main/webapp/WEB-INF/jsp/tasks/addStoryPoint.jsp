<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"
	integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2"
	crossorigin="anonymous">

<!-- Import jquery cdn -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
	integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
	crossorigin="anonymous">
	
</script>

<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx"
	crossorigin="anonymous">
	
</script>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">
<script src="${pageContext.request.contextPath}/js/validation.js"></script>

<jsp:include page="../common/header.jsp"></jsp:include>
<div class="container mt-2">

	<div class="modal" id="addStoryPointModal" tabindex="-1">
		<div class="modal-dialog  modal-lg">
			<div class="modal-content">
				<div class="modal-header">				
					<h5 class="modal-title">Add Story Points</h5>
					
					<button type="button"
							class="close"
							data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true"
							onclick="window.location.href='${pageContext.request.contextPath}/tasks?pageNo=0'">
								×
							</span>
						</button>
						
				</div>
				<div class="modal-body">
					<div class="col-md-12 mx-auto">
						<form id="addStoryPointForm">
							<div class="row">
								<div class="col-md-12 ">
									<div class="mb-3">
										<label id="lable-storyPointTemplayte "
											for="storyPointTemplate" class="form-label">Story
											Point Template:</label> <select class="form-select"
											name="storyPointConfiguration" id="storyPointCofig"
											onchange="myFunction()">
											<option selected class="pluck-radio-option form-control-sm"
												value="0">Select Story Point</option>
											<option value="fibonacciSeries">Fibonacci Series</option>
											<option value="T-shirtValue">T-Shirt Value</option>
											<option value="NumericValue">Numeric Value</option>
										</select>
									</div>
								</div>

								<div id="NewProduct1"
									style="max-height: 250px; overflow-y: auto;">
									<div id="NewProduct" class="card card-body"
										style="background-color: #eee; display: none;"></div>
								</div>


							</div>
						</form>
					</div>
				</div>
				
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary btn-sm"
						data-bs-dismiss="modal" onclick="window.location.href='${pageContext.request.contextPath}/tasks?pageNo=0'">Cancel</button>
					<button id='storyPoint-add' type="button"
						class="btn btn-primary my-3 btn-sm" onclick="storyPointSubmit()" disabled>Submit</button>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	$(window).on('load', function() {
		$('#addStoryPointModal').modal('show');
	});
</script>

<script
	src="https://cdn.jsdelivr.net/gh/bbbootstrap/libraries@main/choices.min.js"></script>
<script>
	$(document).ready(
			function() {

				var multipleCancelButton = new Choices(
						'.choices-multiple-remove-button', {
							removeItemButton : true,
						});

			});
</script>

<script type="text/javascript">
   
    var btn = 0;
	var inc = 1;
	var rinc = 1;
	 var storyPointData = [];
	 var newStoryPoint;
	 var newrangePoint;
	function myFunction() {
		
		btn = 0;
		inc = 1;
		rinc = 1;
		newStoryPoint;
        newrangePoint;
		
		document.getElementById("NewProduct").innerHTML = "";
		
		let inputs = document.querySelectorAll('input');
		  for (let i = 0; i < inputs.length; i++) {
		    inputs[i].value = '';
		  } 
		
		let selector = document.getElementById("NewProduct");
		selector.style.display = "block";

		let div1 = document.createElement('div');
		div1.setAttribute('class', 'row m-2');

		let div2 = document.createElement('div');
		div2.setAttribute('class', 'col-md-5 test1');

		let checkbox = document.createElement('input');
		checkbox.setAttribute('class', 'form-control');
		checkbox.setAttribute('class', ' form-control storyPoint');
		checkbox.setAttribute('type', 'text');
		checkbox.setAttribute('onkeyup', 'manage(this)');

		var storyId = "storyId" + inc;
		checkbox.setAttribute('id', storyId);
		inc++;
		checkbox.type = "text";
		checkbox.name = "storyPoint1";
		checkbox.placeholder = "storyPoint";

		let div3 = document.createElement('div');
		div3.setAttribute('class', 'col-md-5 test2');
		let checkbox1 = document.createElement('input');
		checkbox1.setAttribute('class', 'form-control');
		checkbox1.setAttribute('class', 'range form-control');
		checkbox1.setAttribute('type', 'text');
		checkbox1.setAttribute('onkeyup', 'manage(this)');


		var rangeId = "rangeId" + rinc;
		checkbox1.setAttribute('id', rangeId);
		checkbox1.setAttribute('onblur', "validation()");

		rinc++;
		checkbox1.type = "text";
		checkbox1.name = "range";
		checkbox1.placeholder = "range";

		let div4 = document.createElement('div');
		div4.setAttribute('class', 'col');

		if(btn==0){
		let aSpan = document.createElement('a');
		aSpan.setAttribute('class', 'add-icon');
		aSpan.setAttribute('id', 'add-icon1');
		aSpan.setAttribute('onClick', 'storyPointInput()');

		let iSpan = document.createElement('i');
		iSpan.setAttribute('class', 'fa fa-plus-circle fs-5');
			
		aSpan.appendChild(iSpan);
		div4.appendChild(aSpan);
		}
		btn++

		div2.appendChild(checkbox);
		div3.appendChild(checkbox1);
		div1.appendChild(div2);
		div1.appendChild(div3);
		div1.appendChild(div4);

		$('#NewProduct').append(div1);

	}
	
function nextInput() {
		
		let selector = document.getElementById("NewProduct");
		selector.style.display = "block";

		let div1 = document.createElement('div');
		div1.setAttribute('class', 'row m-2');

		let div2 = document.createElement('div');
		div2.setAttribute('class', 'col-md-5 test1');

		let checkbox = document.createElement('input');
		checkbox.setAttribute('class', 'form-control');
		checkbox.setAttribute('class', ' form-control storyPoint');
		checkbox.setAttribute('type', 'text');
		checkbox.setAttribute('onkeyup', 'manage(this)');

		var storyId = "storyId" + inc;
		checkbox.setAttribute('id', storyId);
		inc++;
		checkbox.type = "text";
		checkbox.name = "storyPoint1";
		checkbox.placeholder = "storyPoint";

		let div3 = document.createElement('div');
		div3.setAttribute('class', 'col-md-5 test2');
		let checkbox1 = document.createElement('input');
		checkbox1.setAttribute('class', 'form-control');
		checkbox1.setAttribute('class', 'range form-control');
		checkbox1.setAttribute('type', 'text');
		checkbox1.setAttribute('onkeyup', 'manage(this)');


		var rangeId = "rangeId" + rinc;
		checkbox1.setAttribute('id', rangeId);
		checkbox1.setAttribute('onblur', "validation()");

		rinc++;
		checkbox1.type = "text";
		checkbox1.name = "range";
		checkbox1.placeholder = "range";

		let div4 = document.createElement('div');
		div4.setAttribute('class', 'col');

		if(btn==0){
		let aSpan = document.createElement('a');
		aSpan.setAttribute('class', 'add-icon');
		aSpan.setAttribute('id', 'add-icon1');
		aSpan.setAttribute('onClick', 'storyPointInput()');

		let iSpan = document.createElement('i');
		iSpan.setAttribute('class', 'fa fa-plus-circle fs-5');
			
		aSpan.appendChild(iSpan);
		div4.appendChild(aSpan);
		}
		btn++

		div2.appendChild(checkbox);
		div3.appendChild(checkbox1);
		div1.appendChild(div2);
		div1.appendChild(div3);
		div1.appendChild(div4);

		$('#NewProduct').append(div1);

	}
	

	function manage(txt) {

		var bt = document.getElementById('storyPoint-add');
		var ele = document.getElementsByTagName('input');

		for (i = 0; i < ele.length; i++) {

			if (ele[i].type == 'text' && ele[i].value == '') {
				bt.disabled = true;
				return false;
			} else {
				bt.disabled = false;
			}
		}
	}

	 function storyPointInput() {
	        $("#storyPoint-add").attr("disabled", true);

	        let storyInputLength = $('.storyPoint').length;
	        let rangeInputLength = $('.range').length;

	        for (var i = 1; i <= storyInputLength; i++) {
	            let currentStoryPoint = $("#storyId" + i).val();
	            let currentRangePoint = $("#rangeId" + i).val();

	            if (currentStoryPoint.trim() === "" || currentRangePoint.trim() === "") {
	                toastr.error("Cannot add Empty StoryPoints And Range");
	                return false;
	            }

	            if (isNaN(currentRangePoint)) {
	                toastr.error("Enter Numeric value to range");
	                return false;
	            }

	            storyPointData.push({
	                storyPoint: currentStoryPoint,
	                range: currentRangePoint
	            });
	        }

	        nextInput();
	    }

	    function storyPointSubmit() {
	        var storyPointData = [];
	        let userAddButton = document.getElementById('storyPoint-add');

	        let storyInputLength = $('.storyPoint').length;
	        for (var i = 1; i <= storyInputLength; i++) {
	            let currentStoryPoint = $("#storyId" + i).val();
	            let currentRangePoint = $("#rangeId" + i).val();

	            if (currentStoryPoint.trim() === "" || currentRangePoint.trim() === "") {
	                toastr.error("Cannot add Empty StoryPoints And Range");
	                return false;
	            }

	            if (isNaN(currentRangePoint)) {
	                toastr.error("Enter Numeric value to range");
	                return false;
	            }

	            storyPointData.push({
	                storyPoint: currentStoryPoint,
	                range: currentRangePoint
	            });
	        }

	        $.ajax({
	            type: "POST",
	            url: "${pageContext.request.contextPath}/storyPoint/addStoryPoint",
	            contentType: "application/json",
	            data: JSON.stringify(storyPointData),
	            success: function (data) {
	                window.location.href = "${pageContext.request.contextPath}/scrum-master/dashboard"
	            },
	            error: function (xhr, status, error) {
	                toastr.error("Error: " + error);
	            }
	        });
	    }
</script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>