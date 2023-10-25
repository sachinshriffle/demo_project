class JobSerializer < ActiveModel::Serializer
  attributes :id, :job_title, :company_id, :required_skills , :created_at , :updated_at
end
