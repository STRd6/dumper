class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_account
    token = env['HTTP_AUTHORIZATION'] || session[:token]

    @current_account ||= Token.where(expired: false).find(token).account
  end
end
