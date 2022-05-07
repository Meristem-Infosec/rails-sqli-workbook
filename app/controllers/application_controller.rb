class ApplicationController < ActionController::Base
  before_action :set_db, :turbo_frame_request_variant

  private

  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end

  def set_db
    if session.key?(:dbid)
      ActiveRecord::Base.establish_connection({adapter: "postgresql", database: session[:dbid], host: "127.0.0.1", username: "sqlinjector", password: Rails.application.credentials.database.password })
    end
  end
end