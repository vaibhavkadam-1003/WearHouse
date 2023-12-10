$(document).ready(function() {
	$('#searchInput').on('keyup', function() {
		var searchText = $(this).val().toLowerCase();

		$('.scrum-user-card').each(function() {
			var cardTitle = $(this).find('.card-title').text().toLowerCase();

			if (cardTitle.includes(searchText)) {
				$(this).show();
			} else {
				$(this).hide();
			}
		});
	});
});

function deleteTeam(teamId){
	let contextPath = $("#contextPathInput").val();
	$.ajax( {
         url: contextPath+'/scrums/delete/' + teamId,
		 type: 'GET',
        data: {
            teamId: teamId
        },
        success: function ( data ) {
			 let scrumTeam = document.getElementById("scrumTeam"+teamId);
			 scrumTeam.remove();
			 toastr.success('Scrum Team Deleted', '', { timeOut: 1000 });
        },
        error: function ( xhr, status, error ) {
            console.log( xhr, status, error );
        }
    } );
}