require 'rails_helper'

RSpec.describe Skill, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  subject{
  	FactoryBot.create(:skill)
  }
  # describe 'associations' do
    it { should have_and_belong_to_many(:job_seekers).join_table(:job_seekers_skills)}
  # end
    it {should validate_uniqueness_of(:skill_name)}

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

end
