class Clearance::SessionsController < Clearance::AuthProxyController
  unloadable

  skip_before_filter :authenticate, :only => [:new, :create, :destroy]
  protect_from_forgery :except => :create
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
    # render :template => 'sessions/new'
  end
  
  def create
    @user = user_model.authenticate(params[:session][:email],
                                params[:session][:password])
    if @user.nil?
      flash_failure_after_create
      render :action => :new, :status => :unauthorized
    else
      if @user.email_confirmed?
        sign_in(@user)
        flash_success_after_create
        redirect_back_or(url_after_create)
      else
        ::ClearanceMailer.deliver_confirmation(@user)
        flash_notice_after_create
        redirect_to :action => :new
      end
    end
  end

  def destroy
    sign_out
    flash_success_after_destroy
    redirect_to(url_after_destroy)
  end

  private

  def flash_failure_after_create
    flash.now[:failure] = translate(:bad_email_or_password,
      :scope   => [:clearance, :controllers, :sessions],
      :default => "Bad email or password.")
  end

  def flash_success_after_create
    flash[:success] = translate(:signed_in, :default =>  "Signed in.")
  end

  def flash_notice_after_create
    flash[:notice] = translate(:unconfirmed_email,
      :scope   => [:clearance, :controllers, :sessions],
      :default => "User has not confirmed email. " <<
                  "Confirmation email will be resent.")
  end

  def url_after_create
    '/'
  end

  def flash_success_after_destroy
    flash[:success] = translate(:signed_out, :default =>  "Signed out.")
  end

  def url_after_destroy
    sign_in_url
  end
end
