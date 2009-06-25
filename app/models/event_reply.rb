class EventReply < ActiveRecord::Base
  include AASM
  
  aasm_initial_state :new

  aasm_state :new
  aasm_state :paid
  aasm_state :expired
  aasm_state :cancelled

  aasm_event :pay do
    transitions :to => :paid, :from => [:new], :on_transition => :on_paid
  end
  
  aasm_event :expire do
    transitions :to => :expired, :from => [:new]
  end

  #aasm_event :cancel do
  #  transitions :to => :cancelled, :from => [:new]
  #end
  
  belongs_to :event
  belongs_to :ticket_type
  validates_presence_of :event, :name, :email, :ticket_type, :message => 'is required'
  
  def self.pay(ids)
    now = Time.now
    EventReply.find(ids).each do |reply|
      reply.pay!
    end
  end
  
  def paid?
    paid_at.present?
  end
  
  def on_paid
    update_attribute(:paid_at, Time.now)
    
    if event.send_mail_for?(:payment_registered)
      EventMailer.deliver_payment_registered(self)
    end
  end
end
