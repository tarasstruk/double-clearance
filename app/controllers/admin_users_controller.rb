class AdminUsersController < Clearance::UsersController
  
  
  use_model :admin_user
  
  def url_after_create
    admin_sign_in_url
  end  
  
  
end
