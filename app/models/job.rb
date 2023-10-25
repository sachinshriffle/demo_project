class Job < ApplicationRecord
  serialize :required_skills, Array
  belongs_to :company
  # delegate :job_recruiter , to: :company , prefix: true

  has_many :job_applications, dependent: :destroy
  has_many :job_seekers, through: :job_applications,dependent: :destroy

  validates :job_title, uniqueness: { scope: :company_id}, presence: true
  validates :required_skills, presence: true
end
