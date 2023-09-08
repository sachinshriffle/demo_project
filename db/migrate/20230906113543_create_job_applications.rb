class CreateJobApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :job_applications do |t|
    	t.belongs_to :user
    	t.belongs_to :job
    	t.integer :status

      t.timestamps
    end
  end
end