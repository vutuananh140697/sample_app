class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate(params[:session][:password])
      check_activated user
    else
      flash[:danger] = t "invalid_combi"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def check_remember user
    if params[:session][:remember_me] == Settings.remember_me_value
      remember user
    else
      forget user
    end
  end

  def check_type _user
    flash[:success] = current_user.admin? ? t("admin") : t("user")
  end

  def check_activated user
    if user.activated?
      log_in user
      check_type user
      check_remember user
      redirect_back_or user
    else
      message  = t("not_acctivated")
      message += t("check_mail")
      flash[:warning] = message
      redirect_to root_url
    end
  end
end
