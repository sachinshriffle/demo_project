FactoryBot.define do
  factory :user do
    name { 'text' }
    type { 'JobRecruiter' }
    email { Faker::Internet.email }
    password { '123456' }
  end
end