$(document).ready(function() {
  $(window).scroll(function () {
    var url;
    url = $('#pagination a').attr('href');
    if (url && $(window).scrollTop() + $(window).height() > $(document).height() - 700) {
      $('#pagination').text("Loading...");
      $('#pagination-loader').show();
      setTimeout(function () {
        return $.getScript(url);
      }, 1000)
    }
  });
});
