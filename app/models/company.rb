class Company < ApplicationRecord
	belongs_to :user
	has_many :jobs , dependent: :destroy
	
	validates :company_name, uniqueness: { scope: :user_id, message: "You've already created a company. You can't create another one"}
	validates :address , :contact , presence: true 
end