class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActionController::ParameterMissing, with: :handle_invalid_request

  def handle_invalid_request
    render json: { error: "Invalid input for #{request.method}" }, status: :bad_request
  end

  private

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, _options|
      ActiveSupport::SecurityUtils.secure_compare(token, Rails.application.credentials.dig(:api, :token))
    end
  end

  def render_unauthorized
    render json: { error: 'Bad credentials' }, status: :unauthorized
  end

  def record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end

  def handle_request_failed
    render json: { error: 'Request failed, contact support' }, status: :bad_gateway
  end
end
