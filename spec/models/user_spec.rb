require 'rails_helper'

RSpec.describe User, type: :model do
	describe 'validations' do
	  it { should presence(:name) }
    it { should presence(:type) }
	end
end
