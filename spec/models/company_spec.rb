require 'rails_helper'

RSpec.describe Company, type: :model do

  subject {
 	   FactoryBot.create(:company)
  }
  describe 'validations' do
	  it { should validate_uniqueness_of(:company_name).scoped_to(:job_recruiter_id) }
	  it { should validate_presence_of(:address) }
	  it { should validate_presence_of(:contact) }
	end

  describe 'associations' do
    it { should belong_to(:job_recruiter)}
    it { should have_many(:jobs)}
  end

  # it "is valid with valid attributes" do
  #   expect(subject).to be_valid
  # end

  # it "is not valid without a company name" do
  #   subject.company_name=nil
  #   expect(subject).to_not be_valid
  # end

  # it "is not valid without a  address" do
  #   subject.address=nil
  #   expect(subject).to_not be_valid
  # end 

  # it "is not valid without a contact" do
  #   subject.contact=nil
  #   expect(subject).to_not be_valid
  # end 
end
