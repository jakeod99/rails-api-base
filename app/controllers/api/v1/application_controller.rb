module Api
  module V1
    class ApplicationController < ActionController::API
      before_action :authorized
    
      def authorized
        render json: { message: 'Invalid Authorization' }, status: :unauthorized unless logged_in?
      end
    
      def logged_in?
        !!current_user
      end
    
      def current_user
        return @user unless @user.nil?
        token = request.headers['Authorization']
        decoded_token_result = AuthTokenDecoder.call(token: token)
        if decoded_token_result.success?
          user_id = decoded_token_result.content.first['user_id']
          @user = User.find(user_id) if User.exists?(user_id)
        end
      end
    end
  end
end
