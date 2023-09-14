class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job
  enum status: %i[applied approved rejected]

  validates :user_id, uniqueness: { scope: :job_id, message: "You've already applied for this job" }
  validate :no_duplicate_applications

  private

  def no_duplicate_applications
    return unless JobApplication.exists?(user_id:, job_id:)

    errors.add(:user_id, "You've already applied for this job")
  end
end
