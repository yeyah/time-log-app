class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :date_of_birth, companies_attributes: [:domain, :name]) }
		devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
		devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :date_of_birth, companies_attributes: [:domain, :name]) }
	end

end
