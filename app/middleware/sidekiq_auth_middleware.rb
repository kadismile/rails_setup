require 'sidekiq/web'

class SidekiqAuthMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    session = request.session
    user_id = session[:user_id]
    user = User.find_by(id: user_id)

    if user.present?
      @app.call(env) # Allow access to Sidekiq if the user is logged in
    else
      # Redirect to login page
      [302, { 'Location' => Rails.application.routes.url_helpers.sign_in_path, 'Content-Type' => 'text/html' }, ['Redirecting...']]
    end
  end
end
