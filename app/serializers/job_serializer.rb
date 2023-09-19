class JobSerializer < ActiveModel::Serializer
  attributes :id, :job_title, :company_id, :required_skills
end
