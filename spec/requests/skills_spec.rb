require 'rails_helper'

RSpec.describe "Skills", type: :request do

  let(:user) { FactoryBot.create(:job_seeker) }
  before do 
    sign_in user
    allow(controller).to receive(:current_user).and_return(user)
    current_user = controller.current_user  
  end 

  describe "GET /index" do
    # pending "add some examples (or delete) #{__FILE__}
    it 'is expected to assign skill instance variable' do
      get '/skills'
      expect(assigns[:skills]).to eq(Skill.all)
    end
  end
  # new action
  describe 'GET #new' do
    before do
      get '/skills/new'
    end

    it 'renders new template' do
      expect(response).to render_template(:new)
    end
  end

  # create action
  describe 'POST #create' do

    context 'when params are correct' do
      let(:skill) {FactoryBot.build(:skill)}
      it 'is expected to create new skill successfully' do
        post '/skills', params: {skill: skill.as_json }
        expect(response).to have_http_status(201)
      end
    end

    context 'when params are not correct' do
      it 'is expected to render new template' do
        post '/skills', params:  { skill: { skill_name: ''} }
        is_expected.to render_template(:new)
        expect(response).to have_http_status(422)
      end
    end
  end
  #edit and update action
  let(:skill) {FactoryBot.create(:skill)}
  describe "put /update/id" do

    context "with valid parameters" do

      it "updates the requested skill" do
        put "/skills/#{skill.id}" , params: {skill: {skill_name: "RUbY on rAils"} }
        skill.reload
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq("message"=>"skill updated successfully!")
      end
    end

    context "with invalid parameters" do
      it "renders a response (i.e. to display the 'edit' template)" do
        # skill = skill.create!(skill_name: "tcs")
        put skill_url(skill), params: { skill: {skill_name: ""  } }
        expect(response).to have_http_status(200)
        # expect(response).to redirect_to(edit_skill_path(skill))
      end
    end
  end

  #show action
  describe 'GET #show/:id' do
    context "with data available" do
      it 'render successfully skill data and status' do
        get "/skills/#{skill.id}"  
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq(Skill.find(skill.id).as_json)
      end
    end

    context "with data not available" do
      it 'give status of data not found' do
        get "/skills/nil"  
        expect(response).to have_http_status(404)
      end
    end
  end

  # destroy action
  describe 'DELETE #destroy/:id' do
    context "with data available" do
      it 'and successfully skill deleted' do
        delete "/skills/#{skill.id}"  
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq("message"=>"skill deleted successfully!")
      end
    end

    context "with data not available" do
      it 'give status of data not found' do
        delete "/skills/nil"  
        expect(response).to have_http_status(404)
      end
    end
  end
 
  # add user skill
  describe 'GET#/skills/add_skill' do
    it 'if user skill are add successfully' do 
      get '/skills/add_skill' , params: { skill_name: "python" }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq("message"=>"skill added successfully!")
    end

    it 'skills are not available ' do 
      get '/skills/add_skill' , params: {skill_name: ""} 
      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)).to eq("message"=>"skill not available")
    end
  end
 
  # see user skill
  describe 'GET#skills/user_skills' do
    it 'if user skills are present' do 
      get '/skills/user_skills'
      expect(response).to have_http_status(200)
    end

    it 'if user skills are not present' do 
      get '/skills/user_skills'
      expect(JSON.parse(response.body)).to eq("message"=>"you don't have any skill")
    end
  end
end