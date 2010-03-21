class UserConfirmationsController < Clearance::ConfirmationsController
  
  use_model :user
  
  def url_after_create
    sign_in_url  
  end  
  
  def url_already_confirmed
    sign_in_url
  end  
  
end
