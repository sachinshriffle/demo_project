class JobApplicationSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :job_id, :status , :resume_url

  def resume_url
  	Rails.application.routes.url_helpers.rails_blob_url(object.resume, only_path: true) if object.resume.attached?
  end
end
