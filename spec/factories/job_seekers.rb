FactoryBot.define do
  factory :job_seeker do
  	name { 'text' }
    type { 'JobSeeker' }
    email { 'text1@gmail.com' }
    password { '123456' }
    
  end
end
