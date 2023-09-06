class CreateJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :skills, :users, id: false do |t|
      t.belongs_to :users
      t.belongs_to :skills
    end
  end
end
