class MyProfileController < UserProxyController
  
  
  before_filter :authenticate
  
  def index
  end

end
