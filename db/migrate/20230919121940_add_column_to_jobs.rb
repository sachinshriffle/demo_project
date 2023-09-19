class AddColumnToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :required_skills, :string, array: true
  end
end
