class RemoveUniqueIndexFromUsersUsername < ActiveRecord::Migration[7.1]
  def change
    remove_index :users, :username if index_exists?(:users, :username)
    add_index :users, :username
  end
end