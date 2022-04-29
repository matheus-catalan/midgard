module V1
  module Users
    class UsersController < ApplicationController
      def index
        @users = User.all
      end

      def create
        @user = User.create!(users_params)
      end

      def show
        @user
      end

      def update
        @user.update!(users_params.except(:password))
      end

      def destroy
        @user.destroy!
      end

      def users_params
        params.require(:user).permit(:name, :email, :password, :status)
      end
    end
  end
end
