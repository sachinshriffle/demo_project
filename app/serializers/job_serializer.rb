class JobSerializer < ActiveModel::Serializer
  attributes :id, :job_title, :required_skills, :company_id
end
