$(function(){

  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });
  
  var dp = $('.isdate1');
  dp.datepicker({format: 'dd/mm/yyyy'});
  dp.on('changeDate', function(ev){
    if (dp.attr('id') == ev.target.id){
      dp.val(ev.target.value);
    }
  });

  var dp2 = $('.isdate2');
  dp2.datepicker({format: 'dd/mm/yyyy'});
  dp2.on('changeDate', function(ev){
    dp2.val(ev.target.value);
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
  $('.dashboard-tabs a').click(function (e) {
    e.preventDefault()
    $(this).tab('show')
  });
  $('input[type=file]').bootstrapFileInput();
})

function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}