// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require social-share-button
//= require_tree ./global

SITENAME = {
  common: {
    init: function() {
      $('.notification').fadeIn().delay(4000).fadeOut();
    }
  },

};
UTIL = {
  exec: function( controller, action ) {
    var ns = SITENAME,
    action = ( action === undefined ) ? "init" : action;
    if ( controller !== "" && ns[controller] && typeof ns[controller][action] == "function" ) {
       ns[controller][action]();
     }
   },
   init: function() {
     var body = document.body, controller = body.getAttribute( "data-controller" ), action = body.getAttribute( "data-action" );
     UTIL.exec( "common" );
     UTIL.exec( controller );
     UTIL.exec( controller, action );
   }
 };
 $( document ).ready( UTIL.init )