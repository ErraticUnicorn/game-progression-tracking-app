module Api
  class SessionsController < ApplicationController
    skip_before_action :authenticate_request, only: [ :create ]

    # POST /api/sessions
    def create
      @user = User.find_by_email(params[:email])

      if @user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: @user.id)
        time = Time.now + 24.hours.to_i
        Yabeda.user_logins_total.increment({})
        render json: {
          token: token,
          exp: time.strftime("%m-%d-%Y %H:%M"),
          email: @user.email,
          user_id: @user.id
        }, status: :ok
      else
        Yabeda.user_login_failures_total.increment({})
        render json: { error: "Invalid credentials" }, status: :unauthorized
      end
    end
  end
end
