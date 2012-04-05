module ApplicationHelper

	#Returns the full title on a per-page basis.
	def full_title(page_title)
		base_title = "Ganagol"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
	
	def user__cs_path(format)
		users_path
	end
	
	def user__c_path(user, format)
		"#{users_path}/#{user.Id}"
	end
	
	def user__c_path(user)
		"#{users_path}/#{user.Id}"
	end
end
