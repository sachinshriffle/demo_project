require 'rails_helper'

RSpec.describe "Companies", type: :request do

  let(:user) { FactoryBot.create(:job_recruiter) }
  before do 
    sign_in user
    allow(controller).to receive(:current_user).and_return(user)
    current_user = controller.current_user	
	end	

  describe "GET /index" do
    # pending "add some examples (or delete) #{__FILE__}
    it 'is expected to assign company instance variable' do
      get '/companies'
      expect(assigns[:companies]).to eq(Company.all)
    end
  end
  
  # new action
  describe 'GET #new' do
    before do
      get '/companies/new'
    end

    it 'renders new template' do
      expect(response).to render_template(:new)
    end
  end

  # create action
  describe 'POST #create' do

    context 'when params are correct' do
      let(:company_create) {FactoryBot.build(:company, job_recruiter_id: user.id)}
      it 'is expected to create new company successfully' do
    	  post '/companies', params: {company: company_create.as_json }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when params are not correct' do
      it 'is expected to render new template' do
      	post '/companies', params:  { company: { company_name: ''} }
        is_expected.to render_template(:new)
        expect(response).to have_http_status(422)
      end
    end
  end
  #edit and update action
  let(:company) {FactoryBot.create(:company, job_recruiter_id: user.id)}
  describe 'GET #edit/id' do

    it 'renders edit template' do
      get "/companies/#{company.id}/edit"  
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH /update/id" do

    context "with valid parameters" do

      it "updates the requested company" do
        put "/companies/#{company.id}" , params: { company: {company_name: "shriffle technology pvt ltd indore m.p. "} }
        company.reload
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq("message"=>"company updated successfuly!")
      end
    end

    context "with invalid parameters" do
      it "renders a response status and edit template" do
        put company_url(company), params: { company: {comapany_name: "" , address: nil} }
        expect(response).to have_http_status(422)
        # expect(response).to redirect_to(edit_company_path(company))
      end
    end
  end

  #show actiom
  describe 'GET #show/:id' do
  	context "with data available" do
	    it 'render successfully company data' do
	      get "/companies/#{company.id}"  
	      expect(response).to have_http_status(200)
	      expect(JSON.parse(response.body)).to eq(Company.find(company.id).as_json)
	    end
	  end

	  context "with data not available" do
	    it 'give status of data not found' do
	      get "/companies/nil"  
	      expect(response).to have_http_status(404)
	    end
	  end
  end

  describe 'DELETE #destroy/:id' do
  	context "with data available" do
	    it 'and successfully company deleted' do
	      delete "/companies/#{company.id}"  
	      expect(response).to have_http_status(200)
	      expect(JSON.parse(response.body)).to eq("message"=>"company deleted successfully!")
	    end
	  end

	  context "with data not available" do
	    it 'give status of data not found' do
	      delete "/companies/nil"  
	      expect(response).to have_http_status(200)
	    end
	  end
  end
  
  describe 'GET #companies/user_company' do
    context "with data available" do
      it 'render successfully user company data' do
        get "/companies/user_company"  
        expect(response).to have_http_status(200)
      end
    end

    context "with data not available" do
      it 'give message of data not found' do
        get "/companies/user_company"  
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq("message" => "you have not create any company")
      end
    end
  end

  describe 'GET #companies/company_by_job_id' do
    context "with data available" do
      let(:job) {FactoryBot.create(:job , company_id: company.id)}
      it 'render successfully company data' do
        get "/companies/company_by_job_id"  , params: { id: job.id }
        expect(response).to have_http_status(200)
      end
    end

    context "with data not available" do
      it 'give message of data not found' do
        get "/companies/company_by_job_id"  , params: { job_id: nil }
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to eq("message" => "job not available")
      end
    end
  end

  describe 'GET #companies/search' do
    context "when params are given " do
      it 'if user name are given' do
        get "/companies/search"  , params: { search: "text" }
        expect(response).to have_http_status(200)
      end

      it 'if company name are given' do
        get "/companies/search"  , params: { search: "new1" }
        expect(response).to have_http_status(200)
      end

      it 'if job title are given' do
        get "/companies/search"  , params: { search: "developer" }
        expect(response).to have_http_status(200)
      end

      it 'if skill name are given' do
        get "/companies/search"  , params: { search: "java" }
        expect(response).to have_http_status(200)
      end
    end

    context "when params are not given" do
      it 'render all company' do
        get "/companies/search" 
        expect(response).to have_http_status(200)
      end
    end
  end
end