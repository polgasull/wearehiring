$(document).ready(function () {

  var instrumentImage = document.querySelector('.load-image');

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
          var newDiv = document.createElement('div');
          var submitButton = document.createElement('div')
          newDiv.classList.add('rounded-image', 'size-150', 'mauto');
          newDiv.innerHTML = ['<img class="image-preview-thumb border-light" src="', e.target.result,
            '" title="', escape(theFile.name), '"/>'
          ].join('');
          submitButton.innerHTML = ['<button class="button is-info mt3" type="submit">Guardar</button>']
          document.getElementById('list').replaceWith(newDiv, submitButton);
        };
      })(f);
      // Read in the image file as a data URL.
      reader.readAsDataURL(f);
    }
  }

  if (instrumentImage) {
    instrumentImage.addEventListener('change', handleFileSelect, false);
  }
  
});