require 'rails_helper'

RSpec.describe "JobApplications", type: :request do
  let(:user) { FactoryBot.create(:job_seeker) }
  # let(:user) { FactoryBot.create(:job_recruiter) }
  let(:job) { FactoryBot.create(:job) }
  before do 
    sign_in user
    allow(controller).to receive(:current_user).and_return(user)
    current_user = controller.current_user  
  end 

  describe "GET /index" do
    # pending "add some examples (or delete) #{__FILE__}
    it 'is expected to assign job_application instance variable' do
      get '/job_applications'
      expect(assigns[:applications]).to eq(JobApplication.all)
    end
  end
  # new action
  describe 'GET #new' do
    before do
      get '/job_applications/new' , params: {job_id: job.id}	
    end

    it 'renders new template' do
      expect(response).to render_template(:new)
    end
  end

  # create action
  describe 'POST #create' do

    context 'when params are correct' do
      let(:job_application) {FactoryBot.build(:job_application , job_id: job.id)}
      it 'is expected to create new job_application successfully' do
        job_applications = job_application.as_json
        job_applications[:resume] = fixture_file_upload('resume.png', 'image/png')
        post '/job_applications', params: {job_application: job_applications }
        expect(response).to have_http_status(200)
        data = (JSON.parse(response.body))
        expect(data['data']['resume_url']).to_not eq nil
        expect(data['message']).to eq("You have applied for the job successfully!")
      end
    end

    context 'when params are not correct' do
      it 'is expected to render new template' do
        post '/job_applications', params:  { job_application: { job_id: job.id} }
        is_expected.to render_template(:new)
        expect(response).to have_http_status(404)
      end
    end
  end

  # #edit and update action
  let(:job_application) {JobApplication.last}

  describe 'GET #edit/id' do
    it 'renders new template' do
      put "/job_applications/#{job_application.id}"  
      expect(response).to render_template(:edit)
    end
  end
  describe "put /update/id" do
    context "with valid parameters" do

      it "updates the status of job_application" do
        put "/job_applications/#{job_application.id}" , params: {job_application: {status: "approved"} }
        job_application.reload
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq("message"=>"Job application updated successfully!")
      end
    end

    context "with invalid parameters" do
      it "renders a response (i.e. to display the 'edit' template)" do
        put "/job_applications/#{job_application.id}" , params: { job_application: {status: "accepted"} }
        expect(response).to have_http_status(404)
        expect(response).to render_template(:edit)
      end
    end
  end

  #show action
  describe 'GET #show/:id' do
    context "with data available" do
      it 'render successfully job_application data and status' do
        data = JobApplication.find(job_application.id)
        get "/job_applications/#{job_application.id}"  
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq(JobApplicationSerializer.new(data).serializable_hash)
      end
    end

    context "with data not available" do
      it 'give status of data not found' do
        get "/job_applications/nil"  
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to eq("message"=>"application not found")
      end
    end
  end

  # destroy action
  describe 'DELETE #destroy/:id' do
    context "with data available" do
      it 'and successfully job_application deleted' do
        delete "/job_applications/#{job_application.id}"  
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq("message"=>"Job application deleted successfully!")
      end
    end

    context "with data not available" do
      it 'give status of data not found' do
        delete "/job_applications/nil"  
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to eq("message"=>"application not found")
      end
    end
  end

  describe 'GET #job_applications/applied_jobs' do
    context "with data available" do
      it 'render successfully job_application data and status' do
        get "/job_applications/applied_jobs"  
        expect(response).to have_http_status(404)
      end
    end

    context "with data not available" do
      it 'give status of data not found' do
        get "/job_applications/applied_jobs"  
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to eq("message"=>"you not apply any jobs")
      end
    end
  end

  describe 'GET #job_applications/application_by_status' do
    context "when status are approved" do
      it 'render successfully job_application data' do
        get "/job_applications/application_by_status", params: {status: "approved"}
        expect(response).to have_http_status(200)
        # expect(JSON.parse(response.body)).to eq(current_user.job_applications.approved.as_json)
      end
    end

    context "when status are applied" do
      it 'render successfully job_application data' do
        get "/job_applications/application_by_status", params: {status: "applied"}
        expect(response).to have_http_status(200)
        # expect(JSON.parse(response.body)).to eq(current_user.job_applications.applied.as_json)
      end
    end

    context "when status are rejected" do
      it 'render successfully job_application data' do
        get "/job_applications/application_by_status", params: {status: "rejected"}
        expect(response).to have_http_status(200)
        # expect(JSON.parse(response.body)).to eq(current_user.job_applications.rejected.as_json)
      end
    end

    context "when result are blank " do
      it 'render message and status code' do
        get "/job_applications/application_by_status"
        expect(response).to have_http_status(200)
      end
    end

    context "when params are not given " do
      it 'render successfully job_application data' do
        get "/job_applications/application_by_status"
        expect(response).to have_http_status(200)
      end
    end
  end
end
