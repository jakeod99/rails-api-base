class Api::V1::SessionsController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def create
    user = User.find_by(username: create_params[:username])
    if user && user.authenticate(create_params[:password])
      token = issue_token(user)
      render json: { user: user, jwt: token }, status: 201
    else
      render json: { error: 'Login Failed' }, status: 401
    end
  end

  private

  def create_params
    params.require(:user).permit(:username, :password)
  end
end