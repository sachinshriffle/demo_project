class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.string :job_title
      t.string :required_skills
      t.belongs_to :company

      t.timestamps
    end
  end
end
