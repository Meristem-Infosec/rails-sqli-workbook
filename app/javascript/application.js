// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbolinks

function jqResetForm() {
  document.getElementById('textarea')
    .value = '';
  var dropdown = document.getElementById('query_action')
  dropdown.selectedIndex = 0;
}

function showContent() {
  var idToShow = $('#query_action').find(":selected").val() || "Choose a method";

  $(".selected_content").each(function () {
    $(this).css("display", $(this).is("#" + idToShow) ? 'block' : 'none');
  })
}

window.showContent = showContent;
window.jqResetForm = jqResetForm;