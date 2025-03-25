class ApplicationController < ActionController::API
  before_action :authenticate_request 
  attr_reader :current_user
  
  protected
  
  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    
    begin
      decoded = JsonWebToken.decode(header)
      @current_user = User.find(decoded[:user_id]) if decoded
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end