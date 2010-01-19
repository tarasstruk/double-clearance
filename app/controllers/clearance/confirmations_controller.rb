class Clearance::ConfirmationsController < ApplicationController
  unloadable

  before_filter :redirect_signed_in_confirmed_user,  :only => [:new, :create]
  before_filter :redirect_signed_out_confirmed_user, :only => [:new, :create]
  before_filter :forbid_missing_token,               :only => [:new, :create]
  before_filter :forbid_non_existent_user,           :only => [:new, :create]

  filter_parameter_logging :token


  def new
    user = ::User.find_by_id_and_perishable_token!(params[:user_id], params[:token])
    user.confirm_email!
    ::UserSession.create(user, true)
    flash_success_after_create
    redirect_to(url_after_create)
  end

  def create
    new
  end

  private

  def redirect_signed_in_confirmed_user
    if current_user.try(:confirmed?)
      flash[:notice] = "Confirmed email and signed in."
      redirect_to root_url
    end
  end

  def redirect_signed_out_confirmed_user
    user = ::User.find_by_id(params[:user_id])
    if user && user.confirmed? && !signed_in?
      flash[:notice] = "Already confirmed email. Please sign in."
      redirect_to root_url
    end
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
