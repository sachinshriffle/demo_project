class CompanySerializer < ActiveModel::Serializer
  attributes :id, :company_name, :address, :contact, :user_id
end
