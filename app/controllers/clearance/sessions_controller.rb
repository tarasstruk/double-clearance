class Clearance::SessionsController < ApplicationController
  unloadable

  protect_from_forgery :except => :create
  filter_parameter_logging :password

  def new
    @user_session = ::UserSession.new
    render :template => 'sessions/new'
  end

  def create
    @user_session = ::UserSession.new(params[:user_session])
    @user_session.save do |result|
      if result
        flash_success_after_create
        redirect_back_or url_after_create
      elsif @user_session.errors.full_messages.include?("Your account is not confirmed")
        flash_notice_after_create
        redirect_to(sign_in_url)
      else
        flash_failure_after_create
        render :template => 'sessions/new', :status => :unauthorized
      end
    end
  end

  def destroy
    ::UserSession.find.try(:destroy)
    flash_success_after_destroy
    redirect_back_or url_after_destroy
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
