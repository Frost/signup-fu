class EventMailer < ActionMailer::Base
  
  def signup_confirmation(reply)
    event = reply.event
    template = event.mail_templates.by_name(:signup_confirmation)
    
    send_mail_from_template(reply, template)
  end
  
  def payment_registered(reply)
    event = reply.event
    
    template = event.mail_templates.by_name(:payment_registered)
    
    send_mail_from_template(reply, template)
  end
  
  protected
  
  def send_mail_from_template(reply, template)
    body = template.render_body(reply)
    subject = template.render_subject(reply)
    
    recipients reply.email
    from "no-reply@signupfu.com"
    subject subject
    body body
    
  end
end
