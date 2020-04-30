$(document).ready(function () {

  var instrumentImage = document.querySelector('.job-avatar');

  function handleFileSelect(evt) {
    var files = evt.target.files; // FileList object

    // Loop through the FileList and render image files as thumbnails.
    for (var i = 0, f; f = files[i]; i++) {

      // Only process image files.
      if (!f.type.match('image.*')) {
        continue;
      }

      var reader = new FileReader();

      // Closure to capture the file information.
      reader.onload = (function(theFile) {
        return function(e) {
          // Render thumbnail.
          var span = document.createElement('span');
          span.innerHTML = ['<img class="avatar-preview-thumb border-light" src="', e.target.result,
            '" title="', escape(theFile.name), '"/>'
          ].join('');
          document.getElementById('list').insertBefore(span, null);
        };
      })(f);
      // Read in the image file as a data URL.
      reader.readAsDataURL(f);
    }
  }

  if (instrumentImage) {
    instrumentImage.addEventListener('change', handleFileSelect, false);
  }

  $(document).on("change", "#salarySwitch", function () {
    if ($('#salarySwitch').is(":checked")) {
      $('#job_salary_from, #job_salary_to').prop("disabled", true);
      $('#job_salary_from, #job_salary_to').addClass("is-disabled");
    } else {
      $('#job_salary_from, #job_salary_to').prop("disabled", false);
      $('#job_salary_from, #job_salary_to').removeClass("is-disabled");
    }
  });

});
