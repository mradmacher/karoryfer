class ApplicationController < ActionController::Base
  helper_method :current_artist,
                :current_artist?,
                :current_user,
                :current_user?,
                :current_user_session
  before_action :redirect_subdomain
  before_action :set_current_artist
  protect_from_forgery
  unless ['test', 'development'].include?(Rails.env)
    rescue_from User::AccessDenied, with: proc { redirect_to admin_login_url }
  end

  def current_user
    return @current_user if defined?(@current_user)
    current_user = current_user_session && current_user_session.user || User.new
    @current_user = CurrentUserPresenter.new(current_user)
  end

  private

  def redirect_subdomain
    return unless request.subdomain.present?
    return unless Artist.pluck(:reference).include?(request.subdomain)
    url = "#{request.protocol}www"
    url << request.host_with_port.gsub("#{request.subdomain}", '')
    url << "/#{request.subdomains.first}"
    url << request.fullpath unless request.fullpath == '/'
    redirect_to url, status: 301
  end

  def set_current_artist
    @current_artist = if params[:controller] == 'artists'
      params[:id] ? Artist.find_by_reference(params[:id]) : nil
    else
      params[:artist_id] ? Artist.find_by_reference(params[:artist_id]) : nil
    end
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_artist
    @current_artist
  end

  def current_artist?
    !@current_artist.nil?
  end

  def current_user?
    !current_user.nil?
  end

  def require_user
    fail User::AccessDenied unless current_user.resource.persisted?
  end

  def require_no_user
    !current_user.resource.persisted?
  end

  protected

  def set_layout
    current_artist? ? 'current_artist' : 'application'
  end
end
