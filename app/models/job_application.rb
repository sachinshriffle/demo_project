class JobApplication < ApplicationRecord
	belongs_to :user
	belongs_to :job
	enum :status, [:applied , :approved, :rejected]
end
