class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :type
end
