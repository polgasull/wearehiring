$(document).ready(function(){function e(e){for(var t,n=e.target.files,a=0;t=n[a];a++)if(t.type.match("image.*")){var i=new FileReader;i.onload=function(e){return function(t){var n=document.createElement("div"),a=document.createElement("div");n.classList.add("rounded-image","size-150","mauto"),n.innerHTML=['<img class="image-preview-thumb border-light" src="',t.target.result,'" title="',escape(e.name),'"/>'].join(""),window.location.href.indexOf("users")>-1&&(a.innerHTML=['<button class="button is-info mt3" type="submit">Guardar</button>']),document.getElementById("list").replaceWith(n,a)}}(t),i.readAsDataURL(t)}}var t=document.querySelector(".load-image");t&&t.addEventListener("change",e,!1)});