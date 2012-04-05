class SessionsController < ApplicationController
	include Databasedotcom::Rails::Controller

	def new
	end
	
	def create
		user = User__c.query("Username__c = '#{params[:session][:username]}' LIMIT 1")[0]
		if user && authenticate(user, params[:session][:password])
			sign_in user
			redirect_back_or "/users/#{user.Id}"
		else
			flash.now[:error] = 'Usuario y/o contrasena incorrectas'
			render 'new'
		end
	end
	
	def destroy
		sign_out
		redirect_to root_path
	end
	
	private
		
		def has_password?(user, submitted_password)
			user.Encrypted_Password__c == encrypt(user.Salt__c, submitted_password)
		end
	
		def authenticate(user, submitted_password)
			return user if has_password?(user, submitted_password)
		end
		
		def encrypt(salt, string)
			secure_hash("#{salt}--#{string}")
		end
		
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end
