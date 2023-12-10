	function sprintFilter() {
        var input, filter, cards, card, title, i;
        input = document.getElementById("myFilter");
        filter = input.value.toUpperCase();
        cards = document.getElementsByClassName("scrum-user-card");

        for (i = 0; i < cards.length; i++) {
            card = cards[i];
            title = card.getElementsByClassName("card-title")[0];

            if (title.innerText.toUpperCase().indexOf(filter) > -1) {
                card.style.display = "";
            } else {
                card.style.display = "none";
            }
        }
	}