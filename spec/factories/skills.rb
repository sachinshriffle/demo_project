FactoryBot.define do
  factory :skill do
  	skill_name { Faker::ProgrammingLanguage.name}
    
  end
end
