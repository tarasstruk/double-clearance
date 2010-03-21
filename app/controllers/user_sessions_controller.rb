class UserSessionsController < Clearance::SessionsController

  # after_filter :log_session_info

  use_model :user
  
  def url_after_create
    {:controller => :my_profile, :action => :index}
  end
  
  def url_after_destroy
    sign_in_url
  end
    
  private 
  
  def log_session_info
    logger.warn '---------'
    logger.warn self.user_model.inspect
  end
      
    
    
end
