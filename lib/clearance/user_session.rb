module Clearance
  module UserSession

    # Hook for the Clearance::UserSession.
    #
    # @see InstanceMethods
    # @see Callbacks
    def self.included(model)
      model.send(:include, InstanceMethods)
      model.send(:include, Callbacks)
    end

    module InstanceMethods
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

    module Callbacks
      # Hook for the confirmation email.  When trying to sign in as an
      # unconfirmed user, re-send the email.
      def self.included(model)
        model.class_eval do
          before_validation_on_create :resend_confirmation_email_if_unconfirmed
        end
      end
    end
  end
end
