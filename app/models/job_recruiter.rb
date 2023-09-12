class JobRecruiter < User
	has_one :company , foreign_key: :user_id , dependent: :destroy
end
