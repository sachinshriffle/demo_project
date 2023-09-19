class JobSeeker < User
  has_and_belongs_to_many :skills, foreign_key: :job_seeker_id, dependent: :destroy
  has_many :job_applications, foreign_key: :job_seeker_id, dependent: :destroy
  has_many :jobs, through: :job_applications, foreign_key: :job_seeker_id, dependent: :destroy
end
