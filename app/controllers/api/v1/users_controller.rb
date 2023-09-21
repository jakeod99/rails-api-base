class Api::V1::UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def show
    @user = User.find(params[:id])
    render json: { user: @user }
  end

  def create
    @user = User.new(create_params)
    if @user.valid?
      @user.save
      token = issue_token(@user)
      render json: { user: @user, jwt: token }, status: 201
    else
      render json: { error: 'Failed to create valid User' }, status: 400
    end
  end

  private

  def create_params
    params.require(:user).permit(:username, :password)
  end
end
