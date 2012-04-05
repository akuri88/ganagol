class UsersController < ApplicationController
	include Databasedotcom::Rails::Controller
	before_filter :signed_in_user
	before_filter :correct_user,	only: [:edit, :update]
	before_filter :admin_user,		only: :destroy
	
	def index
		@users = User__c.all
	end
	
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
			@user.Remember_Token__c = SecureRandom.urlsafe_base64
			@user.Admin__c = false
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
	
	def edit
	end
	
	def update
		if @user.update_attributes User__c.coerce_params(params[:user__c])
			flash[:success] = "Perfil actualizado"
			sign_in @user
			redirect_to @user
		else
			render 'edit'
		end
	end
	
	def destroy
		User__c.find(params[:id]).delete
		flash[:success] = "Usuario eliminado."
		redirect_to users_path
	end
	
	private
	
		def signed_in_user
			unless signed_in?
				store_location
				redirect_to root_path, notice: "Favor de iniciar sesion."
			end
		end
		
		def correct_user
			@user = User__c.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end
		
		def encrypt(salt, string)
			secure_hash("#{salt}--#{string}")
		end
		
		def make_salt(password)
			secure_hash("#{Time.now.utc}--#{password}")
		end
		
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
		
		def admin_user
			redirect_to(root_path) unless current_user.Admin__c  == true
		end
end
