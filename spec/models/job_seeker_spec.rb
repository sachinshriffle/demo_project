require 'rails_helper'

RSpec.describe JobSeeker, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  # subject{
  # 	FactoryBot.create(:job_seeker)
  # }
    describe 'associations' do
    it { should have_and_belong_to_many(:skills).join_table(:job_seekers_skills)}
    it { should have_many(:job_applications) }
    it { should have_many(:jobs).through(:job_applications)}
  end
end
