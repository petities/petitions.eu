# Preview all emails at http://localhost:3000/rails/mailers/signature_mailer
class DeviseMailerPreview < ActionMailer::Preview
  def reset
    Devise::Mailer.reset_password_instructions(User.first, 'testtoken')
  end

  def confirm_normal
    Devise::Mailer.confirmation_instructions(User.first, 'testtoken2')
  end
end
