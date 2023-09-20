class CreateJoinTableJobSeekersSkills < ActiveRecord::Migration[7.0]
  def change
  	create_join_table :job_seekers ,:skills, id: false do |t|
		  t.index [:job_seeker_id, :skill_id]
		  t.index [:skill_id, :job_seeker_id]
		end
  end
end
