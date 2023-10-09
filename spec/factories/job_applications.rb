FactoryBot.define do
  factory :job_application do
  	job_seeker
  	job
  	# traits_for_enum :status, %w[applied approved rejected]
  	status { "applied"}   
  end
end
