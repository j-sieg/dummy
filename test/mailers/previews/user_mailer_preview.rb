# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def reset_password
    UserMailer.with(user: User.last, token: "dummy_token").reset_password
  end
end
