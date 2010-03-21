class Clearance::UsersController < Clearance::AuthProxyController
  unloadable

  skip_before_filter :authenticate, :only => [:new, :create]
  before_filter :redirect_to_root,  :only => [:new, :create], :if => :signed_in?
  filter_parameter_logging :password

  class_inheritable_accessor :user_model 

  class << self
    def use_model(klass_name)
      self.user_model = klass_name.to_s.camelize.constantize
    end
  end

  def model_param_key
    user_model.name.underscore
  end  
  
  def template_directory
    model_param_key.pluralize
  end

  def new
    @user = user_model.new(params[model_param_key])
    render :template => "#{template_directory}/new"
  end

  def create
    @user = user_model.new params[model_param_key]
    if @user.save
      flash_notice_after_create
      redirect_to(url_after_create)
    else
      render :template => "#{template_directory}/new"
    end
  end

  private

  def flash_notice_after_create
    flash[:notice] = translate(:deliver_confirmation,
      :scope   => [:clearance, :controllers, :users],
      :default => "You will receive an email within the next few minutes. " <<
                  "It contains instructions for confirming your account.")
  end

  def url_after_create
    sign_in_url
  end
end
