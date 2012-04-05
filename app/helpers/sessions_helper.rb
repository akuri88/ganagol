module SessionsHelper
	include Databasedotcom::Rails::Controller
	
	def sign_in(user)
		cookies.permanent[:remember_token] = user.Remember_Token__c
		current_user = user
	end
	
	def signed_in?
		puts(current_user)
		!current_user.nil?
	end
	
	def current_user=(user)
		@current_user = user
	end
	
	def current_user
		@current_user ||= user_from_remember_token
	end
	
	def current_user?(user)
		user == current_user
	end
	
	def sign_out
		current_user = nil
		cookies.delete(:remember_token)
	end
	
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		clear_return_to
	end
	
	def store_location
		session[:return_to] = request.fullpath
	end
	
	private
	
		def user_from_remember_token
			remember_token = cookies[:remember_token]
			if remember_token
				User__c.query("Remember_Token__c = '#{remember_token}' LIMIT 1")[0]
			end
		end
		
		def clear_return_to
			session.delete(:return_to)
		end
end
