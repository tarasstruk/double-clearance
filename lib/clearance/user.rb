require 'digest/sha1'

module Clearance
  module User

    # Hook for all Clearance::User modules.
    #
    # If you need to override parts of Clearance::User,
    # extend and include a la carte.
    #
    # @example
    #   include InstanceMethods
    #   include AttrAccessor
    #   include Callbacks
    #
    # @see InstanceMethods
    # @see Callbacks
    def self.included(model)

      model.send(:acts_as_authentic)
      model.send(:include, InstanceMethods)
      model.send(:include, Callbacks)
    end

    module Callbacks
      # Hook for callbacks.
      #
      # salt, token, password encryption are handled before_save.
      def self.included(model)
        model.class_eval do
          after_create :send_confirmation_email, :unless => :email_confirmed?
        end
      end
    end

    module InstanceMethods
      def confirmed?
        email_confirmed?
      end

      def confirm_email!
        update_attribute(:email_confirmed, true)
      end

      def deliver_password_reset_instructions!
        ::ClearanceMailer.deliver_change_password(self)
      end

      protected

      def send_confirmation_email
        ::ClearanceMailer.deliver_confirmation(self)
      end
    end
  end
end
