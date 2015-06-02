class CompanyUser < ActiveRecord::Base
	belongs_to :user
	belongs_to :company
	#validates_uniqueness_of :domain
	before_save :getCompanyUser

	def getCompanyUser
	end
end