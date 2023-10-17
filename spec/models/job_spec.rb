require 'rails_helper'

RSpec.describe Job, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  # subject{
  # 	FactoryBot.create(:job)
  # }
  describe 'associations' do
    it { should belong_to(:company)}
    it { should have_many(:job_applications) }
    it { should have_many(:job_seekers).through(:job_applications)}
  end

  describe 'validations' do
  	it { should validate_uniqueness_of(:job_title).scoped_to(:company_id) }
	  it { should validate_presence_of(:required_skills)}
	end

	it { should serialize(:required_skills)}

end
