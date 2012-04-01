module UsersHelper

	# Returns the Gravatar (http://gravatar.com/) for the given user.
	def gravatar_for(user)
		gravatar_id = Digest::MD5::hexdigest(user.Email__c.downcase)
		gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png"
		image_tag(gravatar_url, alt: user.Name, class: "gravatar")
	end

	def has_password?(user, submitted_password)
		user.Encrypted_Password__c == encrypt_password(submitted_password)
	end
	
	def self.authenticate(username, submitted_password)
		user = User__c.query("Username__c = '#{username}'")
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end
		
end
