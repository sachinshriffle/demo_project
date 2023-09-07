class User < ApplicationRecord
	has_one :company 
	has_and_belongs_to_many :skills , dependent: :destroy
	has_many :job_applications

	validates :name , presence: true , length: {minimum: 3 , case_sensitive: false} 
	validates :email , uniqueness: {case_sensitive: false}
	validates :mobile_number, uniqueness: true , length: {is: 10}, numericality: {only_integer: true}
	validates	:type, presence: true
	validates :password , length: {in: 6..10}
end