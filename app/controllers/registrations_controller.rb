class RegistrationsController < Devise::RegistrationsController
 
  def new
    build_resource({})
    self.resource.companies.build
    respond_with self.resource
  end

  def create

    build_resource(sign_up_params)
 
    if(resource.save)

      company = resource.check_if_company_exists(sign_up_params)
      access_level = resource.check_what_access_level(company.company_users)

      company_user = resource.company_users.build(company_id: company.id, access_level: access_level, first_name: resource.first_name, last_name: resource.last_name)

      company_user.save
    end


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
    allow = [:email, :password, :password_confirmation, :first_name, :last_name, :date_of_birth, :access_level, companies_attributes: [:domain, :name]]
    params.require(resource_name).permit(allow)
  end
 
end