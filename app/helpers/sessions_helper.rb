module SessionsHelper
	include Databasedotcom::Rails::Controller
	
	def sign_in(user)
		cookies.permanent[:remember_token] = user.Remember_Token__c
		current_user = user
	end
	
	def signed_in?
		puts("TEST")
		puts(current_user)
		!current_user.nil?
	end
	
	def current_user=(user)
		@current_user = user
	end
	
	def current_user
		@current_user ||= user_from_remember_token
	end
	
	def sign_out
		current_user = nil
		cookies.delete(:remember_token)
	end
	
	private
	
		def user_from_remember_token
			remember_token = cookies[:remember_token]
			if remember_token
				User__c.query("Remember_Token__c = '#{remember_token}' LIMIT 1")[0]
			end
		end
end
