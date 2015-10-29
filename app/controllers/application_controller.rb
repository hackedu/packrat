class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :current_member, :current_leader, :current_admin
  helper_method :user_signed_in?
  helper_method :correct_user?

  private

  def analytics
    @analytics ||= Analytics.new(current_user)
  end

  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue Exception
      nil
    end
  end

  def current_member
    begin
      current_user.meta if current_user.meta.is_a? Member
    rescue Exception
      nil
    end
  end

  def current_leader
    begin
      current_user.meta if current_user.meta.is_a? Leader
    rescue Exception
      nil
    end
  end

  def current_admin
    begin
      current_user.meta if current_user.meta.is_a? Admin
    rescue Exception
      nil
    end
  end

  def user_signed_in?
    return true if current_user
  end

  def correct_user?
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to root_path, alert: 'Access denied.'
    end
  end

  def authenticate_user!
    unless current_user
      redirect_to root_path, alert: 'You need to sign in to access this page.'
    end
  end

  def authenticate_member!
    unless current_member
      redirect_to new_member_session_path,
        alert: 'You need to sign in to access this page.'
    end
  end

  def authenticate_leader!
    unless current_leader
      redirect_to new_leader_session_path,
        alert: 'You need to sign in to access this page.'
    end
  end

  def authenticate_admin!
    unless current_admin
      redirect_to new_admin_session_path,
        alert: 'You need to sign in to access this page.'
    end
  end

  def authenticate_leader_or_admin!
    unless (current_leader || current_admin)
      redirect_to new_leader_session_path,
        alert: 'You need to sign in to access this page.'
    end
  end
end
