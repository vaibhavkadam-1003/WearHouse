$(document).ready(function(){
	$('#filter').on('change', function() {
  		const selectedOption = $(this).val();
  		filterData(selectedOption);
	});
	if (window.history && window.history.pushState) {
   let loc =  window.history.pushState('forward', null);
    $(window).on('popstate', function() {
          window.location.reload();
    });
  }
})
