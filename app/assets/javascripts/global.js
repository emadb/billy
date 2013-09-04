$(function(){
  var dp = $('.isdate');

  dp.datepicker({format: 'dd-mm-yyyy'});
  dp.on('changeDate', function(ev){
    console.log('changed', dp.val(), ev.target.value );
    dp.val(ev.target.value);
  });
  
  $(document).on('click', '#save-form', function(){
      document.forms[0].submit();
    });

  $(document).on('click', '.drop-box', function(evt){
    evt.preventDefault();
    var url = $(this).attr('href')
    var tr = $(this).parent().parent();
    tr.css('background-color','#ABFFCB');
    $.get(url, function(result){
        tr.css('background-color','#FFFFFF');
    })
  });
})

function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}