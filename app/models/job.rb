class Job < ApplicationRecord
	serialize :required_skills, Array
  belongs_to :company
  delegate :job_recruiter_id , to: :company

  has_many :job_applications, dependent: :destroy
  has_many :job_seekers, through: :job_applications,dependent: :destroy

  validates :job_title, uniqueness: { scope: :company_id, message: 'job title for this company is already created' }
  validates :required_skills, presence: true
end
