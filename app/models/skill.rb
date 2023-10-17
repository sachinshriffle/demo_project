class Skill < ApplicationRecord
  has_and_belongs_to_many :job_seekers , join_table: "job_seekers_skills"

  validates :skill_name, uniqueness: true , presence: true
end
