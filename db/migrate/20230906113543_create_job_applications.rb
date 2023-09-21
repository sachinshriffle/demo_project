class CreateJobApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :job_applications do |t|
      t.belongs_to :job_seeker 
      t.belongs_to :job
      t.string :status

      t.timestamps
    end
  end
end
