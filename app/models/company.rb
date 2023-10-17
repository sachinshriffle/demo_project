class Company < ApplicationRecord
  belongs_to :job_recruiter , class_name: 'JobRecruiter' , foreign_key: 'job_recruiter_id'
  has_many :jobs, dependent: :destroy

  validates :company_name , uniqueness: { scope: :job_recruiter_id}
  validates :address, :contact, presence: true
end
