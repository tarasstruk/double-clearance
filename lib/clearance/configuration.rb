module Clearance
  class Configuration
    attr_accessor :mailer_sender
    attr_accessor :user_model
    attr_accessor :admin_model

    def initialize
      @mailer_sender = 'donotreply@example.com'
      @user_model = User if defined?(User)
      @admin_model = AdminUser if defined?(AdminUser)
    end
  end

  class << self
    attr_accessor :configuration
  end

  # Configure Clearance someplace sensible,
  # like config/initializers/clearance.rb
  #
  # @example
  #   Clearance.configure do |config|
  #     config.mailer_sender = 'donotreply@example.com'
  #   end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
