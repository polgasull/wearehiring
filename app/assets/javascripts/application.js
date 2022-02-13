//= require rails-ujs
//= require jquery
//= require best_in_place
//= require jquery_ujs
//= require jquery-ui
//= require social-share-button
//= require bulma-extensions
//= require cookies_eu
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