class User < ApplicationRecord
	has_one :company 
	has_and_belongs_to_many :skills , dependent: :destroy
	has_many :jobs , through: :job_aplications

	validates :name , presence: true , length: {minimum: 3 , case_sensitive: false} 
	validates :email , uniqueness: {case_sensitive: false}
	validates :mobile_number, uniqueness: true , length: {is: 10}, numericality: {only_integer: true}
end