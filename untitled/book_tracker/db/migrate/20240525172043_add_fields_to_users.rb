class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :username, :string
    add_column :users, :total_books, :integer
    add_column :users, :total_pages, :integer
    add_column :users, :achievements_percentage, :float
    add_column :users, :goal_percentage, :float
  end
end
