class UserMailer < ActionMailer::Base
  default :from => DEFAULT_EMAIL

  def registration_confirmation(user_id)
    @user = User.find(user_id)
    mail(:to => "#{@user.name} <#{@user.email}>", :subject => t("registration_confirmation"))
  end

  def forgot_password(user_id)
    @user = User.find(user_id)
    mail to: @user.email, :subject => t("Reset_password_instructions")
  end
end
