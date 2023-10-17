FactoryBot.define do
  factory :job_seeker do
  	name { 'text' }
    type { 'JobSeeker' }
    email { Faker::Internet.email }
    password { '123456' }
    
  end
end
