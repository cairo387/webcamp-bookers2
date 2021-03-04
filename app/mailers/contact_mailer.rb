class ContactMailer < ApplicationMailer
  def send_when_admin_reply(user, contact)
    @user = user
    @answer = contact.reply_text
    mail to: user.email, subject:'【Bookers2】会員登録が完了しました。'
  end
end
