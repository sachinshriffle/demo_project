class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable , :omniauthable, omniauth_providers: [:google_oauth2]
  # validates :name, presence: true, length: { minimum: 3, case_sensitive: false }
  # validates :type, presence: true

	# def generate_password_token!
	# 	self.reset_password_token = generate_token
	# 	self.reset_password_sent_at = Time.now.utc
	# 	save!
	# end

	# def password_token_valid?
	# 	(self.reset_password_sent_at + 4.hours) > Time.now.utc
	# end

	# def reset_password!(password)
	# 	self.reset_password_token = nil
	# 	self.password = password
	# 	save!
	# end

	# private

	# def generate_token
	# 	SecureRandom.hex(10)
	# end
	 # def self.from_google(email:)
  #   return nil unless email =~ /@shriffle.com\z/
  #   create_with(name: name).find_or_create_by!(email: email)
  # end
  def self.from_omniauth(auth, role)
    @user=where(uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name # assuming the user model has a name
      user.type = role
    end
    return @user
  end
end
