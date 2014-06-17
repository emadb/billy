$(function (){
  var iva = $('#iva').val();
  iva = parseFloat(iva);
  function updateTotals(){
    var total = 0;
    $('.amount:visible').each(function(i, a){
      var itemValue = $(a).val();
      if (isNumber(itemValue)){
        total = total + parseInt(itemValue);
      }
    });

    $('#taxable-income').text(total.toFixed(2));

    var hasTax = $('#invoice_has_tax').attr('checked')?true:false;
    if (hasTax){
      $('#tax').text((total * iva).toFixed(2));
      $('#total').text(((total * (1 + iva))).toFixed(2));
    } else {
        $('#tax').text(0);
        $('#total').text(total.toFixed(2));
    }
  }

  $('.new-item').click(function(evt){
    evt.preventDefault();
    var nextRow = $('.items').children.length + 1;
    $('.items').append('<tr><td><input type="text" name="invoice[invoice_items_attributes][' + nextRow + ' ][description]" class="col-lg-10 form-control"></td><td><input type="text" name="invoice[invoice_items_attributes][' + nextRow + ' ][amount]" class="amount col-lg-2 form-control"></td></tr>');
  });

  $(document).on('blur','.amount',function(){
      updateTotals();
  });

  $('.remove-item').click(function(){
    $(this).prev("input[type=hidden]").val(1);
    $(this).parent().parent().slideUp('slow');
    updateTotals();
  });

  $('#invoice_has_tax').click(function(){
      updateTotals();
  });
})