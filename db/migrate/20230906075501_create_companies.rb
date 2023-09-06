class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
    	t.string :company_name
    	t.string :address
    	t.string :contact
    	t.references :user , foreign_key: true , null: false

      t.timestamps
    end
  end
end
