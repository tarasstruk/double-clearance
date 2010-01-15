class UserSession < Authlogic::Session::Base
  before_validation_on_create :resend_confirmation_email_if_unconfirmed

  private

  def resend_confirmation_email_if_unconfirmed
    if send(login_field)
      attempted_record = search_for_record(find_by_login_method, send(login_field))
      if attempted_record && !attempted_record.confirmed?
        ::ClearanceMailer.deliver_confirmation(attempted_record)
      end
    end
  end
end
