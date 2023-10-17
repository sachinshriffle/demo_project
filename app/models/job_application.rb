class JobApplication < ApplicationRecord
  belongs_to :job_seeker , class_name: 'JobSeeker' , foreign_key: 'job_seeker_id'
  belongs_to :job
  has_one_attached :resume

  enum status: {"applied" => "applied", "approved" => "approved", "rejected" => "rejected"}
  validates :status , presence: true

  delegate :job_recruiter , :company , to: :job , prefix: true

  validates :job_seeker_id, uniqueness: { scope: :job_id}
  validate :no_duplicate_applications, on: :create

  private

  def no_duplicate_applications
    return unless JobApplication.exists?(job_seeker_id:, job_id:)

    errors.add(:job_seeker_id, "You've already applied for this job")
  end
end
  