require 'rails_helper'

RSpec.describe "Users", type: :request do
  # describe "GET /index" do
  #   pending "add some examples (or delete) #{__FILE__}"
  # end
  describe 'GET /users/sign_up' do
    it 'signs up the user' do
      get new_user_registration_path
      expect(response).to have_http_status(200)
      post user_registration_path, params: { user: { email: 'test@example.com', password: 'password' ,name: "text" , type: "JobRecruiter" } }
      expect(response).to have_http_status(422)
      expect(response).to render_template("devise/registrations/new")
    end
  end

  let(:user) { User.create(email: 'test@example.com', password: 'password') }
  describe 'GET /users/sign_in' do
    it 'signs in the user' do
    	post user_session_path, params: { user: { email: 'text1@example.com', password: 'password' } }
      sign_in user
      allow(controller).to receive(:current_user).and_return(user)
      current_user = controller.current_user		
      get root_path
    end
  end

  
end
