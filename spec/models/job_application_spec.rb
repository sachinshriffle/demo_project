require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  # subject{
  # 	FactoryBot.create(:job_application)
  # }

#   #associations
  it { should belong_to(:job_seeker)}
  it { should belong_to(:job)}
  it { should have_one_attached(:resume)}

#   #validation
  it { should validate_uniqueness_of(:job_seeker_id).scoped_to(:job_id) }
  it { should define_enum_for(:status).backed_by_column_of_type(:string) }

  #  it "is valid with valid attributes" do
  #   expect(subject).to be_valid
  # end

  # it "is not valid without a status" do
  #   subject.status=nil
  #   expect(subject).to_not be_valid
  # end
end
