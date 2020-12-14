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
          var lastItem = document.querySelector(".rounded-image:last-child");
          var newDiv = document.createElement('div');
          newDiv.classList.add('rounded-image', 'size-150');
          newDiv.innerHTML = ['<img class="image-preview-thumb border-light" src="', e.target.result,
            '" title="', escape(theFile.name), '"/>'
          ].join('');
          if (lastItem) {
            document.getElementById('list').replaceChild(newDiv, lastItem);
          } else {
            document.getElementById('list').insertBefore(newDiv, null);
          }
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