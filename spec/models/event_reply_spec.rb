require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventReply do
  before(:each) do
    @event = mock_model(Event)
    @event.stub(:send_mail_for?).with(:signup_confirmation).and_return(false)
    @event.stub!(:send_mail_for?).with(:payment_registered).and_return(false)
    
    @ticket_type = mock_model(TicketType)
    @valid_attributes = {
      :event => @event,
      :name => 'Kalle Anka',
      :email => 'kalle@example.org',
      :ticket_type => @ticket_type
    }
    
    @reply = EventReply.new(@valid_attributes)
  end
  
  it "should be valid" do
    @reply.should be_valid
  end
  
  it { should belong_to(:event) }
  it { should belong_to(:ticket_type) }
  it { should validate_presence_of(:event).with_message('is required') }
  it { should validate_presence_of(:ticket_type).with_message('is required') }
  # This is for making the error messages make more sense...
  it { should have_db_column(:aasm_state).of_type(:string).with_options(:null => false)}
  
  
  xit "should send confirmation mail if there are a mail template with name confirmation"
  
  it "should not send confirmation mail if there aren't any confirmation mail template" do
    EventMailer.should_not_receive(:deliver_signup_confirmation)
    
    @reply.save!
    
  end
  
  it "#paid?" do
    @reply.should_not be_paid
    
    @reply.paid_at = Time.now
    
    @reply.should be_paid
  end
  
  it "should batch save paid" do
    now = Time.now
    Time.stub!(:now).and_return(now)
    
    reply1 = mock_model(EventReply)
    reply1.should_receive(:pay!)
    
    EventReply.stub!(:find).and_return([reply1])
    
    EventReply.pay([1])
  end
  
  it "should not have a paid_at on create" do
    @reply.paid_at.should == nil
  end
  
  it "should set payment date on pay!" do
    now = Time.now
    Time.stub!(:now).and_return(now)
    
    reply = EventReply.create!(@valid_attributes)
    reply.pay!
    
    reply.paid_at.should == now
  end
  
  it "should send payment registration mail when there is a payment_registered mail template" do
    
    ticket_type = TicketType.create!(:name => 'Normal ticket', :price => 10)
    event = Event.create!(:name => "My event")
    event.mail_templates.create!(:body => 'foo', :subject => 'bar', :name => 'payment_registered')
    
    @reply = event.replies.create!(:ticket_type => ticket_type, :name => 'Kalle', :email => 'kalle@example.org')
    
    @event.stub!(:send_mail_for?).with(:payment_registered).and_return(true)
    
    @reply.save!
    
    EventMailer.should_receive(:deliver_payment_registered).with(@reply)
    
    EventReply.pay([@reply.id])
  end

end
