  $(function(){
    if ($('#dashboard').length > 0){
        $('#invoices').load('/dashboard/invoices');
        $('#quarters').load('/dashboard/quarters');
        $('#per_customer').load('/dashboard/per_customer');
        $('#inbound_invoices').load('/dashboard/inbound_invoices');
        $('#job_orders').load('/dashboard/job_orders');
        //$('#activities').load('/dashboard/activities');
    }
  });      