class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash.now[:success] = "更新成功"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash.now[:success] = "user deleted"
    redirect_to users_url
  end

  private

    def user_params
       params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    #确保用户已登录
    def logged_in_user
      unless logged_in?
        store_location
        flash.now[:danger] = "Please log in"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
        redirect_to root_url unless current_user?(@user)
    end

    def admin_user
      flash.now[:notice] = "你没有操作权限"
      redirect_to root_url unless current_user.admin?
    end
end
