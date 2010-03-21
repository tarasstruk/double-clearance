class AdminUserConfirmationsController < Clearance::ConfirmationsController
  
  use_model :admin_user
  
  def url_after_create
    admin_sign_in_url  
  end
  
  def url_already_confirmed
    admin_sign_in_url
  end  
  
end
