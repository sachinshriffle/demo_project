class Skill < ApplicationRecord
  has_and_belongs_to_many :job_seeker , class_name: 'JobSeeker', foreign_key: 'job_seeker_id'

  validates :skill_name, uniqueness: {case_sensitive: false}
end
