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

end
