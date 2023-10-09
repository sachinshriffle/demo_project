FactoryBot.define do
  factory :job do
  	job_title { 'developer'}
  	required_skills { ['c,c++'] }
  	company
    
  end
end
