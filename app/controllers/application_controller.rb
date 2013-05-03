class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	before_filter :get_current_time

	def get_current_time
		@time_now = Time.now
	end
end
