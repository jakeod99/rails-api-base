module Api
  module V1
    class UsersController < Api::V1::ApplicationController
      skip_before_action :authorize, only: [:create]

      def show
        @user = User.find(params[:id])
        render json: { user: Api::V1::UserSerializer.new(@user).data }
      rescue
        render json: { error: "Failed to Find User" }, status: 404
      end

      def create
        ActiveRecord::Base.transaction do
          @user = User.create!(create_params)
          token_result = AuthTokenIssuer.call(user_id: @user.id)
          raise StandardError if token_result.failure?
          token = token_result.content
          render json: { user: Api::V1::UserSerializer.new(@user).data, jwt: token }, status: 201
        end
      rescue
        render json: { error: 'Failed to Create Valid User' }, status: 400
      end

      private

      def create_params
        params.require(:user).permit(:username, :password)
      end
    end
  end
end
