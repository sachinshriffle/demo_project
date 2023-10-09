FactoryBot.define do
  factory :user do
    name { 'text' }
    type { 'JobRecruiter' }
    email { 'text@gmail.com' }
    password { '123456' }
  end
end