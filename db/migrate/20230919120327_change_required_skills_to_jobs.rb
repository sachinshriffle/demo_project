class ChangeRequiredSkillsToJobs < ActiveRecord::Migration[7.0]
  def change
  	remove_column :jobs, :required_skills
  end
end
