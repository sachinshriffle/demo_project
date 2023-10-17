FactoryBot.define do
  factory :job_recruiter do
  	name { 'text' }
    type { 'JobRecruiter' }
    email { Faker::Internet.email }
    password { '123456' }
    
  end
end
