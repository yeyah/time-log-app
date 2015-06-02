class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_many :time_entries
	has_many :user_settings
	has_many :company_users, autosave: false
	has_many :companies, through: :company_users

	accepts_nested_attributes_for :companies,:company_users

	# before_create:check_if_company_exists


	def check_if_company_exists (domain)

		# company = self.companies.first
		# puts company.domain
		company = Company.find_by_domain(domain)
		
		if company.present?

			puts = "----------------------------------------------"
			puts " Domain already exists "
			access_level = 2

		else 
			puts = "----------------------------------------------"
			puts " Domain does not exists "
			access_level = 1

		end

		return access_level
		# self.company_users.build(access_level: access_level, user_id: self.id, company_id: company.id, first_name: self.first_name, last_name: self.last_name)
	end

end