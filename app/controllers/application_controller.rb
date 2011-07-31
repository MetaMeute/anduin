class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  protected
  def set_locale
    available = %w{en de}
    locale = available.select { request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first } || "en"
    I18n.locale = locale
  end
end
