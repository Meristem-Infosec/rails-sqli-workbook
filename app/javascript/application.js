// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
//= require jquery
//= require jquery.turbolinks
//= require jquery.cookie
//= require jquery.ui.all
//= require jquery_ujs
//= require bootstrap-sprockets

function jqResetForm() {
  document.getElementById('textarea')
    .value = '';
  var dropdown = document.getElementById('query_action')
  dropdown.selectedIndex = 0;
}

jQuery(function () {
  $('#query_action')
    .on('change', function () {
      var idToShow = $('#query_action').find(":selected").val() || "Choose a method";

      $(".selected_content").each(function () {
        $(this).css("display", $(this).is("#" + idToShow) ? 'block' : 'none');
      })
    })
    .on('change', function () { });
})

window.jqResetForm = jqResetForm;