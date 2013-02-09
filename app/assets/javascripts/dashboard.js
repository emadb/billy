  $(function(){
    var today = new Date();
    if ($('#dashboard').length > 0){
        $('#invoices').load('/dashboard/invoices');
        $('#quarters').load('/dashboard/quarters');
        $('#per_customer').load('/dashboard/per_customer');
        $('#inbound_invoices').load('/dashboard/inbound_invoices');
        $('#job_orders').load('/dashboard/job_orders');
        $('#activities').load('/dashboard/activities?year=' + today.getFullYear() + '&month=' + (today.getMonth() + 1));


        $(document).on('click','#dashboard-activities', function(){
            var month = $('#date_month').val();
            var year = $('#date_year').val();
            $('#activities').load('/dashboard/activities?year=' + year + '&month=' + month);            
        });
    }
  });      