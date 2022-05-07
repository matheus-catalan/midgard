# frozen_string_literal: true

module V1
  module Sessions
    class ApplicationController < ApplicationController
      rescue_from ActiveRecord::RecordInvalid, with: :record_errors
      rescue_from ActiveRecord::RecordNotSaved, with: :record_errors
      rescue_from ActionController::ParameterMissing do |parameter_missing_exception|
        render json: { error: "param is missing or the value is empty: #{parameter_missing_exception.param}" },
               status: :unprocessable_entity
      end

      before_action :set_user, only: %i[create]
      before_action :authenticate, only: %i[create]
      before_action :set_session, only: %i[create]
      before_action :set_device, only: %i[create]
      before_action :authorized?, only: %i[show update destroy]

      def record_errors(invalid)
        return render json: { error: invalid.record.errors }, status: :unprocessable_entity
      end

      def set_user
        @user = User.find_by(email: sessions_params[:email])
        return render json: { error: 'Invalid email or password' }, status: :unauthorized if @user.nil?
      end

      def authenticate
        unless @user.authenticate(sessions_params[:password])
          return render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      def set_session
        @session = Session.find_by(user_id: @user.id)
      end

      def set_device
        @device = Device.find_or_create_by!(device_params.merge(user_id: @user.id))
        # aqui disparar uma mensagem para o serviço de notificação caso o device
        # não exista informando um novo aparelho logado em sua conta
      end

      def make_token(payload)
        JWT.encode(payload, ENV['SECRET_KEY_BASE'])
      end
    end
  end
end
