# Authenticate Application users, handle exceptions throughout the application
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::ParameterMissing, with: :render_not_found

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  def authenticate_active_admin_user!
    authenticate_user!
    unless current_user.administrator?
      flash[:alert] = 'You are not authorized to access this resource!'
      redirect_to root_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def render_not_found(exception)
    render json: {
      message: "#{exception.model.constantize} not found"
    }, status: '404'
  end
end
