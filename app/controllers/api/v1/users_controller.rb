module Api
  module V1
    class UsersController < Api::V1::ApplicationController
      skip_before_action :authorize, only: [:create]

      def show
        begin
          @user = User.find(params[:id])
          render json: { user: Api::V1::UserSerializer.new(@user).data }
        rescue => e
          render json: { error: "Failed to Find User" }, status: 404
        end
      end

      def create
        @user = User.new(create_params)
        if @user.valid?
          @user.save
          token_result = AuthTokenIssuer.call(user_id: @user.id)
          if token_result.success?
            token = token_result.content
            render json: { user: Api::V1::UserSerializer.new(@user).data, jwt: token }, status: 201
          else
            render json: { error: 'Created User, but Failed to Issue Authorization' }, status: 400
          end
        else
          render json: { error: 'Failed to Create Valid User' }, status: 400
        end
      end

      private

      def create_params
        params.require(:user).permit(:username, :password)
      end
    end
  end
end
