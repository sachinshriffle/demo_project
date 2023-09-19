class CreateJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :skills, :users, id: false do |t|
      t.belongs_to :job_seeker
      t.belongs_to :skills
    end
  end
end
