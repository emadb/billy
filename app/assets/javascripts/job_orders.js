$(function(){
    $('#new-activity').on('click', function(){
        var row = $('table.activities tr:last').clone();
        row.find("input[type=text]").each(function(i, txt){
            var element = $(txt)
            element.val('');
            var pre = parseInt(element.attr('name').match(/\d+/g)[0])
            var newName = element.attr('name').replace(pre.toString(), (pre+1).toString());
            element.attr('name', newName);
        });
        $('table.activities').append(row);
    });

    $(document).on('click', '#remove-activity', function(){
        $(this).next().val('1');
        console.log('removing',$(this).next());
        $(this).parent().parent().hide();
        return false;
    });
})