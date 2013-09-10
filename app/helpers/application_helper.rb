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

  def job_order_cost_status_helper(job)
    begin
      delta = job.total_estimated_cost - job.total_consumed_cost
      delta_perc = (delta / job.total_estimated_cost * 100).ceil
      
      label_class = 'info'
      if delta_perc.abs > 80.0
        label_class = 'warning'
      end

      if delta_perc.abs > 100
        label_class = 'important'
      end

      return raw("<span class=\"label label-#{label_class}\">#{delta.abs}</span>")
    rescue
      return raw("<span class=\"label\">Na</span>")
    end
  end

end
