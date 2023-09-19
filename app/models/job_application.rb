class JobApplication < ApplicationRecord
  belongs_to :job_seeker , class_name: 'JobSeeker' , foreign_key: 'job_seeker_id'
  belongs_to :job
  enum status: [:applied, :approved, :rejected]
  has_one_attached :resume

  validates :user_id, uniqueness: { scope: :job_id, message: "You've already applied for this job" }
  validate :no_duplicate_applications

  private

  def no_duplicate_applications
    return unless JobApplication.exists?(user_id:, job_id:)

    errors.add(:user_id, "You've already applied for this job")
  end
end
