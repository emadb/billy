module ApplicationHelper
  def status_helper (status)
  	case status
  		when Invoice.temporary
  			label_class = 'inverse'
  			text = 'temporanea'
  		when Invoice.active
  			label_class = 'info'
  			text = 'emessa'
  		when 3
  			label_class = 'warning'
  			text = 'warning'
  		when 4
  			label_class = 'info'
  			text = 'info'
  		when 5
  			label_class = 'inverse'
  			text = 'inverse'
  	end
  	
  	raw("<span class=\"label label-#{label_class}\">#{text}</span>")
  end

  def due_date_helper (invoice)
    label_class = ''
    text = nil
    if !invoice.due_date.nil? and invoice.due_date <= DateTime.now && !invoice.is_payed
      label_class = 'important'
      text = 'scaduta'
    end
    raw("<span class=\"label label-#{label_class}\">#{text}</span>")
  end

  def job_order_status_helper (job_order)
    if job_order.percent > 99
      return "progress-danger" 
    end
    if job_order.percent > 85
      return "progress-warning"
    end

  end

end
