class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :mobile_number, :type
end
