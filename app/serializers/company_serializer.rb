class CompanySerializer < ActiveModel::Serializer
  attributes :id, :company_name, :address, :contact, :job_recruiter_id
end
