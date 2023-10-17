require 'rails_helper'

RSpec.describe JobRecruiter, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
   describe 'associations' do
    it { should have_one(:company).without_validating_presence }
  end

  # subject {
 	#   FactoryBot.create(:job_recruiter)
  # }
end
