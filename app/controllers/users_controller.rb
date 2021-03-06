class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.per_number
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t "activate_account"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    @microposts =
      @user.microposts.order_desc.page(params[:page]).per Settings.per_number
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "Profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.admin?
      flash[:danger] = t "delete_admin"
    elsif @user.destroy
      flash[:success] = t "success"
    else
      flash[:danger] = t "danger"
    end
    redirect_to users_url
  end

  def following
    @title = t "following"
    @users = @user.following.page(params[:page])
    render :show_follow
  end

  def followers
    @title = t "followers"
    @users = @user.followers.page(params[:page])
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    return if current_user? @user
    flash[:danger] = t "Please_login"
    redirect_to root_url
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:warrning] = t "user_not_found"
    redirect_to root_path
  end
end
