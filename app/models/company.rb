class Company < ActiveRecord::Base
	
	has_many :company_users, autosave: false
	has_many :users, through: :company_users, autosave: false

	accepts_nested_attributes_for :users

end