class AddReadingGoalToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :reading_goal, :integer
  end
end
