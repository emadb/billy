$(function(){
  $('.isdate').datepicker({format: 'dd-mm-yyyy'});

  $(document).on('click', '#save-form', function(){
      document.forms[0].submit();
    });
})

function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}