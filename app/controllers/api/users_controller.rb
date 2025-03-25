module Api
  class UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [:create]
    
    # POST /api/user
    def create
      @user = User.new(user_params)
      
      if @user.save
        render json: {
          id: @user.id,
          email: @user.email,
          created_at: @user.created_at
        }, status: :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    private
    
    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
end