class AdminProxyController < Clearance::AuthProxyController
  
  use_model :admin_user
  
end
