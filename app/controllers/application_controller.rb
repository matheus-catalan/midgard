class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_errors
  rescue_from ActiveRecord::RecordNotSaved, with: :record_errors

  def record_not_found
    class_name = self.class.name.split('::').last
    class_name = class_name.remove('Controller')
    class_name = class_name.singularize
    render json: { error: "#{class_name} not found" }, status: 404
  end

  def record_errors(invalid)
    render json: { error: invalid.record.errors }, status: :unprocessable_entity
  end

  def authorized?
    return error('Unauthorized: Token Bearer is missing') if request.headers['Authorization'].nil?

    @user = User.find_by(id: decode_token['user_id'])
    return error('Unauthorized: User not found') if @user.nil?
    return error('Unauthorized: User disabled') unless @user.status

    @session = Session.find_by(token: token_jwt, user_id: @user.id)
    return error('Unauthorized: User not logged') if @session.nil?
    return error('Unauthorized: Token Bearer is expired') if expired?

    @session.update(expires_at: Time.now + 1.day)
    @session
  end

  def expired?
    (@session.expires_at.to_time + 1.day).to_time < DateTime.current.strftime('%Y-%m-%d %H:%M:%S').to_time
  end

  def decode_token
    JWT.decode(token_jwt, ENV['SECRET_KEY_BASE'], true, algorithm: 'HS256')[0]
  rescue JWT::DecodeError
    error('Unauthorized: Token Bearer is invalid')
  end

  def token_jwt
    request.headers['Authorization'].split(' ')[1]
  end

  def error(message = 'Unauthorized')
    render json: { error: message }, status: :unauthorized
  end
end
