class UserSession < Authlogic::Session::Base
  include Clearance::UserSession
end
