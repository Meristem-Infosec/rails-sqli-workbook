// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
//= require jquery
//= require jquery.turbolinks
//= require jquery.cookie
//= require jquery.ui.all
//= require jquery_ujs
//= require bootstrap-sprockets
//= require popper
//= require custom/buttons

export function jqResetForm(form) {
  document.getElementById('textarea')
    .value = '';
  document.getElementById('query_action').options.length = 0;
}

$('#query_action').change(function () {
  var idToShow = $('#query_action').find(":selected").val();

  $(".selected_content").each(function () {
    $(this).css("display", $(this).is("#" + idToShow) ? 'block' : 'none');
  })
})

window.jqResetForm = jqResetForm;