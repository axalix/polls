class Api::Controller < ApplicationController
  include Concerns::Paginator

  skip_before_filter :verify_authenticity_token # prevents WARNING: Can't verify CSRF token authenticity

  respond_to :json

  before_action :authentication

  helper_method :current_user

#-----------------------
  rescue_from Exception, with: :unprocessed_exceptions_handler

  class AccessDenied < SecurityError; end
  class PathNotFound < RuntimeError; end

  rescue_from AccessDenied, with: :access_denied_handler
  rescue_from ActionController::ParameterMissing, with: :bad_request_handler
  rescue_from ActionView::MissingTemplate, with: :bad_request_handler
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_handler
  rescue_from PathNotFound, with: :path_not_found_handler
  rescue_from CustomError,  with: :bad_request_handler

  def unprocessed_exceptions_handler(exception)
    log_exception(exception)
    error_response :bad_request, "Request cannot be processed"
  end

  def path_not_found_handler(exception)
    log_exception(exception)
    error_response :bad_request, "Path not found"
  end

  def access_denied_handler(exception)
    error_response :forbidden, 'Access denied' + (exception.present? ? ': ' + exception.to_s : '')
  end

  def bad_request_handler(exception)
    error = {}
    p exception.inspect

    if exception.try(:param)
      error[exception.param] = ['parameter is required']
    else
      error = exception.message
    end
    error_response :unprocessable_entity, error
  end

  def record_not_found_handler(exception)
    message_segments = exception.message.split(' [')
    error = message_segments[1].present?? message_segments[0] : "Resource not found"
    error_response :not_found, error
  end
#-----------------------

  def current_user
    @current_user
  end

  private

  attr_accessor :current_user

  def authentication
    @current_user = Services::Auth::Tokens::get_user(request)
    raise AccessDenied if @current_user.nil?
  end

  def error_response(code, *errors)
    errors_primary = []
    errors_secondary = {}
    errors.each do |error|
      #if error.is_a?(Hash) || error.is_a?(ActiveModel::Errors)
      if error.is_a? String
        errors_primary << error
      else
        errors_secondary.merge!(error)
      end
    end

    r = {}
    r.merge! global: errors_primary unless errors_primary.empty?
    r.merge! errors_secondary unless errors_secondary.empty?
    response = { errors: r }
    render status: code, json: response
  end

  def log_exception(exception)
    logger.error("\n------ E R R O R --------")
    logger.tagged("API #{params[:controller]}/#{params[:action]}") { logger.error(exception.message) }
    if env['REMOTE_ADDR'] == '127.0.0.1'
      exception.backtrace.each do |line|
        logger.error(line) if line =~ /tinder-boost-server/i
      end
    else
      exception.backtrace.each { |line| logger.error line }
    end
    logger.error("------ / E R R O R --------\n")
  end
end
