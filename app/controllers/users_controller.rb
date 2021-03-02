class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @user = current_user
    @users= User.all.order(id: :asc)
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.name = params[:name]
    @user.introduction = params[:introduction]
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def following
    @user = User.find(params[:user_id])
    @users = @user.following_user
    render :follow_list
  end

  def follower
    @user = User.find(params[:user_id])
    @users = @user.follower_user
    render :follower_list
  end

  private

  def ensure_correct_user
    unless params[:id].to_i == current_user.id
      redirect_to user_path(current_user)
    end
  end

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
