class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  helper_method :authorization_token
  def authorization_token
    token = request.env['HTTP_AUTHORIZATION'] || params[:authorization]
  end

  def current_account
    return @current_account if @current_account

    token = authorization_token

    if token
      token = Token.where(expired: false).find(token)
    end

    if token
      @current_account ||= token.account
    end
  end

  def require_account
    unless current_account
      render nothing: true, status: :unauthorized
    end
  end
end
