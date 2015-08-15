class Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  skip_before_filter :verify_authenticity_token

  before_filter :expose_token, :authenticate

  # Hello!
  # @url /
  # @action GET
  def index
    render json: { hello: 'Woof, woof.' }
  end

  # Catch-all endpoint for unknown requests.
  def page_not_found
    render_404
  end

  private

  # Exposes the API token idenitified by `token` param.
  # @api private
  # @return [ApiToken] The token.
  # @return [nil] If no matching token can be found.
  def expose_token
    @token = ApiToken.where(code: params[:token]).first
  end

  # Authenticates the exposed token.
  # @api private
  def authenticate
    render_401 if @token.blank? || !@token.active?
  end

  # Everything's OK.
  # @api private
  # @param msg [String] An optional message to add to the JSON.
  def render_200(msg = nil)
    @msg = msg
    render 'api/base/ok', status: 200
  end

  # Bad request.
  # @api private
  # @param msg [String] An optional message to add to the JSON.
  def render_400(msg = nil)
    @msg = msg
    render 'api/base/bad_request', status: 400
  end

  # Unauthorised.
  # @api private
  # @param msg [String] An optional message to add to the JSON.
  def render_401(msg = nil)
    @msg = msg
    render 'api/base/unauthorised', status: 401
  end

  # Forbidden.
  # @api private
  # @param msg [String] An optional message to add to the JSON.
  def render_403(msg = nil)
    @msg = msg
    render 'api/base/forbidden', status: 403
  end

  # Not found.
  # @api private
  # @param msg [String] An optional message to add to the JSON.
  def render_404(msg = nil)
    @msg = msg
    render 'api/base/not_found', status: 404
  end
end
