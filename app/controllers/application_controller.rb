class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  helper_method :current_page
  def current_page
    params[:page].to_i < 1 ? 1 : params[:page].to_i
  end

  helper_method :current_per_page
  def current_per_page
    params[:per_page].to_i < 1 ? 10 : params[:per_page].to_i
  end
end
