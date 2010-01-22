class Clearance::PasswordsController < ApplicationController
  unloadable

  before_filter :forbid_missing_token,     :only => [:edit, :update]
  before_filter :forbid_non_existent_user, :only => [:edit, :update]
  filter_parameter_logging :password, :password_confirmation

  def new
    render :template => 'passwords/new'
  end

  def create
    if user = ::User.find_by_email(params[:password][:email])
      user.deliver_password_reset_instructions!
      flash_notice_after_create
      redirect_to(url_after_create)
    else
      flash_failure_after_create
      render :template => 'passwords/new'
    end
  end

  def edit
    @user = user_using_perishable_token
    if @user
      render :template => 'passwords/edit'
    else
      redirect_to(url_no_such_user)
    end
  end

  def update
    @user = user_using_perishable_token
    if @user
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]

      if @user.save
        @user.confirm_email!
        sign_in(@user)
        flash_success_after_update
        redirect_to(url_after_update)
      else
        render :template => 'passwords/edit'
      end
    else
      redirect_to(url_no_such_user)
    end
  end

  private

  def user_using_perishable_token
    user = ::User.find_using_perishable_token(params[:token])
    unless user
      flash[:notice] = "We're sorry, but we could not locate your account." +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser or restarting the " +
        "reset password process."
    end
    user
  end

  def forbid_missing_token
    if params[:token].blank?
      raise ActionController::Forbidden, "missing token"
    end
  end

  def forbid_non_existent_user
    unless ::User.find_by_id_and_perishable_token(
                  params[:user_id], params[:token])
      raise ActionController::Forbidden, "non-existent user"
    end
  end

  def flash_notice_after_create
    flash[:notice] = translate(:deliver_change_password,
      :scope   => [:clearance, :controllers, :passwords],
      :default => "You will receive an email within the next few minutes. " <<
                  "It contains instructions for changing your password.")
  end

  def flash_failure_after_create
    flash.now[:failure] = translate(:unknown_email,
      :scope   => [:clearance, :controllers, :passwords],
      :default => "Unknown email.")
  end

  def url_after_create
    new_session_url
  end

  def flash_success_after_update
    flash[:success] = translate(:signed_in, :default => "Signed in.")
  end

  def url_after_update
    root_url
  end

  def url_no_such_user
    root_url
  end
end
