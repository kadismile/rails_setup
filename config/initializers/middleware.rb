# Load all middleware from the app/middleware directory
Dir[Rails.root.join('app', 'middleware', '*.rb')].each { |file| require file }
