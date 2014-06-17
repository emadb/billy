$(function(){
  $('.delete').on('click', function(){
    if(confirm("Are you sure?")){
      var row = $(this).closest("tr").get(0);
      $.post(this.href, { _method:'delete' }, function(result){
        $(row).hide();  
      });
    }
    return false;
  });
})