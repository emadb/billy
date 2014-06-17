module ApplicationHelper
  def status_helper (status)
  	case status
  		when Invoice.temporary
  			label_class = 'default'
  			text = t('helpers.invoice_status.draft')
  		when Invoice.active
  			label_class = 'info'
  			text = t('helpers.invoice_status.active')
  		when 3
  			label_class = 'warning'
  			text = t('helpers.invoice_status.warning')
  		when 4
  			label_class = 'info'
  			text = t('helpers.invoice_status.info')
  		when 5
  			label_class = 'inverse'
  			text = t('helpers.invoice_status.inverse')
  	end
  	
  	raw("<span class=\"label fixed-size label-#{label_class}\">#{text}</span>")
  end

  def due_date_helper (invoice)
    label_class = ''
    text = nil
    if !invoice.due_date.nil? and invoice.due_date <= DateTime.now && !invoice.is_payed
      label_class = 'danger'
      text = t('helpers.dates.expired')
    end
    raw("<span class=\"label label-#{label_class}\">#{text}</span>")
  end

  def job_order_status_helper (job_order)
    if job_order.percent > 99
      return "progress-bar-danger" 
    end
    if job_order.percent > 85
      return "progress-bar-warning"
    end
  end

  def job_order_cost_status_helper(job)

    begin
      if job.a_project?
        delta = job.price - job.total_consumed_cost
        delta_perc = (delta / job.price * 100).round(2)
        
        label_class = 'info'
        if delta_perc.abs > 80.0
          label_class = 'warning'
        end

        if delta_perc.abs > 100
          label_class = 'important'
        end
        return "#{job.price} - #{job.total_consumed_cost} = #{delta}"
      else
        delta = (job.total_executed_hours * job.hourly_rate) - job.total_consumed_cost
        return "#{delta.round(2)}"
      end

    rescue
      return "Na"
    end
  end

end
