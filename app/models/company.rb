class Company < ApplicationRecord
	belongs_to :user
	has_many :jobs , dependent: :destroy
    
  validate :access
	validates :company_name , uniqueness: {scope: :user_id , message: "you already create a one company can't create a another company!"} 

end