class UsersController < ApplicationController
	include Databasedotcom::Rails::Controller
	
	def show
		@user = User__c.find(params[:id])
	end
	
	def new
		@user = User__c.new
		password = '';
		password_confirmation = '';
	end
	
	def create
		user = params[:user__c]
		password = user["password"]
		if password == user["password_confirmation"]
			@user = User__c.new
			@user.Name = user["Name"]
			@user.Username__c = user["Username__c"]
			@user.Email__c = user["Email__c"]
			salt = make_salt(password)
			@user.Salt__c = salt
			@user.Encrypted_Password__c = encrypt(salt, password)
			@user.OwnerId = '005d0000000yoahAAA'
			if @user.save
				flash[:success] = "El usuario ha sido creado con exito!"
				redirect_to "/users/#{@user.Id}"
			else
				render 'new'
			end
		else
			render 'new'
		end
	end
	
	private
		
		def encrypt(salt, string)
			secure_hash("#{salt}--#{string}")
		end
		
		def make_salt(password)
			secure_hash("#{Time.now.utc}--#{password}")
		end
		
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end
