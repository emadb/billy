module ApplicationHelper
  def status_helper (status)
  	case status
  		when 1 
  			label_class = ''
  			text = 'default'
  		when 2
  			label_class = 'success'
  			text = 'success'
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
