class JobApplicationSerializer < ActiveModel::Serializer
  attributes :id , :user_id , :job_id , :status
end
