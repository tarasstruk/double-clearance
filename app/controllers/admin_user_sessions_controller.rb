class AdminUserSessionsController < Clearance::SessionsController
  
  use_model :admin_user

  def url_new_session
    admin_sign_in_url
  end  


  def url_after_create
    {:controller => :admin_dashboard, :action => :index}
  end

  def url_after_destroy
    admin_sign_in_url
  end
  
end
