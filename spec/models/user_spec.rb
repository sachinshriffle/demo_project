require 'rails_helper'

RSpec.describe User, type: :model do
	# subject { User.create(name: "Text",type: "JobRecruiter", email: "text@sample.com", encrypted_password: "123456")}
 # subject {
 # 	   FactoryBot.create(:user)
 # }
  it { should validate_presence_of :name  }
  it { should validate_length_of(:name).is_at_least(3)}
  it { should validate_presence_of :type  }
  it { should validate_presence_of :email  }
  # it "is valid with valid attributes" do
  #   expect(subject).to be_valid
  # end

  # it "is not valid without a name" do
  #   subject.name=nil
  #   expect(subject).to_not be_valid
  # end

  # it "is not valid without a type" do
  #   subject.type=nil
  #   expect(subject).to_not be_valid
  # end 

  # it "is not valid without a email" do
  #   subject.email=nil
  #   expect(subject).to_not be_valid
  # end  

  # it "is not valid without a password" do
  #   subject.password=nil
  #   expect(subject).to_not be_valid
  # end 

  describe 'validations' do
    describe 'it validates name' do
      it { is_expected.to validate_presence_of(:name) }
    end 

    describe 'it validates email' do
      it { is_expected.to validate_presence_of(:email) }
    end  

    describe 'it validates type' do
      it { is_expected.to validate_presence_of(:type) }
    end 

    describe 'it validates password' do
      it { is_expected.to validate_presence_of(:password) }
    end 
  end
end
