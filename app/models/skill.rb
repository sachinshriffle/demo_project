class Skill < ApplicationRecord
	has_and_belongs_to_many :users

	validates :required_skills , presence: true
end
