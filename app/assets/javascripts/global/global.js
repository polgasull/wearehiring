$(document).ready(function () {
  if ($("#profileDropdown").length > 0) { 
    let dropdown = document.querySelector('.dropdown');
    dropdown.addEventListener('click', function(event) {
        event.stopPropagation();
        dropdown.classList.toggle('is-active');
    });  
  }
});