class GoalsController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def edit
  end

  def update
    if current_user.update(goal_params)
      redirect_to goal_path, notice: 'Goal was successfully updated.'
    else
      render :edit
    end
  end

  private

  def goal_params
    params.require(:user).permit(:reading_goal)
  end
end
