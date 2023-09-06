class Job < ApplicationRecord
	belongs_to :company
	has_many :job_seekers , through: :job_applications

	validates :job_title , uniqueness: {scope: :company_id , message: "job title for this company is already created"}
end