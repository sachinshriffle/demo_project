FactoryBot.define do
  factory :job_recruiter do
  	name { 'text' }
    type { 'JobRecruiter' }
    email { 'text@gmail.com' }
    password { '123456' }
    
  end
end
