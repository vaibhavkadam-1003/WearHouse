$(document).ready(function() {
	    filterData();

	    $("#filterTaskType, #filterPriority").on("change", function() {
	        filterData();
	    });

	    function filterData() {
	        var selectedTaskType = $("#filterTaskType").val();
	        var selectedPriority = $("#filterPriority").val();

	        $(".list-group-item-filter").show();

	        if (selectedTaskType) {
	            $(".list-group-item-filter").not('[data-taskType="' + selectedTaskType + '"]').hide();
	        }

	        if (selectedPriority) {
	            $(".list-group-item-filter").not('[data-priority="' + selectedPriority + '"]').hide();
	        }
	    }
	});
	
var currentlyVisibleDiv = null; 

function toggleCollapsible(element) {
	 var tasks = element.nextElementSibling;
        if (tasks.style.display === "block") {
            tasks.style.display = "none";
            element.classList.remove("active");
        } else {
            if (currentlyVisibleDiv) {
                currentlyVisibleDiv.nextElementSibling.style.display = "none";
                currentlyVisibleDiv.classList.remove("active");
            }
            
            tasks.style.display = "block";
            element.classList.add("active");
            currentlyVisibleDiv = element;
        }
}