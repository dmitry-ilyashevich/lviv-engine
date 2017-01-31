class InfoMailer < ActionMailer::Base
  default :from => "fosslviv@gmail.com"

  def info_mail(to, subject, text)
    mail(:to => to, :subject => subject, :body => text)
  end
end
