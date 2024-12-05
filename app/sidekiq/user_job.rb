class UserJob
  include Sidekiq::Job

  def perform(*args)
    user_id = args.first["user_id"]
    user = User.find(user_id)
    UserMailer.welcome_email(user).deliver_now
  end
end
