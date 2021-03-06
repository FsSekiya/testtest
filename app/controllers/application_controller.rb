class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :exception

  before_action :basic_auth unless %w[development test].include?(Rails.env)
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit

  protected

  def after_sign_in_path_for(resource)
    return customer_dashboard_index_path if resource.class == Customer
    return admin_dashboard_index_path if resource.class == Admin
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[uid password])
  end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |user, pass|
      user == ENV['BASIC_AUTH_USER'] && pass == ENV['BASIC_AUTH_PASSWORD']
    end
  end
end
