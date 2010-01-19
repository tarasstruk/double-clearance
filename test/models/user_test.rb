require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # signing up

  context "When signing up" do
    should "store email in exact case" do
      user = Factory(:user, :email => "John.Doe@example.com")
      assert_equal "John.Doe@example.com", user.email
    end

    should "send the confirmation email" do
      Factory(:user)
      assert_sent_email do |email|
        email.subject =~ /account confirmation/i
      end
    end
  end

  context "When signing up with email already confirmed" do
    setup do
      ActionMailer::Base.deliveries.clear
      Factory(:user, :email_confirmed => true)
    end

    should "not send the confirmation email" do
      assert_did_not_send_email
    end
  end

  # confirming email

  context "A user without email confirmation" do
    setup do
      @user = Factory(:user)
      assert ! @user.email_confirmed?
      assert ! @user.confirmed?
    end

    context "after #confirm_email!" do
      setup do
        assert @user.confirm_email!
        @user.reload
      end

      should "have confirmed their email" do
        assert @user.email_confirmed?
        assert @user.confirmed?
      end
    end
  end

  # password reset

  should "send an email when sent #deliver_password_reset_instructions!" do
    user = Factory(:user)
    ActionMailer::Base.deliveries.clear
    user.deliver_password_reset_instructions!

    mail = ActionMailer::Base.deliveries.detect{|m| m.to.include?(user.email)}
    assert_not_nil mail
    assert_match /password/i, mail.subject
  end
end
