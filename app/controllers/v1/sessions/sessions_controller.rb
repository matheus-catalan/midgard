module V1
  module Sessions
    class SessionsController < ApplicationController
      def index
        a = 1+2
        @sessions = Session.all
      end

      def create
        return @session unless @session.nil?

        @session = Session.create!(make_params)
      end

      def show
        @session
      end

      def update
        @session.update(make_params)
      end

      def destroy
        @session.destroy
      end

      def make_params
        {
          user_id: @user.id,
          token: make_token({ user_id: @user.id }),
          expires_at: Time.now + 1.day,
          should_expire: sessions_params[:should_expire]
        }
      end

      def sessions_params
        params.require(:user).permit(:email, :password, :should_expire)
      end

      def device_params
        params.require(:device).permit(:name, :ip_address, :user_agent, :platform)
      end
    end
  end
end
