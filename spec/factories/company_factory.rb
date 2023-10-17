FactoryBot.define do
  factory :company do
    company_name { Faker::Company.name  }
    address { 'inodre'}
    contact { '1234557899'}
    job_recruiter
  end
end