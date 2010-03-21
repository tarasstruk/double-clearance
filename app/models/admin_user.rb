class AdminUser < ActiveRecord::Base
  
  include Clearance::User
  
end
