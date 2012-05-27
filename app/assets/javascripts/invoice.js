$(function (){
  $('.new-item').click(function(evt){
    evt.preventDefault();
    var nextRow = $('.items').children.length + 1;
    $('.items').append('<tr><td><input type="text" name="invoice[invoice_items_attributes][' + nextRow + ' ][description]"></td><td><input type="text" name="invoice[invoice_items_attributes][' + nextRow + ' ][amount]"></td></tr>');
  });

  $('.amount').blur(function(){
    var total = 0;
    $('.amount').each(function(i, a){
      total = total + parseInt($(a).val());
    });
    
    $('#taxable-income').text(total);
  });

  $('.remove-item').click(function(){
    $(this).prev("input[type=text]").val(1);
    //$(this).parent().parent().slideUp();

  });
})