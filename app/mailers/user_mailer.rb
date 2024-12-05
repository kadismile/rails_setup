class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @url  = 'http://localhost:3000/users/sign_in'
    mail(
      to: @user.email, 
      from: "Dashy <#{ENV['FROM_EMAIL']}>",
      subject: 'Welcome'
    )
  end
end
