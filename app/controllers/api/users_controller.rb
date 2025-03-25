module Api
  class UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [ :create ]

    # POST /api/user
    # In production, we would want to guarantee we are forcing SSL
    def create
      @user = User.new(user_params)

      if @user.save
        Yabeda.user_registrations_total.increment({})
        
        render json: {
          id: @user.id,
          email: @user.email,
          created_at: @user.created_at
        }, status: :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      # Format the response according to Phase 3 requirements
      stats_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      user_stats = current_user.stats
      stats_duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - stats_start
      
      # Record stats processing duration
      Yabeda.stats_processing_duration_seconds.measure({}, stats_duration)
      
      render json: {
        user: {
          id: current_user.id,
          email: current_user.email,
          stats: user_stats
        }
      }
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
end
