class RegistrationsController < Devise::RegistrationsController
 
  def new
    build_resource({})
    self.resource.companies.build
    respond_with self.resource
  end

  def create

    build_resource(sign_up_params)

    access_level = resource.check_if_company_exists(params[:domain])

    # company_users = resource.company_users.build
    # puts "--------------------------------"
    # puts company_users.inspect
    # puts "--------------------------------"
    # company_users.company = resource.companies.first
    # company_users.access_level = access_level
    # company_users.first_name = resource.first_name
    # company_users.last_name = resource.last_name
    resource.save

    # puts "--------------------"
    # puts resource.companies.first.inspect
    # puts "--------------------"

    company_users = resource.company_users.first
    company_users.update_attributes(access_level: access_level, first_name: resource.first_name, last_name: resource.last_name)
    # find(access_level: access_level, user_id: resource, company_id: resource.companies.first.id, first_name: resource.first_name, last_name: resource.last_name)
    
    # company_users.save

    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
 
  private
 
  def sign_up_params
    allow = [:email, :password, :password_confirmation, :first_name, :last_name, :date_of_birth, :access_level, [companies_attributes: [:name, :domain]]]
    params.require(resource_name).permit(allow)
  end
 
end