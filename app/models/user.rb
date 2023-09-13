class User < ApplicationRecord

	validates :name, presence: true, length: { minimum: 3, case_sensitive: false }
	validates :email, uniqueness: { case_sensitive: false }
	validates :mobile_number, uniqueness: true, length: { is: 10 }, numericality: { only_integer: true }
	validates :password, length: { in: 6..15 }
	validates :type, presence: true
end