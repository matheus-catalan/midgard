# frozen_string_literal: true

module V1
  module Users
    class ApplicationController < ApplicationController
      before_action :set_user, only: %i[show update destroy]

      def set_user
        @user = User.find(params[:id])
      end
    end
  end
end
