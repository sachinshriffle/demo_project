class Company < ApplicationRecord
  belongs_to :job_recruiter , class_name: 'JobRecruiter' , foreign_key: 'job_recruiter_id'
  has_many :jobs, dependent: :destroy

  validates :company_name , uniqueness: { scope: :job_recruiter_id, case_sensitive: false, message: "You've already created a company. You can't create another one" }
  validates :address, :contact, presence: true
end
