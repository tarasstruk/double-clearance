class Clearance::ConfirmationsController < Clearance::AuthProxyController
  unloadable

  skip_before_filter :authenticate,                  :only => [:new, :create]
  before_filter :redirect_signed_in_confirmed_user,  :only => [:new, :create]
  before_filter :redirect_signed_out_confirmed_user, :only => [:new, :create]
  before_filter :forbid_missing_token,               :only => [:new, :create]
  before_filter :forbid_non_existent_user,           :only => [:new, :create]

  filter_parameter_logging :token


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

  def user_id_param
    params["#{model_param_key}_id"]
  end


  def new
    create
  end

  def create
    @user = user_model.find_by_id_and_confirmation_token(
                   user_id_param, params[:token])
    @user.confirm_email!

    sign_in(@user)
    flash_success_after_create
    redirect_to(url_after_create)
  end

  private

  def redirect_signed_in_confirmed_user
    user = user_model.find_by_id(user_id_param)
    if user && user.email_confirmed? && current_user == user
      flash_success_after_create
      redirect_to(url_after_create)
    end
  end

  def redirect_signed_out_confirmed_user
    user = user_model.find_by_id(user_id_param)
    if user && user.email_confirmed? && signed_out?
      flash_already_confirmed
      redirect_to(url_already_confirmed)
    end
  end

  def forbid_missing_token
    if params[:token].blank?
      raise ActionController::Forbidden, "missing token"
    end
  end

  def forbid_non_existent_user
    unless user_model.find_by_id_and_confirmation_token(
                  user_id_param, params[:token])
      raise ActionController::Forbidden, "non-existent user"
    end
  end

  def flash_success_after_create
    flash[:success] = translate(:confirmed_email,
      :scope   => [:clearance, :controllers, :confirmations],
      :default => "Confirmed email and signed in.")
  end

  def flash_already_confirmed
    flash[:success] = translate(:already_confirmed_email,
      :scope   => [:clearance, :controllers, :confirmations],
      :default => "Already confirmed email. Please sign in.")
  end

  def url_after_create
    '/'
  end

  def url_already_confirmed
    sign_in_url
  end
end
