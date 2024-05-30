class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: 'Profile updated successfully.'
    else
      render :edit
    end
  end

  def check_achievements
    AchievementService.new(current_user).check_achievements
    redirect_to profile_path, notice: 'Achievements checked successfully.'
  end

  private

  def user_params
    params.require(:user).permit(:username, :avatar)
  end
end
