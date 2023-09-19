class JobRecruiter < User
  has_one :company, foreign_key: :job_recruiter_id, dependent: :destroy
end
