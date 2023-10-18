require 'rails_helper'

RSpec.describe "Jobs", type: :request do
  let(:user) { FactoryBot.create(:job_recruiter) }
  let(:company) { FactoryBot.create(:company , job_recruiter_id: user.id) }
  before do 
    sign_in user
    allow(controller).to receive(:current_user).and_return(user)
    current_user = controller.current_user	
	end	

  describe "GET /index" do
    # pending "add some examples (or delete) #{__FILE__}
    it 'is expected to assign job instance variable' do
      get '/jobs'
      expect(assigns[:jobs]).to eq(Job.all)
    end
  end

  # new action
  describe 'GET #new' do
    before do
      get '/jobs/new'
    end

    it 'renders new template' do
      expect(response).to render_template(:new)
    end
  end

  # create action
  describe 'POST #create' do

    context 'when params are correct' do
      let(:job_create) {FactoryBot.build(:job, company_id: company.id)}
      it 'is expected to create new job successfully' do
    	  post '/jobs', params: {job: job_create.as_json }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when params are not correct' do
      it 'is expected to render new template' do
      	post '/jobs', params:  { job: { job_name: ''} }
        is_expected.to render_template(:new)
        expect(response).to have_http_status(422)
      end
    end
  end

  #edit and update action
  let(:job) {FactoryBot.create(:job, company_id: company.id)}
  describe 'GET #edit/id' do

    it 'renders new template' do
      get "/jobs/#{job.id}/edit"  
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH /update/id" do

    context "with valid parameters" do

      it "updates the requested job" do
        put "/jobs/#{job.id}" , params: { job: {job_title: "trainee developer"} }
        job.reload
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq("message"=>"job updated successfuly!")
      end
    end

    context "with invalid parameters" do
      it "renders a response (i.e. to display the 'edit' template)" do
        put "/jobs/#{job.id}" , params: { job: {job_title: ""} }
        expect(response).to have_http_status(404)
        # expect(response).to redirect_to(edit_job_path(job))
      end
    end
  end

  #show actiom
  describe 'GET #show/:id' do
  	context "with data available" do
	    it 'render successfully job data and status' do
	      get "/jobs/#{job.id}"  
	      expect(response).to have_http_status(200)
	      expect(JSON.parse(response.body)).to eq(Job.find(job.id).as_json)	
	    end
	  end

	  context "with data not available" do
	    it 'give status of data not found' do
	      get "/jobs/nil"  
	      expect(response).to have_http_status(404)
	      expect(JSON.parse(response.body)).to eq("message"=>"Job not found")
	    end
	  end
  end

  #delete action
  describe 'DELETE #destroy/:id' do
  	context "with data available" do
	    it ' and successfully job deleted' do
	      delete "/jobs/#{job.id}"  
	      expect(response).to have_http_status(200)
	      expect(JSON.parse(response.body)).to eq("message"=>"job deleted successfuly!")
	    end
	  end

	  context "with data not available" do
	    it 'give status of data not found' do
	      delete "/jobs/nil" 
	      expect(response).to have_http_status(404)
	    end
	  end
  end

  describe 'GET #jobs/top_jobs' do
  	context "with data available" do
	    it 'render successfully top jobs' do
	      get "/jobs/top_jobs"  
	      expect(response).to have_http_status(200)	
	    end
	  end

	  context "with data not available" do
	    it 'give status of data not found' do
	      get "/jobs/top_jobs"  
	      expect(response).to have_http_status(200)
	      # expect(JSON.parse(response.body)).to eq("message"=>"No Applicants")
	    end
	  end
  end

  describe 'GET #jobs/current_company_jobs' do
  	context "with data available" do
	    it 'render successfully top jobs' do
	      get "/jobs/current_company_jobs", params: {company_id: company.id}  
	      expect(response).to redirect_to(root_path)	
	    end
	  end

	  context "with data not available" do
	    it 'give status of data not found' do
	      get "/jobs/current_company_jobs" , params: {company_id: company.id}
	      # expect(response).to render_template(:index)
        expect(response).to have_http_status(302)
	    end
	  end
  end

  describe 'GET #jobs/search_jobs_by_company_or_skill_name' do
  	context "when company name available" do
	    it 'render successfully jobs ' do
	      get "/jobs/search_jobs_by_company_or_skill_name", params: {company_name: company.company_name}  
	      expect(response).to have_http_status(200)	
	    end
	  end

	  context "when skill name are available" do
	    it 'render successfully jobs' do
	      get "/jobs/search_jobs_by_company_or_skill_name", params: {skill_name: "java"}
	      expect(response).to have_http_status(200)	
	    end
	  end

	  context "when not any params are given" do
	    it 'render all jobs' do
	      get "/jobs/search_jobs_by_company_or_skill_name"
	      expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq(Job.all.as_json)
	    end
	  end
  end
end
