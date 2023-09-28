module Api
  module V1
    class SessionsController < Api::V1::ApplicationController
      skip_before_action :authorize, only: [:create]

      def create
        user = User.find_by(username: create_params[:username])
        if user && user.authenticate(create_params[:password])
          token_result = AuthTokenIssuer.call(user_id: user.id)
          if token_result.success?
            token = token_result.content
            return render(
              json: { 
                user: Api::V1::UserSerializer.new(user).data, 
                jwt: token 
              }, 
              status: 201
            )
          end
        end
        render json: { error: 'Login Failed' }, status: 401
      end

      private

      def create_params
        params.require(:user).permit(:username, :password)
      end
    end
  end
end