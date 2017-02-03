class InfoMailer < ActionMailer::Base
  default :from => "info@empathy.by"

  def info_mail(to, subject, text)
    mail(:to => to, :subject => subject, :body => text)
  end
end
