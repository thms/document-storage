class ApplicationController < ActionController::Base

  protect_from_forgery with: :null_session
  
  # Protect API with access token
  before_action :authenticate unless Rails.env == 'development'
  
  protected
  
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      "MJagrTYj2dCVTetpyFSyamuRPC2X9xNy" == token
    end
  end
  
  
end
