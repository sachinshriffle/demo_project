class JobApplication < ApplicationRecord
	belongs_to :user
	belongs_to :job
	enum status: [:applied, :approved, :rejected]
  
	validates :user_id, uniqueness: { scope: :job_id, message: "You've already applied for this job" }
	validate :no_duplicate_applications , on: :create
  
	private
	
	def no_duplicate_applications
	  if JobApplication.exists?(user_id: user_id, job_id: job_id)
		  errors.add(:user_id, "You've already applied for this job")
	  end
	end
end