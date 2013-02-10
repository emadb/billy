$(function(){
  var dp = $('.isdate');

  dp.datepicker({format: 'dd-mm-yyyy'});
  // dp.on('changeDate', function(ev){
  //      dp.val(ev.target.value);
  // });
  
  $(document).on('click', '#save-form', function(){
      document.forms[0].submit();
    });
})

function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}