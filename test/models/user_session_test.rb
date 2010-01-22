require 'test_helper'
require 'authlogic/test_case'

class UserSessionTest < ActiveSupport::TestCase
  setup :activate_authlogic

  should "send a confirmation email if the found user is not yet confirmed" do
    user = Factory(:user, :email_confirmed => false, :password => 'foobarbaz', :password_confirmation => 'foobarbaz')
    ActionMailer::Base.deliveries.clear

    UserSession.create(:email => user.email, :password => 'foobarbaz')

    assert_sent_email do |email|
      email.subject =~ /account confirmation/i
    end
  end

  should "send no confirmation email if the found user is confirmed" do
    user = Factory(:user, :email_confirmed => true)
    ActionMailer::Base.deliveries.clear

    UserSession.create(user)

    assert_did_not_send_email
  end

  should "send no confirmation email if the user does not exist" do
    ActionMailer::Base.deliveries.clear
    UserSession.create(:email => 'foo@example.com', :password => 'bar')
    assert_did_not_send_email
  end
end
