$(function(){
  $('.isdate').datepicker({format: 'dd-mm-yyyy'});
})

function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}