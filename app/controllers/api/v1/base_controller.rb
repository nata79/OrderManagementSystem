class Api::V1::BaseController < ApplicationController
  respond_to :json

  rescue_from 'ActiveRecord::RecordNotFound', with: :not_found
  rescue_from 'ActiveRecord::RecordInvalid', with: :record_invalid
  rescue_from 'ActionController::ParameterMissing', with: :record_invalid

  def send_error message, code
    render json: { error: message }, status: code
  end

private
  def not_found
    send_error 'Record not found', :not_found
  end

  def record_invalid exception
    send_error exception.message, :bad_request
  end
end