class User < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3, case_sensitive: false }
  validates :email, uniqueness: { case_sensitive: false }
  validates :mobile_number, uniqueness: true, length: { is: 10 }, numericality: { only_integer: true }
  validates :password, length: { in: 6..15 }
  validates :type, presence: true

	def generate_password_token!
		self.reset_password_token = generate_token
		self.reset_password_sent_at = Time.now.utc
		save!
	end

	def password_token_valid?
		(self.reset_password_sent_at + 4.hours) > Time.now.utc
	end

	def reset_password!(password)
		self.reset_password_token = nil
		self.password = password
		save!
	end

	private

	def generate_token
		SecureRandom.hex(10)
	end
end
