$(function(){
  $('.date').datepicker({format: 'dd-mm-yyyy'}).on('changeDate', function(ev){console.log('change', ev);});
})

function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}